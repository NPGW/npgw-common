#!/bin/bash
# monitor_containers.sh

LOG_DIR="./profiling_logs"
mkdir -p $LOG_DIR

# Function to profile a container
profile_container() {
    local container_name=$1
    local log_prefix=$2

    echo "Profiling $container_name..."

    # Resource usage
    docker stats --no-stream $container_name >> "$LOG_DIR/${log_prefix}_stats.log"

    # Process list
    docker exec $container_name ps aux >> "$LOG_DIR/${log_prefix}_processes.log"

    # Java specific if it's a Java container
    if docker exec $container_name which java > /dev/null 2>&1; then
        docker exec $container_name jps -v >> "$LOG_DIR/${log_prefix}_java_processes.log"

        # Get main Java PID
        local java_pid=$(docker exec $container_name jps | grep -v Jps | head -1 | cut -d' ' -f1)
        if [ ! -z "$java_pid" ]; then
            docker exec $container_name jstack $java_pid >> "$LOG_DIR/${log_prefix}_thread_dump.log"
            docker exec $container_name jstat -gc $java_pid >> "$LOG_DIR/${log_prefix}_gc_stats.log"
        fi
    fi

    # Memory info
    docker exec $container_name cat /proc/meminfo >> "$LOG_DIR/${log_prefix}_meminfo.log"

    # Load average
    docker exec $container_name cat /proc/loadavg >> "$LOG_DIR/${log_prefix}_loadavg.log"
}

# Monitor main containers
while true; do
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] Collecting metrics..."

    profile_container "api-test" "api_test"
    profile_container "aws-mock" "aws_mock"

    # Check if any Java processes are hanging
    for container in api-test aws-mock; do
        if docker ps --filter "name=$container" --filter "status=running" -q > /dev/null; then
            java_pids=$(docker exec $container jps | grep -v Jps | cut -d' ' -f1)
            for pid in $java_pids; do
                cpu_usage=$(docker exec $container ps -p $pid -o %cpu= 2>/dev/null | tr -d ' ')
                if [ ! -z "$cpu_usage" ] && (( $(echo "$cpu_usage > 80" | bc -l) )); then
                    echo "[$timestamp] High CPU detected in $container PID $pid: $cpu_usage%"
                    docker exec $container jstack $pid >> "$LOG_DIR/high_cpu_${container}_${pid}.log"
                fi
            done
        fi
    done

    sleep 30
done