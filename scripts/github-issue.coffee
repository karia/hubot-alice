# Description
#   Add & Get Github issue
#
# Dependencies:
#   "githubot": "<module version>"
#
# Configuration:
#   HUBOT_GITHUB_TOKEN
#
# Commands:
#   hubot get issue <issue_number> - get issue title and URL
#   hubot add issue <issue title> - add issue
#
# Author:
#   karia <karia@side2.net>

module.exports = (robot) ->
  github = require('githubot')(robot)
  repository = "karia/hubot-alice"

  robot.respond /issue add (.*)/i, (res) ->
    issue_title = res.match[1]
    issue_description = res.match[1]
    res.send "GitHub #{repository} にIssueを追加します: #{issue_title}"
    data = { title: "#{issue_title}", body: "#{issue_description}" }
    github.post "repos/#{repository}/issues" , data ,(issue) ->
      console.log "[NOTICE] issue add: " + issue.html_url
      res.send "追加されました: ##{issue.number} #{issue.title} #{issue.html_url}"

  robot.respond /issue list$/i, (res) ->
    res.send "GitHub #{repository} の Issue Listを取得します..."
    data = { status: "open" , sort: "updated" }
    github.get "repos/#{repository}/issues" , data ,(issue) ->
      resp_list = ["##Issue list"]
      for key,value of issue
        resp_list.push("- #" + value.number + " " + value.title + ": " + value.html_url)
      console.log "[NOTICE] issue list: " + resp_list
      res.send resp_list.join("\n")

  robot.respond /issue get (.*)/i, (res) ->
    issue_number = res.match[1]
    res.send "GitHub #{repository} の Issue ##{issue_number}を取得します..."
    github.get "repos/#{repository}/issues/#{issue_number}" ,(issue) ->
      resp_get = """
##{issue.number} #{issue.title}: #{issue.html_url}
description:
#{issue.body}
"""
      console.log "[NOTICE] get issue: " + resp_get
      res.send resp_get

