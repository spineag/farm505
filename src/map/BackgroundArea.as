/**
 * Created by user on 5/14/15.
 */
package map {
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
    private var _callback:Function;

    protected var g:Vars = Vars.getInstance();

    public function BackgroundArea(f:Function) {
        _cont = g.cont.backgroundCont;
        _additionalCont = new Sprite();

        _callback = f;
        fillBG();
    }

    private function fillBG():void {
//        var arr:Array = g.matrixGrid.matrix;
//        var arr2:Array;
//        var tile:BackgroundTile;
//        var p:Point;

//        for (var i:int = 0; i < arr.length; i++) {
//            arr2 = arr[i];
//            for (var j:int = 0; j < arr2.length; j++) {
//                tile = new BackgroundTile((i+j)%2 + 1, arr2[j].inGame);
//                p = new Point(i, j);
//                tile.graphicsSource.pivotX = tile.graphicsSource.width/2;
//                setTileFromIndex(tile, p);
//                _cont.addChild(tile.graphicsSource);
//            }
//        }
        var q:Quad = new Quad(7560, 5000, Color.WHITE);
        _cont.addChild(q);

        g.gameDispatcher.addEnterFrame(createMapBackground);
    }

    private var _counter:int = 0;
    private var _texture:Texture;
    private var _bg:Image;
    private var _x:int;
    private var _y:int;
    private function createMapBackground():void {
        _counter++;
        switch(_counter) {
            case 1: _texture = Texture.fromBitmap(new EmbedAssets.Map1());
                _x = 0;
                _y = 0;
                break;
            case 2: _texture = Texture.fromBitmap(new EmbedAssets.Map2());
                _x = 2000;
                _y = 0;
                break;
            case 3: _texture = Texture.fromBitmap(new EmbedAssets.Map3());
                _x = 4000;
                _y = 0;
                break;
            case 4: _texture = Texture.fromBitmap(new EmbedAssets.Map4());
                _x = 6000;
                _y = 0;
                break;
            case 5: _texture = Texture.fromBitmap(new EmbedAssets.Map5());
                _x = 0;
                _y = 2000;
                break;
            case 6: _texture = Texture.fromBitmap(new EmbedAssets.Map6());
                _x = 2000;
                _y = 2000;
                break;
            case 7: _texture = Texture.fromBitmap(new EmbedAssets.Map7());
                _x = 4000;
                _y = 2000;
                break;
            case 8: _texture = Texture.fromBitmap(new EmbedAssets.Map8());
                _x = 6000;
                _y = 2000;
                break;
            case 9: _texture = Texture.fromBitmap(new EmbedAssets.Map9());
                _x = 0;
                _y = 4000;
                break;
            case 10: _texture = Texture.fromBitmap(new EmbedAssets.Map10());
                _x = 2000;
                _y = 4000;
                break;
            case 11: _texture = Texture.fromBitmap(new EmbedAssets.Map11());
                _x = 4000;
                _y = 4000;
                break;
            case 12: _texture = Texture.fromBitmap(new EmbedAssets.Map12());
                _x = 6000;
                _y = 4000;
                break;
        }

        _bg = new Image(_texture);
        _texture = null;
        _bg.x = _x;
        _bg.y = _y;
        _additionalCont.addChild(_bg);

        if (_counter >= 12) {
            _additionalCont.x = -_additionalCont.width / 2 + MatrixGrid.DIAGONAL / 2;
//            _additionalCont.y = _cont.height / 2 - _additionalCont.height / 2;
//            _additionalCont.flatten();
            _cont.addChild(_additionalCont);

            g.gameDispatcher.removeEnterFrame(createMapBackground);
            _counter = 0;
            _x = 0;
            _y = 0;
            _texture = null;
            _bg = null;

            if (_callback != null) {
                _callback.apply();
                _callback = null;
            }
        }
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
