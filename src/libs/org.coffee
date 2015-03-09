GitHubAPI = require 'github'
_ = require 'lodash'

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
            msg.send "`#{org.name}`"
            msg.send " - Location: #{org.location}"
            msg.send " - Created: #{org.created_at}"
            msg.send " - Public Repos: `#{org.public_repos}`"
            msg.send " - Private Repos: `#{org.total_private_repos}`"
            msg.send " - Total Repos: `#{org.public_repos + org.total_private_repos}`"
            msg.send " - Members: `#{members.length}`"
            msg.send " - Teams: `#{teams.length}`"
            msg.send " - Collaborators: #{org.collaborators}"
            msg.send " - Followers: #{org.followers}"
            msg.send " - Following: #{org.following}"
            msg.send " - Public Gists: #{org.public_gists}"
            msg.send " - Private Gists: #{org.private_gists}"

  list: {
    teams: (msg) ->
      github.orgs.getTeams org: organization, per_page: 100, (err, res) ->
        msg.reply "There was an error fetching the teams for the organization: #{organization}" if err
        msg.send " - #{team.name} - #{team.description}" for team in res unless err and res.length == 0

    members: (msg, teamName) ->
      github.orgs.getMembers org: organization, per_page: 100, (err, res) ->
        msg.reply "There was an error fetching the memebers for the organization:#{organization}" if err
        msg.send "- #{user.login}" for user in res unless err and res.length == 0

    repos: (msg, repoType="all") ->
      github.repos.getFromOrg org: organization, type: repoType, per_page: 100, (err, res) ->
        msg.reply "There was an error fetching all the repos for the organization: #{organization}" if err
        msg.send " - #{repo.name} - #{repo.description}" for repo in res unless err and res.length == 0
  }

  create: {
    team: (msg, teamName) ->
      github.orgs.createTeam org: organization, name: teamName, permission: "push", (err, team) ->
        msg.reply "There was an error and the team: `#{teamName}` was not created" if err
        msg.send "The team: `#{team.name}` was successfully created" unless err

    repo: (msg, repoName, repoStatus) ->
      github.repos.createFromOrg org: organization, name: repoName, private: repoStatus == "private", (err, repo) ->
        msg.reply "There was an error, and the repo: `#{repoName}` was not created" if err
        msg.send "The private repo: `#{repo.name}` was created" unless err or !repo.private
        msg.send "The public repo: `#{repo.name}` was created" unless err or repo.private
  }

  add: {
    repos: (msg, repoList, teamName) ->
      github.orgs.getTeams org: organization, per_page: 100, (err, res) ->
        return msg.reply "There was an error adding the repos: #{repoList} to the team: #{teamName}" if err or res.length == 0
        team = _.find(res, { name: teamName })
        if team
          for repository in repoList.split ','
            github.orgs.addTeamRepo id: team.id, user: organization, repo: repository, (err, res) ->
              msg.reply "The repo: `#{repository}` could not be added to the team: #{team.name}" if err
              msg.send "The repo: `#{repository}` was added to the team: #{team.name}" unless err

    members: (msg, memberList, teamName) ->
      github.orgs.getTeams org: organization, per_page: 100, (err, res) ->
        return msg.reply "There was an error adding the members: #{memberList} to the team: #{teamName}" if err or res.length == 0
        team = _.find(res, { name: teamName })
        if team
          for member in memberList.split ','
            github.orgs.addTeamMember id: team.id, user: member, (err, res) ->
              msg.reply "The member: `#{member}` could not be added to the team: #{team.name}" if err
              msg.send "The member: `#{member}` was added to the team: #{team.name}" unless err
  }

  remove: {
    repos: (msg, repoList, teamName) ->
      console.log repoList, teamName
      github.orgs.getTeams org: organization, per_page: 100, (err, res) ->
        return msg.reply "There was an error removing the repos: #{repoList} from the team: #{teamName}" if err or res.length == 0
        team = _.find(res, { name: teamName })
        if team
          for repository in repoList.split ','
            github.orgs.deleteTeamRepo id: team.id, user: organization, repo: repository, (err, res) ->
              msg.reply "The repo: `#{repository}` could not be removed from the team: #{teamName}" if err
              msg.send "The repo: `#{repository}` was removed from the team: #{teamName}" unless err

    members: (msg, memberList, teamName) ->
      github.orgs.getTeams org: organization, per_page: 100, (err, res) ->
        return msg.reply "There was an error removing the members: #{memberList} from the team: #{teamName}" if err or res.length == 0
        team = _.find(res, { name: teamName })
        if team
          for member in memberList.split ','
            github.orgs.deleteTeamMember id: team.id, user: member, (err, res) ->
              msg.reply "The member: `#{member}` could not be removed from the team: #{teamName}" if err
              msg.send "The member: `#{member}` was removed from the team: #{teamName}" unless err

  }

  delete: {
    team: (msg, teamName) ->
      github.orgs.getTeams org: organization, per_page: 100, (err, res) ->
        return msg.reply "There was an error deleteing the team: #{teamName}" if err or res.length == 0
        team = _.find(res, { name: teamName })
        if team
          github.orgs.deleteTeam id: team.id, (err, res) ->
            msg.reply "The team: `#{teamName}` could not be deleted" if err
            msg.send "The team: `#{teamName}` was successfully deleted" unless err
  }

}



module.exports = org
