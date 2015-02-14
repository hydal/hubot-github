# Hubot Github

`Please don't install this yet, it's still a work in progress, and this package is not on NPM yet.`

Give Hubot the ability to take control of Github 


Please contribute, espically on things like:

* If you think the commands can be better setup
* If you think the code could be organized in a better fashion
* And everything else!


## Suggested Setup


## Installation

In hubot project repository, run:

`npm install hubot-github --save`

Then add **hubot-github** to your `external-scripts.json`:

```json
[
  "hubot-github"
]
```


## Configuration

```
HUBOT_GITHUB_KEY   - Github Application Key
HUBOT_GITHUB_ORG  - Github Organization Name
HUBOT_SLACK_ADMIN - Slack Admins who can use certain admin commands
```

## Commands to be Implemented

These are following the API spec set out by [node-github](http://mikedeboer.github.io/node-github/):

* Full Pull Requests API
* Full Repositories API
* Full Users API
* Full Issues API
* Full Search API
* Full Git Data API
* Full Activity API
* Partial Organizations API


## Commands

Organization commands, hence gho (GitHub Organization)

`hubot`:

* `gho` - returns a summary of your organization
* `gho list (teams|repos|members)` - returns a list of the members, teams or repos in your organization
* `gho create team "<team name>"` - creates a team with the following name
* `gho create repo "<repo name>":"<repo desc>":"<private | public>" - creates a repo with the following name, description and type (public or private)
