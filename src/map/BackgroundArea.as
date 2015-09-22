/**
 * Created by user on 5/14/15.
 */
package map {
import flash.display.Bitmap;
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

        loadBG();

//        g.gameDispatcher.addEnterFrame(createMapBackground);
    }

//    private var _counter:int = 0;
//    private var _texture:Texture;
//    private var _bg:Image;
//    private var _x:int;
//    private var _y:int;
//    private function createMapBackground():void {
//        _counter++;
//        switch(_counter) {
//            case 10: _texture = Texture.fromBitmap(new EmbedAssets.Map1());
//                _x = 0;
//                _y = 0;
//                break;
//            case 20: _texture = Texture.fromBitmap(new EmbedAssets.Map2());
//                _x = 2000;
//                _y = 0;
//                break;
//            case 30: _texture = Texture.fromBitmap(new EmbedAssets.Map3());
//                _x = 4000;
//                _y = 0;
//                break;
//            case 40: _texture = Texture.fromBitmap(new EmbedAssets.Map4());
//                _x = 6000;
//                _y = 0;
//                break;
//            case 50: _texture = Texture.fromBitmap(new EmbedAssets.Map5());
//                _x = 0;
//                _y = 2000;
//                break;
//            case 60: _texture = Texture.fromBitmap(new EmbedAssets.Map6());
//                _x = 2000;
//                _y = 2000;
//                break;
//            case 70: _texture = Texture.fromBitmap(new EmbedAssets.Map7());
//                _x = 4000;
//                _y = 2000;
//                break;
//            case 90: _texture = Texture.fromBitmap(new EmbedAssets.Map8());
//                _x = 6000;
//                _y = 2000;
//                break;
//            case 80: _texture = Texture.fromBitmap(new EmbedAssets.Map9());
//                _x = 0;
//                _y = 4000;
//                break;
//            case 10: _texture = Texture.fromBitmap(new EmbedAssets.Map10());
//                _x = 2000;
//                _y = 4000;
//                break;
//            case 11: _texture = Texture.fromBitmap(new EmbedAssets.Map11());
//                _x = 4000;
//                _y = 4000;
//                break;
//            case 12: _texture = Texture.fromBitmap(new EmbedAssets.Map12());
//                _x = 6000;
//                _y = 4000;
//                break;
//        }
//
//        if (_texture) {
//            _bg = new Image(_texture);
//            _texture = null;
//            _bg.x = _x;
//            _bg.y = _y;
//            _additionalCont.addChild(_bg);
//        }
//
//        if (_counter >= 90) {
//            _additionalCont.x = -_additionalCont.width / 2 + MatrixGrid.DIAGONAL / 2;
////            _additionalCont.y = _cont.height / 2 - _additionalCont.height / 2;
////            _additionalCont.flatten();
//            _cont.addChild(_additionalCont);
//
//            g.gameDispatcher.removeEnterFrame(createMapBackground);
//            _counter = 0;
//            _x = 0;
//            _y = 0;
//            _texture = null;
//            _bg = null;
//
//            if (_callback != null) {
//                _callback.apply();
//                _callback = null;
//            }
//        }
//    }

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
            g.load.loadImage('../assets/map/map_opt/map01.jpg', onLocalLoadMap1);
            g.load.loadImage('../assets/map/map_opt/map02.jpg', onLocalLoadMap2);
            g.load.loadImage('../assets/map/map_opt/map03.jpg', onLocalLoadMap3);
            g.load.loadImage('../assets/map/map_opt/map04.jpg', onLocalLoadMap4);
            g.load.loadImage('../assets/map/map_opt/map05.jpg', onLocalLoadMap5);
            g.load.loadImage('../assets/map/map_opt/map06.jpg', onLocalLoadMap6);
            g.load.loadImage('../assets/map/map_opt/map07.jpg', onLocalLoadMap7);
            g.load.loadImage('../assets/map/map_opt/map08.jpg', onLocalLoadMap8);
            g.load.loadImage('../assets/map/map_opt/map09.jpg', onLocalLoadMap9);
            g.load.loadImage('../assets/map/map_opt/map10.jpg', onLocalLoadMap10);
            g.load.loadImage('../assets/map/map_opt/map11.jpg', onLocalLoadMap11);
            g.load.loadImage('../assets/map/map_opt/map12.jpg', onLocalLoadMap12);
        } else {
            g.load.loadImage(g.dataPath.getTempGraphicsPath() + 'map/map01.jpg', onLoadMap1);
            g.load.loadImage(g.dataPath.getTempGraphicsPath() + 'map/map02.jpg', onLoadMap2);
            g.load.loadImage(g.dataPath.getTempGraphicsPath() + 'map/map03.jpg', onLoadMap3);
            g.load.loadImage(g.dataPath.getTempGraphicsPath() + 'map/map04.jpg', onLoadMap4);
            g.load.loadImage(g.dataPath.getTempGraphicsPath() + 'map/map05.jpg', onLoadMap5);
            g.load.loadImage(g.dataPath.getTempGraphicsPath() + 'map/map06.jpg', onLoadMap6);
            g.load.loadImage(g.dataPath.getTempGraphicsPath() + 'map/map07.jpg', onLoadMap7);
            g.load.loadImage(g.dataPath.getTempGraphicsPath() + 'map/map08.jpg', onLoadMap8);
            g.load.loadImage(g.dataPath.getTempGraphicsPath() + 'map/map09.jpg', onLoadMap9);
            g.load.loadImage(g.dataPath.getTempGraphicsPath() + 'map/map10.jpg', onLoadMap10);
            g.load.loadImage(g.dataPath.getTempGraphicsPath() + 'map/map11.jpg', onLoadMap11);
            g.load.loadImage(g.dataPath.getTempGraphicsPath() + 'map/map12.jpg', onLoadMap12);
        }

        _cont.addChild(_additionalCont);
        _additionalCont.x = - g.realGameWidth/2 + MatrixGrid.DIAGONAL / 2;
        _additionalCont.y = _cont.height / 2 - g.realGameHeight / 2;
        if (_callback != null) {
                _callback.apply();
                _callback = null;
            }
    }

    private function onLoadMap1(b:Bitmap):void {
        var t:Texture = Texture.fromBitmap(b);
        var bg:Image = new Image(t);
        bg.x = 0;
        bg.y = 0;
        _additionalCont.addChild(bg);
        delete g.pBitmaps[g.dataPath.MAIN_PATH_GRAPHICS + 'map/map01.jpg'];
    }

    private function onLoadMap2(b:Bitmap):void {
        var t:Texture = Texture.fromBitmap(b);
        var bg:Image = new Image(t);
        bg.x = 2000;
        bg.y = 0;
        _additionalCont.addChild(bg);
        delete g.pBitmaps[g.dataPath.MAIN_PATH_GRAPHICS + 'map/map02.jpg'];
    }

    private function onLoadMap3(b:Bitmap):void {
        var t:Texture = Texture.fromBitmap(b);
        var bg:Image = new Image(t);
        bg.x = 4000;
        bg.y = 0;
        _additionalCont.addChild(bg);
        delete g.pBitmaps[g.dataPath.MAIN_PATH_GRAPHICS + 'map/map03.jpg'];
    }

    private function onLoadMap4(b:Bitmap):void {
        var t:Texture = Texture.fromBitmap(b);
        var bg:Image = new Image(t);
        bg.x = 6000;
        bg.y = 0;
        _additionalCont.addChild(bg);
        delete g.pBitmaps[g.dataPath.MAIN_PATH_GRAPHICS + 'map/map04.jpg'];
    }

    private function onLoadMap5(b:Bitmap):void {
        var t:Texture = Texture.fromBitmap(b);
        var bg:Image = new Image(t);
        bg.x = 0;
        bg.y = 2000;
        _additionalCont.addChild(bg);
        delete g.pBitmaps[g.dataPath.MAIN_PATH_GRAPHICS + 'map/map05.jpg'];
    }

    private function onLoadMap6(b:Bitmap):void {
        var t:Texture = Texture.fromBitmap(b);
        var bg:Image = new Image(t);
        bg.x = 2000;
        bg.y = 2000;
        _additionalCont.addChild(bg);
        delete g.pBitmaps[g.dataPath.MAIN_PATH_GRAPHICS + 'map/map06.jpg'];
    }

    private function onLoadMap7(b:Bitmap):void {
        var t:Texture = Texture.fromBitmap(b);
        var bg:Image = new Image(t);
        bg.x = 4000;
        bg.y = 2000;
        _additionalCont.addChild(bg);
        delete g.pBitmaps[g.dataPath.MAIN_PATH_GRAPHICS + 'map/map07.jpg'];
    }

    private function onLoadMap8(b:Bitmap):void {
        var t:Texture = Texture.fromBitmap(b);
        var bg:Image = new Image(t);
        bg.x = 6000;
        bg.y = 2000;
        _additionalCont.addChild(bg);
        delete g.pBitmaps[g.dataPath.MAIN_PATH_GRAPHICS + 'map/map08.jpg'];
    }

    private function onLoadMap9(b:Bitmap):void {
        var t:Texture = Texture.fromBitmap(b);
        var bg:Image = new Image(t);
        bg.x = 0;
        bg.y = 4000;
        _additionalCont.addChild(bg);
        delete g.pBitmaps[g.dataPath.MAIN_PATH_GRAPHICS + 'map/map09.jpg'];
    }

    private function onLoadMap10(b:Bitmap):void {
        var t:Texture = Texture.fromBitmap(b);
        var bg:Image = new Image(t);
        bg.x = 2000;
        bg.y = 4000;
        _additionalCont.addChild(bg);
        delete g.pBitmaps[g.dataPath.MAIN_PATH_GRAPHICS + 'map/map10.jpg'];
    }

    private function onLoadMap11(b:Bitmap):void {
        var t:Texture = Texture.fromBitmap(b);
        var bg:Image = new Image(t);
        bg.x = 4000;
        bg.y = 4000;
        _additionalCont.addChild(bg);
        delete g.pBitmaps[g.dataPath.MAIN_PATH_GRAPHICS + 'map/map11.jpg'];
    }

    private function onLoadMap12(b:Bitmap):void {
        var t:Texture = Texture.fromBitmap(b);
        var bg:Image = new Image(t);
        bg.x = 6000;
        bg.y = 4000;
        _additionalCont.addChild(bg);
        delete g.pBitmaps[g.dataPath.MAIN_PATH_GRAPHICS + 'map/map12.jpg'];
    }

    private function onLocalLoadMap1(b:Bitmap):void {
//        var bitmap:Bitmap = g.pBitmaps['../assets/map/map_opt/map01.jpg'].create() as Bitmap;
        var t:Texture = Texture.fromBitmap(b);
        var bg:Image = new Image(t);
        bg.x = 0;
        bg.y = 0;
        _additionalCont.addChild(bg);
        delete g.pBitmaps['../assets/map/map_opt/map01.jpg'];
    }

    private function onLocalLoadMap2(b:Bitmap):void {
//        var bitmap:Bitmap = g.pBitmaps['../assets/map/map_opt/map02.jpg'].create() as Bitmap;
        var t:Texture = Texture.fromBitmap(b);
        var bg:Image = new Image(t);
        bg.x = 2000;
        bg.y = 0;
        _additionalCont.addChild(bg);
        delete g.pBitmaps['../assets/map/map_opt/map02.jpg'];
    }

    private function onLocalLoadMap3(b:Bitmap):void {
//        var bitmap:Bitmap = g.pBitmaps['../assets/map/map_opt/map03.jpg'].create() as Bitmap;
        var t:Texture = Texture.fromBitmap(b);
        var bg:Image = new Image(t);
        bg.x = 4000;
        bg.y = 0;
        _additionalCont.addChild(bg);
        delete g.pBitmaps['../assets/map/map_opt/map03.jpg'];
    }

    private function onLocalLoadMap4(b:Bitmap):void {
//        var bitmap:Bitmap = g.pBitmaps['../assets/map/map_opt/map04.jpg'].create() as Bitmap;
        var t:Texture = Texture.fromBitmap(b);
        var bg:Image = new Image(t);
        bg.x = 6000;
        bg.y = 0;
        _additionalCont.addChild(bg);
        delete g.pBitmaps['../assets/map/map_opt/map04.jpg'];
    }

    private function onLocalLoadMap5(b:Bitmap):void {
//        var bitmap:Bitmap = g.pBitmaps['../assets/map/map_opt/map05.jpg'].create() as Bitmap;
        var t:Texture = Texture.fromBitmap(b);
        var bg:Image = new Image(t);
        bg.x = 0;
        bg.y = 2000;
        _additionalCont.addChild(bg);
        delete g.pBitmaps['../assets/map/map_opt/map05.jpg'];
    }

    private function onLocalLoadMap6(b:Bitmap):void {
//        var bitmap:Bitmap = g.pBitmaps['../assets/map/map_opt/map06.jpg'].create() as Bitmap;
        var t:Texture = Texture.fromBitmap(b);
        var bg:Image = new Image(t);
        bg.x = 2000;
        bg.y = 2000;
        _additionalCont.addChild(bg);
        delete g.pBitmaps['../assets/map/map_opt/map06.jpg'];
    }

    private function onLocalLoadMap7(b:Bitmap):void {
//        var bitmap:Bitmap = g.pBitmaps['../assets/map/map_opt/map07.jpg'].create() as Bitmap;
        var t:Texture = Texture.fromBitmap(b);
        var bg:Image = new Image(t);
        bg.x = 4000;
        bg.y = 2000;
        _additionalCont.addChild(bg);
        delete g.pBitmaps['../assets/map/map_opt/map07.jpg'];
    }

    private function onLocalLoadMap8(b:Bitmap):void {
//        var bitmap:Bitmap = g.pBitmaps['../assets/map/map_opt/map08.jpg'].create() as Bitmap;
        var t:Texture = Texture.fromBitmap(b);
        var bg:Image = new Image(t);
        bg.x = 6000;
        bg.y = 2000;
        _additionalCont.addChild(bg);
        delete g.pBitmaps['../assets/map/map_opt/map08.jpg'];
    }

    private function onLocalLoadMap9(b:Bitmap):void {
//        var bitmap:Bitmap = g.pBitmaps['../assets/map/map_opt/map09.jpg'].create() as Bitmap;
        var t:Texture = Texture.fromBitmap(b);
        var bg:Image = new Image(t);
        bg.x = 0;
        bg.y = 4000;
        _additionalCont.addChild(bg);
        delete g.pBitmaps['../assets/map/map_opt/map09.jpg'];
    }

    private function onLocalLoadMap10(b:Bitmap):void {
//        var bitmap:Bitmap = g.pBitmaps['../assets/map/map_opt/map10.jpg'].create() as Bitmap;
        var t:Texture = Texture.fromBitmap(b);
        var bg:Image = new Image(t);
        bg.x = 2000;
        bg.y = 4000;
        _additionalCont.addChild(bg);
        delete g.pBitmaps['../assets/map/map_opt/map10.jpg'];
    }

    private function onLocalLoadMap11(b:Bitmap):void {
//        var bitmap:Bitmap = g.pBitmaps['../assets/map/map_opt/map11.jpg'].create() as Bitmap;
        var t:Texture = Texture.fromBitmap(b);
        var bg:Image = new Image(t);
        bg.x = 4000;
        bg.y = 4000;
        _additionalCont.addChild(bg);
        delete g.pBitmaps['../assets/map/map_opt/map11.jpg'];
    }

    private function onLocalLoadMap12(b:Bitmap):void {
//        var bitmap:Bitmap = g.pBitmaps['../assets/map/map_opt/map12.jpg'].create() as Bitmap;
        var t:Texture = Texture.fromBitmap(b);
        var bg:Image = new Image(t);
        bg.x = 6000;
        bg.y = 4000;
        _additionalCont.addChild(bg);
        delete g.pBitmaps['../assets/map/map_opt/map12.jpg'];
    }
}
}
