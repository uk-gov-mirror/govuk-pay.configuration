resource "github_repository" "this" {
  name                        = var.name
  description                 = var.repository.description
  visibility                  = var.repository.visibility
  homepage_url                = var.repository.homepage_url
  topics                      = var.repository.topics
  has_discussions             = var.repository.has_discussions
  has_issues                  = var.repository.has_issues
  has_projects                = false
  has_wiki                    = false
  allow_merge_commit          = true
  allow_squash_merge          = true
  allow_rebase_merge          = true
  allow_auto_merge            = false
  allow_update_branch         = true
  delete_branch_on_merge      = true
  web_commit_signoff_required = false
  archive_on_destroy          = true
}

resource "github_actions_repository_permissions" "this" {
  repository           = github_repository.this.name
  enabled              = var.repository.actions_enabled
  sha_pinning_required = true
  allowed_actions      = "selected"
  allowed_actions_config {
    github_owned_allowed = true
    patterns_allowed     = var.repository.actions_allowed
  }
}

resource "github_branch_default" "this" {
  repository = github_repository.this.name
  branch     = var.repository.default_branch
}

resource "github_branch_protection" "this" {
  repository_id  = github_repository.this.id
  pattern        = var.repository.default_branch
  enforce_admins = true

  dynamic "required_status_checks" {
    for_each = var.repository.allow_push_to_main ? [] : ["this"]

    content {
      strict   = var.repository.fast_forward_only
      contexts = var.repository.required_status_checks
    }
  }

  dynamic "required_pull_request_reviews" {
    for_each = var.repository.allow_push_to_main ? [] : ["this"]

    content {
      required_approving_review_count = 1
      require_last_push_approval      = true
      dismiss_stale_reviews           = true
    }
  }
}

resource "github_repository_collaborators" "this" {
  repository = github_repository.this.name

  team {
    team_id    = "team-payments"
    permission = "push"
  }

  team {
    team_id    = "team-payments-admin"
    permission = "admin"
  }

  team {
    team_id    = "team-payments-readonly"
    permission = "pull"
  }
}

resource "github_repository_dependabot_security_updates" "this" {
  repository = github_repository.this.name
  enabled    = true

  depends_on = [
    github_repository_vulnerability_alerts.this
  ]
}

resource "github_repository_vulnerability_alerts" "this" {
  repository = github_repository.this.name
  enabled    = true
}

resource "github_workflow_repository_permissions" "this" {
  repository                   = github_repository.this.name
  default_workflow_permissions = "read"
}
