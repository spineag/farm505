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
    private var _catsArray:Array;
    private var _catInfo:Object;
    private var _maxCountCats:int;
    private var _cat:int;

    private var g:Vars = Vars.getInstance();

    public function ManagerCats() {
        _townMatrix = g.townArea.townMatrix;
        _catsArray = [];
        _catInfo = new Object();
        _catInfo.name = 'Котэ';
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
        try {
            do {
                i = int(Math.random() * _townMatrix.length);
                j = int(Math.random() * _townMatrix[0].length);
            } while (_townMatrix[i][j].isWall);
            return new Point(i, j);
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
                _catsArray[i].setPosition(getRandomFreeCell());
                _catsArray[i].addToMap();
            }
        }
    }

    public function goCatToPoint(cat:BasicCat, p:Point, callback:Function = null, ...callbackParams):void {
        try {
            var f2:Function = function ():void {
                if (callback != null) {
                    callback.apply(null, callbackParams);
                }
            };
            var f1:Function = function (arr:Array):void {
                if (arr.length > 3) {
                    cat.runAnimation();
                } else {
                    cat.walkAnimation()
                }
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
            if ((_catsArray[i] as HeroCat).isFree) return _catsArray[i];
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
