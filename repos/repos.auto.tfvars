repos = {
  "configuration" = {
    visibility  = "public"
    description = "Infrastructure-as-code for the GOV.UK Pay GitHub organisation"
  }

  "pay-apple-developer-agreements" = {
    visibility  = "private"
    description = "This repository is for GOV.UK Pay to store and track changes to the Apple Developer Agreement terms and conditions."
  }

  "pay-architecture" = {
    visibility         = "internal"
    description        = "GOV.UK Pay architecture documentation"
    has_discussions    = true
    allow_push_to_main = true
  }
}
