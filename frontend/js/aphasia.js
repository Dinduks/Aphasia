"use strict";

var module = angular.module('aphasia', ['ngResource'], function ($routeProvider) {
    $routeProvider.when('/searchrepo/:keyword', {
        controller:  searchCtrl,
        templateUrl: 'partials/search.html'
    });
    $routeProvider.when('/searchuser/:keyword', {
        controller:  searchCtrl,
        templateUrl: 'partials/search.html'
    });
    $routeProvider.when('/:username/:repositoryName', {
        controller:  repoInfoCtrl,
        templateUrl: 'partials/repo_info.html'
    });
    $routeProvider.otherwise({
        redirectTo: '/'
    });
});

module.factory('Repository', function ($resource) {
    return $resource(
        'http://:url::port/repos/:keyword',
        {url: app.config.apiUrl, port: app.config.apiPort},
        {query: {method: 'GET', isArray: true}}
    );
});

module.factory('UserRepository', function ($resource) {
    return $resource(
        'http://:url::port/user/:keyword/repos',
        {url: app.config.apiUrl, port: app.config.apiPort},
        {query:{method:'GET', isArray:true}}
    );
});

module.factory('Commit', function ($resource) {
    return $resource(
        'http://:url::port/repo/:username/:repo/commits',
        {url: app.config.apiUrl, port: app.config.apiPort},
        {query: {method: 'GET', isArray: true}}
    );
});

function searchCtrl($scope, $routeParams) {
    var keyword;

    hideAllPopovers();
    keyword = $routeParams.keyword;
    // Fire an event along with sharing the repository name that comes form the URL
    $scope.$emit('directSearchEvent', { keyword: keyword });
}

function repoInfoCtrl($scope, $routeParams, Commit) {
    var repositoryFullName;

    repositoryFullName = $routeParams.username + '/' + $routeParams.repositoryName;
    showRepositoryInfo($scope, Commit, repositoryFullName);
}

function AphasiaCtrl($scope, $location, Repository, UserRepository, Commit) {
    // Expect the event fired when searching from the URL
    $scope.$on('directSearchEvent', function (event, args) {
        $scope.keyword = args.keyword;

        app.manualSearch = true;
        $scope.repositoryName = $scope.keyword;

        loadingAnimation('show');
        $('.main-panel').fadeOut('slow');
        if (/\/searchuser\//.test($location.$$url)) {
            $scope.repositoryName += '/';
            $scope.searchUrl = 'searchuser';
            updateRepositoriesList($scope, UserRepository);
        } else if (/\/searchrepo\//.test($location.$$url)) {
            $scope.searchUrl = 'searchrepo';
            updateRepositoriesList($scope, Repository);
        } else {
            throw "Unknown search route.";
        }

        // Automatically focus the first list element
        // if the user isn't typing
        if (!app.isTyping) {
            setTimeout(function () {
                $('.repositories-list a').first().focus()
            }, 1250);
        }
    });

    $scope.updateRepositoriesList = function () {
        var repositoryNameLastChar;

        app.manualSearch = true;

        repositoryNameLastChar = $scope.repositoryName.substr($scope.repositoryName.length - 1, $scope.repositoryName.length);
        if ('/' == repositoryNameLastChar) {
            $location.url('/searchuser/' + $scope.repositoryName);
        } else {
            $location.url('/searchrepo/' + $scope.repositoryName);
        }
    };

    $scope.showRepositoryInfo = function (repositoryFullName) {
        showRepositoryInfo($scope, Commit, repositoryFullName);
    };

    $scope.showSearchResults = function (onSearch) {
        $('.search-results').fadeIn();
        $('.repository-info').slideUp();
    };

    $scope.parseRepositoryInfo = function (commits) {
        var contributors;

        contributors = getContributors(commits);
        $scope.contributors = contributors;
    }
}

// Show or hide the loading gif
function loadingAnimation(action) {
    if ('hide' == action)
        $('.repository-input').removeClass('loading-gif');
    else if ('show' == action)
        $('.repository-input').addClass('loading-gif');
    else
        throw 'loadingAnimation() has no "' + action + '" option.';
}

function hideSearchResults() {
    $('.search-results').slideUp();
}

function displayRepositoryInfo() {
    $('.repository-info').slideDown();
}

