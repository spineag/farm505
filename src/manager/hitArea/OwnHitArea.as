/**
 * Created by user on 4/26/16.
 */
package manager.hitArea {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Matrix;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Color;

import utils.DrawToBitmap;

public class OwnHitArea {
    private var _source:Sprite; // use only for test
    private var _pixelsArr:Vector.< Vector.<Boolean> >;
    private var _w:int;
    private var _h:int;
    private var _rect:flash.geom.Rectangle;

    public function OwnHitArea(sp:Sprite) {
        _source = sp;
        _rect = sp.getBounds(sp);
        _rect.x = int(_rect.x);
        _rect.y = int(_rect.y);
        createBitmapData(sp);
    }

    private function createBitmapData(sp:Sprite):void {
//        var bm:Bitmap = DrawToBitmap.drawToBitmap(sp);
        var bm:Bitmap = new Bitmap(DrawToBitmap.copyToBitmapScale(sp));
        var bitmapScaling:Number = 1; // use for minimise memory, try smaller number for that, max = 1
        _w = int(bm.width * bitmapScaling);
        _h = int(bm.height * bitmapScaling);
        var tempBitmapData:BitmapData = new BitmapData(bm.width, bm.height, true, 0x00000000);
        bitmapScaling < 1 ? tempBitmapData.draw(bm.bitmapData, new Matrix(bitmapScaling, 0, 0, bitmapScaling, 0, 0)) : tempBitmapData = bm.bitmapData.clone();
        bm.bitmapData.dispose();
        bm = null;
        createPixelArray(tempBitmapData);
//        createTestSprite();
//        createTestSprite2(tempBitmapData);
    }

    public function createTestSprite():void {
        var bData:BitmapData = new BitmapData(_w, _h);
        var j:int;
        for (var i:int=0; i<_w; i++) {
            for (j=0; j<_h; j++) {
                if (_pixelsArr[i][j]) {
                    bData.setPixel(i, j, 0xff00ff00);
                } else {
                    bData.setPixel32(i, j, 0x00ff0000);
                }
            }
        }
        var im:Image = new Image(Texture.fromBitmapData(bData));
        im.x = _rect.x;
        im.y = _rect.y;
        _source.addChild(im);
    }

    private function createTestSprite2(bData:BitmapData):void {
        var j:int;
        var color:uint;
        for (var i:int=0; i<_w; i++) {
            for (j=0; j<_h; j++) {
                color = bData.getPixel32(i, j);
                if (Color.getAlpha(color) < 30) {
                    bData.setPixel32(i, j, 0x00000000);
                } else {
                    bData.setPixel32(i, j, 0xff000000);
                }
            }
        }
        createTestSprite3(bData);
    }

    private function createTestSprite3(bData:BitmapData):void {
        var im:Image = new Image(Texture.fromBitmapData(bData));
        im.x = _rect.x;
        im.y = _rect.y;
        _source.addChild(im);
    }

    private function createPixelArray(bData:BitmapData):void {
        var j:int;
        var pixels:Vector.<Boolean>;
        var isFullPixel:Boolean;
        var color:uint;
        _pixelsArr = new Vector.<Vector.<Boolean>>(_w);
        for (var i:int=0; i<_w; i++) {
            pixels = new Vector.<Boolean>;
            for (j=0; j<_h; j++) {
                color = bData.getPixel32(i, j);
                isFullPixel = Color.getAlpha(color) > 30;
                pixels[j] = isFullPixel;
            }
            _pixelsArr[i] = pixels;
        }
    }

    public function isTouchablePoint(x:int, y:int):Boolean {
        var isFullPixel:Boolean;
        try {
            isFullPixel = _pixelsArr[x - _rect.x][y - _rect.y];
        } catch (e:Error) {
            return false;
        }

        return isFullPixel;
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
