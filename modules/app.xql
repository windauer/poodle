xquery version "3.0";

module namespace app="http://podlove.org/podlove-matrix/templates";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://podlove.org/podlove-matrix/config" at "config.xqm";
import module namespace podcast="http://podlove.org/podlove-matrix/podcast" at "podcast.xqm";

declare namespace psc="http://podlove.org/simple-chapters";
declare namespace fh="http://purl.org/syndication/history/1.0";
declare namespace feedburner="http://rssnamespace.org/feedburner/ext/1.0";
declare namespace itunes="http://www.itunes.com/dtds/podcast-1.0.dtd";
declare namespace atom="http://www.w3.org/2005/Atom";
declare namespace content="http://purl.org/rss/1.0/modules/content/";

declare %templates:wrap  function app:rss($node as node(), $model as map(*)) {
    podcast:rss()
};


declare %templates:wrap  function app:rss-alt($node as node(), $model as map(*)) {
    let $data-root := $config:app-root || "/data/podcast"
    
    (:  
        let $data :=  httpclient:get(xs:anyURI("http://cre.fm/feed/m4a/"),false(), ())
        let $aggregate-feed := local:get-page($data) 
    :)
    let $data := collection($data-root)/rss[1]
    
    let $enhanced-model :=map:new((
            $model,
            map:entry("rss",$data)
    ))
    return
        element { node-name($node) } {
                $node/@*, for $child in $node/node() return templates:process($child, $enhanced-model)
            }
};

declare %templates:wrap  function app:podcasts($node as node(), $model as map(*)) {
    let $data-root := $config:app-root || "/data/podcast"
    let $podcasts := for $podcast in collection($data-root)//rss
                        order by $podcast//channel/title ascending
                        return $podcast
    return 
        map {
            "podcasts" := $podcasts
        }
};

declare
    %templates:wrap
    %templates:default("title", "")
function app:podcast($node as node(), $model as map(*), $title) {
    let $data-root := $config:app-root || "/data/podcast"
    let $podcast := collection($data-root)//rss[channel/title/text() eq $title]
    return 
        map {
            "podcast" := $podcast
        }
};



declare 
    %templates:wrap
function app:podcast-title($node as node(), $model as map(*)) {
    let $title := $model("podcast")/channel/title/string()
    return 
        element { node-name($node) } {
            $node/@*, 
            if(string(node-name($node)) eq "a") 
            then (
                attribute href {"podcast.html?title=" || $title}
            )
            else (),
            $title
        }

    
};

declare 
    %templates:wrap
function app:podcast-subtitle($node as node(), $model as map(*)) {
    $model("podcast")/channel/itunes:subtitle/text()
};

declare 
    %templates:wrap
function app:podcast-desc($node as node(), $model as map(*)) {
     $model("podcast")/channel/itunes:summary/string() 
};

declare 
    %templates:replace
function app:podcast-icon($node as node(), $model as map(*)){
    element { node-name($node)}
        { 
            $node/@*,
            attribute src { $model("podcast")/channel/itunes:image/@href },
            $node/node() 
        }
};





declare %templates:wrap function app:meta($node as node(), $model as map(*)) {
    element { node-name($node) } {
                $node/@*, for $child in $node/node() return templates:process($child, $model)
            }    
};

declare %templates:wrap function app:feed-title($node as node(), $model as map(*)) {
    $model("rss")/channel/title/text()
};

declare %templates:wrap function app:feed-desc($node as node(), $model as map(*)) {
    $model("rss")/channel/description/text()
};


declare 
    %templates:wrap 
function app:items($node as node(), $model as map(*))  as map(*) {
    map { "items" := $model("rss")//item }
};

declare 
    %templates:wrap
function app:item-title($node as node(), $model as map(*)) {
     $model("item")/title/string() 
};

declare 
    %templates:wrap
function app:item-desc($node as node(), $model as map(*)) {
     $model("item")//itunes:subtitle/string() 
};

