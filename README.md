## Steps

```
# build docker image and create infra 
docker build -t terraform-runner \
--build-arg AWS_ACCESS_KEY_ID=<Your AWS Access Key> \
--build-arg AWS_SECRET_ACCESS_KEY=<Your AWS Secret Key> \
--build-arg AWS_DEFAULT_REGION=us-east-1 
.

# destroy infra 
docker run -it terraform-runner:latest  /bin/bash
terraform destroy --auto-approve
```

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