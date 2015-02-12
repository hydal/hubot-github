GitHubAPI = require 'github'

github = new GitHubAPI version: "3.0.0", debug: true, headers: Accept: "application/vnd.github.moondragon+json"

organization = process.env.HUBOT_GITHUB_ORG


org = {

  init: () ->
    github.authenticate type: "oauth", token: process.env.HUBOT_GITHUB_KEY


  summary: (msg) ->
    github.orgs.get org: organization, per_page: 100, (err, org) ->
      github.orgs.getMembers org: organization, per_page: 100, (memberErr, members) ->
        github.orgs.getTeams org: organization, per_page: 100, (teamErr, teams) ->
          if err or memberErr or teamErr
            msg.reply "There was an error getting the details of the organization: #{organization}"
          else
            msg.send "<#{org.html_url}|#{org.name}>"
            msg.send " * Location: #{org.location}"
            msg.send " * Created: #{org.created_at}"
            msg.send " * Public Repos: #{org.public_repos}"
            msg.send " * Private Repos: #{org.total_private_repos}"
            msg.send " * Total Repos: #{org.public_repos + org.total_private_repos}"
            msg.send " * Members: <#{org.html_url}/people|#{members.length}>"
            msg.send " * Teams: <#{org.html_url}/teams|#{teams.length}>"
            msg.send " * Collaborators: #{org.collaborators}"
            msg.send " * Followers: #{org.followers}"
            msg.send " * Following: #{org.following}"
            msg.send " * Public Gists: #{org.public_gists}"
            msg.send " * Private Gists: #{org.private_gists}"

  list: {}

  create: {
    team: (msg, teamName) ->
      github.orgs.createTeam org: organization, name: teamName, permission: "push", (err, team) ->
        msg.reply "There was an error and the team: #{teamName} was not created" if err
        msg.send "The team: #{team.name} was successfully created" unless err

    repo: (msg, repoName, repoDesc) ->
  }

  remove: {}

  delete: {}

}



module.exports = org
