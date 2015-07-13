var remodoraServices = angular.module("Remodora.Services", ["ngResource"] );

remodoraServices.factory( "Pianobar", ["$resource", function( $resource )
{
	return $resource( "api.ws/tickets/:id/:cmd", {},
	{
		post: { method:"POST", isArray:false, transformRequest: [], headers: {'Content-Type': undefined } },
		files: { method:"POST", params: { cmd: "files" }, isArray:false, transformRequest: [], headers: {'Content-Type': undefined } },
		update: { method:"POST", params: { cmd: "update" }, isArray:false, transformRequest: [], headers: {'Content-Type': undefined } },
		upload: { method:"POST", params: { cmd: "upload" }, isArray:false, transformRequest: [], headers: {'Content-Type': undefined } }
	} );
} ]);

remodoraServices.factory( "UI", ["$resource", function( $resource )
{
	return $resource( "api.ws/ui/:id/:cmd", {},
	{
		category: { method:"GET", params: { cmd: "category" }, isArray:true },
		vehicle: { method:"GET", params: { cmd: "vehicle" }, isArray:true },
		country: { method:"GET", params: { cmd: "country" }, isArray:true },
		headlamptype: { method:"GET", params: { cmd: "headlamptype" }, isArray:true },
		headlampcontrol: { method:"GET", params: { cmd: "headlampcontrol" }, isArray:true },
		failuretypes: { method:"GET", params: { cmd: "failuretypes" }, isArray:true },
		specificlocation: { method:"GET", params: { cmd: "specificlocation" }, isArray:true }
	} );
} ]);
