/**
 * Created by user on 11/18/16.
 */
package temp {
import com.junkbyte.console.Cc;

import flash.utils.getTimer;

import manager.Vars;

public class TestTime {
     private var g:Vars = Vars.getInstance();
    private var _timeStart:int = new Date().getTime()/1000;
    private var _timer:int;

     public function TestTime() {
         _timer = 0;
         g.gameDispatcher.addEnterFrame(test);
    }

    private function test():void {
        _timer++;
        if (_timer >= 100) {
            g.directServer.testGetUserFabric(test1);
            g.gameDispatcher.removeEnterFrame(test);
        }
    }

    private function test1(d:Object):void {
        var time:int = new Date().getTime()/1000;
        var client:int = time - _timeStart;
        var server :int = d.time - _timeStart;
//        Cc.ch('test', 'Time Start: ' + _timeStart + ' Time in Client: ' + time + ' Time in Server: ' + d.time);

        Cc.ch('test', 'Time Client: ' + client + ' Time in Server: ' + server);
        _timer = 0;
        g.gameDispatcher.addEnterFrame(test);
    }
}
}
