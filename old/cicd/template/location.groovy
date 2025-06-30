import jenkins.model.JenkinsLocationConfiguration

def jenkinsLocation = JenkinsLocationConfiguration.get()
def newUrl = "http://your-new-jenkins-url/"

if (jenkinsLocation.getUrl() != newUrl) {
    jenkinsLocation.setUrl(newUrl)
    jenkinsLocation.save()
    println "Jenkins URL set to: ${newUrl}"
} else {
    println "Jenkins URL is already set correctly."
}
