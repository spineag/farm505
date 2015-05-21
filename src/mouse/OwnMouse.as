/**
 * Created by user on 5/21/15.
 */
package mouse {


import flash.display.Bitmap;
import flash.display.BitmapData;
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
    public static const USUAL_CURSOR:String = 'usual_cursor';
    public static const HOVER_CURSOR:String = 'hover_cursor';
    public static const CLICK_CURSOR:String = 'click_cursor';

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
        var cursor_D:MouseCursorData = new MouseCursorData();
        cursor_D.data = makeCursorImages("cursor");
        cursor_D.frameRate = 0;
        cursor_D.hotSpot = new Point(0, 0);
        Mouse.registerCursor(USUAL_CURSOR, cursor_D);
        Mouse.cursor = USUAL_CURSOR;

        cursor_D = new MouseCursorData();
        cursor_D.data = makeCursorImages("cursor_hover");
        cursor_D.frameRate = 0;
        cursor_D.hotSpot = new Point(0, 0);
        Mouse.registerCursor(HOVER_CURSOR, cursor_D);

        cursor_D = new MouseCursorData();
        cursor_D.data = makeCursorImages("cursor_click");
        cursor_D.frameRate = 0;
        cursor_D.hotSpot = new Point(0, 0);
        Mouse.registerCursor(CLICK_CURSOR, cursor_D);
    }

    private function makeCursorImages(st:String):Vector.<BitmapData> {
        var cursorData:Vector.<BitmapData> = new Vector.<BitmapData>();
        var texture:Texture = g.mapAtlas.getTexture(st);
        var bitMap:Bitmap = DrawToBitmap.drawToBitmap(new Image(texture));
        cursorData.push(bitMap.bitmapData);

        return cursorData;

    }
}
}
