( function()
{
	var appVersion = "2.0-dev";
	var userCookieName = "user";
//"Remodora.Login",
	angular.module( "RemodoraApp", ["ui.bootstrap", "snap", "Remodora.Services"] )

	.controller( "AppCtrl", [ "$scope", "$location", "$modal", "Pianobar",
	function ( $scope, $location, $modal, Pianobar )
	{
		$scope.version = appVersion;
		$scope.opts =
		{
			disable: "right"
		};
		$scope.song = {
			coverArt: $location.absUrl() + "/images/song.png",
			title: "Loading...",
		};
		$scope.stations = [];
		$scope.currentStation = "";
		$scope.isPlaying = true;

		$scope.Play = function()
		{
			console.log( "play" );
			Pianobar.play();
			$scope.SongDetails();
			$scope.isPlaying = true;
		};

		$scope.Pause = function()
		{
			console.log( "pause" );
			Pianobar.pause();
			$scope.SongDetails();
			$scope.isPlaying = false;
		};

		$scope.Next = function()
		{
			console.log( "next" );
			Pianobar.next();
			$scope.SongDetails();
		};

		$scope.ThumbUp = function()
		{
			console.log( "thumb-up" );
			Pianobar.thumbup();
			$scope.SongDetails();
		};

		$scope.ThumbDown = function()
		{
			console.log( "thumb-down" );
			Pianobar.thumbdown();
			$scope.SongDetails();
		};

		$scope.Tired = function()
		{
			console.log( "tired" );
			Pianobar.tired();
			$scope.SongDetails();
		};

		$scope.ResetVolume = function()
		{
			console.log( "resetvolume" );
			Pianobar.resetvolume();
		};

		$scope.SongDetails = function()
		{
			console.log( "songdetails" );
			Pianobar.songdetails( function( newDetails, headers )
			{
				if ( $scope.song.title != newDetails.title ||
					$scope.song.artist != newDetails.artist ||
					$scope.song.album != newDetails.album ||
					$scope.song.rating != newDetails.rating )
				{
					console.log("Changed details");
					$scope.song = newDetails;
					$scope.currentStation = $scope.song.stationName;
					$scope.isPlaying = true;
				}

				if ( $scope.song.coverArt.length == 0 )
				{
					$scope.song.coverArt = $location.absUrl() + "/images/song.png";
				}
			} );
		};

		$scope.Stations = function()
		{
			console.log( "stations" );
			$scope.stations = Pianobar.stations();
		};

		$scope.ChangeStation = function( station )
		{
			console.log( "changestation", station );
			Pianobar.changestation( { id: station } );
			$scope.SongDetails();
		};

		$scope.Signin = function()
		{
			console.log( "signin" );
			Pianobar.signin();
			$scope.Play();
			$scope.SongDetails();
		};

		$scope.PowerOff = function()
		{
			console.log( "poweroff" );
			Pianobar.poweroff();
			$scope.SongDetails();
			$scope.isPlaying = false;
		};

		$scope.Stations();
		$scope.SongDetails();
		// Refresh song details every X second
		window.setInterval( function()
		{
			$scope.SongDetails();
		}, 5000 );
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
	} ]);
} )();
