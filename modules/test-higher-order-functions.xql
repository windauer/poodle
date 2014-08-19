xquery version "3.0";

(: higher order function tests :)
declare function local:rss($item as item()*){
     <info>element rss is fine</info>
};

declare function local:channel($item as item()*){
     <info>element channel is fine</info>
};

declare function local:title($item as item()*){
    <info>element title is fine</info>
};

declare function local:link($item as item()*){
    <info>element link is fine</info>
        (: 
            element { "a"} {
                $item/(@*),            
                $item/text()
        }
        :)     
        
};


declare variable $local:CONFIG :=
    map {
         "rss" := local:rss#1,
         "channel" := local:channel#1,
         "title" := local:title#1,
         "link" := local:link#1
};

declare function local:parse-xml($xml, $config){
 for $node in $xml
    let $fn-name := name($node)
    return
         if ($node instance of element()) 
            then ( 
                if(map:contains($config, $fn-name))
                then (
                    $config($fn-name)($node),
                    local:parse-xml($node/*, $config)
                )else (
                    <error>no function for elment {$fn-name}</error>    
                )
            )
         else if ($node instance of attribute()) then 'attribute'
         else if ($node instance of text()) then 'text'
         else if ($node instance of document-node()) then 'document-node'
         else if ($node instance of comment()) then 'comment'
         else if ($node instance of processing-instruction())
                 then 'processing-instruction'
         else 'unknown'            
            
           
};
    
let $config := $local:CONFIG
let $xml := <rss>
                <channel>
                    <title>MyTitle</title>
                    <link href="http://mylink.com">MyLink</link>
                </channel>
            </rss>
return 
    <result>
        {
            local:parse-xml($xml, $config)    
       
        }
    </result>

