#script condition create
if [ -e ${bamboo_build_working_directory}/successful_tag.file ]
then
    export DEPLOYMENT_STATUS=successful
else
    export DEPLOYMENT_STATUS=failed
    ansible-playbook ${bamboo_build_working_directory}/jira/ansible/create_jira_task_your_app.yml -e application_name=your_app

fi
