static def getInitiator(currentBuild) {
    def cause = currentBuild.rawBuild.getCauses().find {
        c -> c.class.simpleName == 'UserIdCause'
    }
    if (cause) {
        return cause.getUserName()
    }
    def timerCause = currentBuild.rawBuild.getCauses().find {
        c -> c.class.simpleName == 'TimerTriggerCause'
    }
    if (timerCause) {
        return 'Timer/Scheduler'
    }
    return 'Automated Trigger'
}