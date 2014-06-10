/*!
* put application-specific JavaScript code
*/
'use strict';

jQuery(document).ready(function() {
    console.log("loaded app.js");
    $( "#update-feeds" ).click(function() {
        console.log("executing updates-feeds")
        var jqxhr = $.ajax( "modules/feed.xql")
            .done(function() {
                console.log( "success" );
            })
            .fail(function() {
                console.log( "error" );
            })
            .always(function() {
                console.log( "complete" );
            });
        // Perform other work here ...
        // Set another completion function for the request above
        // jqxhr.always(function() {
        //    console.log( "second complete" );
        // });
    });

});
