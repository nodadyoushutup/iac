#!/bin/bash

# Prompt the user for a GitHub repository URL
read -p "Enter the GitHub repository URL: " repo_url

# Check if the input is not empty
if [[ -z "$repo_url" ]]; then
    echo "Error: No URL entered. Exiting."
    exit 1
fi

# Extract repo name from the URL
repo_name=$(basename -s .git "$repo_url")

# Prompt the user for the branch name
read -p "Enter the branch to checkout (leave empty for default): " branch

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

echo "Repository cloned successfully to ~/$(basename "$repo_url" .git) and checked out to branch '$branch'."
