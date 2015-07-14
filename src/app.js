( function()
{
	var appVersion = "2.0-dev";
	var userCookieName = "user";
//"Remodora.Login",
	angular.module( "RemodoraApp", ["ui.router", "ui.bootstrap", "snap", "Remodora.Services"] )
	.config( ["$stateProvider", "$urlRouterProvider", function ( $stateProvider, $urlRouterProvider )
	{
		$urlRouterProvider.otherwise( "/" );
	} ])

	.controller( "AppCtrl", [ "$scope", "$location", "$modal", "$state", "Pianobar",
	function ( $scope, $location, $modal, $state, Pianobar )
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
		$scope.stations = ["Quickmix", "Christian Metal Radio", "Dance Radio"];
		$scope.currentStation = "Quickmix";

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
			console.log( "play" );
			Pianobar.play();
		}

		$scope.Pause = function()
		{
			console.log( "pause" );
			Pianobar.pause();
		}

		$scope.Next = function()
		{
			console.log( "next" );
			Pianobar.next();
		}

		$scope.ThumbUp = function()
		{
			console.log( "thumb-up" );
			Pianobar.thumbup();
		}

		$scope.ThumbDown = function()
		{
			console.log( "thumb-down" );
			Pianobar.thumbdown();
		}

		$scope.Tired = function()
		{
			console.log( "tired" );
			Pianobar.tired();
		}
		
		$scope.SongDetails = function()
		{
			console.log( "songdetails" );
			$scope.song = Pianobar.songdetails();
		}
		
		$scope.Stations = function()
		{
			console.log( "stations" );
			$scope.stations = Pianobar.stations();
		}
		
		$scope.ChangeStation = function( station )
		{
			console.log( "changestation", station );
			Pianobar.changestation( { id: station } );
		}
		
		$scope.Signin = function()
		{
			console.log( "signin" );
			Pianobar.signin();
		}
		
		$scope.PowerOff = function()
		{
			console.log( "poweroff" );
			Pianobar.poweroff();
		}
		
//		$scope.Stations();
//		$scope.SongDetails();
		
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
		};
	} ])
} )();
