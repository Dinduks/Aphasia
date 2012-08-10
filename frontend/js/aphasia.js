var module = angular.module('aphasia', ['ngResource']);

module.factory('Repository', function($resource) {
  return $resource('http://localhost::port/repos/:keyword', {keyword: '', port: 4567}, {
    query: {method: 'GET', isArray: true},
  });
})

function AphasiaCtrl($scope, Repository) {
  $scope.updateRepositoriesList = function() {
    if ((repositoryName = $scope.repositoryName).length < 3)
      return;

    Repository.query({keyword: repositoryName}, function (repositories) {
      $scope.repositories = repositories;
    });
  }
}

