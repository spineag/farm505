/**
 * Created by user on 11/30/16.
 */
package windows.dailyGiftWindow {
import com.greensock.TweenMax;
import com.greensock.easing.Back;

import data.BuildType;
import data.DataMoney;

import flash.display.StageDisplayState;

import flash.geom.Point;

import manager.ManagerFilters;

import resourceItem.DropItem;

import starling.core.Starling;

import starling.display.Image;

import starling.display.Sprite;

import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import temp.DropResourceVariaty;

import user.User;

import utils.CButton;
import utils.CTextField;
import utils.MCScaler;

import windows.WOComponents.Birka;
import windows.WOComponents.CartonBackground;
import windows.WOComponents.CartonBackgroundIn;
import windows.WOComponents.WindowBackground;

import windows.WindowMain;
import windows.WindowsManager;

public class WODailyGift extends WindowMain {
    private var _woBG:WindowBackground;
    private var _cont:Sprite;
    private var _btnGet:CButton;
    private var _arrayItem:Array;
    private var _sprItem:Sprite;
    private var _itemToday:Object;
    private var _point:Point;
    private var _arrCTex:Array;

    public function WODailyGift() {
        super();
        _windowType = WindowsManager.WO_DAILY_GIFT;
        _woHeight = 550;
        _woWidth = 800;
        _sprItem = new Sprite();
        _arrCTex = [];

        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        _cont = new Sprite();
        _source.addChild(_cont);
        var c:CartonBackground = new CartonBackground(735, 485);
        c.x = -_woWidth/2 + 30;
        c.y = -_woHeight/2 + 30 ;
        _cont.filter = ManagerFilters.SHADOW;
        _cont.addChild(c);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;
        _btnGet = new CButton();
        _btnGet.addButtonTexture(160,40,CButton.GREEN,true);
        var _txt:CTextField = new CTextField(160,40,String(g.managerLanguage.allTexts[437]));
        _txt.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _btnGet.addChild(_txt);
        _btnGet.y = 270;
        _source.addChild(_btnGet);
        _btnGet.clickCallback = onClick;
        _txt = new CTextField(680, 340, String(g.managerLanguage.allTexts[438]));
        _txt.setFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txt.x = -350;
        _txt.y = -393;
        _source.addChild(_txt);
        _arrCTex.push(_txt);

        _txt = new CTextField(600,40, String(g.managerLanguage.allTexts[439]));
        _txt.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txt.x = -300;
        _txt.y = -208;
        _source.addChild(_txt);
        _arrCTex.push(_txt);
        _itemToday = {};
    }

    override public function showItParams(callback:Function, params:Array):void {
        _arrayItem = [];
        _arrayItem = params[0];
        var source:Sprite;
        var day:int = 24 * 60 * 60 * 1000;
//        var yesterday:Date = new Date();
//        var yesterdayDailyGift:Date = new Date(g.user.dayDailyGift * 1000);
//        yesterday.setTime(yesterday.getTime() - day);
        g.user.countDailyGift++;
        if (g.user.countDailyGift > 15) {
            g.user.countDailyGift = 1;
        }
//
//        if (yesterday.date != yesterdayDailyGift.date) {
//            g.user.countDailyGift = 1;
//        }
        for (var i:int = 0; i < _arrayItem.length; i++) {
            source = new Sprite();
            source.x = (i % 5) * 135;
            source.y = int(i / 5) * 135;
            createItem(_arrayItem[i].resource_id, _arrayItem[i].type, _arrayItem[i].count, source, i);
            _sprItem.addChild(source);
        }
        _sprItem.x = -340;
        _sprItem.y = -168;
        _source.addChild(_sprItem);
        super.showIt();
    }
    override public function hideIt():void {
        g.managerCats.helloCats();
        if (g.userTimer.partyToEndTimer > 0 && g.managerParty.eventOn && g.managerParty.levelToStart <= g.user.level) {
            g.windowsManager.openWindow(WindowsManager.WO_PARTY,null);
        }
        else if (g.userTimer.partyToEndTimer < 0 && !g.managerParty.userParty.showWindow) g.managerParty.endPartyWindow();
        super.hideIt();
    }

    private function onClickExit(e:Event = null):void {
        g.directServer.updateDailyGift(g.user.countDailyGift);
        if (int(_itemToday.type) == BuildType.DECOR || int(_itemToday.type) == BuildType.DECOR_ANIMATION) flyItDecor();
        else new DropItem(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2, _itemToday);
        hideIt();
    }

    override protected function deleteIt():void {
        for (var i:int = 0; i<_arrCTex.length; i++) {
            _arrCTex[i].deleteIt();
            _arrCTex[i] = null;
        }
        super.deleteIt();
    }

    private function createItem(id:int, type:String, count:int, source:Sprite, number:int):void {
        var bg:CartonBackgroundIn = new CartonBackgroundIn(130, 130);
        source.addChild(bg);
        var im:Image;

        if (id == 1 && type == '1') {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_icon'));
            MCScaler.scale(im,im.height-20,im.width-20);
            im.pivotX = im.width/2;
            im.pivotY = im.height/2;
            im.x = bg.width/2 - 10;
            im.y = bg.width/2;
            id = DataMoney.HARD_CURRENCY;
            type = DropResourceVariaty.DROP_TYPE_MONEY;

        } else if (id == 2 && type == '2') {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_icon'));
            MCScaler.scale(im,im.height-20,im.width-20);
            im.pivotX = im.width/2;
            im.pivotY = im.height/2;
            im.x = bg.width/2 - 10;
            im.y = bg.width/2;
            id = DataMoney.SOFT_CURRENCY;
            type = DropResourceVariaty.DROP_TYPE_MONEY;
        } else if (int(type) == BuildType.INSTRUMENT) {
            im = new Image(g.allData.atlas['instrumentAtlas'].getTexture(g.allData.getResourceById(id).imageShop));
            MCScaler.scale(im,im.height-10,im.width-10);
            im.pivotX = im.width/2;
            im.pivotY = im.height/2;
            im.x = bg.width/2 - 5;
            im.y = bg.width/2;
            type = DropResourceVariaty.DROP_TYPE_RESOURSE;
        } else if (int(type) == BuildType.DECOR) {
            im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.allData.getBuildingById(id).image+ '_icon'));
            MCScaler.scale(im,im.height-60,im.width-60);
//            im.scale = 100;
            im.pivotX = im.width/2;
            im.pivotY = im.height/2;
            im.x = bg.width/2 - 20;
            im.y = bg.width/2 - 20;
        } else if (int(type) == BuildType.DECOR_ANIMATION) {
            im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.allData.getBuildingById(id).url+ '_icon'));
            MCScaler.scale(im,im.height-60,im.width-60);
