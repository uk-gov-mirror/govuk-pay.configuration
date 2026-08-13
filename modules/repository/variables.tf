variable "name" {
  type = string
}

variable "repository" {
  type = object({
    description            = optional(string, null)
    visibility             = string
    homepage_url           = optional(string, null)
    default_branch         = optional(string, "main")
    has_discussions        = optional(bool, false)
    has_issues             = optional(bool, true)
    license_template       = optional(string, null)
    topics                 = optional(list(string), [])
    actions_enabled        = optional(bool, true)
    actions_allowed        = optional(list(string), [])
    allow_push_to_main     = optional(bool, false)
    fast_forward_only      = optional(bool, false)
    required_status_checks = optional(list(string), [])
  })
  description = <<-EOF
  fast_forward_only: Defaults to `false`. Require branches to be up to date before they can be merged.
  required_status_checks: Defaults to `[]`. A list of job names or IDs that must pass prior to merging.
  EOF
}
