/**
 * Created by user on 5/14/15.
 */
package map {
import com.junkbyte.console.Cc;

import flash.display.Bitmap;
import flash.geom.Point;

import map.Containers;
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

import utils.IsoUtils;
import utils.Point3D;

import windows.WindowsManager;

public class BackgroundArea {
    private var _cont:Sprite;
    private var _additionalCont:Sprite;
    private var _callback:Function;
    private var _countLoaded:int;

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

        loadBG();
    }

//    private function setTileFromIndex(tile:BackgroundTile, point:Point):void {
//        var pos:Point3D = new Point3D();
//        pos.x = point.x * g.matrixGrid.FACTOR;
//        pos.z = point.y * g.matrixGrid.FACTOR;
//        var isoPoint:Point = IsoUtils.isoToScreen(pos);
//        tile.graphicsSource.x = isoPoint.x;
//        tile.graphicsSource.y = isoPoint.y;
//        tile.posX = point.x;
//        tile.posY = point.y;
//    }

    private function loadBG():void {
        var st:String = g.dataPath.getGraphicsPath() + 'map/';
        _countLoaded = 0;
        g.load.loadImage(st+'map_1.jpg', onLoadMap, st+'map_1.jpg', 0, 0);
        g.load.loadImage(st+'map_2.jpg', onLoadMap, st+'map_2.jpg', 2000, 0);
        g.load.loadImage(st+'map_3.jpg', onLoadMap, st+'map_3.jpg', 4000, 0);
        g.load.loadImage(st+'map_4.jpg', onLoadMap, st+'map_4.jpg', 6000, 0);
        g.load.loadImage(st+'map_5.jpg', onLoadMap, st+'map_5.jpg', 0, 2000);
        g.load.loadImage(st+'map_6.jpg', onLoadMap, st+'map_6.jpg', 2000, 2000);
        g.load.loadImage(st+'map_7.jpg', onLoadMap, st+'map_7.jpg', 4000, 2000);
        g.load.loadImage(st+'map_8.jpg', onLoadMap, st+'map_8.jpg', 6000, 2000);
        g.load.loadImage(st+'map_9.jpg', onLoadMap, st+'map_9.jpg', 0, 4000);
        g.load.loadImage(st+'map_10.jpg', onLoadMap, st+'map_10.jpg', 2000, 4000);
        g.load.loadImage(st+'map_11.jpg', onLoadMap, st+'map_11.jpg', 4000, 4000);
        g.load.loadImage(st+'map_12.jpg', onLoadMap, st+'map_12.jpg', 6000, 4000);
        _cont.addChild(_additionalCont);
        _additionalCont.x = -g.realGameWidth/2 + g.matrixGrid.DIAGONAL/2 - g.cont.SHIFT_MAP_X;
        _additionalCont.y = -g.matrixGrid.offsetY - g.cont.SHIFT_MAP_Y;
        if (_callback != null) {
            _callback.apply();
            _callback = null;
        }
    }

    private function onLoadMap(b:Bitmap, url:String, _x:int, _y:int):void {
        if (!b) {
            b = g.pBitmaps[url].create() as Bitmap;
        }
        if (!b) {
            Cc.error('BackgroundArea: map bitmap is null for url: ' + url);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'backgroundArea');
            return;
        }

        var t:Texture = Texture.fromBitmap(b);
        b.bitmapData.dispose();
        b = null;
        var bg:Image = new Image(t);
        bg.x = _x * g.scaleFactor;
        bg.y = _y * g.scaleFactor;
        _additionalCont.addChild(bg);
        g.pBitmaps[url].deleteIt();
        delete g.pBitmaps[url];
        _countLoaded++;
    }
}
}
