/**
 * Created by user on 7/24/15.
 */
package windows.paperWindow {
import data.DataMoney;

import flash.filters.GlowFilter;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import user.Someone;

import utils.CSprite;
import utils.MCScaler;

import windows.WOComponents.WOButtonTexture;

import windows.Window;

public class WOPaper extends Window{
    private var _btnRefresh:CSprite;
    private var _arrPaper:Array;
    private var _leftPage:WOPaperPage;
    private var _rightPage:WOPaperPage;
    private var _shiftPages:int;
    private var _maxPages:int;
    private var _leftArrow:CSprite;
    private var _rightArrow:CSprite;
    private var _tempLeftPage:WOPaperPage;
    private var _tempRightPage:WOPaperPage;
    private var _flipPage:WOPaperFlipPage;

    public function WOPaper() {
        _woWidth = 842;
        _woHeight = 526;
        _shiftPages = 1;

        _btnRefresh = new CSprite();
        var btnT:Sprite = new WOButtonTexture(130, 40, WOButtonTexture.GREEN);
        _btnRefresh.addChild(btnT);
        var txt:TextField = new TextField(100, 40, "Обновить 1", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        txt.nativeFilters = [new GlowFilter(0x2d610d, 1, 3, 3, 5.0)];
        txt.x = 2;
        _btnRefresh.addChild(txt);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
        MCScaler.scale(im, 25, 25);
        im.x = 100;
        im.y = 8;
        _btnRefresh.addChild(im);
        _btnRefresh.x = 285;
        _btnRefresh.y = 270;
        _source.addChild(_btnRefresh);
        _btnRefresh.endClickCallback = makeRefresh;
        createBtns();

        callbackClickBG = onClickExit;
    }

    private function onClickExit():void {
        _leftPage.deleteIt();
        _rightPage.deleteIt();
        _source.removeChild(_leftPage.source);
        _source.removeChild(_rightPage.source);
        _leftPage = null;
        _rightPage = null;
        hideIt();
    }

    public function showItMenu():void {
        _arrPaper = g.managerPaper.arr;
        if (_arrPaper.length > 60) _arrPaper.length = 60;
        _maxPages = Math.ceil(_arrPaper.length/6);
        if (_maxPages <2) _maxPages = 2;

        createPages();
        showIt();
    }

    private function createPages():void {
        _leftPage = new WOPaperPage(_shiftPages, _maxPages, WOPaperPage.LEFT_SIDE);
        _rightPage = new WOPaperPage(_shiftPages + 1, _maxPages, WOPaperPage.RIGHT_SIDE);
        _leftPage.source.x = -_woWidth/2;
        _leftPage.source.y = -_woHeight/2;
        _rightPage.source.x = 0;
        _rightPage.source.y = -_woHeight/2;
        _source.addChild(_leftPage.source);
        _source.addChild(_rightPage.source);

        var arr:Array = _arrPaper.slice((_shiftPages - 1)*6, (_shiftPages - 1)*6 + 6);
        _leftPage.fillItems(arr);
        arr = _arrPaper.slice(_shiftPages*6, _shiftPages*6 + 6);
        _rightPage.fillItems(arr);
        checkSocialInfoForArray(_arrPaper.slice((_shiftPages - 1)*6, _shiftPages*6 + 6));
    }

    private function createBtns():void {
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friends_panel_ar'));
        _leftArrow = new CSprite();
        _leftArrow.addChild(im);
        _leftArrow.x = -_woWidth/2 + 12 - 50;
        _leftArrow.y = -_woHeight/2 + 240;
        _source.addChild(_leftArrow);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friends_panel_ar'));
        im.scaleX = -1;
        im.x = im.width;
        _rightArrow = new CSprite();
        _rightArrow.addChild(im);
        _rightArrow.x = 386 + 50;
        _rightArrow.y = -_woHeight/2 + 240;
        _source.addChild(_rightArrow);
        _leftArrow.endClickCallback = movePrev;
        _rightArrow.endClickCallback = moveNext;
    }

    private var _isAnim:Boolean = false;
    private function moveNext():void {
        if (_isAnim) return;
        if (_shiftPages + 1>= _maxPages) return;
        _tempLeftPage = new WOPaperPage(_shiftPages + 2, _maxPages, WOPaperPage.LEFT_SIDE);
        _tempRightPage = new WOPaperPage(_shiftPages + 3, _maxPages, WOPaperPage.RIGHT_SIDE);
        var arr:Array = _arrPaper.slice((_shiftPages + 1)*6, (_shiftPages + 1)*6 + 6);
        _tempLeftPage.fillItems(arr);
        arr = _arrPaper.slice((_shiftPages+2)*6, (_shiftPages+2)*6 + 6);
        _tempRightPage.fillItems(arr);
        _isAnim = true;
        _flipPage = new WOPaperFlipPage(_rightPage.getScreenshot, _tempLeftPage.getScreenshot, true, afterMoveNext);
        _flipPage.y = 28;
        _source.removeChild(_rightPage.source);
        _rightPage.deleteIt();
        _rightPage = null;
        _tempRightPage.source.y = -_woHeight/2;
        _source.addChild(_tempRightPage.source);
        _source.addChild(_flipPage);
    }

    private function afterMoveNext():void {
        _shiftPages +=2;
        _source.removeChild(_flipPage);
        _flipPage = null;
        _source.removeChild(_leftPage.source);
        _leftPage.deleteIt();
        _leftPage = _tempLeftPage;
        _tempLeftPage = null;
        _leftPage.source.x = -_woWidth/2;
        _leftPage.source.y = -_woHeight/2;
        _source.addChild(_leftPage.source);
        _rightPage = _tempRightPage;
        _tempRightPage = null;
        _isAnim = false;
    }

    private function movePrev():void {
        if (_isAnim) return;
        if (_shiftPages <= 1) return;
        _tempLeftPage = new WOPaperPage(_shiftPages - 2, _maxPages, WOPaperPage.LEFT_SIDE);
        _tempRightPage = new WOPaperPage(_shiftPages - 1, _maxPages, WOPaperPage.RIGHT_SIDE);
        var arr:Array = _arrPaper.slice((_shiftPages - 1)*6, (_shiftPages - 1)*6 + 6);
        _tempLeftPage.fillItems(arr);
        arr = _arrPaper.slice((_shiftPages)*6, (_shiftPages)*6 + 6);
        _tempRightPage.fillItems(arr);
        _isAnim = true;
        _flipPage = new WOPaperFlipPage(_leftPage.getScreenshot, _tempRightPage.getScreenshot, false, afterMovePrev);
        _flipPage.y = 28;
        _source.removeChild(_leftPage.source);
        _leftPage.deleteIt();
        _leftPage = null;
        _tempLeftPage.source.x = -_woWidth/2;
        _tempLeftPage.source.y = -_woHeight/2;
        _source.addChild(_tempLeftPage.source);
        _source.addChild(_flipPage);
    }

    private function afterMovePrev():void {
        _shiftPages -=2;
        _source.removeChild(_flipPage);
        _flipPage = null;
        _source.removeChild(_rightPage.source);
        _rightPage.deleteIt();
        _rightPage = _tempRightPage;
        _tempRightPage = null;
        _rightPage.source.y = -_woHeight/2;
        _source.addChild(_rightPage.source);
        _leftPage = _tempLeftPage;
        _tempLeftPage = null;
        _isAnim = false;
    }

    private function makeRefresh():void {
        if (1 > g.user.hardCurrency){
            g.woBuyCurrency.showItMenu(true);
            return;
        }
        g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -1);
        g.directServer.getPaperItems(fillAfterRefresh);
    }

    private function checkSocialInfoForArray(ar:Array):void {
        var userIds:Array = [];
        var p:Someone;
        for (var i:int=0; i<ar.length; i++) {
            p = g.user.getSomeoneBySocialId(ar[i].userSocialId);
            if (!p.photo) userIds.push(ar[i].userSocialId);
        }
        if (userIds.length) {
            g.socialNetwork.getTempUsersInfoById(userIds, onGettingInfo);
        }
    }

    private function onGettingInfo(ar:Array):void {
        if (_leftPage) _leftPage.updateAvatars();
        if (_rightPage) _rightPage.updateAvatars();
    }

    private function fillAfterRefresh():void {
        _shiftPages = 1;
        _leftPage.deleteIt();
        _source.removeChild(_leftPage.source);
        _leftPage = null;
        _rightPage.deleteIt();
        _source.removeChild(_rightPage.source);
        _rightPage = null;
        _arrPaper = [];
        _arrPaper = g.managerPaper.arr;
        if (_arrPaper.length > 60) _arrPaper.length = 60;
        _maxPages = Math.ceil(_arrPaper.length/6);
        if (_maxPages <2) _maxPages = 2;

        createPages();
    }
}
}
