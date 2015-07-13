( function()
{
	var appVersion = "2.0-dev";
	var userCookieName = "user";
//"Remodora.Login",
	angular.module( "RemodoraApp", ["ui.router", "ui.bootstrap", "snap"] )
	.config( ["$stateProvider", "$urlRouterProvider", function ( $stateProvider, $urlRouterProvider )
	{
		$urlRouterProvider.otherwise( "/" );
	} ])

	.controller( "AppCtrl", [ "$scope", "$location", "$modal", "$state", //"Users",
	function ( $scope, $location, $modal, $state ) //, Users )
	{
		$scope.version = appVersion;
		$scope.opts =
		{
			disable: "right"
		};
		$scope.song = {
			albumArt: "/images/song.png",
			title: "Loading...",
			album: "",
			artist: ""
		}
		$scope.station = "Quickmix"
		$scope.name = "world";
		$scope.isCollapsed = true;
//		$scope.currentUser = {};
//
		$scope.$on( "$stateChangeSuccess", function( event, toState, toParams, fromState, fromParams)
		{
			if ( angular.isDefined( toState.data.pageTitle ) )
			{
				$scope.pageTitle = toState.data.pageTitle;
			}
			if ( angular.isDefined( toState.data.pageDescription ) )
			{
				$scope.pageDescription = toState.data.pageDescription;
			}
		});

		$scope.Play = function()
		{
			$state.go( "play" );
		}

		$scope.Pause = function()
		{
			$state.go( "pause" );
		}

		$scope.Next = function()
		{
			$state.go( "next" );
		}

		$scope.ThumbUp = function()
		{
			$state.go( "thumb-up" );
		}

		$scope.ThumbDown = function()
		{
			$state.go( "thumb-down" );
		}

		$scope.Tired = function()
		{
			$state.go( "tired" );
		}

//		$scope.ShowLoginDialog = function()
//		{
//			var modalInstance = $modal.open(
//			{
//				templateUrl: "common/login/login-dialog.tpl.html",
//				controller: "LoginDialogCtrl",
//				backdrop: "static",
//				keyboard: false
//			});
//
//			modalInstance.result.then( function( userDetails )
//			{
//				$scope.currentUser = userDetails;
//				$cookieStore.put( userCookieName, $scope.currentUser );
//				$state.go( "tickets-by-user", { id: userDetails.id } );
//				console.log( "Logged in users details:" );
//				console.log( $scope.currentUser );
//			});
//		}
//
//		$scope.LoadUserDetails = function()
//		{
//			var userDetails = $cookieStore.get( userCookieName );
//			if ( userDetails )
//			{
//				$scope.currentUser = userDetails;
//				console.log( "Returning user so no need to show login" );
//			}
//			else
//			{
//				$scope.ShowLoginDialog();
//			}
//		}
//
//		$scope.IsLoggedIn = function()
//		{
//			if ( $scope.currentUser && $scope.currentUser.id )
//			{
//				return true;
//			}
//			else
//			{
//				return false;
//			}
//		}
//
//		$scope.IsAdmin = function()
//		{
//			if ( $scope.currentUser && $scope.currentUser.is_admin )
//			{
//				return true;
//			}
//			else
//			{
//				return false;
//			}
//		}
//
//		$scope.Logout = function( userid )
//		{
//			$cookieStore.remove( userCookieName );
//			$scope.currentUser = {};
//			$scope.LoadUserDetails();
//		}
//
//		if( navigator.sayswho.search( "IE" ) != -1 )
//		{
//			console.log( "IE found. Unsupported browser found.");
//			window.location =  "unsupportedBrowser.html";
//		}
//		else
//		{
//			$scope.LoadUserDetails();
//			console.log( $scope.currentUser );
//		}
    } ])

	.directive( "playerControls", ["$parse", function( $parse )
	{
		return {
			restrict: "E",
			replace: "true",
			templateUrl: "common/player-controls.tpl.html"
//			link: function( scope, element, attrs )
//			{
//
//			}
		};
	} ])
} )();
