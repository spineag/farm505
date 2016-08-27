/**
 * Created by user on 4/26/16.
 */
package manager.hitArea {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Matrix;

import starling.core.Starling;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Color;

import utils.DrawToBitmap;

public class OwnHitArea {
    public static const NO_HIT_AREA:int = 1;
    public static const UNDER_VISIBLE_POINT:int = 2;
    public static const UNDER_INVISIBLE_POINT:int = 3;

    private var _source:Sprite; // use only for test
    private var _pixelsArr:Vector.< Vector.<int> >;
    private var _w:int;
    private var _h:int;
    private var _rect:flash.geom.Rectangle;
    private var bitmapScaling:Number = .25; // use for minimise memory, try smaller number for that, max = 1
    private var _name:String;

    public function OwnHitArea(sp:Sprite, nm:String) {
        _name = nm;
        _source = sp;
        _rect = sp.getBounds(sp);
        createBitmapData(sp);
    }

    private function createBitmapData(sp:Sprite):void {
        // 1st way
        var bm:Bitmap = new Bitmap(DrawToBitmap.copyToBitmapData(Starling.current, sp));
        _w = int(bm.width * bitmapScaling);
        _h = int(bm.height * bitmapScaling);
        _rect.x = int(_rect.x * bitmapScaling);
        _rect.y = int(_rect.y * bitmapScaling);
        var tempBitmapData:BitmapData = new BitmapData(bm.width, bm.height, true, 0x00000000);
        bitmapScaling < 1 ? tempBitmapData.draw(bm.bitmapData, new Matrix(bitmapScaling, 0, 0, bitmapScaling, 0, 0)) : tempBitmapData = bm.bitmapData.clone();
        bm.bitmapData.dispose();
        bm = null;
        createPixelArray(tempBitmapData);

        
        // 2nd way
        
        
        
        //use for test
//        createTestSprite();
//        bData = tempBitmapData;
//        createTestSprite2();
    }

//    public function createTestSprite():void {
//        var bData:BitmapData = new BitmapData(_w, _h);
//        var j:int;
//        for (var i:int=0; i<_w; i++) {
//            for (j=0; j<_h; j++) {
//                if (_pixelsArr[i][j]) {
//                    bData.setPixel(i, j, 0xff00ff00);
//                } else {
//                    bData.setPixel32(i, j, 0x00ff0000);
//                }
//            }
//        }
//        var im:Image = new Image(Texture.fromBitmapData(bData));
//        im.x = _rect.x/bitmapScaling;
//        im.y = _rect.y/bitmapScaling;
//        im.scaleX = im.scaleY = 1/bitmapScaling;
//        _source.addChild(im);
//    }

//    private var bData:BitmapData;
//    public function createTestSprite2():void {
//        if (!bData) return;
//        var j:int;
//        var color:uint;
//        for (var i:int=0; i<_w; i++) {
//            for (j=0; j<_h; j++) {
//                color = bData.getPixel32(i, j);
//                if (Color.getAlpha(color) < 30) {
//                    bData.setPixel32(i, j, 0x00000000);
//                } else {
//                    bData.setPixel32(i, j, 0xff000000);
//                }
//            }
//        }
//        createTestSprite3(bData);
//    }

//    private function createTestSprite3(bData:BitmapData):void {
//        var im:Image = new Image(Texture.fromBitmapData(bData));
//        im.x = _rect.x/bitmapScaling;
//        im.y = _rect.y/bitmapScaling;
//        im.scaleX = im.scaleY = 1/bitmapScaling;
//        _source.addChild(im);
//    }

    private function createPixelArray(bData:BitmapData):void {
        var j:int;
        var pixels:Vector.<int>;
        var isFullPixel:int;
        var color:uint;
        _pixelsArr = new Vector.<Vector.<int>>(_w);
        for (var i:int=0; i<_w; i++) {
            pixels = new Vector.<int>;
            for (j=0; j<_h; j++) {
                color = bData.getPixel32(i, j);
                if (Color.getAlpha(color) > 30) isFullPixel = 2;
                    else isFullPixel = 1;
                pixels[j] = isFullPixel;
            }
            _pixelsArr[i] = pixels;
        }
    }

    public function isTouchablePoint(x:int, y:int):Boolean {
        var isFullPixel:int;
        try {
            x = int(x*bitmapScaling);
            y = int(y*bitmapScaling);
            if (_pixelsArr[x - _rect.x] && _pixelsArr[x - _rect.x][y - _rect.y])
                isFullPixel = _pixelsArr[x - _rect.x][y - _rect.y] - 1;
            else isFullPixel = 0;
        } catch (e:Error) {
            return false;
        }

        return Boolean(isFullPixel);
    }

    public function deleteIt():void {
        if (_pixelsArr) {
            _pixelsArr.fixed = false;
            _pixelsArr.length = 0;
            _pixelsArr = null;
        }
    }
}
}
