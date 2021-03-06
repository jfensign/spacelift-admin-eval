{
  "version": 4,
  "terraform_version": "0.12.20",
  "serial": 8,
  "lineage": "979b48c6-07f4-2bba-f1c4-eca5d4de8796",
  "outputs": {
    "labels": {
      "value": {
        "account_id": "1234567890",
        "account_name": "webops-dev",
        "account_pwho": "0987",
        "cloud": "aws",
        "group_id": "1270",
        "group_name": "webops",
        "sla": "dev",
        "tenant_group_id": "1270",
        "tenant_name": "webops",
        "vendor_name": "aws",
        "vendor_pwho": "098"
      },
      "type": [
        "object",
        {
          "account_id": "string",
          "account_name": "string",
          "account_pwho": "string",
          "cloud": "string",
          "group_id": "string",
          "group_name": "string",
          "sla": "string",
          "tenant_group_id": "string",
          "tenant_name": "string",
          "vendor_name": "string",
          "vendor_pwho": "string"
        }
      ]
    }
  },
  "resources": [
    {
      "mode": "data",
      "type": "terraform_remote_state",
      "name": "tenant",
      "provider": "provider.terraform",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "backend": "local",
            "config": {
              "value": {
                "path": "../aws-tenant/terraform.tfstate"
              },
              "type": [
                "object",
                {
                  "path": "string"
                }
              ]
            },
            "defaults": null,
            "outputs": {
              "value": {
                "group_id": "1270",
                "labels": {
                  "tenant_group_id": "1270",
                  "tenant_name": "webops"
                },
                "name": "webops"
              },
              "type": [
                "object",
                {
                  "group_id": "string",
                  "labels": [
                    "object",
                    {
                      "tenant_group_id": "string",
                      "tenant_name": "string"
                    }
                  ],
                  "name": "string"
                }
              ]
            },
            "workspace": "default"
          }
        }
      ]
    },
    {
      "mode": "data",
      "type": "terraform_remote_state",
      "name": "vendor",
      "provider": "provider.terraform",
      "instances": [
        {
          "schema_version": 0,
          "attributes": {
            "backend": "local",
            "config": {
              "value": {
                "path": "../aws-vendor/terraform.tfstate"
              },
              "type": [
                "object",
                {
                  "path": "string"
                }
              ]
            },
            "defaults": null,
            "outputs": {
              "value": {
                "labels": {
                  "vendor_name": "aws",
                  "vendor_pwho": "098"
                },
                "name": "aws",
                "pwho": "098"
              },
              "type": [
                "object",
                {
                  "labels": [
                    "object",
                    {
                      "vendor_name": "string",
                      "vendor_pwho": "string"
                    }
                  ],
                  "name": "string",
                  "pwho": "string"
                }
              ]
            },
            "workspace": "default"
          }
        }
      ]
    }
  ]
}
