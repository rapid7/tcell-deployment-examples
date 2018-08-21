# terraform-tcell-provider
A [terraform](https://www.terraform.io/) provider for managing [tCell.io](https://www.tcell.io/)

## Installation
Download and extract the latest release to your [terraform plugin directory](https://www.terraform.io/docs/configuration/providers.html#third-party-plugins) (typically ~/.terraform.d/plugins/)

## Usage
Enclosed [main.tf](main.tf) file contains examples of tcell resources that can be curranly managed via terraform:

### Resource
* `tcell_app`
* `tcell_features`
* `tcell_config`
* `tcell_config_clone`
### Data
* `tcell_config`

### Resources

#### `tcell_app`
```hcl
resource "tcell_app" "my-app" {
  name = "Apps display name" //required
}
```
To import existing app run
`terraform import tcell_app.stage <app-id>`
#### `tcell_features`
To set high level features for an app
```hcl
resource "tcell_features" "stage-features" {
  app_id = "${tcell_app.stage.id}"
  <feature> = <value>
}
```
#### `tcell_config`
To set specific config values or set whole config
```hcl
resource "tcell_config" "stage-config" {
  app_id = "${tcell_app.stage.id}"
  type = "<feature>" //optional
  config = <<CONFIG
{
  //pretty printed json blob
}
CONFIG
}
```
To import a whole config run   
`terraform import tcell_config.stage-config <app-id>`   
To import a specific config add `.<feature>`   
`terraform import tcell_config.stage-config <app-id>.<feature>`   
Running the `terraform state show tcell_config.stage-config` would then show the config json blob

#### data `tcell_config`
To retrieve latest config for an app
```hcl
data "tcell_config" "stage-config" {
  app_id = "${tcell_app.stage.id}"
}
```
#### `tcell_config_clone`
To clone a config between tcell apps
```hcl
resource "tcell_app" "prod" {
  name = "Prod"
}

resource "tcell_config_clone" "deploy2prod" {
  source_app_id = "${tcell_app.stage.id}"
  source_cfg_id = "${data.tcell_config.stage-config.id}"
  destination_app_id = "${tcell_app.prod.id}"
  type = "<feature>" //optional
}
```
Using `data.tcell_config` will pull the latest config for the given app and compare it to the latest clone, if there is a newer version of the source config then the `deploy2prod` will perform a clone (deployment) to the destination app. This gives flexibility to either fully manage config and deployment or only the config deplyment between apps. Optional `type` of the config can be specified to only deploy certian feature at a time.

##### Deployment example
Given two apps `"stage"` and `"prod"`
1. Change `config` value in `"tcell_config" "stage"`
1. `terraform apply` will deploy the config change to the `stage` app
1. Running `terraform apply` again will deploy the same config change to the `prod` app via the `"tcell_config_clone" "deploy2prod"` resource


## Support
[Contact us](mailto:support@tcell.io)
