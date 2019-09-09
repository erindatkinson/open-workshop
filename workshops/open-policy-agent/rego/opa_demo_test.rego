package authz.terraform



test_ver_allowed {
    valid_version with input as { "terraform_version": "0.12.1"}
}

test_ver_denied {
    not valid_version with input as { "terraform_version" : "0.11.13" }
}

test_count_changes_create {
    check_deletes with input as {
        "resource_changes": [
        {
            "type": "aws_security_group",
            "change": {
                "actions": [
                    "create"
                ]
            }
        }]
    }
}

test_count_changes_delete {
    check_deletes with input as {
        "resource_changes": [{
            "type": "google_compute_forwarding_rule",
            "change": {
                "actions": [
                    "delete"
                ]
            }
        }]
    }
}

test_count_changes_too_many_deletes {
    not check_deletes with input as {
        "resource_changes": [
            {
                "type": "aws_security_group",
                "change": {
                    "actions": [
                        "delete"
                    ]
                }
            },
                        {
                "type": "google_compute_forwarding_rule",
                "change": {
                    "actions": [
                        "delete"
                    ]
                }
            },
                        {
                "type": "aws_ami",
                "change": {
                    "actions": [
                        "delete"
                    ]
                }
            },
                        {
                "type": "azurerm_dns_a_record",
                "change": {
                    "actions": [
                        "delete"
                    ]
                }
            },
                        {
                "type": "google_compute_forwarding_rule",
                "change": {
                    "actions": [
                        "delete"
                    ]
                }
            },
                        {
                "type": "azurerm_lb",
                "change": {
                    "actions": [
                        "delete"
                    ]
                }
            },
        ]
    }
}