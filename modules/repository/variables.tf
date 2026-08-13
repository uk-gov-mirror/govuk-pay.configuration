variable "name" {
  type = string
}

variable "repository" {
  type = object({
    description        = optional(string, null)
    visibility         = string
    homepage_url       = optional(string, null)
    default_branch     = optional(string, "main")
    has_discussions    = optional(bool, false)
    has_issues         = optional(bool, true)
    license_template   = optional(string, null)
    topics             = optional(list(string), [])
    actions_enabled    = optional(bool, true)
    actions_allowed    = optional(list(string), [])
    allow_push_to_main = optional(bool, false)
  })
}
