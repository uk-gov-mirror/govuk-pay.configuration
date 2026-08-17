import {
  for_each = var.repos
  to       = module.repository[each.key].github_repository.this
  id       = each.key
}
