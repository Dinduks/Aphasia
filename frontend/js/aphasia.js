var module = angular.module('aphasia', ['ngResource']);

// This object will handle the Ajax API calls
module.factory('Repository', function($resource) {
  return $resource('http://localhost::port/repos/:keyword', {keyword: '', port: 4567}, {
    query: {method: 'GET', isArray: true},
  });
});

function AphasiaCtrl($scope, Repository) {
  $scope.updateRepositoriesList = function() {
    loadingAnimation('show');
    $('.main-panel').fadeOut('slow');

    Repository.query({keyword: $scope.repositoryName}, function (repositories) {
      if (repositories.length == 0) {
        repositories.push({ full_name: 'No repository called "' + $scope.repositoryName + '" were found' });
      }
      $scope.repositories = repositories;

      loadingAnimation('hide');
      $scope.showSearchResults();
      setTimeout(function() {$('.repositories-list a').first().focus();}, 2500);
    });
  }

  $scope.showRepositoryInfo = function(fullName) {
    hideSearchResults();
    $scope.parseRepositoryInfo();
    displayRepositoryInfo();
  }

  $scope.showSearchResults = function() {
    $('.search-results').fadeIn();
    $('.repository-info').slideUp();
    $('.repositories-list a').first().focus();
  }

  $scope.parseRepositoryInfo = function() {}
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
