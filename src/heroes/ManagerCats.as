/**
 * Created by user on 9/23/15.
 */
package heroes {

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
        do {
            i = int(Math.random()*_townMatrix.length) + 1;
            j = int(Math.random()*_townMatrix[0].length) + 1;
        } while (_townMatrix[i][j].isWall);
        return new Point(j, i);
    }

    public function addAllHeroCats():void {
        for (var i:int=0; i<4; i++) {
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

    }
}
}
