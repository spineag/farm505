/**
 * Created by user on 5/14/15.
 */
package map {
import flash.geom.Matrix;
import flash.geom.Point;

import manager.EmbedAssets;

import manager.Vars;

import starling.display.Image;

import starling.display.Quad;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Color;

import utils.IsoUtils;
import utils.Point3D;

public class BackgroundArea {
    private var _cont:Sprite;
    private var _additionalCont:Sprite;

    protected var g:Vars = Vars.getInstance();

    public function BackgroundArea() {
        _cont = g.cont.backgroundCont;
        _additionalCont = new Sprite();

        fillBG();
    }

    private function fillBG():void {
        var arr:Array = g.matrixGrid.matrix;
        var arr2:Array;
        var tile:BackgroundTile;
        var p:Point;

//        var quad:Quad = new Quad(g.realGameWidth, g.realGameHeight, Color.GREEN);
        var texture:Texture = Texture.fromBitmap(new EmbedAssets.Valey());
        var bg:Image = new Image(texture);

        for (var i:int = 0; i < arr.length; i++) {
            arr2 = arr[i];
            for (var j:int = 0; j < arr2.length; j++) {
                tile = new BackgroundTile((i+j)%2 + 1, arr2[j].inGame);
                p = new Point(i, j);
                tile.graphicsSource.pivotX = tile.graphicsSource.width/2;
                setTileFromIndex(tile, p);
                _cont.addChild(tile.graphicsSource);
            }
        }

        _additionalCont.addChild(bg);
        _additionalCont.x = -_additionalCont.width/2 + MatrixGrid.DIAGONAL/2;
        _additionalCont.y = _cont.height/2 - _additionalCont.height/2;
        _cont.addChildAt(_additionalCont, 0);

        _cont.flatten();
    }

    private function setTileFromIndex(tile:BackgroundTile, point:Point):void {
        var pos:Point3D = new Point3D();
        pos.x = point.x * MatrixGrid.FACTOR;
        pos.z = point.y * MatrixGrid.FACTOR;
        var isoPoint:Point = IsoUtils.isoToScreen(pos);
        tile.graphicsSource.x = isoPoint.x;
        tile.graphicsSource.y = isoPoint.y;
        tile.posX = point.x;
        tile.posY = point.y;
    }
}
}
