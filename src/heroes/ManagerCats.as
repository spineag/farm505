/**
 * Created by user on 9/23/15.
 */
package heroes {

import com.junkbyte.console.Cc;

import data.BuildType;
import data.DataMoney;

import flash.geom.Point;

import manager.AStar;

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
//            try {
                cat.flipIt(false);
                cat.showFront(true);
                cat.idleAnimation();
                if (callback != null) {
                    callback.apply(null, callbackParams);
                }
//            } catch (e:Error) {
//                Cc.error('ManagerCats goCatToPoint f2 error: ' + e.errorID + ' - ' + e.message);
//                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ManagerCats goCat2');
//            }
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
                if (callback != null) {
                    callback.apply(null, callbackParams);
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
            };
            var f1:Function = function (arr:Array):void {
                cat.walkIdleAnimation();
                cat.goWithPath(arr, f2);
            };
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
}
}
