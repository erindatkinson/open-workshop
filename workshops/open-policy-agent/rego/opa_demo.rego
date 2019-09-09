package authz.terraform
# ^ This really could be anything, it's just your package definition.

default allow = false
# This allows us to access the resource changes array directly.
import input.resource_changes

# Limit configs

tf_versions = { "0.12.1", "0.12.2", "0.12.3"}
blast_radius = 5

# Main rule to evaluate.
allow {
    valid_version
    check_deletes
}

## General Rules
valid_version {
    # We need you to be running within our allowed versions (0.12.1, 0.12.2, 0.12.3)
    tf_versions[_] == input["terraform_version"]
}

check_deletes {
    deletes := count([type | 
        resource_changes[i].change.actions[_] == "delete"
        type := resource_changes[i].type
    ])

    deletes < blast_radius
}

## AWS Specific rules


## Azure Specific rules

## GCP Specific rules




