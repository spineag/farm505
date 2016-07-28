/**
 * Created by user on 9/23/15.
 */
package heroes {
import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;
import flash.geom.Point;

import heroes.BasicCat;

import manager.AStar.AStar;
import manager.Vars;
import tutorial.TutorialAction;
import windows.WindowsManager;

public class ManagerCats {
    protected var _townMatrix:Array;
    private var _matrixLength:int;
    protected var _townAwayMatrix:Array;
//    [ArrayElementType('heroes.BasicCat')]
    private var _catsArray:Array;
    private var _catsAwayArray:Array;
    private var _catInfo:Object;
    private var _maxCountCats:int;

    private var g:Vars = Vars.getInstance();

    public function ManagerCats() {
        _townMatrix = g.townArea.townMatrix;
        _matrixLength = g.matrixGrid.getLengthMatrix();
        _catsArray = [];
        _catInfo = new Object();
        _catInfo.name = 'Помощник';
        _catInfo.url = 'cat';
        _catInfo.image = 'cat';
        _catInfo.image2 = 'cat_woman';
        _catInfo.cost = 0;
        _catInfo.currency == DataMoney.SOFT_CURRENCY;
        _catInfo.buildType = BuildType.CAT;
    }

    public function get catInfo():Object {
        return _catInfo;
    }


    public function addAllHeroCats():void {
        for (var i:int=0; i < g.user.countCats; i++) {
            addHeroCat(int(Math.random()*2) + 1);
        }
    }

    public function addHeroCat(type:int):void {
        var cat:HeroCat = new HeroCat(type);
        _catsArray.push(cat);
    }

    public function get curCountCats():int {
        return _catsArray.length;
    }

    public function get maxCountCats():int {
        return _maxCountCats;
    }

    public function calculateMaxCountCats():void {
        for (var i:int=0; i < g.dataCats.length; i++) {
            if (g.dataCats[i].blockByLevel[0] > g.user.level) {
                break;
            }
        }
        _maxCountCats = i;
    }

    public function setAllCatsToRandomPositions():void {
        for (var i:int=0; i<_catsArray.length; i++) {
            if ((_catsArray[i] as HeroCat).isFree) {
                (_catsArray[i] as BasicCat).setPosition(g.townArea.getRandomFreeCell());
                (_catsArray[i] as BasicCat).addToMap();
                (_catsArray[i] as HeroCat).makeFreeCatIdle();
            }
        }
    }

    public function goCatToPoint(cat:BasicCat, p:Point, callback:Function = null, ...callbackParams):void {
        var f2:Function = function ():void {
            cat.flipIt(false);
            cat.showFront(true);
            cat.idleAnimation();
            if (cat.walkCallback != null) {
                cat.walkCallback.apply(null, cat.walkCallbackParams);
            }
            cat.walkCallback = null;
            cat.walkCallbackParams = [];
        };

        var f1:Function = function (arr:Array):void {
            try {
                cat.showFront(true);
                if (arr.length > 5) {
                    cat.runAnimation();
                } else {
                    cat.walkAnimation()
                }
                cat.goWithPath(arr, f2);
            } catch (e:Error) {
                Cc.error('ManagerCats goCatToPoint f1 error: ' + e.errorID + ' - ' + e.message);
                Cc.stackch('error', 'ManagerCats goCatToPoint f1', 10);
                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ManagerCats goCat1');
            }
        };

        try {
            if (!cat) {
                Cc.error('ManagerCats goCatToPoint error: cat == null');
                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ManagerCats goCatToPoint cat == null');
                return;
            }
            if (cat is HeroCat) (cat as HeroCat).killAllAnimations();
            if (cat.posX == p.x && cat.posY == p.y) {
                cat.flipIt(false);
                cat.showFront(true);
                cat.idleAnimation();
                if (callback != null) {
                    callback.apply(null, callbackParams);
                }
                return;
            }
            cat.walkCallback = callback;
            cat.walkCallbackParams = callbackParams;
            var a:AStar = new AStar();
            a.getPath(cat.posX, cat.posY, p.x, p.y, f1);
        } catch (e:Error) {
            Cc.error('ManagerCats goCatToPoint error: ' + e.errorID + ' - ' + e.message);
            Cc.stackch('error', 'ManagerCats goCatToPoint', 10);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ManagerCats goCatToPoint');
        }
    }

    public function goIdleCatToPoint(cat:BasicCat, p:Point, callback:Function = null, ...callbackParams):void {
        try {
            if (cat.posX == p.x && cat.posY == p.y) {
                if (cat.walkCallback != null) {
                    cat.walkCallback.apply(null, cat.walkCallbackParams);
                }
                return;
            }

            var f2:Function = function ():void {
                cat.flipIt(false);
                cat.showFront(true);
                cat.idleAnimation();
                if (callback != null) {
                    callback.apply(null, callbackParams);
                }
                cat.walkCallback = null;
                cat.walkCallbackParams = [];
            };
            var f1:Function = function (arr:Array):void {
                cat.walkIdleAnimation();
                cat.goWithPath(arr, f2);
            };
            cat.walkCallback = callback;
            cat.walkCallbackParams = callbackParams;
            var a:AStar = new AStar();
            a.getPath(cat.posX, cat.posY, p.x, p.y, f1);
        } catch (e:Error) {
            Cc.error('ManagerCats goIdleCatToPoint error: ' + e.errorID + ' - ' + e.message);
            Cc.stackch('error', 'ManagerCats goIdleCatToPoint', 10);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ManagerCats goIdleCatToPoint');
        }
    }

    public function onBuyCatFromShop():void {
        var cat:HeroCat = new HeroCat(int(Math.random()*2) + 1);
        _catsArray.push(cat);
        if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction == TutorialAction.BUY_CAT) {
            cat.setPosition(new Point(31, 28));
        } else {
            cat.setPosition(g.townArea.getRandomFreeCell());
        }
        cat.addToMap();
        g.user.countCats++;
        g.directServer.buyHeroCat(null);
        g.catPanel.checkCat();
        if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction == TutorialAction.BUY_CAT) {
            cat.playDirectLabel('idle', true, cat.makeFreeCatIdle);
        } else {
            cat.makeFreeCatIdle();
        }

    }

    public function getFreeCat():HeroCat {
        for (var i:int=0; i<_catsArray.length; i++) {
            if ((_catsArray[i] as HeroCat).isFree) {
                (_catsArray[i] as HeroCat).stopFreeCatIdle();
                return _catsArray[i];
            }
        }
        return null;
    }

    public function get countFreeCats():int {
        var j:int = 0;
        for (var i:int=0; i<_catsArray.length; i++) {
            if ((_catsArray[i] as HeroCat).isFree) ++j;
        }
        return j;
    }

    public function makeAwayCats():void {
        _catsAwayArray = [];
        var cat:HeroCat;
        for (var i:int=0; i<5; i++) {
            cat = new HeroCat(int(Math.random() * 2) + 1);
            _catsAwayArray.push(cat);
        }
        _townAwayMatrix = g.townArea.townAwayMatrix;
        for (i=0; i<_catsAwayArray.length; i++) {
            (_catsAwayArray[i] as BasicCat).setPosition(g.townArea.getRandomFreeCell());
            (_catsAwayArray[i] as BasicCat).addToMap();
            (_catsAwayArray[i] as HeroCat).makeFreeCatIdle();
        }
    }

    public function removeAwayCats():void {
        if (!_catsAwayArray.length) return;
        for (var i:int=0; i<_catsAwayArray.length; i++) {
            (_catsAwayArray[i] as HeroCat).deleteIt();
        }
        _catsAwayArray = [];
    }

    public function checkAllCatsAfterPasteBuilding(buildPosX:int, buildPosY:int, buildWidth:int, buildHeight:int):void {
        // check if any cat is under new building (or after removing) or his way is under building
        for (var i:int=0; i<_catsArray.length; i++) {
            if (_catsArray[i] is HeroCat && (_catsArray[i] as HeroCat).visible) {  // means that cat is not on any fabrica
                checkCatAfterPasteBuilding(_catsArray[i] as HeroCat, buildPosX, buildPosY, buildWidth, buildHeight);
            }
        }
    }

    private function checkCatAfterPasteBuilding(cat:HeroCat, buildPosX:int, buildPosY:int, buildWidth:int, buildHeight:int):void {
        if (g.isAway) return;
        if (cat.isFree) {
            if (cat.isIdleGo) {
                if (isCrossedPathAndSquare(cat.currentPath, buildPosX, buildPosY, buildWidth, buildHeight)) {
                    cat.killAllAnimations();
                    if (cat.posX > buildPosX && cat.posX < buildPosX + buildWidth && cat.posY > buildPosY && cat.posY < buildPosY + buildHeight) {
                        var afterRunFree:Function = function ():void {
                            cat.makeFreeCatIdle();
                        };
                        forceRunToPoint(buildPosX + buildWidth, buildPosY, afterRunFree);
                    } else cat.makeFreeCatIdle();
                }
            } else {
                if (cat.posX > buildPosX && cat.posX < buildPosX + buildWidth && cat.posY > buildPosY && cat.posY < buildPosY + buildHeight) {
                    var afterRunFree2:Function = function ():void {
                        cat.makeFreeCatIdle();
                    };
                    cat.killAllAnimations();
                    forceRunToPoint(buildPosX + buildWidth, buildPosY, afterRunFree2);
                }
            }
        } else {
            var endPoint:Point = cat.endPathPoint;
            if (cat.posX > buildPosX && cat.posX < buildPosX+buildWidth && cat.posY > buildPosY && cat.posY < buildPosY+buildHeight) {
                var afterRun:Function = function ():void {
                    goCatToPoint.apply(null, [cat, endPoint, cat.walkCallback].concat(cat.walkCallbackParams));
                };
                cat.killAllAnimations();
                forceRunToPoint(buildPosX+buildWidth, buildPosY, afterRun);
            } else if (isCrossedPathAndSquare(cat.currentPath, buildPosX, buildPosY, buildWidth, buildHeight)) {
                cat.killAllAnimations();
                goCatToPoint.apply(null, [cat, endPoint, cat.walkCallback].concat(cat.walkCallbackParams));
            }
        }
    }

    private function isCrossedPathAndSquare(path:Array, buildPosX:int, buildPosY:int, buildWidth:int, buildHeight:int):Boolean {
        var isCrossed:Boolean = false;
        var p:Point;
        for (var i:int=0; i<path.length; i++) {
            p = path[i];
            if (p.x > buildPosX && p.x < buildPosX+buildWidth && p.y > buildPosY && p.y < buildPosY+buildHeight) {
                isCrossed = true;
                break;
            }
        }
        return isCrossed;
    }

    private function forceRunToPoint(posX:int, posY:int, callback:Function):void {

    }
}
}
