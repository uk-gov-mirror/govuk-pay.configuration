#!/usr/bin/env python3

import argparse
import subprocess

parser = argparse.ArgumentParser("import")
parser.add_argument("repo")
parser.add_argument("--branch", default="main")
args = parser.parse_args()

resources = [
    "github_actions_repository_permissions",
    "github_branch_default",
    "github_repository",
    "github_repository_collaborators",
    "github_repository_dependabot_security_updates",
    "github_repository_vulnerability_alerts",
    "github_workflow_repository_permissions",
]


def import_resource(repo, resource, resource_name):
    subprocess.run(
        [
            "aws-vault",
            "exec",
            "deploy",
            "--",
            "terraform",
            "import",
            f'module.repository["{repo}"].{resource}.this',
            resource_name,
        ],
    )


import_resource(args.repo, "github_branch_protection", f"{args.repo}:{args.branch}")
for resource in resources:
    import_resource(args.repo, resource, args.repo)

