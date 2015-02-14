# Hubot Github

`Please don't install this yet, it's still a work in progress, and this package is not on NPM yet.`

Give Hubot the ability to take control of Github 


Please contribute, espically on things like:

* If you think the commands can be better setup
* If you think the code could be organized in a better fashion
* And everything else!


## Suggested Setup

If you just wanted to use this hubot-script without having to create a special user in your organization, then l suggest that one of the owners of the organization creates a personal access token for the `HUBOT_GITHUB_KEY`. However this will mean that everything that hubot does, will come up as being done by that owner.

The **ideal** setup that in my opinion that works best, is to create a special user called `whatever your hubot` is called. Thenn you make that bot user an owner of your organization, and get that bot user to create a personal access token for the `HUBOT_GITHUB_KEY`. So in the audit log, every event will appear as being done by your bot user. This means, as you give you bot user more abilities, you can properly monitor what exactly it is doing.



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
HUBOT_GITHUB_KEY   - Github Application Key (personal access token)
HUBOT_GITHUB_ORG  - Github Organization Name (the one in the url)
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
* `gho create repo "<repo name>":"<repo desc>":"<private | public>"` - creates a repo with the following name, description and type (public or private)
* `gho add (members|repos) to team "<team name>"` - adds a comma seperated list of members or repos to a given team
