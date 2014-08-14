/*!
* put application-specific JavaScript code
*/
'use strict';

jQuery(document).ready(function() {
    console.log("loaded app.js");
    
    $("#validateBtn").click(function() {
        console.log("executing validate!")
        var feedURL = $("#inputFeedURL").val();
        console.log("feedURL: ", feedURL)
        var jqxhr = $.ajax({
                type: "POST",
                url: "modules/feed-validator.xql",
                data: { feedURL: feedURL}
            }).done(function(data) {
                console.log( "success data:'",data,"'");
            })
            .fail(function(error) {
                console.log( "fail error:'",error,"'");
            })
            .always(function(data) {
                console.log( ".always data: '", data, "'" );
            });
        // Perform other work here ...
        // Set another completion function for the request above
        // jqxhr.always(function() {
        //    console.log( "second complete" );
        // });
         
         
    });
    $( "#update-feeds" ).click(function() {
        console.log("executing updates-feeds")
        var jqxhr = $.ajax( "modules/feed-validator.xql")
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
