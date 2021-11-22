# Automatically create Jira ticket in case of failed deployment

This Ansible role is responsible for creating Jira ticket based on provided template. Such role can be used in deployment process to create task in case of failed deployment. 
The role is using Jira API and is intended to be added at the level of deployment process of environment in bamboo deployment project.
The role is based on default environment variables set by bamboo deployment.

Now the role is first checking if jira ticket with same title exists. If exists, then the current jira will be commented with log link to bamboo. If not exists, then Jira is created.

## Parameters

In catalog roles/create_jira/defaults/main.yml you can find all variables required by this role. Some of them are overwritten in playbook *create_jira_task_your_app.yml* based on environment variables
 
ansible variable| environment variable |description
---------|------------|------
bamboo_release_name | bamboo_deploy_release | variable with release name that the deployment is rolling out
environment_name | bamboo_deploy_environment | bamboo specific environment name from deployment project
bamboo_release_url | bamboo_resultsUrl | variable that points to the URL that pass to the results of particular deployment
jira_username | bamboo_your_app_devops_user | specifically for your_app dedicated user has been prepared to interact with Jira, defined as bamboo global variable
jira_password | bamboo_your_app_devops_password | specifically for your_app dedicated user and password has been prepared to interact with Jira, defined as bamboo global variable

Additional parameter that is defined via -e argument is application name which then is added into the name of jira task 
eg. PolicyCenter
## Usage

### Triggering the role when deployment failed

To create the ticket automatically the Bamboo specific Final task has to be added. This task is executed always as a final step of each deployments.

In Guidewire project in standard deployment task as a last of the tasks we added a step to create flag file that is considered as flag for successful deployment.
If the flag file is missing then the final step is considering the entire deployment as failed and can trigger the ansible role to create jira task.
The role is first checking if jira ticket with same title exists. If exists, then the current jira will be commented with log link to bamboo. If not exists, then Jira is created

To trigger the jira task creation below command has been implemented as final task. 

```bash

    ansible-playbook ${bamboo_build_working_directory}/jira/ansible/create_jira_task_your_app.yml -e application_name=your_app

### Customize jira tasks

in directory ansible/roles/create_jira/templates you can find a template for jira task that is used to create jira ticket. 
To handle different projects different templates can be prepared. Once you prepare different template with custom name like jira_response_your_app.json.j2 
you can easily use it for the script by overwriting the value of variable file_name with format jira_response_your_app.json.

## Dependency and Requirements

As described in parameters this role is based on bamboo specific variables. If you want to use this role in different place then you can overwrite them by the -e command parameter of Ansible

New variable has been introduced to control if the Jira should be created for particular deployment - *call_jira_creation*. It should be exported as environment variables. 
If the variable is not set, then by default it is taking the value as true and create ticket. At the level of Ansible variables for your_app project we have additional variable *call_jira_creation* in group vars to control the process.
