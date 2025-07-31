def getInitiator(currentBuild) {
    for (cause in currentBuild.getBuildCauses()) {
        if (cause._class == 'org.jenkinsci.plugins.workflow.cps.Cause$UserIdCause' ||
                cause.shortDescription.contains('Started by user')) {
            return cause.userName ?: cause.shortDescription
        }
        if (cause._class == 'hudson.triggers.TimerTrigger$TimerTriggerCause' ||
                cause.shortDescription.contains('Started by timer')) {
            return 'Timer/Scheduler'
        }
    }
    return 'Automated Trigger'
}
return this