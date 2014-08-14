xquery version "3.0";

import module namespace config="http://podlove.org/podlove-matrix/config" at "config.xqm";
import module namespace feed="http://podlove.org/podlove-matrix/feed" at "feed.xqm";

import module namespace xdiff="http://exist-db.org/xquery/xmldiff"
    at "java:org.exist.xquery.modules.xmldiff.XmlDiffModule";


declare namespace psc="http://podlove.org/simple-chapters";
declare namespace fh="http://purl.org/syndication/history/1.0";
declare namespace feedburner="http://rssnamespace.org/feedburner/ext/1.0";
declare namespace itunes="http://www.itunes.com/dtds/podcast-1.0.dtd";
declare namespace atom="http://www.w3.org/2005/Atom";
declare namespace content="http://purl.org/rss/1.0/modules/content/";
declare namespace dc="http://purl.org/dc/elements/1.1/";
declare namespace slash="http://purl.org/rss/1.0/modules/slash/";
declare namespace rawvoice="http://www.rawvoice.com/rawvoiceRssModule/";
declare namespace wfw="http://wellformedweb.org/CommentAPI/";
declare namespace sy="http://purl.org/rss/1.0/modules/syndication/";



declare variable $local:ITEM_HANDLERS :=
    local:title#2,
    local:link#2,
    local:guid#2,
    local:pubDate#2,
    local:description#2,
    local:chapters#2,
    local:duration#2,
    local:subtitle#2,
    local:author#2,
    local:summary#2,
    local:contributor#2,
    local:origLink#2,
    local:enclosure#2,
    local:origEnclosureLink#2,
    local:encoded#2;


declare variable $local:CONFIG := map {
    "heading" := function($level as xs:int, $content as xs:string*) {
        element { "h" || $level } {
            $content
        }
    }
};

