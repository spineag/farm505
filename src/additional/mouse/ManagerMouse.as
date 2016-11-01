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

    public function fillFromServer(day:String, lastCount:int):void {
        var lastDayNumber:int = int(day);
        var curDayNumber:int = new Date().dateUTC;
        if (curDayNumber != lastDayNumber)
            g.user.countAwayMouse = 0;
        else
            g.user.countAwayMouse = int(lastCount);
    }

    public function addMouse():void {
        if (g.user.isMegaTester || g.user.isTester) {
            if (g.user.countAwayMouse > 4) return;
            if (!g.isAway) return;
            if (Math.random() < .6) return;
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
        _mouse = new MouseHero(onClickMouse, onAhtung);
        goIdleMouseToPoint(g.townArea.getRandomFreeCell(), makeAnyAction);
    }

    private function onAhtung():void {
        if (_mouse) {
            _mouse.stopAll();
            _mouse.needRunQuick();
            _mouse.idleAnimation('ahtung', afterAhtung);
        }
    }
    
    private function afterAhtung():void {
        var p:Point = getRandomAwayFreeCellFromMouse();
        goIdleMouseToPoint(p, makeAnyAction);
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
        g.directServer.useHeroMouse(null);
        _mouse.giveAward();
        _mouse = null;
    }

    private function getRandomAwayFreeCellFromMouse():Point { // for MouseHero -> run from mouse
        var p:Point = new Point();
        var arrAway:Array = g.townArea.freePlaceAway;
        if (!arrAway.length) {
            return p;
        }
        var pMouseHero:Point = new Point(_mouse.posX, _mouse.posY);
        var pMouse:Point = new Point(g.ownMouse.mouseX, g.ownMouse.mouseY);
        pMouse = g.matrixGrid.getIndexFromXY(pMouse);
        var arrAwayNormal:Array = [];
        var ar:Array;
        for (var i:int=0, l:int=arrAway.length; i<l; i++) {
            ar = arrAway[i].split('$');
            p.x = int(ar[0]);
            p.y = int(ar[1]);
            if (pMouseHero.x < pMouse.x) {
                if (pMouseHero.x < p.x) continue;
                if (pMouseHero.y < pMouse.y) {
                    if (pMouseHero.y < p.y) continue;
                    arrAwayNormal.push(p);
                    p = new Point();
                } else {
                    if (pMouseHero.y > p.y) continue;
                    arrAwayNormal.push(p);
                    p = new Point();
                }
            } else {
                if (pMouseHero.x > p.x) continue;
                if (pMouseHero.y < pMouse.y) {
                    if (pMouseHero.y < p.y) continue;
                    arrAwayNormal.push(p);
                    p = new Point();
                } else {
                    if (pMouseHero.y > p.y) continue;
                    arrAwayNormal.push(p);
                    p = new Point();
                }
            }
        }
        if (arrAwayNormal.length) {
            p = arrAwayNormal[int(Math.random()*arrAwayNormal.length)];
        } else p = g.townArea.getRandomFreeCell();
        return p;
    }
}
}
