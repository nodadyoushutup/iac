<flow-definition plugin="workflow-job@1505.vea_4b_20a_4a_495">
	<actions>
		<org.jenkinsci.plugins.pipeline.modeldefinition.actions.DeclarativeJobAction plugin="pipeline-model-definition@2.2221.vc657003fb_d93"/>
		<org.jenkinsci.plugins.pipeline.modeldefinition.actions.DeclarativeJobPropertyTrackerAction plugin="pipeline-model-definition@2.2221.vc657003fb_d93">
			<jobProperties/>
			<triggers/>
			<parameters/>
			<options/>
		</org.jenkinsci.plugins.pipeline.modeldefinition.actions.DeclarativeJobPropertyTrackerAction>
	</actions>
	<description/>
	<keepDependencies>false</keepDependencies>
	<properties>
		<org.jenkinsci.plugins.workflow.job.properties.DisableConcurrentBuildsJobProperty>
			<abortPrevious>false</abortPrevious>
		</org.jenkinsci.plugins.workflow.job.properties.DisableConcurrentBuildsJobProperty>
		<com.coravy.hudson.plugins.github.GithubProjectProperty plugin="github@1.41.0">
			<projectUrl>${git_repository_url}</projectUrl>
			<displayName/>
		</com.coravy.hudson.plugins.github.GithubProjectProperty>
		<hudson.model.ParametersDefinitionProperty>
			<parameterDefinitions>
				<hudson.model.StringParameterDefinition>
					<name>subdir</name>
					<defaultValue>${subdir}</defaultValue>
					<trim>true</trim>
				</hudson.model.StringParameterDefinition>
			</parameterDefinitions>
		</hudson.model.ParametersDefinitionProperty>
	</properties>
	<definition class="org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition" plugin="workflow-cps@4018.vf02e01888da_f">
		<scm class="hudson.plugins.git.GitSCM" plugin="git@5.7.0">
			<configVersion>2</configVersion>
			<userRemoteConfigs>
				<hudson.plugins.git.UserRemoteConfig>
					<url>${git_repository_url}</url>
				</hudson.plugins.git.UserRemoteConfig>
			</userRemoteConfigs>
			<branches>
				<hudson.plugins.git.BranchSpec>
					<name>${git_repository_branch}</name>
				</hudson.plugins.git.BranchSpec>
			</branches>
			<doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
			<submoduleCfg class="empty-list"/>
			<extensions/>
		</scm>
		<scriptPath>terraform/stack/jenkins/pipeline/terraform.jenkins</scriptPath>
		<lightweight>true</lightweight>
	</definition>
	<triggers/>
	<disabled>false</disabled>
</flow-definition>