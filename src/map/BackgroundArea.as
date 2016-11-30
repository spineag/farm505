/**
 * Created by user on 5/14/15.
 */
package map {
import com.junkbyte.console.Cc;

import flash.display.Bitmap;
import flash.geom.Point;

import loaders.PBitmap;

import map.Containers;
import manager.Vars;

import starling.display.BlendMode;

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
        loadBG();
    }

    private function loadBG():void {
        var st:String = g.dataPath.getGraphicsPath() + 'map/';
        _countLoaded = 0;
        g.load.loadImage(st+'map_1.jpg' + g.getVersion('map'), onLoadMap, st+'map_1.jpg'+ g.getVersion('map'), 0, 0);
        g.load.loadImage(st+'map_2.jpg' + g.getVersion('map'), onLoadMap, st+'map_2.jpg'+ g.getVersion('map'), 2000, 0);
        g.load.loadImage(st+'map_3.jpg' + g.getVersion('map'), onLoadMap, st+'map_3.jpg'+ g.getVersion('map'), 4000, 0);
        g.load.loadImage(st+'map_4.jpg' + g.getVersion('map'), onLoadMap, st+'map_4.jpg'+ g.getVersion('map'), 6000, 0);
        g.load.loadImage(st+'map_5.jpg' + g.getVersion('map'), onLoadMap, st+'map_5.jpg'+ g.getVersion('map'), 0, 2000);
        g.load.loadImage(st+'map_6.jpg' + g.getVersion('map'), onLoadMap, st+'map_6.jpg'+ g.getVersion('map'), 2000, 2000);
        g.load.loadImage(st+'map_7.jpg' + g.getVersion('map'), onLoadMap, st+'map_7.jpg'+ g.getVersion('map'), 4000, 2000);
        g.load.loadImage(st+'map_8.jpg' + g.getVersion('map'), onLoadMap, st+'map_8.jpg'+ g.getVersion('map'), 6000, 2000);
        g.load.loadImage(st+'map_9.jpg' + g.getVersion('map'), onLoadMap, st+'map_9.jpg'+ g.getVersion('map'), 0, 4000);
        g.load.loadImage(st+'map_10.jpg' + g.getVersion('map'), onLoadMap, st+'map_10.jpg'+ g.getVersion('map'), 2000, 4000);
        g.load.loadImage(st+'map_11.jpg' + g.getVersion('map'), onLoadMap, st+'map_11.jpg'+ g.getVersion('map'), 4000, 4000);
        g.load.loadImage(st+'map_12.jpg' + g.getVersion('map'), onLoadMap, st+'map_12.jpg'+ g.getVersion('map'), 6000, 4000);
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
        bg.blendMode = BlendMode.NONE;
        _additionalCont.addChild(bg);
        (g.pBitmaps[url] as PBitmap).deleteIt();
        delete g.pBitmaps[url];
        _countLoaded++;
    }
}
}
