# Remote State Sample


## Objective
* Define Standard PCE/Cloud Platform Model(s)

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
    workspace = "webopsinternal-${SK8S_ENVIRONMENT}-global-${PROVISIONER}-account-default"
  }
}
```

### Enhancements for Better Support/UX
The TF pipeline's YAML configuration layer should be augmented to support a "terraform_remote_state" attribute to allow teams to configure remote workspaces. The pipeline will restrict them to workspaces that start with the appropriate tenant name. An OPA policy should be written to ensure this is not bypassed.
