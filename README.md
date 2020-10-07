# Remote State Sample


## Objective
* Define Cloud-Agnostic PCE/Cloud Foundation Platform Model(s)

## Initial Use-Case/Immediate Value Prop
* Standardize labels/tags and centralize their administration
* Reduces communication between operators and users
* Reduces code duplication, hard-coded variable assignments
* Consistent abstraction/interface across vendors for downstream projects/consumers

## Initial Models
Models are implemented as discrete TML modules that do not create any infrastructure. They should only declare variables and outputs. WebOps should maintain Tier 2 projects that use the TML modules. Workspaces can continue to use the current workspace naming convention:

`${SK8S_ORGANIZATION}-${SK8S_ENVIRONMENT}-${PROVISIONER}-${REGION}-${PROJECT}-${NAME}`

### One-to-Many or Foundational Models
These represent core constructs/entities that expose a list of tags/labels used by downstream "many-to-one" Models. Listed are the models used in the demo, but more can be added (e.g. CostCenter). These modules should not require a datasource, and only defined variables and outputs.

#### Vendor
Corresponds to a TF Provisioner (e.g. AWS, Azure, GCP, EfficientIP, NS1, etc...). 
* Inputs: `name`, `pwho`
* Outputs: `name`, `pwho`, `labels`
* Workspace: `webopsinternal-dev-global-aws-vendor-default`

#### Tenant
App team, DRQS Group ID (e.g. webops, msv, wss, enterprise, etc...), etc...
* Inputs: `name`, `drqsgid`
* Outputs: `name`, `drqsgid`, `labels`
* Workspace: `webopsinternal-dev-global-aws-tenant-wss`

#### Environment
Environments (i.e. dev, stg, prod)
* Inputs: `name`
* Outputs: `name`, `labels`
* Workspace: `webopsinternal-dev-global-aws-environment-default`

### Many-to-One
These represent the platform's vendor-resource abstractions. The Projects declare terraform_remote_state data sources that are configured to expose the outputs in the appropriate one-to-many model workspaces. Tags/Labels are a composite of the `labels` outputs consumed from the various data sources. These can be used by app teams to give them a more "platformy" experience.

#### Account
Associates Vendor, Tenant, and Environment.
* Data Sources: `remote.Vendor`, `remote.Tenant`, `remote.Environment`
* Inputs: `drqs_gid`, `pwho`, `name`, `account_id`, `environment`, `vendor`, `tenant`, `account_labels`
* Outputs: `drqs_gid`, `pwho`, `name`, `account_id`, `environment`, `vendor`, `tenant`, `labels(remote.Vendor.labels + remote.Tenant.labels + remote.Environment.labels + account_labels)`
* Workspace: `webopsinternal-dev-global-aws-account-wss`

## How can Users leverage this?
Similar to how the pipeline creates the backend.tf file to configure the remote backend and workspace, the pipeline can generate a datasources.tf file that enables developers to use `data.terraform_remote_state` in their projects. This behavior can be selectively toggled on/off via the pipeline's yaml configuration/overrides. Alternatively, this can be restricted to tier1 projects so we can "dogfood" the mechanism before advertising this feature.

### Example datasources.tf Configuration
This example is roughly what the pipeline will provision.

```
data "terraform_remote_state" "account" {
  backend = "pg"
  config = {
    workspace = "webopsinternal-${SK8S_ENVIRONMENT}-global-${PROVISIONER}-account-${SK8S_TENANCY}"
  }
}

data "terraform_remote_state" "app_team_resources" {
  backend = "pg"
  config = {
    prefix = "${SK8S_ORGANIZATION}-${SK8S_ENVIRONMENT}-${PROVISIONER}-${REGION}-"
  }
}
```

### Enhancements for Better Support/UX
The TF pipeline's YAML configuration layer should be augmented to support a "terraform_remote_state" attribute to allow teams to configure remote workspaces. The pipeline will restrict them to workspaces that start with the appropriate tenant name. An OPA policy should be written to ensure this is not bypassed.


## Workflow
```
# docker run -it -v $(pwd):/data artprod.dev.bloomberg.com/webops/terraform:0.12.20 /bin/sh
# cd /data/projects/aws-vendor
# terraform init
Initializing modules...
- vendor in ../../tml/cloud-vendor

Initializing the backend...

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
# terraform apply
var.vendor_name
  Enter a value: aws

var.vendor_pwho
  Enter a value: cloud-pwho


Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

labels = {
  "vendor_name" = "aws"
  "vendor_pwho" = "cloud-pwho"
}
name = aws
pwho = cloud-pwho
# cd ../aws-environment
main.tf
# terraform init
Initializing modules...
- environment in ../../tml/cloud-environment

Initializing the backend...

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
# terraform apply
var.environment_name
  Enter a value: dev


Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

labels = {
  "environment_name" = "dev"
}
name = dev

# terraform workspace new dev
Created and switched to workspace "dev"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
# terraform workspace select dev
# terraform apply
var.environment_name
  Enter a value: dev


Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

labels = {
  "environment_name" = "dev"
}
name = dev
# cd ../aws-tenant

# terraform init
Initializing modules...
- tenant in ../../tml/cloud-tenant

Initializing the backend...

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
# terraform apply
var.tenant_group_id
  Enter a value: 1270

var.tenant_name
  Enter a value: webops


Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

group_id = 1270
labels = {
  "tenant_group_id" = "1270"
  "tenant_name" = "webops"
}
name = webops
# cd ../aws-account
# terraform init
Initializing modules...
- account in ../../tml/cloud-account

Initializing the backend...

Successfully configured the backend "local"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
# terraform apply
data.terraform_remote_state.tenant: Refreshing state...
data.terraform_remote_state.vendor: Refreshing state...
data.terraform_remote_state.environment: Refreshing state...

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

labels = {
  "account_id" = "1234567890"
  "account_name" = "webops-dev"
  "account_pwho" = "0987654321"
  "cloud" = "aws"
  "group_id" = "1270"
  "group_name" = "webops"
  "sla" = "dev"
  "tenant_group_id" = "1270"
  "tenant_name" = "webops"
  "vendor_name" = "aws"
  "vendor_pwho" = "cloud-pwho"
}
```

