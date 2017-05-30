//
//  Repository.swift
//  FastlaneExample
//
//  Created by Ivan Bruel on 30/05/2017.
//  Copyright © 2017 Swift Aveiro. All rights reserved.
//

import Foundation
import ObjectMapper

struct Repository: ImmutableMappable {

  let keysURL: String
  let statusesURL: String
  let issuesURL: String
  let defaultBranch: String
  let issueEventsURL: String?
  let identifier: Int
  let owner: User
  let eventsURL: String
  let subscriptionURL: String
  let watchers: Int
  let gitCommitsURL: String
  let subscribersURL: String
  let cloneURL: String
  let hasWiki: Bool
  let URL: String
  let pullsURL: String
  let fork: Bool
  let notificationsURL: String
  let description: String?
  let collaboratorsURL: String
  let deploymentsURL: String
  let languagesURL: String
  let hasIssues: Bool
  let commentsURL: String
  let isPrivate: Bool
  let size: Int
  let gitTagsURL: String
  let updatedAt: String
  let sshURL: String
  let name: String
  let contentsURL: String
  let archiveURL: String
  let milestonesURL: String
  let blobsURL: String
  let contributorsURL: String
  let openIssuesCount: Int
  let forksCount: Int
  let treesURL: String
  let svnURL: String
  let commitsURL: String
  let createdAt: String
  let forksURL: String
  let hasDownloads: Bool
  let mirrorURL: String?
  let homepage: String?
  let teamsURL: String
  let branchesURL: String
  let issueCommentURL: String
  let mergesURL: String
  let gitRefsURL: String
  let gitURL: String
  let forks: Int
  let openIssues: Int
  let hooksURL: String
  let htmlURL: URL
  let stargazersURL: String
  let assigneesURL: String
  let compareURL: String
  let fullName: String
  let tagsURL: String
  let releasesURL: String
  let pushedAt: String?
  let labelsURL: String
  let downloadsURL: String
  let stargazersCount: Int
  let watchersCount: Int
  let language: String
  let hasPages: Bool

  var isSwift: Bool {
    return language == "Swift"
  }

  // swiftlint:disable next function_body_length
  init(map: Map) throws {
    keysURL = try map.value("keys_url")
    statusesURL = try map.value("statuses_url")
    issuesURL = try map.value("issues_url")
    defaultBranch = try map.value("default_branch")
    issueEventsURL = try? map.value("issues_events_url")
    identifier = try map.value("id")
    owner = try map.value("owner")
    eventsURL = try map.value("events_url")
    subscriptionURL = try map.value("subscription_url")
    watchers = try map.value("watchers")
    gitCommitsURL = try map.value("git_commits_url")
    subscribersURL = try map.value("subscribers_url")
    cloneURL = try map.value("clone_url")
    hasWiki = try map.value("has_wiki")
    URL = try map.value("url")
    pullsURL = try map.value("pulls_url")
    fork = try map.value("fork")
    notificationsURL = try map.value("notifications_url")
    description = try? map.value("description")
    collaboratorsURL = try map.value("collaborators_url")
    deploymentsURL = try map.value("deployments_url")
    languagesURL = try map.value("languages_url")
    hasIssues = try map.value("has_issues")
    commentsURL = try map.value("comments_url")
    isPrivate = try map.value("private")
    size = try map.value("size")
    gitTagsURL = try map.value("git_tags_url")
    updatedAt = try map.value("updated_at")
    sshURL = try map.value("ssh_url")
    name = try map.value("name")
    contentsURL = try map.value("contents_url")
    archiveURL = try map.value("archive_url")
    milestonesURL = try map.value("milestones_url")
    blobsURL = try map.value("blobs_url")
    contributorsURL = try map.value("contributors_url")
    openIssuesCount = try map.value("open_issues_count")
    forksCount = try map.value("forks_count")
    treesURL = try map.value("trees_url")
    svnURL = try map.value("svn_url")
    commitsURL = try map.value("commits_url")
    createdAt = try map.value("created_at")
    forksURL = try map.value("forks_url")
    hasDownloads = try map.value("has_downloads")
    mirrorURL = try? map.value("mirror_url")
    homepage = try? map.value("homepage")
    teamsURL = try map.value("teams_url")
    branchesURL = try map.value("branches_url")
    issueCommentURL = try map.value("issue_comment_url")
    mergesURL = try map.value("merges_url")
    gitRefsURL = try map.value("git_refs_url")
    gitURL = try map.value("git_url")
    forks = try map.value("forks")
    openIssues = try map.value("open_issues")
    hooksURL = try map.value("hooks_url")
    htmlURL = try map.value("html_url", using: URLTransform())
    stargazersURL = try map.value("stargazers_url")
    assigneesURL = try map.value("assignees_url")
    compareURL = try map.value("compare_url")
    fullName = try map.value("full_name")
    tagsURL = try map.value("tags_url")
    releasesURL = try map.value("releases_url")
    pushedAt = try? map.value("pushed_at")
    labelsURL = try map.value("labels_url")
    downloadsURL = try map.value("downloads_url")
    stargazersCount = try map.value("stargazers_count")
    watchersCount = try map.value("watchers_count")
    language = try map.value("language")
    hasPages = try map.value("has_pages")
  }
}
