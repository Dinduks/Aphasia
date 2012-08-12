"use strict";

var module = angular.module('aphasia', ['ngResource']);

// This object will handle the Ajax API calls concerning the repos
module.factory('Repository', function($resource) {
  return $resource('http://localhost::port/repos/:keyword', {keyword: '', port: 4567}, {
    query: {method: 'GET', isArray: true},
  });
});

// This one will handle the calls related to the commits
module.factory('Commit', function($resource) {
  return $resource('http://localhost::port/repo/:username/:repo/commits', {repository_full_name: '', port: 4567}, {
    query: {method: 'GET', isArray: true},
  });
});

function AphasiaCtrl($scope, Repository, Commit) {
  $scope.updateRepositoriesList = function() {
    loadingAnimation('show');
    $('.main-panel').fadeOut('slow');

    Repository.query({keyword: $scope.repositoryName}, function(repositories) {
      $scope.noRepositoryFound = (repositories.length == 0) ? true : false;
      $scope.repositories = repositories;

      loadingAnimation('hide');
      $scope.showSearchResults(true);
    });
  }

  $scope.showRepositoryInfo = function(repositoryFullName) {
    var timeline,
        username,
        repo;

    $scope.repositoryTitle = repositoryFullName;
    hideSearchResults();

    username = repositoryFullName.split('/')[0]
    repo     = repositoryFullName.split('/')[1]
    Commit.query({username: username, repo: repo}, function(commits) {
      $scope.noCommitFound = (commits.length == 0) ? true : false;
      $scope.parseRepositoryInfo(commits);
      $scope.totalCommits = commits.length;
      timeline = getTimeline(commits);
      $scope.timeline = timeline;
      setTimeout(function() {createCommitPopovers(timeline)}, 1000);
    });

    displayRepositoryInfo();
  }

  $scope.showSearchResults = function(onSearch) {
    $('.search-results').fadeIn();
    $('.repository-info').slideUp();
    if (onSearch) return;
    $('.repositories-list a').first().focus();
  }

  $scope.parseRepositoryInfo = function(commits) {
    var contributors = getContributors(commits);
    $scope.contributors = contributors;
  }
}

function loadingAnimation(action) {
  if (action == 'hide')
    $('.repository-input').css('background-image', 'none');
  else if (action == 'show')
    $('.repository-input').css('background-image', 'url("./img/loading.gif")');
  else
    throw 'loadingAnimation() has no "' + action + '" option.';
}

function hideSearchResults() {
  $('.search-results').slideUp();
  $('.search-results').css('display', 'block');
}

function displayRepositoryInfo() {
  $('.repository-info').slideDown();
}

function getContributors(commits) {
  var contributors = {};
  var oneSingleCommitPercentage = Math.ceil(1 / commits.length * 100);

  for (var i=0; i < commits.length; i++) {
    var author = commits[i].author;
    if (!contributors[author.login]) {
      contributors[author.login] = {
        contributionsCounter: 1,
        avatar_url: author.avatar_url,
        url: author.url,
        contributionsPercentage: oneSingleCommitPercentage,
      }
    } else {
      contributors[author.login].contributionsCounter++;
      contributors[author.login].contributionsPercentage = Math.ceil(contributors[author.login].contributionsCounter / commits.length * 100);
    }
  }

  return contributors;
}

function getTimeline(commits) {
  var oldestCommitTimestamp,
      newestCommitTimestamp,
      timestampsDifference,
      timeline = {},
      commit,
      percentage,
      i;

  oldestCommitTimestamp = new Date(commits[commits.length - 1].date).getTime() / 1000;
  newestCommitTimestamp = new Date(commits[0].date).getTime() / 1000;
  timestampsDifference  = newestCommitTimestamp - oldestCommitTimestamp;

  for (i=commits.length - 1; i > 0; i--) {
    commit = commits[i];
    percentage = (((new Date(commit.date).getTime() / 1000) - oldestCommitTimestamp) / timestampsDifference * 100);
    timeline[percentage] = commit;
  }

  return timeline;
}

function createCommitPopovers(timeline) {
  var i = 0,
      milestone,
      index,
      commit;

  for (index in timeline) {
    commit = timeline[index];
    $('.timeline-commit-' + i + ' a').popover({
      placement: get_popover_placement,
      trigger: 'hover',
    });
    i++;
  }
}

/**
 * Source: http://stackoverflow.com/a/9261887/604041
 */
function get_popover_placement(pop, dom_el) {
  var width = window.innerWidth;
  if (width<500) return 'bottom';
  var left_pos = $(dom_el).offset().left;
  if (width - left_pos > 400) return 'right';
  return 'left';
}