//            im.scale = 100;
            im.pivotX = im.width/2;
            im.pivotY = im.height/2;
            im.x = bg.width/2 - 20;
            im.y = bg.width/2 - 20;
        }
        source.addChild(im);
        var txt:CTextField = new CTextField(130,40, String(g.managerLanguage.allTexts[440]) + " " + (number+1));
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.y = -5;
        source.addChild(txt);
        _arrCTex.push(txt);
        txt = new CTextField(130,30, String(count));
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.y = 95;
        source.addChild(txt);
        _arrCTex.push(txt);
        if (number < g.user.countDailyGift-1) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check_big'));
            MCScaler.scale(im,im.height-20,im.width-20);
            im.x = 35;
            im.y = 35;
            source.addChild(im);
            source.alpha = .5;
        }

        if (number == g.user.countDailyGift-1) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check_big'));
            MCScaler.scale(im,im.height-20,im.width-20);
            im.x = 35;
            im.y = 35;
            source.addChild(im);
            _itemToday.id = id;
            _itemToday.type = type;
            _itemToday.count = count;
            _point = new Point(source.x, source.y);
            _point = source.localToGlobal(_point);

        }

    }

    private function onClick():void {
        g.directServer.updateDailyGift(g.user.countDailyGift);
        if (int(_itemToday.type) == BuildType.DECOR || int(_itemToday.type) == BuildType.DECOR_ANIMATION) flyItDecor();
        else new DropItem(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2, _itemToday);
        hideIt();

    }

    private function flyItDecor():void {
        var f1:Function = function (dbId:int):void {
            g.userInventory.addToDecorInventory(_itemToday.id, dbId);
            deleteIt();
        };
        var f:Function = function ():void {
            g.directServer.buyAndAddToInventory(_itemToday.id, f1);
        };
        var v:Number;
        if (Starling.current.nativeStage.displayState == StageDisplayState.NORMAL) v = .5;
        else v = .2;
        var im:Image;
        if (int(_itemToday.type) == BuildType.DECOR) im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.allData.getBuildingById(_itemToday.id).image + '_icon'));
        else if (int(_itemToday.type) == BuildType.DECOR_ANIMATION) im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.allData.getBuildingById(_itemToday.id).url + '_icon'));
        new TweenMax(im, v, {scaleX:.3, scaleY:.3, ease:Back.easeIn, onComplete:f});
    }

}
}
