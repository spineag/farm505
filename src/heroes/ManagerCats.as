/**
 * Created by user on 9/23/15.
 */
package heroes {

import com.junkbyte.console.Cc;

import data.BuildType;
import data.DataMoney;

import flash.geom.Point;

import manager.Vars;

public class ManagerCats {
    protected var _townMatrix:Array;
//    [ArrayElementType('heroes.BasicCat')]
    private var _catsArray:Array;
    private var _catInfo:Object;
    private var _maxCountCats:int;
    private var _cat:int;

    private var g:Vars = Vars.getInstance();

    public function ManagerCats() {
        _townMatrix = g.townArea.townMatrix;
        _catsArray = [];
        _catInfo = new Object();
        _catInfo.name = 'Кот';
        _catInfo.url = 'catAtlas';
        _catInfo.image = 'cat_man';
        _catInfo.image2 = 'cat_woman';
        _catInfo.cost = 0;
        _catInfo.currency == DataMoney.SOFT_CURRENCY;
        _catInfo.buildType = BuildType.CAT;
    }

    public function get catInfo():Object {
        return _catInfo;
    }

    public function getRandomFreeCell():Point {
        var i:int;
        var j:int;
        var b:int = 0;
        try {
            do {
                i = int(Math.random() * _townMatrix.length);
                j = int(Math.random() * _townMatrix[0].length);
                b++;
                if (b>30) return new Point(0, 0);
            } while (_townMatrix[i][j].isFull);
            return new Point(j, i);
        } catch (e:Error) {
            Cc.error('ManagerCats getRandomFreeCell: ' + e.errorID + ' - ' + e.message);
            g.woGameError.showIt();
        }
        return new Point(0, 0);
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
                (_catsArray[i] as BasicCat).setPosition(getRandomFreeCell());
                (_catsArray[i] as BasicCat).addToMap();
                (_catsArray[i] as HeroCat).makeFreeCatIdle();
            }
        }
    }

    public function goCatToPoint(cat:BasicCat, p:Point, callback:Function = null, ...callbackParams):void {
        var f2:Function = function ():void {
            try {
                cat.flipIt(false);
                cat.showFront(true);
                cat.idleAnimation();
                if (callback != null) {
                    callback.apply(null, callbackParams);
                }
            } catch (e:Error) {
                Cc.error('ManagerCats goCatToPoint f2 error: ' + e.errorID + ' - ' + e.message);
                g.woGameError.showIt();
            }
        };

        var f1:Function = function (arr:Array):void {
            try {
                if (arr.length > 5) {
                    cat.runAnimation();
                } else {
                    cat.walkAnimation()
                }
                cat.goWithPath(arr, f2);
            } catch (e:Error) {
                Cc.error('ManagerCats goCatToPoint f1 error: ' + e.errorID + ' - ' + e.message);
                g.woGameError.showIt();
            }
        };


        try {
            if (!cat) {
                Cc.error('ManagerCats goCatToPoint error: cat == null');
                g.woGameError.showIt();
                return;
            }
            (cat as HeroCat).killAllAnimations();
            if (cat.posX == p.x && cat.posY == p.y) {
                cat.flipIt(false);
                cat.showFront(true);
                cat.idleAnimation();
                if (callback != null) {
                    callback.apply(null, callbackParams);
                }
                return;
            }
            g.aStar.getPath(cat.posX, cat.posY, p.x, p.y, f1);
        } catch (e:Error) {
            Cc.error('ManagerCats goCatToPoint error: ' + e.errorID + ' - ' + e.message);
            g.woGameError.showIt();
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
                cat.walkAnimation();
                cat.goWithPath(arr, f2);
            };
            g.aStar.getPath(cat.posX, cat.posY, p.x, p.y, f1);
        } catch (e:Error) {
            Cc.error('ManagerCats goCatToPoint error: ' + e.errorID + ' - ' + e.message);
            g.woGameError.showIt();
        }
    }

    public function onBuyCatFromShop():void {
        var cat:HeroCat = new HeroCat(int(Math.random()*2) + 1);
        _catsArray.push(cat);
        cat.setPosition(getRandomFreeCell());
        cat.addToMap();
        g.user.countCats++;
        g.directServer.buyHeroCat(null);
        g.catPanel.checkCat();
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
}
}
