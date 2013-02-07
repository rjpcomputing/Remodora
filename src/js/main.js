$(document).ready( function()
{
	//toastr.info('Are you the 6 fingered man?');
	//toastr.error('Another message');

	// Setup keyboard shortcuts
	Mousetrap.bind( ["p", "space"], function() { $.get( "/remodora/rest/action/p" ) } );
	Mousetrap.bind( "n", function() { $.get( "/remodora/rest/action/n" ); } );
	Mousetrap.bind( "l", function() { $.get( "/remodora/rest/action/+" ); } );
	Mousetrap.bind( "b", function() { $.get( "/remodora/rest/action/-" ); } );
	Mousetrap.bind( "t", function() { $.get( "/remodora/rest/action/t" ); } );
	Mousetrap.bind( "down", function() { $.get( "/remodora/rest/action/(" ); } );
	Mousetrap.bind( "up", function() { $.get( "/remodora/rest/action/)" ); } );

	var title = $("h2.title");
	var artist = $("h2.artist");
	var album = $("h2.album");
	var station = $("h2.station");
	var love = $("img.love");

	window.setInterval( function()
	{
	   $.getJSON( "/remodora/rest/songinfo", function( data )
		{
			var ratingChanged = false;
			if ( !love.is( ":visible" ) && data.rating == 1 )
			{
				ratingChanged = true;
			}

			if ( title.text() != data.title ||
				artist.text() != data.artist ||
				album.text() != data.album ||
				ratingChanged )
			{
				$('#content').fadeOut( "slow", function()
				{
					title.text( data.title );
					artist.text( data.artist );
					album.text( data.album );
					station.text( data.stationName );
					if ( data.coverArt )
					{
						// pandora.com has album art
						$("img.albumart").attr( "src", data.coverArt );
					}
					else
					{
						// pandora.com did not have album art
						$("img.albumart").attr( "src", "/remodora/images/song.png" );
					}

					if ( data.rating == 1 )
					{
						$("img.love").show();
					}
					else
					{
						$("img.love").hide();
					}
				} ).fadeIn( "slow" );
			}
		} );
	}, 3000);
} );
