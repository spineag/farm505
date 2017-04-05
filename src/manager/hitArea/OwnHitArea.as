/**
 * Created by user on 4/26/16.
 */
package manager.hitArea {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

import manager.Vars;

import starling.core.Starling;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Color;

import utils.DrawToBitmap;

public class OwnHitArea {
    public static const NO_HIT_AREA:int = 1;
    public static const UNDER_VISIBLE_POINT:int = 2;
    public static const UNDER_INVISIBLE_POINT:int = 3;

    private var _source:starling.display.Sprite; // use only for test
    private var _pixelsArr:Vector.< Vector.<int> >;
    private var _w:int;
    private var _h:int;
    private var _rect:flash.geom.Rectangle;
    private var bitmapScaling:Number = 1; // use for minimise memory, try smaller number for that, max = 1
    private var _name:String;
    private var g:Vars = Vars.getInstance();

    public function OwnHitArea() {}
    
    public function createFromStarlingSprite(sp:starling.display.Sprite, nm:String):void {
        _name = nm;
        _source = sp;
        _rect = sp.getBounds(sp);
        _w = int(_rect.width * bitmapScaling);
        _h = int(_rect.height * bitmapScaling);
        _rect.x = int(_rect.x * bitmapScaling);
        _rect.y = int(_rect.y * bitmapScaling);

        var bmR:BitmapData = sp.drawToBitmapData();
        if (bitmapScaling != 1) bmR = DrawToBitmap.scaleBitmapData(bmR, bitmapScaling);

        var i:int;
        var j:int;
        var isFullPixel:int;
        var pixels:Vector.<int>;
        var color:uint;
        _pixelsArr = new Vector.<Vector.<int>>(_w);
        for (i=0; i<_w; i++) {
            pixels = new Vector.<int>;
            for (j=0; j<_h; j++) {
                color = bmR.getPixel32(i, j);
                if (color > 0x11000000)
                    isFullPixel = 2;
                else isFullPixel = 1;
                pixels[j] = isFullPixel;
            }
            _pixelsArr[i] = pixels;
        }
//        drawForTest();
    }

//    public function createFromLoaded(lsp:flash.display.Sprite, sp:starling.display.Sprite, nm:String):void {
//        _name = nm;
//        _source = sp;
//        _rect = sp.getBounds(sp);
//        _w = int(_rect.width * bitmapScaling);
//        _h = int(_rect.height * bitmapScaling);
//        _rect.x = int(_rect.x * bitmapScaling);
//        _rect.y = int(_rect.y * bitmapScaling);
//        var loadedRect:Rectangle = lsp.getBounds(lsp);
//        var bm:Bitmap = new Bitmap(DrawToBitmap.copyToBitmapDataFromFlashSprite(lsp, g.scaleFactor));
//
//        var tempBitmapData:BitmapData = new BitmapData(bm.width, bm.height);
//        bitmapScaling < 1 ? tempBitmapData.draw(bm.bitmapData, new Matrix(bitmapScaling, 0, 0, bitmapScaling, 0, 0)) : tempBitmapData = bm.bitmapData.clone();
//        bm.bitmapData.dispose();
//        bm = null;
//
//        var i:int;
//        var j:int;
//        var isFullPixel:int;
//        var pixels:Vector.<int>;
//        var color:uint;
//        var deltaW_left:int = loadedRect.x*g.scaleFactor -_rect.x;
//        var deltaW_right:int = deltaW_left + loadedRect.width*g.scaleFactor;
//        var deltaH_top:int = loadedRect.y*g.scaleFactor -_rect.y;
//        var deltaH_bottom:int = deltaH_top + loadedRect.height*g.scaleFactor;
//        _pixelsArr = new Vector.<Vector.<int>>(_w);
//        for (i=0; i<_w; i++) {
//            pixels = new Vector.<int>;
//            for (j=0; j<_h; j++) {
//                if (i<=deltaW_left || i>=deltaW_right || j<=deltaH_top || j>=deltaH_bottom) {
//                    isFullPixel = 1;
//                } else {
//                    color = tempBitmapData.getPixel(i-deltaW_left, j-deltaH_top);
//                    if (color == Color.BLACK)
//                        isFullPixel = 2;
//                    else isFullPixel = 1;
//                }
//                pixels[j] = isFullPixel;
//            }
//            _pixelsArr[i] = pixels;
//        }
//    }

//    public function createTiled(sp:starling.display.Sprite, nm:String, sX:int, sY:int):void {
//        _name = nm;
//        _source = sp;
//        _rect = sp.getBounds(sp);
//        _w = int(_rect.width * bitmapScaling);
//        _h = int(_rect.height * bitmapScaling);
//        _rect.x = int(_rect.x * bitmapScaling);
//        _rect.y = int(_rect.y * bitmapScaling);
//
//        var s:Shape = new Shape();
//        s.graphics.beginFill(Color.RED);
//        s.graphics.drawRect(0, 0, sX*g.matrixGrid.WIDTH_CELL, sY*g.matrixGrid.WIDTH_CELL);
//        s.graphics.endFill();
//        var s2:flash.display.Sprite = new flash.display.Sprite();
//        s.rotation = 45;
//        s2.addChild(s);
//        s2.scaleY = .5;
//        var s3:flash.display.Sprite = new flash.display.Sprite();
//        s3.addChild(s2);
//        var bm:BitmapData = DrawToBitmap.copyToBitmapDataFromFlashSprite(s3);
//        var tempBitmapData:BitmapData = new BitmapData(s3.width, s3.height);
//        bitmapScaling < 1 ? tempBitmapData.draw(bm, new Matrix(bitmapScaling, 0, 0, bitmapScaling, 0, 0)) : tempBitmapData = bm.clone();
//        bm.dispose();
//        bm = null;
//
//        var j:int;
//        var pixels:Vector.<int>;
//        var isFullPixel:int;
//        var color:uint;
//        _pixelsArr = new Vector.<Vector.<int>>(_w);
//        for (var i:int=0; i<_w; i++) {
//            pixels = new Vector.<int>;
//            for (j=0; j<_h; j++) {
//                if (j<-_rect.y) {
//                    isFullPixel = 1;
//                } else {
//                    color = tempBitmapData.getPixel(i, j+_rect.y);
//                    if (color == Color.RED)
//                        isFullPixel = 2;
//                    else isFullPixel = 1;
//                }
//                pixels[j] = isFullPixel;
//            }
//            _pixelsArr[i] = pixels;
//        }
//    }
    
//    public function createFromBitmapData(ob:Object, sp:starling.display.Sprite, nm:String):void {
//        _name = nm;
//        _source = sp;
//        _rect = sp.getBounds(sp);
//        _w = int(_rect.width * bitmapScaling);
//        _h = int(_rect.height * bitmapScaling);
//        _rect.x = int(_rect.x * bitmapScaling);
//        _rect.y = int(_rect.y * bitmapScaling);
//
//        var bd:BitmapData = ob.bitmapData;
//        var i:int;
//        var j:int;
//        var isFullPixel:int;
//        var pixels:Vector.<int>;
//        var color:uint;
//        _pixelsArr = new Vector.<Vector.<int>>(_w);
//        for (i=0; i<_w; i++) {
//            pixels = new Vector.<int>;
//            for (j=0; j<_h; j++) {
//                color = bd.getPixel(i, j);
//                if (color == Color.WHITE)
//                    isFullPixel = 1;
//                else isFullPixel = 2;
//                pixels[j] = isFullPixel;
//            }
//            _pixelsArr[i] = pixels;
//        }
//    }

//    public function createForRidge(sp:starling.display.Sprite, nm:String):void {
//        _name = nm;
//        _source = sp;
//        _rect = sp.getBounds(sp);
//        _w = int(_rect.width * bitmapScaling);
//        _h = int(_rect.height * bitmapScaling);
//        _rect.x = int(_rect.x * bitmapScaling);
//        _rect.y = int(_rect.y * bitmapScaling);
//
//        var bmR:BitmapData = sp.drawToBitmapData();
//        if (bitmapScaling != 1) bmR = DrawToBitmap.scaleBitmapData(bmR, bitmapScaling);
//
//        var i:int;
//        var j:int;
//        var isFullPixel:int;
//        var pixels:Vector.<int>;
//        var color:uint;
//        _pixelsArr = new Vector.<Vector.<int>>(_w);
//        for (i=0; i<_w; i++) {
//            pixels = new Vector.<int>;
//            for (j=0; j<_h; j++) {
//                color = bmR.getPixel32(i, j);
//                if (color > 0x11000000)
//                    isFullPixel = 2;
//                else isFullPixel = 1;
//                pixels[j] = isFullPixel;
//            }
//            _pixelsArr[i] = pixels;
//        }
//    }

    public function createSimple(sp:starling.display.Sprite, nm:String):void {
        _name = nm;
        _source = sp;
        _rect = sp.getBounds(sp);
        _w = int(_rect.width * bitmapScaling);
        _h = int(_rect.height * bitmapScaling);
        _rect.x = int(_rect.x * bitmapScaling);
        _rect.y = int(_rect.y * bitmapScaling);
        _pixelsArr = new Vector.<Vector.<int>>(_w);
        var i:int;
        var j:int;
        var pixels:Vector.<int>;
        for (i=0; i<_w; i++) {
            pixels = new Vector.<int>;
            for (j=0; j<_h; j++) {
                pixels[j] = 2;
            }
            _pixelsArr[i] = pixels;
        }
    }

    public function createCircle(sp:starling.display.Sprite, nm:String):void {
        _name = nm;
        _source = sp;
        _rect = sp.getBounds(sp);
        _w = int(_rect.width * bitmapScaling);
        _h = int(_rect.height * bitmapScaling);
        _rect.x = int(_rect.x * bitmapScaling);
        _rect.y = int(_rect.y * bitmapScaling);

        var s:Shape = new Shape();
        s.graphics.beginFill(Color.RED);
        s.graphics.drawCircle(_w/2, _h/2, _w/2);
        s.graphics.endFill();
        var s2:flash.display.Sprite = new flash.display.Sprite();
        s2.addChild(s);
        var bm:BitmapData = DrawToBitmap.copyToBitmapDataFromFlashSprite(s2);
        var tempBitmapData:BitmapData = new BitmapData(_w, _h);
        bitmapScaling < 1 ? tempBitmapData.draw(bm, new Matrix(bitmapScaling, 0, 0, bitmapScaling, 0, 0)) : tempBitmapData = bm.clone();
        bm.dispose();
        bm = null;

        var i:int;
        var j:int;
        var isFullPixel:int;
        var pixels:Vector.<int>;
        var color:uint;
        _pixelsArr = new Vector.<Vector.<int>>(_w);
        for (i=0; i<_w; i++) {
            pixels = new Vector.<int>;
            for (j=0; j<_h; j++) {
                color = tempBitmapData.getPixel(i, j);
                if (color == Color.RED)
                    isFullPixel = 2;
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
    
    private function drawForTest():void {
        var i:int;
        var j:int;
        var bData:BitmapData = new BitmapData(_w, _h);
        for (i=0; i<_w; i++) {
            for (j=0; j<_h; j++) {
                if (_pixelsArr[i][j]==2) {
                    bData.setPixel32(i, j, 0xff00ff00);
                } else {
                    bData.setPixel32(i, j, 0x00000000);
                }
            }
        }
        var im:Image = new Image(Texture.fromBitmapData(bData));
        im.x = _rect.x/bitmapScaling;
        im.y = _rect.y/bitmapScaling;
        im.scaleX = im.scaleY = 1/bitmapScaling;
        im.alpha = .5;
        _source.addChild(im);
    }
}
}
