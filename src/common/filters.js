angular.module( "RemodoraApp" )
	.filter( "beautify", function()
	{
		return function( input )
		{
			var words = input.replace( /_/g, " " ).split(' ');
			var array = [];
			for ( var i = 0; i < words.length; ++i )
			{
				array.push( words[i].charAt( 0 ).toUpperCase() + words[i].toLowerCase().slice( 1 ) );
			}

			return array.join(' ');
		}
	} )
	.filter( "epoch_date", [ "$filter", function( $filter )
	{
		return function( input )
		{
			if ( input )
			{
				return $filter( "date" )( input * 1000, "medium" );
			}
		}
	} ] )
	.filter( "epoch_timedate", [ "$filter", function( $filter )
	{
		return function( input )
		{
			if ( input )
			{
				return $filter( "date" )( input * 1000, "h:mma MM/dd/yyyy" );
			}
		}
	} ] )
	.filter( "number_fixed_len", [ "$filter", function( $filter )
	{
        return function( n, len )
		{
            var num = parseInt( n, 10 );
            len = parseInt( len, 10 );
            if ( isNaN( num ) || isNaN( len ) )
			{
                return n;
            }
            num = '' + num;
            while ( num.length < len )
			{
                num = '0' + num;
            }
            return num;
        };
    } ] )
	.filter('truncate', [ "$filter", function ( $filter ) {
        return function( text, length, end )
		{
			if ( text )
			{
				if ( isNaN( length ) )
				{
					length = 10;
				}

				if ( end === undefined )
				{
					end = "...";
				}

				if ( text.length <= length || text.length - end.length <= length )
				{
					return text;
				}
				else
				{
					return String( text ).substring( 0, length - end.length ) + end;
				}
			}
        };
    } ] );
