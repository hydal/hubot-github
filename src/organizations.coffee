# Description:
#   Allow Hubot to manage your github organization members and teams
#
# Dependencies:
#   "github": "latest"
#   "lodash": "latest"
#
# Configuration:
#   HUBOT_GITHUB_KEY - Github Application Key
#   HUBOT_GITHUB_ORG - Github Organization Name
#   HUBOT_SLACK_ADMIN - Userid of slack admins who can use these commands
#
# Commands:
#   hubot gho - returns a summary of your organization
#   hubot gho list (teams|repos|members) - returns a list of members, teams or repos in your organization
#   hubot gho list public repos - returns a list of all public repos in your organization
#   hubot gho create team <team name> - creates a team with the following name
#   hubot gho create repo <repo name>/<private|public> - creates a repo with the following name, description and type (private or public)
#   hubot gho add (members|repos) <members|repos> to team <team name> - adds a comma separated list of members or repos to a given team
#   hubot gho remove (repos|members) <members|repos> from team <team name> - removes the repos or members from the given team
#   hubot gho delete team <team name> - deletes the given team from your organization
#
# Author:
#   Ollie Jennings <ollie@olliejennings.co.uk>

org = require './libs/org'
admins = []

##############################
# API Methods
##############################

isAdmin = (user) ->
  user.id.toString() in admins

ensureConfig = (out) ->
  out "Error: Github App Key is not specified" if not process.env.HUBOT_GITHUB_KEY
  out "Error: Github organization name is not specified" if not process.env.HUBOT_GITHUB_ORG
  out "Error: Slack Admin userid is not specified" if not process.env.HUBOT_SLACK_ADMIN
  return false unless (process.env.HUBOT_GITHUB_KEY and process.env.HUBOT_GITHUB_ORG and process.env.HUBOT_SLACK_ADMIN)
  true


# getOrgMember = (msg, username, orgName) ->
#   ensureConfig msg.send
#   github.orgs.getMember org: orgName, user: username, (err, res) ->
#     msg.reply "There was an error getting the details of org member: #{username}" if err
#     msg.send "#{username} is part of the organization: #{orgName}" unless err




module.exports = (robot) ->

  ensureConfig console.log
  admins = process.env.HUBOT_SLACK_ADMIN.split ','
  org.init()

  robot.respond /gho$/i, (msg) ->
    org.summary msg

  robot.respond /gho list (teams|members|repos)/i, (msg) ->
    org.list[msg.match[1]] msg

  robot.respond /gho list (public) (repos)/i, (msg) ->
    org.list[msg.match[2]] msg, msg.match[1]

  robot.respond /gho create (team|repo) (\w.+)/i, (msg) ->
    unless isAdmin msg.message.user
      msg.reply "Only admins can use `create` commands"
    else
      org.create[msg.match[1]] msg,  msg.match[2].split('/')[0], msg.match[2].split('/')[1]

  robot.respond /gho add (members|repos) (\w.+) to team (\w.+)/i, (msg) ->
    unless isAdmin msg.message.user
      msg.reply "Only admins can use `add` commands"
    else
      org.add[msg.match[1]] msg, msg.match[2], msg.match[3]

  robot.respond /gho remove (members|repos) (\w.+) from team (\w.+)/i, (msg) ->
    unless isAdmin msg.message.user
      msg.reply "Only admins can use `remove` commands"
    else
      org.remove[msg.match[1]] msg, msg.match[2], msg.match[3]

  robot.respond /gho delete (team) (\w.+)/, (msg) ->
    unless isAdmin msg.message.user
      msg.reply "Only admins can use the `delete` commands"
    else
      org.delete[msg.match[1]] msg, msg.match[2]
