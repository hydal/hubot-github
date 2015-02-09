# Description:
#   Say Hi to Hubot.
#
# Dependencies:
#   "github": "latest"
#
# Configuration:
#   HUBOT_GITHUB_KEY - Github Application Key
#   HUBOT_GITHUB_ORG - Github Organization Name
#   HUBOT_SLACK_ADMIN - Userid of slack admins who can use these commands
#
# Commands:
#   hubot org list members|users
#
# Author:
#   Ollie Jennings <ollie@olliejennings.co.uk>


GithubiApi = require 'github'

github = new GithubiApi version: "3.0.0", debug: true, headers: Accept: "application/vnd.github.moondragon+json"

admins = []



# verify that all the environment vars are available
ensureConfig = (out) ->
  out "Error: Github App Key is not specified" if not process.env.HUBOT_GITHUB_KEY
  out "Error: Github organization name is not specified" if not process.env.HUBOT_GITHUB_ORG
  out "Error: Slack Admin userid is not specified" if not process.env.HUBOT_SLACK_ADMIN
  return false unless (process.env.HUBOT_GITHUB_KEY and process.env.HUBOT_GITHUB_ORG and process.env.HUBOT_SLACK_ADMIN)
  true



##############################
# API Methods
##############################

isAdmin = (user) ->
  user.id.toString() in admins

getOrgMembers = (msg, orgName) ->
  ensureConfig msg.send
  github.orgs.getMembers org: orgName, per_page: 100, (err, res) ->
    msg.reply "There was an error getting the members for organization: #{orgName}" if err
    msg.send "* <#{user.url}|#{user.login}>" for user in res unless err and res.length == 0


getOrgMember = (msg, username, orgName) ->
  ensureConfig msg.send
  github.orgs.getMember org: orgName, user: username, (err, res) ->
    msg.reply "There was an error getting the details of org member: #{username}" if err
    msg.send "#{username} is part of the organization: #{orgName}" unless err


getOrgTeams = (msg, orgName) ->
  ensureConfig msg.send
  github.orgs.getTeams org: orgName, per_page: 100, (err, res) ->
    msg.reply "There was an error getting the teams for organization: #{orgName}" if err
    msg.send "* <https://github.com/org/#{orgName}/teams/#{team.name}|#{team.name}> - #{team.description}" for team in res unless err and res.length == 0

getOrgRepos = (msg, orgName, repoType) ->
  ensureConfig msg.send
  github.repos.getFromOrg org: orgName, type: repoType, per_page: 100, (err, res) ->
    msg.reply "There was an error getting all repos for organization: #{orgName}" if err
    msg.send "*<#{repo.html_url}|#{repo.name}> - #{repo.description}" for repo in res unless err and res.length == 0



module.exports = (robot) ->

  ensureConfig console.log
  admins = process.env.HUBOT_SLACK_ADMIN.split ','

  github.authenticate type: "oauth", token: process.env.HUBOT_GITHUB_KEY

  robot.respond /org list (members|users)/i, (msg) ->
    getOrgMembers msg, process.env.HUBOT_GITHUB_ORG

  robot.respond /org check (member|user) (\w+)/i, (msg) ->
    getOrgMember msg, msg.match[2], process.env.HUBOT_GITHUB_ORG

  robot.respond /org list teams/i, (msg) ->
    getOrgTeams msg, process.env.HUBOT_GITHUB_ORG

  robot.respond /org list repos/i, (msg) ->
    getOrgRepos msg, process.env.HUBOT_GITHUB_ORG, "all"



  robot.respond /hello/, (msg) ->
    unless isAdmin msg.message.user
      msg.reply "Sorry, only admins use github organization commands."
    else
      msg.reply "hello!"
