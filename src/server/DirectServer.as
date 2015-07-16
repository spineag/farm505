/**
 * Created by user on 7/16/15.
 */
package server {
import com.junkbyte.console.Cc;

import flash.events.Event;

import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

import manager.Vars;

public class DirectServer {
    private var g:Vars = Vars.getInstance();

    public function makeTest():void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_TEST);
        Cc.ch('server', 'start makeTest', 1);
        request.method = URLRequestMethod.POST;
        request.requestHeaders=[new URLRequestHeader("Content-Type", "application/json")];
        loader.addEventListener(Event.COMPLETE, onCompleteTest);
        function onCompleteTest(e:Event):void {
            completeTest(e.target.data);
        }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('test error:' + error.errorID);
        }
    }

    private function completeTest(response:String):void {
        Cc.ch('server', 'on makeTest response: ' + response, 1);
    }

    public function getDataLevel(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DATA_LEVEL);
        var st:String = g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DATA_LEVEL;
//        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'start getDataLevel', 1);
//        variables = addDefault(variables);
//        variables.key = generateSecretKey(Consts.INQ_ALLLEVELS);
//        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAllLevels);
        function onCompleteAllLevels(e:Event):void { completeLevels(e.target.data, callback); }

        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataLevel error:' + error.errorID);
        }
    }

    private function completeLevels(response:String, callback:Function = null):void {
        var data:Object;
        try {
            data = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('loadLevels: wrong JSON:' + String(response));
            return;
        }

        if (data.id == 0) {
            var obj:Object;
            for (var i:int = 0; i<data.message.length; i++) {
                obj = {};
                obj.id = int(data.message[i].number_level);
                obj.xp = int(data.message[i].count_xp);
                g.dataLevel.objectLevels[obj.id] = obj;
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('loadLevels: id: ' + data.id + '  with message: ' + data.message);
        }
    }
}
}
