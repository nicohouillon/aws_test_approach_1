# aws_test_approach_1
Launch a simple web site in a load balanced and highly available manner utilizing automation and AWS best practices


### Prerequisites
a recent version of Terraform
www.terraform.io/downloads.html 

## Built With

* [Packer](https://www.packer.io) - Used to build a custom AMI 
* [Terraform](https://www.terraform.io) - Used to define the AWS infrastructure and resources 

## Instructions 
1) Deploy the infrastructure : 
``` 
terraform init 
terraform plan 
terraform apply
```
2) Access the webpage: 

- The script will output the dns address of the Elastic Load Balancer , simply copy the url and add /index.php to get the desired webpage.  
example : http://elb-1961652575.us-west-2.elb.amazonaws.com/index.php 
- refresh the page to get a different [results](https://github.com/nicohouillon/aws_test_approach_1/tree/master/results) 

3) Autoscaling :
- using the command stress , we can stimulate the CPU and force the autoscaling policies to increase the number of instances.
This has been tested as per screenshot in Result folder. When SSH to an ec2 instance , a cron task will start the Stress utility for 5 minutes.

### Pre steps :
* a Custom AMI is prebuild with [Packer]() and available across various regions . 
This allows a faster boot time and avoid repetitive download to install dependencies (nginx,php, ...).
```
packer build packer.json 
```
* index.php is downloaded from a S3 bucket and a Ec2 role with S3 access has been previously created. 

### Additonal informations :
* [Terraform]() will retrieve the appropriate most recent AMI in a given region in using a common tag issued from the Packer build.
* some informations may be needed in variables.tf or terraform.tfvars (example: your AWS credentials/profile , ssh key path, specific region, ...). 


