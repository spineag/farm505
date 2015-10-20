/**
 * Created by user on 9/23/15.
 */
package heroes {

import com.junkbyte.console.Cc;

import flash.geom.Point;

import manager.Vars;

public class ManagerCats {
    protected var _townMatrix:Array;
    private var _catsArray:Array;
    private var g:Vars = Vars.getInstance();

    public function ManagerCats() {
        _townMatrix = g.townArea.townMatrix;
        _catsArray = [];
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

    public function setAllCatsToRandomPositions():void {
        for (var i:int=0; i<_catsArray.length; i++) {
            _catsArray[i].setPosition(getRandomFreeCell());
            _catsArray[i].addToMap();
        }
    }

    public function goCatToPoint(cat:BasicCat, p:Point):void {
        try {
            var f1:Function = function (arr:Array):void {
                if (arr.length > 3) {
                    cat.runAnimation();
                } else {
                    cat.walkAnimation()
                }
                cat.goWithPath(arr);
            };
            g.aStar.getPath(cat.posX, cat.posY, p.x, p.y, f1);
        } catch (e:Error) {
            Cc.error('ManagerCats goCatToPoint error: ' + e.errorID + ' - ' + e.message);
            g.woGameError.showIt();
        }
    }

}
}
