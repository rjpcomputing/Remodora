angular.module( "Traction.Login", ["ui.router", "ui.bootstrap.modal.dialog", "ngCookies", "Traction.Services"] )


.controller( "LoginDialogCtrl", [ "$scope", "$modalInstance", "Users",
function( $scope, $modalInstance, Users )
{
	$scope.Login = function()
	{
		$scope.errorMessage = "";		// Clear the errors

		var fd = new FormData();
		fd.append( "username", $scope.username );
		fd.append( "password", $scope.password );
		Users.login( fd, function( data, status, headers )
		{
			location.reload();
			$modalInstance.close( data );
		},
		function( errorDetails )
		{
			$scope.errorMessage = "Error Occured! Invalid username or password. " + errorDetails.data.userMessage + ".";

			console.log( "Error Occured!" );
			console.log( errorDetails.data );
		} );
	}

	$scope.Cancel = function()
	{
		$modalInstance.dismiss( "cancel" );
	};
} ])

;
