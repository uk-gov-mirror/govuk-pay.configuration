#!/usr/bin/env python3

import argparse
import json
import os
import pathlib
import sys

import github

SCRIPT_DIR = pathlib.Path(__file__).parent.resolve()
REPOS_FILE = SCRIPT_DIR / ".." / "repos" / "repos.auto.tfvars.json"


def parse_args():
    parser = argparse.ArgumentParser("import-repo")
    parser.add_argument("repos", nargs="+")
    return parser.parse_args()


def load_current_repos():
    with REPOS_FILE.open() as f:
        return json.load(f)


def generate_repo_configs(client, name):
    repo = client.get_repo(f"govuk-pay/{name}", lazy=True)
    configs = {"visibility": repo.visibility}

    if repo.default_branch != "main":
        configs["default_branch"] = repo.default_branch

    if repo.description is not None:
      configs["description"] = repo.description

    return configs


def update_repos(terraform_json):
    terraform_json["repos"] = dict(sorted(terraform_json["repos"].items()))
    with REPOS_FILE.open("w") as f:
        json.dump(terraform_json, f, indent=2)


def main():
    args = parse_args()

    github_token = os.getenv("GITHUB_TOKEN")
    if github_token is None:
        print(
            "Set GITHUB_TOKEN to a PAT with read access to repository metadata",
            file=sys.stderr,
        )
        sys.exit(1)

    auth = github.Auth.Token(github_token)
    client = github.Github(auth=auth)

    terraform_json = load_current_repos()
    terraform_repos = terraform_json["repos"]
    for name in args.repos:
        terraform_repos[name] = generate_repo_configs(client, name)
    update_repos(terraform_json)


if __name__ == "__main__":
    main()
