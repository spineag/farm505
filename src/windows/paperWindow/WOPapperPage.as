/**
 * Created by user on 11/18/15.
 */
package windows.paperWindow {
import flash.display.Bitmap;
import manager.ManagerFilters;
import manager.Vars;

import starling.core.Starling;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Align;
import starling.utils.Color;
import utils.CSprite;
import utils.CTextField;
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
    private var _txtPage:CTextField;
    private var _txtTitle:CTextField;
    private var _woHeight:int;
    private var g:Vars = Vars.getInstance();

    public function WOPapperPage(numberPage:int, maxNumberPage:int, side:String, wo:WOPapper) {
        _wo = wo;
        source = new Sprite();
        _side = side;
        _woHeight = 545;
        createBG(numberPage, maxNumberPage);
        createItems();
    }

    public function updateTextField():void {
        _txtPage.updateIt();
        _txtTitle.updateIt();
        for (var i:int=0; i<_arrItems.length; i++) {
            _arrItems[i].updateTextField();       
        }
    }

    private function createBG(n:int, nMax:int):void {
        _bg = new CSprite();
        var im:Image;
        var sp:Sprite = new Sprite();
//        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('newspaper_p1'));
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('bottom_newspaper'));
        im.y = _woHeight - im.height;
        sp.addChild(im);

        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('top_newspaper'));
        sp.addChild(im);

        for (var i:int = 0; i < 92; i++) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('centre_newspaper'));
            im.y = 30 + (i * 5);
            sp.addChild(im);
        }

        _quad = new Quad(sp.width, sp.height,Color.WHITE);
        _quad.alpha = 0;
        source.addChild(_quad);
        sp.touchable = false;
        if (_side == RIGHT_SIDE) {
            sp.scaleX = -1;
            sp.x = sp.width;
        }
        _bg.addChild(sp);
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
        _txtTitle = new CTextField(300, 100, "НьюсМяу");
        _txtTitle.setFormat(CTextField.BOLD30, 26, ManagerFilters.BLUE_COLOR);
        _txtTitle.alignH = Align.LEFT;
        _txtTitle.x = 66;
        _txtTitle.y = -23;
        _bg.addChild(_txtTitle);
        if (n <= nMax) {
//            trace(n + ' n');
//            trace(nMax + ' nMax');
            _txtPage = new CTextField(100, 100, String(n) + '/' + String(nMax));
            _txtPage.setFormat(CTextField.BOLD24, 20, ManagerFilters.BROWN_COLOR);
            if (n > nMax) {
                _txtPage.text = '';
                _txtPage.updateIt();
            }
            _txtPage.x = 170;
            _txtPage.y = 460;
            _bg.addChild(_txtPage);
        }
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
            if (ar[i].isBotBuy) (_arrItems[i] as WOPapperItem).fillItBot(ar[i]);
            else (_arrItems[i] as WOPapperItem).fillIt(ar[i]);
        }
    }

    public function get getScreenshot():Texture {
        var b:Texture = DrawToBitmap.getTextureFromStarlingDisplayObject(source);
        return b;
    }

    public function deleteIt():void {
        _wo = null;
        for (var i:int=0; i<6; i++) {
            source.removeChild(_arrItems[i].source);
            _arrItems[i].deleteIt();
        }
        if (_txtTitle) {
            _bg.removeChild(_txtTitle);
            _txtTitle.deleteIt();
            _txtTitle = null;
        }
        if (_txtPage) {
            _bg.removeChild(_txtPage);
            _txtPage.deleteIt();
            _txtPage = null;
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
            if(!_arrItems[i].isBotBuy) (_arrItems[i] as WOPapperItem).updateAvatar();
        }
    }

    public function get arrItems():Array {
        return _arrItems;
    }
}
}
