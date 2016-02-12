/**
 * Created by user on 7/24/15.
 */
package windows.paperWindow {
import data.DataMoney;

import flash.utils.getTimer;

import manager.ManagerFilters;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import user.Someone;

import utils.CButton;
import utils.CSprite;
import utils.MCScaler;

import windows.WOComponents.WOButtonTexture;
import windows.Window;

public class WOPaper extends Window{
    private var _btnRefreshGreen:CButton;
    private var _btnRefreshBlue:CButton;
    private var _arrPaper:Array;
    private var _leftPage:WOPaperPage;
    private var _rightPage:WOPaperPage;
    private var _shiftPages:int;
    private var _maxPages:int;
    private var _leftArrow:CButton;
    private var _rightArrow:CButton;
    private var _tempLeftPage:WOPaperPage;
    private var _tempRightPage:WOPaperPage;
    private var _flipPage:WOPaperFlipPage;
    private var _timer:int;
    private var _txtTimer:TextField;

    public function WOPaper() {
        _woWidth = 842;
        _woHeight = 526;
        _shiftPages = 1;
        var im:Image;

        _btnRefreshGreen = new CButton();
        _btnRefreshGreen.addButtonTexture(130, 40, CButton.GREEN, true);
        var txt:TextField = new TextField(100, 40, "Обновить 1", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        txt.x = 2;
        _btnRefreshGreen.addChild(txt);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
        MCScaler.scale(im, 25, 25);
        im.x = 100;
        im.y = 8;
        _btnRefreshGreen.addChild(im);
        im.filter = ManagerFilters.SHADOW_TINY;
        _btnRefreshGreen.x = 360;
        _btnRefreshGreen.y = 290;
        _source.addChild(_btnRefreshGreen);
        _btnRefreshGreen.clickCallback = makeRefresh;
        createBtns();
        createExitButton(onClickExit);
        _btnExit.x += 30;
        _btnExit.y -= 25;
        _btnRefreshBlue = new CButton();
        _btnRefreshBlue.addButtonTexture(130,40, CButton.BLUE, true);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('refresh_icon'));
        im.x = 5;
        im.y = 5;
        _txtTimer = new TextField(100,30,'',g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _txtTimer.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _btnRefreshBlue.addChild(im);
        _btnRefreshBlue.addChild(_txtTimer);
        _btnRefreshBlue.x = 220;
        _btnRefreshBlue.y = 290;
        _btnRefreshBlue.setEnabled = false;
        _btnRefreshBlue.clickCallback = onRefresh;
        callbackClickBG = onClickExit;
        timerRefresh();
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
        checkArrows();
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
//        _source.addChildAt(_leftPage.source,0);
//        _source.addChildAt(_rightPage.source,0);
        _source.addChild(_rightPage.source);
        _source.addChild(_btnRefreshBlue);

        var arr:Array = _arrPaper.slice((_shiftPages - 1)*6, (_shiftPages - 1)*6 + 6);
        _leftPage.fillItems(arr);
        arr = _arrPaper.slice(_shiftPages*6, _shiftPages*6 + 6);
        _rightPage.fillItems(arr);
        checkSocialInfoForArray(_arrPaper.slice((_shiftPages - 1)*6, _shiftPages*6 + 6));

        _source.setChildIndex(_btnExit, _source.numChildren - 1);
    }

    private function createBtns():void {
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left'));
        _leftArrow = new CButton();
        _leftArrow.addDisplayObject(im);
        _leftArrow.x = -_woWidth/2 - 50 ;//+ _leftArrow.width/2;
        _leftArrow.y = -_woHeight/2 + 240;
        _source.addChild(_leftArrow);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left'));
        im.scaleX = -1;
        im.x = im.width;
        _rightArrow = new CButton();
        _rightArrow.addDisplayObject(im);
        _rightArrow.x = 390 + 57 - _leftArrow.width/2;
        _rightArrow.y = -_woHeight/2 + 240;
        _source.addChild(_rightArrow);
        _leftArrow.clickCallback = movePrev;
        _rightArrow.clickCallback = moveNext;
    }

    private var _isAnim:Boolean = false;
    private function moveNext():void {
        checkArrows();
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
        _source.setChildIndex(_btnExit, _source.numChildren - 1);
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
        _source.setChildIndex(_btnExit, _source.numChildren - 1);
    }

    private function movePrev():void {
        checkArrows();
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
        _source.setChildIndex(_btnExit, _source.numChildren - 1);
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
        _source.setChildIndex(_btnExit, _source.numChildren - 1);
    }

    private function makeRefresh():void {
        if (1 > g.user.hardCurrency){
            g.woBuyCurrency.showItMenu(true);
            return;
        }
        g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -1);
        g.directServer.updateUserTimePaper(onUpdateUserTimePaper);
        _timer = 900;
        g.gameDispatcher.addToTimer(renderPaperProgress);
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

    private function checkArrows():void {
        if (_shiftPages <= 1) {
            _leftArrow.setEnabled = false;
        } else {
            _leftArrow.setEnabled = true;
        }
        if (_shiftPages + 1>= _maxPages) {
            _rightArrow.setEnabled = false;
        } else {
            _rightArrow.setEnabled = true;
        }
    }
    private function timerRefresh():void {
        var time:Number = getTimer();
        var TimeC:int = time/10;
        var timeeee:int = g.user.timePaper/10;
        _timer = g.user.timePaper - time;
        if (_timer <= 900) {
            _btnRefreshBlue.setEnabled = true;
            _btnRefreshGreen.setEnabled = false;
            _txtTimer.text = 'Обновить';
        } else {
            g.gameDispatcher.addToTimer(renderPaperProgress);
        }
    }

    private function renderPaperProgress():void {
        _timer--;
        _txtTimer.text = String(_timer);
        if (_timer <= 0) {
            _btnRefreshBlue.setEnabled = true;
            _btnRefreshGreen.setEnabled = false;
            _txtTimer.text = 'Обновить';
            g.gameDispatcher.removeFromTimer(renderPaperProgress);
            g.directServer.updateUserTimePaper(onUpdateUserTimePaper);
        }
    }

    private function onRefresh():void {
        g.directServer.getPaperItems(fillAfterRefresh);
        _timer = 900;
        g.gameDispatcher.addToTimer(renderPaperProgress);
        g.directServer.updateUserTimePaper(onUpdateUserTimePaper);
        _btnRefreshBlue.setEnabled = false;
        _btnRefreshGreen.setEnabled = true;
    }

    private function onUpdateUserTimePaper(b:Boolean = true):void {}

}
}
