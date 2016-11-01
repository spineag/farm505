/**
 * Created by user on 10/31/16.
 */
package additional.mouse {
import com.junkbyte.console.Cc;
import flash.geom.Point;
import manager.AStar.AStar;
import manager.Vars;

public class ManagerMouse {
    private var g:Vars = Vars.getInstance();
    private var _mouse:MouseHero;

    public function ManagerMouse() { }

    public function addMouse():void {
        if (g.user.isMegaTester || g.user.isTester) {
            if (g.user.countAwayMouse > 4) return;
            if (!g.isAway) return;
            if (g.allData.factory['mouse_yobar']) {
                onLoad();
            } else {
                g.loadAnimation.load('animations_json/x1/mouse', 'mouse_yobar', onLoad);
            }
        }
    }

    public function removeMouse():void {
        if (_mouse) {
            _mouse.deleteIt();
            _mouse = null;
        }
    }

    private function onLoad():void {
        _mouse = new MouseHero(onClickMouse);
        goIdleMouseToPoint(g.townArea.getRandomFreeCell(), makeAnyAction);
    }

    private function goIdleMouseToPoint(p:Point, callback:Function = null):void {
        if (!_mouse) return;
        try {
            if (_mouse.posX == p.x && _mouse.posY == p.y) {
                if (callback != null) {
                    callback.apply(null);
                }
                return;
            }

            var f2:Function = function ():void {
                if (callback != null) {
                    callback.apply(null);
                }
            };
            var f1:Function = function (arr:Array):void {
                if (!_mouse) return;
                _mouse.goWithPath(arr, f2);
            };
            var a:AStar = new AStar();
            a.getPath(_mouse.posX, _mouse.posY, p.x, p.y, f1, _mouse);
        } catch (e:Error) {
            Cc.error('ManagerMouse goIdleMouseToPoint error: ' + e.errorID + ' - ' + e.message);
        }
    }

    private function makeAnyAction():void {
        if (!_mouse) return;
        var m:int = int(Math.random()*10);
        if (m < 5) {
            goIdleMouseToPoint(g.townArea.getRandomFreeCell(), makeAnyAction);
        } else {
            _mouse.idleAnimation('front', makeAnyAction);
        }
    }

    private function onClickMouse():void {
        if (!_mouse) return;
        g.user.countAwayMouse++;
        _mouse.giveAward();
        _mouse = null;
    }
}
}
