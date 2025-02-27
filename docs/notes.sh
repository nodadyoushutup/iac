git reset --soft $(git rev-list --max-parents=0 HEAD)
git commit -m "Your new big commit message"