function getContributors(commits) {
    var contributors = {},
        oneSingleCommitPercentage = Math.ceil(1 / commits.length * 100),
        committer,
        commit,
        sortedContributors;

    for (var i = 0; i < commits.length; i++) {
        commit = commits[i];
        committer = commit.author;
        if (!contributors[committer.login]) {
            contributors[committer.login] = {
                contributionsCounter:    1,
                avatar_url:              committer.avatar_url,
                url:                     committer.url,
                contributionsPercentage: oneSingleCommitPercentage,
                name:                    committer.name,
                email:                   committer.email
            };
            contributors[committer.login].displayGithubUrl = (committer.login) ? 'true' : 'false';
        } else {
            contributors[committer.login].contributionsCounter++;
            contributors[committer.login].contributionsPercentage = Math.ceil(contributors[committer.login].contributionsCounter / commits.length * 100);
        }
    }

    sortedContributors = sortContributors(contributors);

    return sortedContributors;
}

function sortContributors(contributors) {
    var index,
        sortedContributors = [];

    for (var index in contributors) {
        sortedContributors.push(contributors[index]);
    }

    sortedContributors = sortedContributors.sort(function (a, b) {
        return a.contributionsCounter < b.contributionsCounter;
    });

    return sortedContributors;
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
    timestampsDifference = newestCommitTimestamp - oldestCommitTimestamp;

    for (i = commits.length - 1; i >= 0; i--) {
        commit = commits[i];

        commit.displayGithubUrl = (commit.committer.login) ? 'yes' : 'no';

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
            title:     getShortCommitMessage(commit.message),
            trigger:   'manual'
        });

        $('.timeline-commit-' + i + ' a').click(function () {
            $('.timeline-commit a').popover('hide');
            $(this).popover('show');
            return false;
        });

        $('html').click(function () {
            $('.timeline-commit a').popover('hide');
        });

        i++;
    }
}

/**
 * Source: http://stackoverflow.com/a/9261887/604041
 */
function get_popover_placement(pop, dom_el) {
    var width = window.innerWidth;
    if (500 > width) return 'bottom';
    var left_pos = $(dom_el).offset().left;
    if (400 < width - left_pos) return 'right';
    return 'left';
}

function getShortCommitMessage(message) {
    var shortMessage;

    if (/Merge pull request/.test(message)) {
        shortMessage = 'Merge PR: ';
        shortMessage += $.trim(message.split("\n\n")[1]);
    } else {
        shortMessage = $.trim(message.split("\n")[0]);
    }

    return shortMessage;
}

function updateRepositoriesList($scope, Repository) {
    loadingAnimation('show');
    setTimeout(function () {
        if (500 < (new Date()).getTime() - app.lastRepositoryKeywordUpdate) {
            Repository.query({keyword: $scope.keyword}, function (repositories) {
                loadingAnimation('show');
                $('.main-panel').fadeOut('slow');
                $scope.noRepositoryFound = (0 == repositories.length);

                $scope.repositories = repositories;
                loadingAnimation('hide');
                $scope.showSearchResults();
                $scope.userNotFound = false;
            }, function() {
                $scope.userNotFound = true;
                loadingAnimation('hide');
                $scope.showSearchResults();
            });
        }
    }, 500);

    app.lastRepositoryKeywordUpdate = (new Date()).getTime();
}

function showRepositoryInfo($scope, Commit, repositoryFullName) {
    var timeline,
        username,
        repository;

    $scope.repositoryTitle = repositoryFullName;
    $scope.manualSearch = (app.manualSearch == true) ? true : false;
    hideSearchResults();
    loadingAnimation('show');

    username = repositoryFullName.split('/')[0]
    repository = repositoryFullName.split('/')[1]
    Commit.query({username: username, repo: repository}, function (commits) {
        // This boolean is used to show or hide the
        // "this repo has no commits" message
        $scope.noCommitFound = (0 == commits.length);

        if ($scope.noCommitFound) {
            displayRepositoryInfo();
            loadingAnimation('hide');
            return;
        }

        $scope.parseRepositoryInfo(commits);
        $scope.totalCommits = commits.length;

        timeline = getTimeline(commits);
        $scope.timeline = timeline;
        setTimeout(function () {
            createCommitPopovers(timeline)
        }, 1000);

        loadingAnimation('hide');
        displayRepositoryInfo();
    });
}

function hideAllPopovers(element) {
    element = typeof element !== 'undefined' ? element : $('.popover');

    try {
        element.fadeOut();
        element.remove();
    } catch(e) {
    }
}

