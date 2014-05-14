xquery version "3.0";

module namespace podcast="http://podlove.org/podlove-matrix/podcast";

import module namespace config="http://podlove.org/podlove-matrix/config" at "config.xqm";

declare namespace psc="http://podlove.org/simple-chapters";
declare namespace fh="http://purl.org/syndication/history/1.0";
declare namespace feedburner="http://rssnamespace.org/feedburner/ext/1.0";
declare namespace itunes="http://www.itunes.com/dtds/podcast-1.0.dtd";
declare namespace atom="http://www.w3.org/2005/Atom";
declare namespace content="http://purl.org/rss/1.0/modules/content/";


declare function podcast:rss() {
    let $data-root := $config:app-root || "/data/podcast"
    let $podcasts := collection($data-root)//rss
    for $podcast in $podcasts
        return 
            <div class="podcast">
                <h2 class="title"><a href="?mode=podcast">{$podcast//channel/title/text()}</a></h2>
                <div>
                    <a href="?mode=podcast"><img src="{$podcast//channel/itunes:image/@href}" widht="200px" height="200px"/></a>
                </div>
                <div class="contributors" style="display:none">
                {
                    for $contributor in distinct-values($podcast//atom:contributor/atom:name)
                        return
                            <div class="contributor">{$contributor}</div>
                }
                </div>
                <div class="episodes" style="display:none">
                {
                    for $episode in $podcast//item
                        return
                            <div class="episode">{$episode/title/text()}</div>
                }
                
                </div>
            </div>
};
declare function podcast:episode($document as xs:string){
    let $data-root := $config:app-root || "/data/podcast"
    let $podcast := doc($data-root || "/" || $document)//rss
    return 
        <div>
            <table>
                <tr>
                    <td>
                        <h1 class="title">{$podcast//channel/title/text()}</h1>
                    </td>
                    <td rowspan="3">
                        <img src="{$podcast//channel/itunes:image/@href}" style="width:200px;height:200px;position:relative;right:10px;"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <h2 class="subtitle">{$podcast//channel/itunes:subtitle/text()}</h2>
                    </td>
                    <td/>
                </tr>
                <tr>
                    <td>
                        <div class="summary">{$podcast//channel/itunes:summary/text()}</div>
                    </td>
                    <td/>
                </tr>
            </table>
            <div class="content">
                
                
                <h2>Contributors</h2>
                <div class="contributors">
                {
                        for $contributor in distinct-values($podcast//channel/atom:contributor/atom:name)
                            return
                                <div class="contributor"><a href="?mode=person&amp;name={$contributor}">{$contributor}</a></div>
    
                }
                </div>
                <h2>Author</h2>
                <div class="author">{$podcast//channel/itunes:author/text()}</div>
                
            </div>            
        </div>
};
