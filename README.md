# Mon module webapp

Ceci est un exemple de module pour creer une webapp

## Usage

```hcl
module "<module name>" {
    source = "<path of your module>"
    name = "<name of the webapp>"
    resource_group = "<name of the resource group>"
    tags = {
        <key>   = "<value>"
    }
}
```

## Variables obligatoires

name (string) : "Name for each resources"

resource_group (string) :"Name of the resource_group"



## Variables facultatives

location (string) : "Location for the resources"
  default     = "westeurope"

vnet_range (string) : "cidr for the vnet"
  default     = "10.0.0.0/16"

subnet_endpoint_range (string) : "cidr for the endpoint subnet"
  default     = "10.0.2.0/24"

"tags" (map) : "List of tags"
  default     = {}
