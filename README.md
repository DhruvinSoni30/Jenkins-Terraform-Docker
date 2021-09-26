# A complete overview of Jenkins-Terraform-Docker integration

### What is Jenkins?

Jenkins is a free and open-source CI/CD automation server. It helps to automate the parts of the software development lifecycle i.e building, testing, and deploying the code to various servers.

![3](https://github.com/DhruvinSoni30/Jenkins-Terraform-Docker/blob/main/3.png)

* CI/CD is a method to frequently deliver apps to customers by introducing automation into the stages of app development. Specifically, CI/CD introduces ongoing automation and continuous monitoring throughout the lifecycle of apps, from integration and testing phases to delivery and deployment.

* Continuous Integration works by pushing small code chunks to your application’s codebase hosted in a Git repository, and to every push, run a pipeline of scripts to build, test, and validate the code changes before merging them into the main branch.

* Continuous Delivery and Deployment consist of a step further CI, deploying your application to production at every push to the default branch of the repository.

![4](https://github.com/DhruvinSoni30/Jenkins-Terraform-Docker/blob/main/4.png)

### What is Terraform?

Terraform is a free and open-source infrastructure as code (IAC) that can help to automate the deployment, configuration, and management of the remote servers. Terraform can manage both existing service providers and custom in-house solutions.

![5](https://github.com/DhruvinSoni30/Jenkins-Terraform-Docker/blob/main/5.png)

### What is Docker?

Docker is an open-source lightweight virtualization tool. It is the containerizing platform in which users can run and deploy applications and their dependencies and form containers to run over any Linux infrastructure. With Docker, you can manage your infrastructure in the same ways you manage your applications. By taking advantage of Docker’s methodologies for shipping, testing, and deploying code quickly, you can significantly reduce the delay between writing code and running it in production.

![6](https://github.com/DhruvinSoni30/Jenkins-Terraform-Docker/blob/main/6.png)

### Prerequisite:
* Basic understanding of Jenkins, Terraform, Docker, AWS
* A server with Jenkins & Terraform pre-installed
* An access key & secret key created the AWS

Lets, start with the configuration of the project

**Step 1:- Install Terraform plugin**
  
  * In order to integrate Jenkins with Terraform, we need to install the Terraform plugin in Jenkins.
  * Go to Manage Jenkins -> Manage Plugins -> Search “Terraform Plugin” -> Click on Install -> Restart the Jenkins

![7](https://github.com/DhruvinSoni30/Jenkins-Terraform-Docker/blob/main/7.png)

**Step 2:- Configure the Terraform plugin**

  * Go to Manage Jenkins -> Global Tool Configuration -> Search for “Terraform” -> Add Path of the Terraform

![8](https://github.com/DhruvinSoni30/Jenkins-Terraform-Docker/blob/main/8.png)

**Step 3:- Install Multibranch pipeline plugin**

  * For this project, we will create the multibranch pipeline. In order to create that we need to install a Multibranch pipeline
  * Go to Manage Jenkins -> Manage Plugins -> Search “Pipeline: Multibranch” -> Install the plugin -> Restart the Jenkins

![9](https://github.com/DhruvinSoni30/Jenkins-Terraform-Docker/blob/main/9.png)

**Step 4:- Create Pipeline**
  
  * Create file called `Jenkinsfile` and add below code in it

    ```
    properties([ parameters([
    string( name: 'AWS_ACCESS_KEY_ID', defaultValue: ''),
    string( name: 'AWS_SECRET_ACCESS_KEY', defaultValue: ''),
    string( name: 'AWS_REGION', defaultValue: ''),
    ]), pipelineTriggers([]) ])

    // Environment Variables.
   env.access_key = AWS_ACCESS_KEY_ID
   env.secret_key = AWS_SECRET_ACCESS_KEY
   env.aws_region = AWS_REGION


    pipeline {
      agent any
        stages {
           stage ('Terraform Init'){
             steps {
               sh "export TF_VAR_aws_region='${env.aws_region}' && terraform init"
            }
         }
           stage ('Terraform Plan'){
             steps {
               sh "export TF_VAR_aws_region='${env.aws_region}' && terraform plan" 
           }
         }
           stage ('Terraform Apply & Deploy Docker Image on Webserver'){
             steps {
               sh "export TF_VAR_aws_region='${env.aws_region}' && terraform apply -auto-approve"
           }
         }
     }
    }
    ```
    
**Step 5:- Create the Multibranch pipeline**

  * Click on New Item -> Click on Multibranch Pipeline -> Click on OK
  * Now we need to configure the project
  * Go to Branch sources -> Click on Git -> Add the repository URL
  * By default in the Build Configuration By Jenkins is selected.
  * Click on Save
  * Now Jenkins will Scan the Multibranch Pipeline Log

![10](https://github.com/DhruvinSoni30/Jenkins-Terraform-Docker/blob/main/10.png)

  * Now click on the Build with parameters


  * Fill the details with your access key, secret key, and name of the region
  * As of now this project only supports the us-east-1 and eu-east-1 regions. So, you can only choose between these two.
  * Jenkins will create the various resources on AWS & also pull the docker image and run the docker container on the newly created EC2 instance.
  * Wait for Jenkins JOB to finish. It will take some time to finish so, sit back and relex.

![11](https://github.com/DhruvinSoni30/Jenkins-Terraform-Docker/blob/main/11.png)

**Step 6:- Check the output**
  
  * In order to verify the output, take the public IP of the instance and browse to <IP:80> and you can view below page
  
  ![12](https://github.com/DhruvinSoni30/Jenkins-Terraform-Docker/blob/main/12.png)
  
That’s it now, you have learned how to integrate Terraform with Jenkins. You can now modify the changes and can play with it
