angular.module('Phonebook', ['angularFileUpload'])
.controller('ContactsCtrl',['$scope','$http', '$upload','$interval', function($scope,$http, $upload,$interval){
  
  var currentJob = null; 


  var states = {
    completed: 'completed',
    working: 'working',
    queued: 'queued'
  };

  var refreshData = function(){
      return $http({method:'GET', url:'api/contacts.json'})
        .success(function(data){
           $scope.phonebook = data;
        });
  };
  
  $scope.downloadLink = 'api/contacts/download.txt';
  $scope.onNewEntry = function(){
    var number = $scope.newNumber;
    var name = $scope.newName;
    var newEntry = {
      full_name:name,
      number:number
    };
    $http({method:'POST', url:'api/contacts.json', data: newEntry})
    .success(function(){
      $scope.phonebook.push(newEntry);
      $scope.newNumber = '';
      $scope.newName = '';
    });

  }

  $scope.Edit = function(selectedEntry){
    var updatedEntry = {
      full_name:selectedEntry.full_name,
      number:selectedEntry.number
    };
    $http({method:'PUT', url:'api/contacts/' + selectedEntry.id + '.json', data: updatedEntry})
    .success(function(){
      $scope.editMode = false;
      refreshData()
    });
  };

  $scope.Delete = function(selectedEntry){
    $http({method:'DELETE', url:'api/contacts/' + selectedEntry.id + '.json'})
    .success(function(){
      refreshData()
    });
  };

  $scope.onFileSelect = function($files) {
    for (var i = 0; i < $files.length; i++) {
      var file = $files[i];
      $scope.upload = $upload.upload({
        url: 'api/contacts/upload', //upload.php script, node.js route, or servlet url
        method: 'POST',
        fileFormDataName: 'phonebook',
        file: file
      })
      .progress(function(evt) {
        console.log('percent: ' + parseInt(100.0 * evt.loaded / evt.total));
      })
      .success(function(data, status, headers, config) {
        currentJob = data.job_id;
        $scope.inProgress = true;
      })
      .then(function(){

        var promise = $interval(function(){
          
          $http({
            method:'GET',
            url:'api/jobs/' + currentJob +'/status.json'
          })
          .success(function(data){
            switch(data.status){
              case states.completed:
              $interval.cancel(promise);
              refreshData()
              .then(function(){
                 $scope.inProgress = false;
                 currentJob = null;  
              });
              break;
              case states.working:
              case states.queued:
              default:
                return;
            }
          });

        },1000);
      });
      // .error(function(){
      //   currentJob = null;
      //   $scope.inProgress = false;
      // }); 
    }
  };

  refreshData();

}]);

