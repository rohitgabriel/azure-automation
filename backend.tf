terraform {
    backend "remote" {
        organization = "int"
        workspaces {
            name = "azure-automation"
        }
    }
}