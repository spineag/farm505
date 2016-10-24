/**
 * Created by user on 10/24/16.
 */
package additional.lohmatik {
import com.junkbyte.console.Cc;
import flash.geom.Point;
import manager.AStar.AStar;
import manager.Vars;

public class ManagerLohmatik {
    private var g:Vars = Vars.getInstance();
    private var _arr:Array;

    public function ManagerLohmatik() {
        addLohmatics();
    }

    private function addLohmatics():void {
        if (g.allData.factory['lohmatik']) {
            onLoad();
        } else {
            g.loadAnimation.load('animations_json/x1/lohmatik', 'lohmatik', onLoad);
        }
    }

    private function onLoad():void {
        var l:Lohmatik;
        _arr = [];
        for (var i:int=0; i<3; i++) {
            l = new Lohmatik(onLohClick);
            _arr.push(l);
            l.setPosition(g.townArea.getRandomFreeCell());
            makeAnyAction(l);
        }
    }

    private function onLohClick(l:Lohmatik):void {
        l.deleteIt();
        if (_arr.indexOf(l) > -1) _arr.removeAt(_arr.indexOf(l));
//        if (!_arr.length) {
//            delete g.allData.factory['lohmatik'];
//        }
    }

    private function makeAnyAction(l:Lohmatik):void {
        var m:int = int(Math.random()*10);
        if (m < 5) {
            goIdleLohmatikToPoint(l, g.townArea.getRandomFreeCell(), makeAnyAction);
        } else if (m<7) {
            l.idleAnimation('idle_1', makeAnyAction);
        } else if (m<9) {
            l.idleAnimation('idle_2', makeAnyAction);
        } else {
            l.idleAnimation('idle_7', makeAnyAction);
        }
    }

    private function goIdleLohmatikToPoint(l:Lohmatik, p:Point, callback:Function = null):void {
        try {
            if (l.posX == p.x && l.posY == p.y) {
                if (callback != null) {
                    callback.apply(null, [l]);
                }
                return;
            }

            var f2:Function = function ():void {
                if (callback != null) {
                    callback.apply(null, [l]);
                }
            };
            var f1:Function = function (arr:Array):void {
                l.goWithPath(arr, f2);
            };
            var a:AStar = new AStar();
            a.getPath(l.posX, l.posY, p.x, p.y, f1, l);
        } catch (e:Error) {
            Cc.error('ManagerLohmatik goIdleCatToPoint error: ' + e.errorID + ' - ' + e.message);
        }
    }
}
}
