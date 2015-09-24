/**
 * Created by user on 9/23/15.
 */
package heroes {
import flash.geom.Point;

import manager.Vars;

import map.MatrixGrid;

import utils.CSprite;
import utils.IsoUtils;
import utils.Point3D;

public class BasicCat {
    public static const MAN:int = 1;
    public static const WOMAN:int = 2;

    protected var _posX:int;
    protected var _posY:int;
    protected var _depth:Number;
    protected var _source:CSprite;
    protected var _speedGo:int;
    protected var _speedRun:int;
    protected var g:Vars = Vars.getInstance();

    public function BasicCat() {

    }

    public function setPosition(p:Point):void {
        _posX = p.x;
        _posY = p.y;
    }

    public function addToMap():void {
        g.townArea.addHero(this);
    }

    public function get depth():Number {
        return _depth;
    }

    public function updateDepth():void {
        var point3d:Point3D = IsoUtils.screenToIso(new Point(_source.x, _source.y));
        point3d.x += MatrixGrid.FACTOR/2;
        point3d.z += MatrixGrid.FACTOR/2;
        _depth = point3d.x + point3d.z;
    }

    public function get posX():int {
        return _posX;
    }

    public function get posY():int {
        return _posY;
    }

    public function get source():CSprite {
        return _source;
    }

}
}
