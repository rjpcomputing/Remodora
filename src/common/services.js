var remodoraServices = angular.module("Remodora.Services", ["ngResource"] );

remodoraServices.factory( "Pianobar", ["$resource", function( $resource )
{
	return $resource( "pianobar/:cmd/:id", {},
	{
		play: { method:"GET", params: { cmd: "action", id: "play" }, isArray:false, transformRequest: [], headers: {'Content-Type': undefined } },
		pause: { method:"GET", params: { cmd: "action", id: "pause" }, isArray:false, transformRequest: [], headers: {'Content-Type': undefined } },
		next: { method:"GET", params: { cmd: "action", id: "next" }, isArray:false, transformRequest: [], headers: {'Content-Type': undefined } },
		thumbup: { method:"GET", params: { cmd: "action", id: "thumbup" }, isArray:false, transformRequest: [], headers: {'Content-Type': undefined } },
		thumbdown: { method:"GET", params: { cmd: "action", id: "thumbdown" }, isArray:false, transformRequest: [], headers: {'Content-Type': undefined } },
		tired: { method:"GET", params: { cmd: "action", id: "tired" }, isArray:false, transformRequest: [], headers: {'Content-Type': undefined } },
		stations: { method:"GET", params: { cmd: "stations" }, isArray:true },
		changestation: { method:"GET", params: { cmd: "changestation" }, isArray:false, transformRequest: [], headers: {'Content-Type': undefined } },
		songdetails: { method:"GET", params: { cmd: "songdetails" }, isArray:false, transformRequest: [], headers: {'Content-Type': undefined } },
		signin: { method:"POST", params: { cmd: "signin" }, isArray:false, transformRequest: [], headers: {'Content-Type': undefined } },
		resetvolume: { method:"GET", params: { cmd: "action", id: "resetvolume" }, isArray:false, transformRequest: [], headers: {'Content-Type': undefined } },
		poweroff: { method:"GET", params: { cmd: "action", id: "poweroff" }, isArray:false, transformRequest: [], headers: {'Content-Type': undefined } }
	} );
} ]);