declare %private function local:handle-item($item as item(), $handlers as function(*)*, $config as map(*)) {
    if (empty($handlers)) 
    then(
        'unknown element ' || local-name($item)
    )
    else
        let $handler := head($handlers)
        let $result := $handler($item, $config)
        return
            if (exists($result)) then
                element {name($item)} { $item/@*,
                    if(exists($item/*))
                    then ($item/*) 
                    else ($item/text())
                }
            else
                local:handle-item($item, tail($handlers), $config)
};

declare %private function local:parse-item($item as item(), $config as map(*)) {
    for $elem in $item/*
    return
        local:handle-item($elem, $local:ITEM_HANDLERS, $config)
};

declare %private function local:validate-item($item as item(), $config as map(*)) {
    let $check-title := 
        if(not(exists($item/title)))
        then()
        else if(string-length($item/title) eq 0)
        then ()
        else ()
        
    return local:parse-item($item, $config)
};

declare %private function local:validate-element($item as item(), $elemName as xs:string, $config as map(*)) {
    let $elemToCheck := $item/*[local-name(.) eq $elemName]
    let $check-elem := 
        if(not(exists($elemToCheck)))
        then()
        else if(string-length($elemToCheck/text()) eq 0)
        then ()
        else ()
        
    return local:parse-item($item, $config)
};

declare %private function local:validate-attribute($elem as element(), $attrName as xs:string, $config as map(*)) {
    let $elemToCheck := $elem/@*[local-name(.) eq $elemName]
    let $check-elem := 
        if(not(exists($elemToCheck)))
        then()
        else if(string-length(data($elemToCheck)) eq 0)
        then ()
        else ()
        
    return ()
};







declare %private function local:title($elem as item(), $config as map(*)) {
    if(local-name($elem) eq 'title')
    then (
        'title'
    )else ()
};

declare %private function local:link($elem as item(), $config as map(*)) {
    if(local-name($elem) eq 'link')
    then (
        'link'
    )else ()
};

declare %private function local:guid($elem as item(), $config as map(*)) {
    if(local-name($elem) eq 'guid')
    then (
        'guid'
    )else ()
};
declare %private function local:pubDate($elem as item(), $config as map(*)) {
    if(local-name($elem) eq 'pubDate')
    then (
        'pubDate'
    )else ()
};

declare %private function local:description($elem as item(), $config as map(*)) {
    if(local-name($elem) eq 'description')
    then (
        'description'
    )else ()
};

declare %private function local:chapters($elem as item(), $config as map(*)) {
    if(local-name($elem) eq 'chapters')
    then (
        'chapters'
    )else ()
};
declare %private function local:duration($elem as item(), $config as map(*)) {
    if(local-name($elem) eq 'duration')
    then (
        'duration'
    )else ()
};
declare %private function local:subtitle($elem as item(), $config as map(*)) {
    if(local-name($elem) eq 'subtitle')
    then (
        'subtitle'
    )else ()
};

declare %private function local:author($elem as item(), $config as map(*)) {
    if(local-name($elem) eq 'author')
    then (
        'author'
    )else ()
};

declare %private function local:summary($elem as item(), $config as map(*)) {
    if(local-name($elem) eq 'summary')
    then (
        'summary'
    )else ()
};

declare %private function local:contributor($elem as item(), $config as map(*)) {
    if(local-name($elem) eq 'contributor')
    then (
        'contributor'
    )else ()
};

declare %private function local:origLink($elem as item(), $config as map(*)) {
    if(local-name($elem) eq 'origLink')
    then (
        'origLink'
    )else ()
};
declare %private function local:enclosure($elem as item(), $config as map(*)) {
    if(local-name($elem) eq 'enclosure')
    then (
        'enclosure'
    )else ()
};

declare %private function local:origEnclosureLink($elem as item(), $config as map(*)) {
    if(local-name($elem) eq 'origEnclosureLink')
    then (
        'origEnclosureLink'
    )else ()
};
declare %private function local:encoded($elem as item(), $config as map(*)) {
    if(local-name($elem) eq 'encoded')
    then (
        'encoded'
    )else ()
};

declare function local:validate-feed($feed as item(), $config as map(*)){
    let $channel := $feed/rss/channel
    let $title := $channel/title
    let $atomLinks := $channel/atom:link
    let $links := $channel/link
    let $description := $channel/description
    let $lastBuildDate := $channel/lastBuildDate
    let $language := $channel/language
    let $syUpdatePeriod := $channel/sy:updatePeriod
    let $syUpdateFrequency := $channel/sy:updateFrequency
    let $generator := $channel/generator
    let $itunesSummary := $channel/itunes:summary
    let $itunesAuthor := $channel/itunes:author
    let $itunesExplicit := $channel/itunes:explicit
    let $itunesImage := $channel/itunes:image
    let $itunesOwner := $channel/itunes:owner
    let $itunesSubtitle := $channel/itunes:subtitle
    let $managingEditor := $channel/managingEditor
    let $image := $channel/image
    let $itunesCategory := $channel/itunes:category

    return
        (
            if(not(exists($feed/rss))) 
            then (
                <error>Root element 'rss' is missing</error>
            )
            else (
                if(not(exists($channel))) 
                then (
                    <error>Element 'channel' is missing</error>
                )
                else (
                    if(not(exists($title)))
                    then (
                        <error>Element 'title' is missing in channel</error>
                    )
                    else if(string-length($title) eq 0)
                    then (
                        <error>Feed 'title' has no value</error>
                    )
                    else ()
                )                    
            )
        )
};

let $inputURL := request:get-parameter("feedURL", "")
return 
    try {
        let $feedURL := $inputURL cast as xs:anyURI
        let $feedPath := feed:store-feed(xs:anyURI($feedURL))
        let $feed := doc($feedPath)
        let $map := map{}
        return 
            <podcast>
                <feed checkedURL="{$inputURL}" dbLocation="{$feedPath}"/>
            {
                local:validate-feed($feed, $map)
                (: 
                    return 
                    for $messages in map:keys($returnMap)
                        return
                            <message type="{$messages}">{$returnMap($messages)}</message>
                :)
            }
            </podcast>
    } catch * {
            <error>Caught error {$err:code}: {$err:description}</error>
    }

    
    