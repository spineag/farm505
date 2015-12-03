/**
 * Created by user on 11/18/15.
 */
package windows.paperWindow {
import flash.display.Bitmap;

import manager.ManagerFilters;

import manager.Vars;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.HAlign;

import utils.DrawToBitmap;

import utils.MCScaler;

public class WOPaperPage {
    public static const LEFT_SIDE:String = 'left_side';
    public static const RIGHT_SIDE:String = 'right_side';

    public var source:Sprite;
    private var _arrItems:Array;
    private var _bg:Sprite;
    private var _side:String;

    private var g:Vars = Vars.getInstance();

    public function WOPaperPage(numberPage:int, maxNumberPage:int, side:String) {
        source = new Sprite();
        _side = side;
        createBG(numberPage, maxNumberPage);
        createItems();
    }

    private function createBG(n:int, nMax:int):void {
        _bg = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('newspaper_p1'));
        if (_side == RIGHT_SIDE) {
            im.scaleX = -1;
            im.x = im.width;
        }
        _bg.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('birka_cat'));
        MCScaler.scale(im, 30, 30);
        im.rotation = Math.PI/2;
        im.x = 66;
        im.y = 15;
        _bg.addChild(im);
        var q:Quad = new Quad(320, 2, 0x0184df);
        q.x = 70;
        q.y = 38;
        _bg.addChild(q);
        var txt:TextField = new TextField(300, 100, "НьюсМяу", g.allData.fonts['BloggerBold'], 26, ManagerFilters.TEXT_BROWN);
        txt.hAlign = HAlign.LEFT;
        txt.x = 66;
        txt.y = -23;
        _bg.addChild(txt);
        txt = new TextField(100, 100, String(n) + '/' + String(nMax), g.allData.fonts['BloggerBold'], 20, ManagerFilters.TEXT_BROWN);
        txt.x = 170;
        txt.y = 460;
        _bg.addChild(txt);
        _bg.flatten();
        source.addChild(_bg);
    }

    private function createItems():void {
        var item:WOPaperItem;
        _arrItems = [];
        for (var i:int = 0; i<6; i++) {
            item = new WOPaperItem(i);
            item.source.x = 41 + (i%2)*178;
            item.source.y = 58 + int(i/2)*150;
            source.addChild(item.source);
            _arrItems.push(item);
        }
    }

    public function fillItems(ar:Array):void {
        for (var i:int=0; i< ar.length; i++) {
            _arrItems[i].fillIt(ar[i]);
        }
    }

    public function get getScreenshot():Bitmap {
        var b:Bitmap = DrawToBitmap.drawToBitmap(source);
        return b;
    }

    public function deleteIt():void {
        for (var i:int=0; i<6; i++) {
            _arrItems[i].deleteIt();
        }
    }

    public function updateAvatars():void {
        for (var i:int=0; i< _arrItems.length; i++) {
            _arrItems[i].updateAvatar();
        }
    }
}
}
