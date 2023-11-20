# Talk Terraform

## Infra-as-code

Infrastructure as Code (IaC) is nothing more than the management and provisioning of infrastructure through code rather than manual processes.
With IaC, configuration files are created and that contain your infrastructure specifications, making it easier to edit and distribute configurations. It also ensures that you provision the same environment every time, thus avoiding failures in manual processes when creating environments.

## Benefits of IaC

There are some benefits of using IaC, as described below:

- **Plan, test and avoid human failures** - With automation is much easier to create, test and validate a whole environment, it's difficult to remember all steps when you create in a manual way. In the past, it was always difficult for infrastructure professionals to test infrastructure. Testing basically meant installing the exact same infrastructure in an isolated environment for testing, but it is an unreliable process with high chances of failures, because, as it is a manual and slow process, there is no guarantee that all the same steps will be performed in the production environment. With IAC, it becomes much easier, faster and more reliable to test new infrastructures for development and production environments.
- **No repetitive tasks** - If you need to create 3 Kubernetes clusters on AWS for example, you don't have to repeat the same steps 3 times, which in turn makes the process faster and avoids human error during the process.
- **Simplified documentation** - There's no need to log into a server or cloud provider to try to dig through and understand everything that's been configured, *it's all in the code*;
- **Code reuse and easy replication** - Once everything is coded and separated into modules, it is easy to reuse code for future implementations, you just need to copy and run the code again;
- **Versioning and traceability** - By approaching our infrastructure as code, we now have the possibility to version our entire infrastructure, since it must be in a central Git repository, in addition to having traceability and history of how our infrastructure has evolved.
- **Disaster recovery** - As we work with IT we have to keep in mind that disasters will happen at some point. Imagine a major problem in your infrastructure. For example, if the Access and Secret Key password or key was leaked from AWS and the environment was completely deleted. Of course, good practices have long preached that we should always have backups of all servers and systems, but backups are nothing more than files. And the actual infrastructure? You need to have an active infrastructure before you can restore backups, right? Network, firewall, VPCs, Clusters, Servers, etc.  If you have all your infrastructure in code, recovering it all is simple.

## Terraform

Was created in 2014, with the aim of creating and orchestrating infrastructure as code in an automated way. Terraform is developed in Goolang and has its own syntax called HCL which is very similar to the well-known YAML. Terraform is opensource and is software that uses declarative language.

## Declarative x Imperative

To explain this point, I will first make a brief comparison using these 2 softwares, **Ansible** and **Terraform**.
The common point between them is that both can be used to build infrastructure as code, configure and manage infrastructure, however Terraform was made and is better as an infrastructure provisioning tool while Ansible is better used as a configuration tool for that. infrastructure.

Terraform was thought and developed to be cloud native, thus managing the infrastructure in a more organized and efficient way, while ansible arose from the need to execute commands in batches in a more agile way, without repetitions, but it was adapted to manage the infrastructure, but if comes out better for configuration management.

Then, going back to our point, imagine that we have 2 environments, one using Ansible for automation and the other using Terraform. In each of these environments we upload 3 instances. If we need to decrease the number of these instances to 1, with Ansible we need to specify which 2 instances we need to destroy in our code. With Terraform, we just change the count number in our code from the number 3 to 1 and it takes care of doing the rest, that is, in the language with **imperative** approach (procedural) we need to give instructions, say **HOW** to do it, while in the declarative we just need to tell the **STATE** that we want our infrastructure and the code takes care of doing the rest for us.

- **Terraform**
```sh
resource "aws_instance" "my-machine" {
    count = 3
    
    ami = "ami-0416962131234133f"
    instance_type = "t2.micro"
    subnet_id = "subnet-29e63345"
    key_name = "mykey"
    tags = {
        Name = "my-machine-${count.index}"
    }
}
```

- **Ansible**
```
- amazon.aws.ec2:
    key_name: mykey
    instance_type: t2.micro
    image: ami-0416962131234133f
    wait: yes
    group: webserver
    count: 3
    vpc_subnet_id: subnet-29e63345
    assign_public_ip: yes
```

## How Terraform Works?

When you are coding in Terraform, you will basically have to worry about the following files, your Terraform files with the extension **“.tf”**, which will be the files responsible for saying what state of infrastructure you want to have or want to create and **“terraform.tfstate”** which is the file that will tell you the current state of your infrastructure, and it can be in the root of your directory or versioned in a remote repository.

When you want to create, delete or modify the state of your infrastructure, you first need to run **"terraform init"** command and Terraform will trigger Terraform's **"CORE"** which would be the libraries in GO responsible for understanding your code and being able to apply it, terraform will create a folder called **".terraform"** inside the folder you are running the command, and it will be able to modify your infrastructure after running the command **"terraform apply"** by comparing the current state of your infrastructure in **".terraform.tfstate"** with the desired state in which you set your **“.tf”** files.

