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
		<jenkins.model.BuildDiscarderProperty>
			<strategy class="hudson.tasks.LogRotator">
				<daysToKeep>${discard_build.day}</daysToKeep>
				<numToKeep>${discard_build.max}</numToKeep>
				<artifactDaysToKeep>-1</artifactDaysToKeep>
				<artifactNumToKeep>-1</artifactNumToKeep>
				<removeLastBuild>false</removeLastBuild>
			</strategy>
		</jenkins.model.BuildDiscarderProperty>
		<org.jenkinsci.plugins.workflow.job.properties.DisableConcurrentBuildsJobProperty>
			<abortPrevious>false</abortPrevious>
		</org.jenkinsci.plugins.workflow.job.properties.DisableConcurrentBuildsJobProperty>
		<com.coravy.hudson.plugins.github.GithubProjectProperty plugin="github@1.41.0">
			<projectUrl>${git_repository.url}</projectUrl>
			<displayName/>
		</com.coravy.hudson.plugins.github.GithubProjectProperty>
		%{ if length(parameter) > 0 }
		<hudson.model.ParametersDefinitionProperty>
			<parameterDefinitions>
				%{ for key, value in parameter }
				<hudson.model.StringParameterDefinition>
					<name>${key}</name>
					<defaultValue>${value}</defaultValue>
					<trim>true</trim>
				</hudson.model.StringParameterDefinition>
				%{ endfor }
			</parameterDefinitions>
		</hudson.model.ParametersDefinitionProperty>
		%{ endif }
	</properties>
	<definition class="org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition" plugin="workflow-cps@4018.vf02e01888da_f">
		<scm class="hudson.plugins.git.GitSCM" plugin="git@5.7.0">
			<configVersion>2</configVersion>
			<userRemoteConfigs>
				<hudson.plugins.git.UserRemoteConfig>
					<url>${git_repository.url}</url>
				</hudson.plugins.git.UserRemoteConfig>
			</userRemoteConfigs>
			<branches>
				<hudson.plugins.git.BranchSpec>
					<name>${git_repository.branch}</name>
				</hudson.plugins.git.BranchSpec>
			</branches>
			<doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
			<submoduleCfg class="empty-list"/>
			<extensions/>
		</scm>
		<scriptPath>${script_path}</scriptPath>
		<lightweight>true</lightweight>
	</definition>
	<triggers/>
	<disabled>false</disabled>
</flow-definition>
