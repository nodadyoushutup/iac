#!/bin/bash

# Function to check if a GitHub repository exists
function check_repo_exists() {
    repo_url="$1"
    api_url="${repo_url%.git}" # Remove .git from URL
    api_url="https://api.github.com/repos/${api_url#https://github.com/}"

    http_code=$(curl -s -o /dev/null -w "%{http_code}" "$api_url")

    if [[ "$http_code" -ne 200 ]]; then
        echo "Error: Repository does not exist or is inaccessible."
        exit 1
    fi
}

# Function to check if a branch exists in the repository
function check_branch_exists() {
    repo_url="$1"
    branch="$2"
    api_url="${repo_url%.git}" # Remove .git from URL
    api_url="https://api.github.com/repos/${api_url#https://github.com/}/branches/$branch"

    http_code=$(curl -s -o /dev/null -w "%{http_code}" "$api_url")

    if [[ "$http_code" -ne 200 ]]; then
        echo "Error: Branch '$branch' does not exist in the repository."
        exit 1
    fi
}

# Prompt the user for a GitHub repository URL
read -p "Enter the GitHub repository URL: " repo_url

# Check if the input is not empty
if [[ -z "$repo_url" ]]; then
    echo "Error: No URL entered. Exiting."
    exit 1
fi

# Verify repository existence
check_repo_exists "$repo_url"

# Extract repo name from the URL
repo_name=$(basename -s .git "$repo_url")

# Prompt the user for the branch name
read -p "Enter the branch to checkout (leave empty for default): " branch

# If a branch is specified, verify it exists
if [[ -n "$branch" ]]; then
    check_branch_exists "$repo_url" "$branch"
fi

# Clone the repository to the home directory
if [[ -z "$branch" ]]; then
    git clone "$repo_url" ~/ || { echo "Error: Failed to clone repository."; exit 1; }
else
    git clone -b "$branch" --single-branch "$repo_url" ~/ || { echo "Error: Failed to clone repository."; exit 1; }
fi

# Change into the cloned repository directory
cd ~/"$repo_name" || { echo "Error: Repository directory not found."; exit 1; }

# If the branch was specified, ensure it's checked out
if [[ -n "$branch" ]]; then
    git checkout "$branch" || { echo "Error: Failed to checkout branch '$branch'."; exit 1; }
fi

echo "Repository cloned successfully to ~/$(basename "$repo_url" .git) and checked out to branch '${branch:-default}'."
