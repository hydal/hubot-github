# Hubot Github

[![npm version](https://badge.fury.io/js/hubot-github.svg)](http://badge.fury.io/js/hubot-github)
[![Dependency Status](https://david-dm.org/boxxenapp/hubot-github.svg)](https://david-dm.org/boxxenapp/hubot-github)

> Give Hubot the ability to take control of Github

Hubot-GitHub gives `Hubot` the ability to **take control of your github organization**, such as **creating repos or teams**. With this script, `Hubot` can even list the details about your organization, teams, members and repos. The only dependency required is having a [GitHub](http://github.com/) account! (oh and maybe [Node.js](http://nodejs.org) and [npm](http://npmjs.org) aswell).

**FYI: This hubot-script will only work with slack right now**


## Suggested Setup

If you just wanted to use this hubot-script without having to create a special user in your organization, then l suggest that one of the owners of the organization creates a personal access token for the `HUBOT_GITHUB_KEY`. However this will mean that everything that hubot does, will come up as being done by that owner.

The **ideal** setup in my opinion that works best, is to create a special user called `whatever your hubot` is called. Then you make that bot user an owner of your organization, and get that bot user to create a personal access token for the `HUBOT_GITHUB_KEY`. So in the audit log, every event will appear as being done by your bot user. This means, as you give you bot user more abilities, you can properly monitor what exactly it is doing.



## Installation

In hubot project repository, run:

```sh
$ npm install --save hubot-github
```

Then add **hubot-github** to your `external-scripts.json`:

```json
[
  "hubot-github"
]
```




## Configuration

**Environmental variables**

```
HUBOT_GITHUB_KEY   - Github Application Key (personal access token)
HUBOT_GITHUB_ORG  - Github Organization Name (the one in the url)
HUBOT_SLACK_ADMIN - Slack Admins who can use certain admin commands
```




## Commands

Organization commands, hence gho (GitHub Organization)

```
hubot:
- gho - returns a summary of your organization
- gho list (team|repos|members) - returns a list of (members|teams|repos) in your org
- gho list public repos - returns a list of your orgs public repos
- gho create team <team name> - creates a team with the following name
- gho create repo <repo name>/<public|private> - create a repo with the following name and optional status
- gho add (members|repos) to team <team name> - adds a comma separated list of members or repos to the given team
- gho remove (members|repos) from team <team name> - removes comma list of members or repos from the given team
- gho delete team <team name> - deletes the given team from your org (doesn't delete the repos or members from your org)
```


## Changelog

**2015-03-09**: [Release Notes](http://github.com/boxxenapp/hubot-github/releases/tag/v0.2.0)
