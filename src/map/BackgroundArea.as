/**
 * Created by user on 5/14/15.
 */
package map {
import com.junkbyte.console.Cc;

import flash.display.Bitmap;
import flash.geom.Point;

import manager.Containers;
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

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

        loadBG();
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

    private function loadBG():void {
        if (g.isDebug) {
            g.load.loadImage('../assets/map/map_opt/map01.jpg', onLoadMap, '../assets/map/map_opt/map01.jpg', 0, 0);
            g.load.loadImage('../assets/map/map_opt/map02.jpg', onLoadMap, '../assets/map/map_opt/map02.jpg', 2000, 0);
            g.load.loadImage('../assets/map/map_opt/map03.jpg', onLoadMap, '../assets/map/map_opt/map03.jpg', 4000, 0);
            g.load.loadImage('../assets/map/map_opt/map04.jpg', onLoadMap, '../assets/map/map_opt/map04.jpg', 6000, 0);
            g.load.loadImage('../assets/map/map_opt/map05.jpg', onLoadMap, '../assets/map/map_opt/map05.jpg', 0, 2000);
            g.load.loadImage('../assets/map/map_opt/map06.jpg', onLoadMap, '../assets/map/map_opt/map06.jpg', 2000, 2000);
            g.load.loadImage('../assets/map/map_opt/map07.jpg', onLoadMap, '../assets/map/map_opt/map07.jpg', 4000, 2000);
            g.load.loadImage('../assets/map/map_opt/map08.jpg', onLoadMap, '../assets/map/map_opt/map08.jpg', 6000, 2000);
            g.load.loadImage('../assets/map/map_opt/map09.jpg', onLoadMap, '../assets/map/map_opt/map09.jpg', 0, 4000);
            g.load.loadImage('../assets/map/map_opt/map10.jpg', onLoadMap, '../assets/map/map_opt/map10.jpg', 2000, 4000);
            g.load.loadImage('../assets/map/map_opt/map11.jpg', onLoadMap, '../assets/map/map_opt/map11.jpg', 4000, 4000);
            g.load.loadImage('../assets/map/map_opt/map12.jpg', onLoadMap, '../assets/map/map_opt/map12.jpg', 6000, 4000);
        } else {
            g.load.loadImage(g.dataPath.getTempGraphicsPath() + 'map/map01.jpg', onLoadMap, g.dataPath.getTempGraphicsPath() + 'map/map01.jpg', 0, 0);
            g.load.loadImage(g.dataPath.getTempGraphicsPath() + 'map/map02.jpg', onLoadMap, g.dataPath.getTempGraphicsPath() + 'map/map02.jpg', 2000, 0);
            g.load.loadImage(g.dataPath.getTempGraphicsPath() + 'map/map03.jpg', onLoadMap, g.dataPath.getTempGraphicsPath() + 'map/map03.jpg', 4000, 0);
            g.load.loadImage(g.dataPath.getTempGraphicsPath() + 'map/map04.jpg', onLoadMap, g.dataPath.getTempGraphicsPath() + 'map/map04.jpg', 6000, 0);
            g.load.loadImage(g.dataPath.getTempGraphicsPath() + 'map/map05.jpg', onLoadMap, g.dataPath.getTempGraphicsPath() + 'map/map05.jpg', 0, 2000);
            g.load.loadImage(g.dataPath.getTempGraphicsPath() + 'map/map06.jpg', onLoadMap, g.dataPath.getTempGraphicsPath() + 'map/map06.jpg', 2000, 2000);
            g.load.loadImage(g.dataPath.getTempGraphicsPath() + 'map/map07.jpg', onLoadMap, g.dataPath.getTempGraphicsPath() + 'map/map07.jpg', 4000, 2000);
            g.load.loadImage(g.dataPath.getTempGraphicsPath() + 'map/map08.jpg', onLoadMap, g.dataPath.getTempGraphicsPath() + 'map/map08.jpg', 6000, 2000);
            g.load.loadImage(g.dataPath.getTempGraphicsPath() + 'map/map09.jpg', onLoadMap, g.dataPath.getTempGraphicsPath() + 'map/map09.jpg', 0, 4000);
            g.load.loadImage(g.dataPath.getTempGraphicsPath() + 'map/map10.jpg', onLoadMap, g.dataPath.getTempGraphicsPath() + 'map/map10.jpg', 2000, 4000);
            g.load.loadImage(g.dataPath.getTempGraphicsPath() + 'map/map11.jpg', onLoadMap, g.dataPath.getTempGraphicsPath() + 'map/map11.jpg', 4000, 4000);
            g.load.loadImage(g.dataPath.getTempGraphicsPath() + 'map/map12.jpg', onLoadMap, g.dataPath.getTempGraphicsPath() + 'map/map12.jpg', 6000, 4000);
        }

        _cont.addChild(_additionalCont);
        _additionalCont.x = -g.realGameWidth/2 + MatrixGrid.DIAGONAL/2 - Containers.SHIFT_MAP_X;
        _additionalCont.y = -g.matrixGrid.offsetY - Containers.SHIFT_MAP_Y;
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
            g.woGameError.showIt();
            return;
        }

        var t:Texture = Texture.fromBitmap(b);
        b.bitmapData.dispose();
        b = null;
        var bg:Image = new Image(t);
        bg.x = _x;
        bg.y = _y;
        _additionalCont.addChild(bg);
        g.pBitmaps[url].deleteIt();
        delete g.pBitmaps[url];
    }
}
}