The **.terraform.lock.hcl** file is a file that simply does a version control on top of the providers you downloaded, it will always be updated when you run the **“terraform init”** command.

The **.tfvars** file is a file that define a hierarchy on declaring variables, different from declaring a variable inside **".tf"** file, it must have a value defined in it and also is used for declaring sensitive values, it's a file that you usually don't commit into your repository if you use sensitive values on it.

## Before start

```sh
export AWS_ACCESS_KEY_ID="anaccesskey"
export AWS_SECRET_ACCESS_KEY="asecretkey"
export AWS_DEFAULT_REGION="us-east-1"
```

## Commands

Initialize and download Hashicorp dependencies:

```sh
terraform init
```
Create and run execution plan:

```sh
terraform plan
terraform apply
```
You can, if you wish, use a command with automatic approval:
```sh
terraform apply --auto-approve
```
Run plan and apply only in a single target of whole code:
```sh
terraform plan -target="aws_security_group_rule.sg-rule[5]"
terraform apply -target="aws_security_group_rule.sg-rule[5]"
```
Destroy all the resources inside the folder running the command:
```sh
terraform destroy
```
Destroy only a single target:
```sh
terraform destroy -target="aws_instance.web"
```
See the resources on the state:
```sh
terraform state list
```
Mark a resource as damaged and force to recreate:
```sh
terraform taint aws_instance.web
```
Mark a resource as no need for changes:
```sh
terraform untaint aws_instance.web
```

## Simple functions

- **Count** - With **count** we use this to create more than one resource without need to declare another resource on the code. We can use **count.index** for interpolate between the values inside the **count**. We also can use **count** as a ternary conditional operator boolen, numerical comparison or equality condition.
- **Lenght** - We can use **lenght** to determine the length of a given list, map, or string.
- **For_each** - This function is similar to **count** , but the difference is that the function needs to know the value before running the code, it can't refer to attributes that are unknown. It works with map and a set of expressions refered on the link (https://www.terraform.io/language/expressions) 

## Modular format , why ?

- **Code organization and ease of understanding** - First point I would mention the issue of organization and configuration, with the modules it is easier to navigate and understand the full extent of our code. Imagine that we need to create a stack where we have an application using various AWS services such as AutoScaling on EC2, using a database data on RDS, ELB, WAF, Elasticache and Cloudfront for example. With modules it is easy to standardize the operating settings of each service by separating them into logical components, if we need to update one of the aforementioned services, we do not need to analyze 1000 lines of code for example, but only the module separately.
- **Less risky for updates** - Without modules, updating the configuration will become more risky, as an update to one section may cause unintended consequences to other parts of your configuration.
- **Code reuse, avoid human errors and duplicated code** - With modules we avoid reconfiguration from scratch of services already created previously, which can be subject to errors in the process. This way we save time in any new implementation that depends on modules already written previously.
- **Encourages standardization and best practices** - Depending on the service, such as Cloudfront for example or an S3 bucket, to ensure consistency and good functioning of these services, it may be necessary to perform several configurations in these services, which makes this process a little complex, with the module we guarantee standard and consistency in service settings. 

## Data-Sources

- Data sources provide information about entities that are not managed by the current Terraform configuration, you can retrieve information from your S3, Git repository, inside AWS, etc.

```sh
data "terraform_remote_state" "networking" {
    backend = "s3"
    config = {
        bucket = "name-of-your-bucket"
        key = "terraform.tfstate"
        region = "us-east-1"
    }
}
```

```sh
data "github_repositories" "example" {
  query = "org:hashicorp language:Go"
}
```

## Extras

Here we have another tools that could make your experience better with Terraform.

| Tools | README | Description
| ------ | ------ | ------ |
| Terragrunt | [https://terragrunt.gruntwork.io/][PlDb] | Terragrunt is a thin wrapper that provides extra tools for keeping your configurations DRY, working with multiple Terraform modules, and managing remote state.
| Terraformer | [https://github.com/GoogleCloudPlatform/terraformer][PlDb] | A CLI tool that generates tf/json and tfstate files based on existing infrastructure (reverse Terraform).
| TFSwitch | [https://tfswitch.warrensbox.com/][PlGh] | The tfswitch command line tool lets you switch between different versions of terraform.
| TFLint | [https://github.com/terraform-linters/tflint][PlGd] | A Pluggable Terraform Linter
| Terraform-docs | [https://terraform-docs.io/][PlOd] | Generate Terraform modules documentation in various formats
| Checkov | [https://www.checkov.io/][PlMe] | Checkov scans cloud infrastructure configurations to find misconfigurations before they're deployed.
| Infracost | [https://www.infracost.io/][PlGa] | Cloud cost estimates for Terraform in pull requests
