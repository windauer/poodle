xquery version "3.0";
import module namespace podcast="http://podlove.org/podlove-matrix/podcast" at "modules/podcast.xqm";

declare option exist:serialize "method=html5 media-type=text/html";

let $irgendwas := "sein"
return 
<html>
    <head>
        <title>App Title</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <link rel="shortcut icon" href="$shared/resources/images/exist_icon_16x16.ico"/>
        <link rel="stylesheet" type="text/css" href="resources/css/style.css"/>
        <link rel="stylesheet" type="text/css" href="$shared/resources/css/bootstrap-3.0.3.min.css"/>
        <style type="text/css">
            .media {{
                border:1px solid gray;
            }}
        </style>
    </head>
    <body>
        <div class="container">
            <div class="row">
                <div class="col-md-12">
                {
                    let $mode := request:get-parameter("mode","")
                    return 
                        if($mode eq "") 
                        then (
                            podcast:rss()   
                        )
                        else if($mode eq "podcast")
                        then (
                            podcast:episode("bba893d1-fa4c-337b-93ae-1f4258d1ecb7.xml")   
                        )
                        else()
                }
                </div>
            </div>
            <div id="footer">
                <div id="copyright">
                    <p/>
                </div>
            </div>
        </div>
        <script type="text/javascript" src="$shared/resources/scripts/jquery/jquery-1.7.1.min.js"/>
        <script type="text/javascript" src="$shared/resources/scripts/bootstrap-3.0.3.min.js"/>
        <script type="text/javascript" src="$shared/resources/scripts/loadsource.js"/>
    </body>
</html>