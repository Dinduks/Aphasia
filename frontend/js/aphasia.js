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
      if (repositories.length == 0) {
        repositories.push({ full_name: 'No repository called "' + $scope.repositoryName + '" were found' });
      }
      $scope.repositories = repositories;

      loadingAnimation('hide');
      $scope.showSearchResults();
    });
  }

  $scope.showRepositoryInfo = function(repositoryFullName) {
    hideSearchResults();

    var username = repositoryFullName.split('/')[0]
    var repo     = repositoryFullName.split('/')[1]
    Commit.query({username: username, repo: repo}, function(commits) {
      $scope.parseRepositoryInfo(commits);
      $scope.totalCommits = commits.length;
    });

    displayRepositoryInfo();
  }

  $scope.showSearchResults = function() {
    $('.search-results').fadeIn();
    $('.repository-info').slideUp();
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

  for (var i=0; i < commits.length; i++) {
    var author = commits[i].author;
    if (!contributors[author.login]) {
      contributors[author.login] = {
        contributionsCounter: 1,
        avatar_url: author.avatar_url,
        url: author.url,
      }
    } else {
      contributors[author.login].contributionsCounter++;
    }
  }

  return contributors;
}

