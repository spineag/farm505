/**
 * Created by user on 8/21/15.
 */
package server {
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLRequestMethod;


public class NodeServer {
//    https://farm505-spineag.c9.io/public/api-v1-0/socket/server.js

    public function NodeServer() {

    }

    static public function makeTest():void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest("https://farm505-spineag.c9.io/public/api-v1-0/socket/server.js");
        request.method = URLRequestMethod.POST;
        request.requestHeaders=[new URLRequestHeader("Content-Type", "application/json")];
        loader.addEventListener(Event.COMPLETE, onCompleteTest);
        function onCompleteTest(e:Event):void {
            completeTest(e.target.data);
        }
        try {
            loader.load(request);
        } catch (error:Error) {
        }
    }

    static private function completeTest(response:String):void {
        trace('asdasdasd');
    }
}
}
