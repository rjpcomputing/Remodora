$(document).ready( function()
{
	//toastr.info('Are you the 6 fingered man?');
	//toastr.error('Another message');

	var title = $("h2.title");
	var artist = $("h2.artist");
	var album = $("h2.album");
	var love = $("img.love");

	window.setInterval(function(){
	   $.getJSON( "/remodora/rest/songinfo", function( data )
		{
			//console.log( data );
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
					$("img.albumart").attr( "src", data.coverArt );
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
