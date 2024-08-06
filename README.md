# actions-workflow-pipeline
Trigger additional workflows

Github docs for the action:
https://docs.github.com/en/rest/actions/workflows?apiVersion=2022-11-28#create-a-workflow-dispatch-event

## Usage
### Trigger one or more workflows
```
uses: mego22/actions-workflow-pipeline@main
with:
  token: "${{ secrets.TOKEN }}"
  dispatch: '[{"org": "mego22" ,"repo": "action-workflow-pipeline","branch": "main","workflow": "test.yml"}]'
```

## Inputs
* `token` - Token with privileges to run workflows
* `dispatch` - JSON with the org, repo, branch, and workflow
