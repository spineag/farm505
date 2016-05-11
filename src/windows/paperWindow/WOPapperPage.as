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
import starling.utils.Color;
import starling.utils.HAlign;

import utils.CSprite;


import utils.DrawToBitmap;

import utils.MCScaler;

public class WOPapperPage {
    public static const LEFT_SIDE:String = 'left_side';
    public static const RIGHT_SIDE:String = 'right_side';

    public var source:Sprite;
    private var _arrItems:Array;
    private var _bg:CSprite;
    private var _side:String;
    private var _quad:Quad;
    private var _wo:WOPapper;
    private var g:Vars = Vars.getInstance();

    public function WOPapperPage(numberPage:int, maxNumberPage:int, side:String, wo:WOPapper) {
        _wo = wo;
        source = new Sprite();
        _side = side;
        createBG(numberPage, maxNumberPage);
        createItems();
    }

    private function createBG(n:int, nMax:int):void {
        _bg = new CSprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('newspaper_p1'));
        _quad = new Quad(im.width, im.height,Color.WHITE ,false);
        _quad.alpha = 0;
        source.addChild(_quad);
        im.touchable = false;
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
        var txt:TextField = new TextField(300, 100, "НьюсМяу", g.allData.fonts['BloggerBold'], 26, ManagerFilters.TEXT_MAX_BLUE);
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
//        var item:WOPapperBuyerItem;
//        _arrItems = [];
//        for (var i:int = 0; i<6; i++) {
//            item = new WOPapperBuyerItem(i, _wo);
//            item.source.x = 41 + (i%2)*178;
//            item.source.y = 58 + int(i/2)*150;
//            source.addChild(item.source);
//            _arrItems.push(item);
//        }

        var item:WOPapperItem;
        _arrItems = [];
        for (var i:int = 0; i<6; i++) {
            item = new WOPapperItem(i, _wo);
            item.source.x = 41 + (i%2)*178;
            item.source.y = 58 + int(i/2)*150;
            source.addChild(item.source);
            _arrItems.push(item);
        }
    }

    public function fillItems(ar:Array):void {
        for (var i:int=0; i< ar.length; i++) {
            if (ar[i].isBotBuy) _arrItems[i].fillItBot(ar[i]);
            else _arrItems[i].fillIt(ar[i]);
        }
    }

    public function get getScreenshot():Bitmap {
        var b:Bitmap = DrawToBitmap.drawToBitmap(source);
        return b;
    }

    public function deleteIt():void {
        _wo = null;
        for (var i:int=0; i<6; i++) {
            source.removeChild(_arrItems[i].source);
            _arrItems[i].deleteIt();
        }
        _arrItems.length = 0;
        source.removeChild(_bg);
        _bg.deleteIt();
        _bg = null;
        source.dispose();
        source = null;
    }

    public function updateAvatars():void {
        for (var i:int=0; i< _arrItems.length; i++) {
            if(!_arrItems[i].isBotBuy) _arrItems[i].updateAvatar();
        }
    }
}
}
