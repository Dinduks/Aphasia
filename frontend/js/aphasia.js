var module = angular.module('aphasia', ['ngResource']);

module.factory('Repository', function($resource) {
  return $resource('http://localhost::port/repos/:keyword', {keyword: '', port: 4567}, {
    query: {method: 'GET', isArray: true},
  });
})

function AphasiaCtrl($scope, Repository) {
  $scope.updateRepositoriesList = function() {
    loadingAnimation('show');
    $('.main-panel').fadeOut('slow');

    Repository.query({keyword: $scope.repositoryName}, function (repositories) {
      $scope.repositories = repositories;

      loadingAnimation('hide');

      if ($('.main-panel').css('display') == 'none')
        $('.main-panel').fadeIn('slow');

      setTimeout(function() {$('.repositories-list a').first().focus();}, 2500);
    });
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

