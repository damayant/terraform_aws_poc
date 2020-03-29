
## Terraform Resources
1. https://learn.hashicorp.com/terraform/getting-started/
2. https://www.terraform.io/docs/modules/index.html
3. https://registry.terraform.io/
4. https://www.linode.com/docs/applications/configuration-management/create-terraform-module/



### Terrform commands
- terraform init
- terraform plan
- terraform apply
- terraform fmt 
- terraform validate
- terraform show
- terraform state list
  
**terraform graph


## TODO
- Setup Terraform Remote State

## Plan
- Docker container
  - takes input: AWS credentials
  - installs software
    - aws cli
    - terraform
  - runs
    - terraform init
    - terraform apply
    - returns some kind of load banacer ip
    - maps volumes for state ? 