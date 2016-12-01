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
    private var _birka:Birka;
    private var _cont:Sprite;
    private var _btnGet:CButton;
    private var _arrayItem:Array;
    private var _sprItem:Sprite;
    private var _itemToday:Object;
    private var _point:Point;

    public function WODailyGift() {
        super();
        _windowType = WindowsManager.WO_DAILY_GIFT;
        _woHeight = 630;
        _woWidth = 900;
        _sprItem = new Sprite();

        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        _birka = new Birka('НА нахуй', _source, _woWidth, _woHeight);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;
        _cont = new Sprite();
        _source.addChild(_cont);
        var c:CartonBackground = new CartonBackground(800, 530);
        c.x = -_woWidth/2 + 50;
        c.y = -_woHeight/2 + 50 ;
        _cont.filter = ManagerFilters.SHADOW;
        _cont.addChild(c);
        _btnGet = new CButton();
        _btnGet.addButtonTexture(140,40,CButton.GREEN,true);
        var _txt:CTextField = new CTextField(140,40,'Получить');
        _txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _btnGet.addChild(_txt);
        _btnGet.y = 280;
        _source.addChild(_btnGet);
        _btnGet.clickCallback = onClick;
        _txt = new CTextField(680, 340, "Ежедневный подарок");
        _txt.setFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txt.x = -350;
        _txt.y = -400;
        _source.addChild(_txt);

        _txt = new CTextField(600,40, "Заходите каждый день что бы получить новую награду");
        _txt.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txt.x = -300;
        _txt.y = -215;
        _source.addChild(_txt);
        _itemToday = {};
    }

    override public function showItParams(callback:Function, params:Array):void {
        _arrayItem = [];
        _arrayItem = params[0];
        var source:Sprite;
        var day:int = 24 * 60 * 60 * 1000;
        var yesterday:Date = new Date();
        var yesterdayDailyGift:Date = new Date(g.user.dayDailyGift * 1000);
        yesterday.setTime(yesterday.getTime() - day);
        g.user.countDailyGift++;
        if (g.user.countDailyGift > 15) {
            g.user.countDailyGift = 1;
        }

        if (yesterday.date != yesterdayDailyGift.date) {
            g.user.countDailyGift = 1;
        }
        for (var i:int = 0; i < _arrayItem.length; i++) {
            source = new Sprite();
            source.x = (i % 5) * 135;
            source.y = int(i / 5) * 135;
            createItem(_arrayItem[i].resource_id, _arrayItem[i].type, _arrayItem[i].count, source, i);
            _sprItem.addChild(source);
        }
        _sprItem.x = -340;
        _sprItem.y = -160;
        _source.addChild(_sprItem);
        super.showIt();
    }

    private function onClickExit(e:Event = null):void {
        g.directServer.updateDailyGift(g.user.countDailyGift);
        if (int(_itemToday.type) == BuildType.DECOR || int(_itemToday.type) == BuildType.DECOR_ANIMATION) flyItDecor();
        else new DropItem(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2, _itemToday);
        hideIt();
    }

    override protected function deleteIt():void {
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
            im = new Image(g.allData.atlas['instrumentAtlas'].getTexture(g.dataResource.objectResources[id].imageShop));
            MCScaler.scale(im,im.height-10,im.width-10);
            im.pivotX = im.width/2;
            im.pivotY = im.height/2;
            im.x = bg.width/2 - 5;
            im.y = bg.width/2;
            type = DropResourceVariaty.DROP_TYPE_RESOURSE;
        } else if (int(type) == BuildType.DECOR) {
            im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.dataBuilding.objectBuilding[id].image+ '_icon'));
            MCScaler.scale(im,im.height-60,im.width-60);
//            im.scale = 100;
            im.pivotX = im.width/2;
            im.pivotY = im.height/2;
            im.x = bg.width/2 - 20;
            im.y = bg.width/2 - 20;
        } else if (int(type) == BuildType.DECOR_ANIMATION) {
            im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.dataBuilding.objectBuilding[id].url+ '_icon'));
            MCScaler.scale(im,im.height-60,im.width-60);
//            im.scale = 100;
            im.pivotX = im.width/2;
            im.pivotY = im.height/2;
            im.x = bg.width/2 - 20;
            im.y = bg.width/2 - 20;
        }
        source.addChild(im);
        var txt = new CTextField(130,40, "День " + (number+1));
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.y = -5;
        source.addChild(txt);
        txt = new CTextField(130,30, String(count));
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.y = 95;
        source.addChild(txt);
        if (number < g.user.countDailyGift-1) {
            source.filter = ManagerFilters.SHADOW_LIGHT;
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
        if (int(_itemToday.type) == BuildType.DECOR) im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.dataBuilding.objectBuilding[_itemToday.id].image + '_icon'));
        else if (int(_itemToday.type) == BuildType.DECOR_ANIMATION) im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.dataBuilding.objectBuilding[_itemToday.id].url + '_icon'));
        new TweenMax(im, v, {scaleX:.3, scaleY:.3, ease:Back.easeIn, onComplete:f});
    }

}
}
