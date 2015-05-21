/**
 * Created by user on 5/21/15.
 */
package mouse {


import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Shape;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.ui.Mouse;

import flash.ui.MouseCursorData;

import manager.Vars;

import starling.display.Image;


import starling.display.Sprite;

import starling.events.Touch;

import starling.events.TouchEvent;
import starling.textures.Texture;

import utils.DrawToBitmap;

public class OwnMouse {
    private var _mouseX:Number;
    private var _mouseY:Number;
    private var _touch:Touch;
    private var _cont:Sprite;
    private var cursorPoints:Vector.<Number> = new <Number>[0,8, 16,8, 16,0, 24,12, 16,24, 16,16, 0,16, 0,8];//
    private var cursorDrawCommands:Vector.<int> = new <int>[1,2,2,2,2,2,2,2];//

    private var g:Vars = Vars.getInstance();

    public function OwnMouse() {
        _cont = g.cont.mouseCont;
        g.mainStage.addEventListener(TouchEvent.TOUCH, onTouchEvent);
        CreateMouseCursor();
    }

    private function onTouchEvent(e:TouchEvent):void {
        _touch = e.getTouch(g.mainStage);
        if (_touch) {
            _mouseX = _touch.globalX;
            _mouseY = _touch.globalY;
        }
    }

    public function get mouseX():Number {
        return _mouseX;
    }

    public function get mouseY():Number {
        return _mouseY;
    }

    private function CreateMouseCursor():void {
        _cont = new Sprite();

        var vec_D:Vector.<BitmapData> = new Vector.<BitmapData>(1, true);
        var texture:Texture = g.mapAtlas.getTexture("cursor");
        var bitMap:Bitmap = DrawToBitmap.drawToBitmap(new Image(texture));
        vec_D[0] = bitMap.bitmapData;

        var cursor_D:MouseCursorData = new MouseCursorData();
        cursor_D.data = makeCursorImages();//vec_D;
        cursor_D.hotSpot = new Point(0, 0);
        Mouse.registerCursor("newCursor", cursor_D);
        Mouse.cursor = "newCursor";


//        var mouseCursorData:MouseCursorData = new MouseCursorData();
//        mouseCursorData.data = makeCursorImages();
//        mouseCursorData.frameRate = 1;

//        Mouse.registerCursor("spinningArrow", mouseCursorData);
//        Mouse.cursor = "spinningArrow";

    }

    private function makeCursorImages():Vector.<BitmapData> {
        var cursorData:Vector.<BitmapData> = new Vector.<BitmapData>();

        var cursorShape:Shape = new Shape();
        cursorShape.graphics.beginFill(0xff5555, .75);
        cursorShape.graphics.lineStyle(1);
        cursorShape.graphics.drawPath(cursorDrawCommands, cursorPoints);
        cursorShape.graphics.endFill();
        var transformer:Matrix = new Matrix();

        //Rotate and draw the arrow shape to a BitmapData object for each of 8 frames
        for (var i:int = 0; i < 8; i++) {
            var cursorFrame:BitmapData = new BitmapData(32, 32, true, 0);
            cursorFrame.draw(cursorShape, transformer);
            cursorData.push(cursorFrame);

            transformer.translate(-15, -15);
            transformer.rotate(0.785398163);
            transformer.translate(15, 15);
        }
        return cursorData;

    }
}
}
