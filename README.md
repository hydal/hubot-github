# Hubot Github Organization

Give Hubot the ability to take control of you're Github Organization

## Installation

In hubot project repository, run:

`npm install hubot-github-org --save`

Then add **hubot-github-org** to your `external-scripts.json`:

```json
[
  "hubot-github-org"
]
```


## Configuration

```
HUBOT_GITHUB_KEY   - Github Application Key
HUBOT_GITHUB_ORG  - Github Organization Name
HUBOT_SLACK_ADMIN - Slack Admins who can use this command
```


### test

This directory is home to any tests you write for your scripts. This example
package uses Mocha, Chai and Sinon to manage writing tests.

## Advantages of Building a Package

Some of the advantages of building an npm package for your hubot script(s) are:

* You don't need to rely on when hubot-scripts package is released.
* You can specify dependencies in the `package.json` rather than have users
  manually specify them
* You can easily add tests using your favourite frameworks and libraries
