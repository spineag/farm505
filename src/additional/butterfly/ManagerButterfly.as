/**
 * Created by andy on 5/9/16.
 */
package additional.butterfly {
import flash.geom.Point;

import manager.Vars;

public class ManagerButterfly {
    private var _arrButterFlyes:Array;
    private var _matrix:Array;
    private var _matrixLength:int;
    private var g:Vars = Vars.getInstance();

    public function ManagerButterfly() {
        _arrButterFlyes = [];
        _matrix = g.matrixGrid.matrix;
        _matrixLength = g.matrixGrid.matrixSize;
    }

    public function createBFlyes():void {
        var bfly:Butterfly;
        var type:int;
        for (var i:int=0; i<5; i++) {
            type = int((Math.random()*3)) + 1;
            bfly = new Butterfly(type, this);
            _arrButterFlyes.push(bfly);
        }
    }

    public function startButterflyFly():void {
        for (var i:int=0; i<_arrButterFlyes.length; i++) {
            (_arrButterFlyes[i] as Butterfly).startFly();
        }
    }

    public function get randomPoint():Point {
        var p:Point = new Point();
        var i:int = int(Math.random()*_matrixLength);
        p.x = i;
        i = int(Math.random()*_matrixLength);
        p.y = i;
        return p;
    }

    public function getRandomClosestPoint(p:Point, d:int = 12):Point {
        var newP:Point = new Point();
        var delta:int = int(Math.random()*2*d) - d;
        newP.x = p.x + delta;
        if (newP.x < 0 || newP.x > _matrixLength) newP.x = p.x - delta;
        delta = int(Math.random()*2*d) - d;
        newP.y = p.y + delta;
        if (newP.y < 0 || newP.y > _matrixLength) newP.y = p.y - delta;
        return newP;
    }

    public function hideButterfly(v:Boolean):void {
        g.cont.cloudsCont.visible = !v;
    }
}
}
