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

import starling.core.Starling;
import starling.display.Image;
import starling.textures.Texture;
import utils.DrawToBitmap;

public class OwnMouse {
    [Embed(source="../../assets/embeds/cursor_click.png")]
    private const CursorClick:Class;
    [Embed(source="../../assets/embeds/cursor_default.png")]
    private const CursorDefault:Class;
    [Embed(source="../../assets/embeds/cursor_hover.png")]
    private const CursorHover:Class;

    public static const USUAL_CURSOR:String = 'cursor_default';
    public static const HOVER_CURSOR:String = 'cursor_hover';
    public static const CLICK_CURSOR:String = 'cursor_click';

    private var g:Vars = Vars.getInstance();

    public function OwnMouse() {
        CreateMouseCursor();
    }

    public function get mouseX():Number {
        return g.starling.nativeOverlay.mouseX;
    }

    public function get mouseY():Number {
        return g.starling.nativeOverlay.mouseY;
    }

    private function CreateMouseCursor():void {
        var cursorData:Vector.<BitmapData>;
        var cursor_D:MouseCursorData = new MouseCursorData();
//        cursor_D.data = makeCursorImages("cursor_default");
        cursorData = new Vector.<BitmapData>();
        cursorData.push(Bitmap(new CursorDefault()).bitmapData);
        cursor_D.data = cursorData;
        cursor_D.frameRate = 0;
        cursor_D.hotSpot = new Point(0, 0);
        Mouse.registerCursor(USUAL_CURSOR, cursor_D);
        Mouse.cursor = USUAL_CURSOR;

        cursor_D = new MouseCursorData();
//        cursor_D.data = makeCursorImages("cursor_hover");
        cursorData = new Vector.<BitmapData>();
        cursorData.push(Bitmap(new CursorHover()).bitmapData);
        cursor_D.data = cursorData;
        cursor_D.frameRate = 0;
        cursor_D.hotSpot = new Point(0, 0);
        Mouse.registerCursor(HOVER_CURSOR, cursor_D);

        cursor_D = new MouseCursorData();
//        cursor_D.data = makeCursorImages("cursor_click");
        cursorData = new Vector.<BitmapData>();
        cursorData.push(Bitmap(new CursorClick()).bitmapData);
        cursor_D.data = cursorData;
        cursor_D.frameRate = 0;
        cursor_D.hotSpot = new Point(0, 0);
        Mouse.registerCursor(CLICK_CURSOR, cursor_D);
    }

//    private function makeCursorImages(st:String):Vector.<BitmapData> {
//        var cursorData:Vector.<BitmapData> = new Vector.<BitmapData>();
//        var texture:Texture = g.allData.atlas['interfaceAtlas'].getTexture(st);
//        var bitMapD:BitmapData = DrawToBitmap.copyToBitmapData(Starling.current, new Image(texture));
//        cursorData.push(bitMapD);
//
//        return cursorData;
//    }

    public function showUsualCursor():void {
        Mouse.cursor = USUAL_CURSOR;
    }

    public function showClickCursor():void {
        Mouse.cursor = CLICK_CURSOR;
    }
}
}
