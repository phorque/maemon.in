angular.module("maytricsApp").controller 'MetricsController',
  ["$scope", "$routeParams", "$location", "Metrics", "Users", "Hashtags",
    ($scope, $routeParams, $location, Metrics, Users, Hashtags, $filter) ->
      $scope.search = if $routeParams.search then "##{$routeParams.search}" else ""
      $scope.user =
        id: $routeParams.userId
      $scope.loadUser $scope.user.id

      Metrics.all($routeParams.userId).then (response) ->
        $scope.metrics = response.data.metrics
        $scope.$watch "metrics", ->
          $scope.hashtags = Hashtags.extractAll $scope.metrics
        , true

        $scope.create = ->
          metric =
            name: "New metric"
            value: 5

          Metrics.create($scope.currentUser.id, metric).then (response) ->
            $scope.metrics.unshift response.data.metric

        $scope.delete = (metric) ->
          Metrics.delete($scope.currentUser.id, metric.id).then ->
            $scope.metrics =
              (element for element in $scope.metrics when element != metric)

        $scope.update = (metric) ->
          if (metric.name == "")
            $scope.delete metric
          else
            Metrics.update($scope.currentUser.id, metric.id, metric)


]
