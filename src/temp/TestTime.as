/**
 * Created by user on 11/18/16.
 */
package temp {
import com.junkbyte.console.Cc;

import flash.utils.getTimer;

import manager.Vars;

public class TestTime {
     private var g:Vars = Vars.getInstance();
    private var _timeServer:int = 0;
    private var _timerFlash:int = 0;
    private var _timer:int;

     public function TestTime() {
         _timer = 0;
         g.gameDispatcher.addToTimer(test);
    }

    private function test():void {
        _timer++;
        if (_timer >= 30) {
            g.directServer.testGetUserFabric(test1);
            g.gameDispatcher.removeFromTimer(test);
        }

    }

    private function test1(d:Object):void {
        if (_timerFlash <= 0) _timerFlash = getTimer() / 1000;
        if (_timeServer <= 0) _timeServer = d.time;
        else {
            var client:int =  getTimer() / 1000 - _timerFlash;
            var server :int = d.time - _timeServer;
            Cc.ch('test', 'Time Client: ' + client + ' Time in Server: ' + server);

        }
//        var time:int = new Date().getTime()/10000;



//        Cc.ch('test', 'Time Start: ' + _timeStart + ' Time in Client: ' + time + ' Time in Server: ' + d.time/1000  + ' getTime: ' + getTime*60);
//
        _timer = 0;
        g.gameDispatcher.addToTimer(test);
    }
}
}
