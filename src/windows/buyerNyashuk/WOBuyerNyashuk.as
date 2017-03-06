/**
 * Created by user on 12/15/16.
 */
package windows.buyerNyashuk {
import additional.buyerNyashuk.BuyerNyashuk;

import com.junkbyte.console.Cc;

import data.BuildType;

import data.DataMoney;

import flash.geom.Point;

import manager.ManagerFilters;

import quest.ManagerQuest;

import resourceItem.DropItem;

import starling.display.Image;
import starling.events.Event;
import starling.utils.Align;
import starling.utils.Color;

import ui.xpPanel.XPStar;

import utils.CButton;
import utils.CTextField;
import utils.MCScaler;

import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOBuyerNyashuk extends WindowMain{

    private var _woBG:WindowBackground;
    private var _data:Object;
    private var _nyashuk:BuyerNyashuk;
    private var _arrCTex:Array;

    public function WOBuyerNyashuk() {
        _windowType = WindowsManager.WO_SHOP;
        _woWidth = 550;
        _woHeight = 400;
        _arrCTex = [];
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('visitor_window_back'));
        im.x = -_woWidth/2 - 2.5;
        im.y = -_woHeight/2 - 7;
        _source.addChild(im);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;
        var btn:CButton = new CButton();
        btn.addButtonTexture(172, 45, CButton.GREEN, true);
        var txt:CTextField =  new CTextField(172,45,"Принять");
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        btn.addChild(txt);
        btn.x = 120;
        btn.y = _woHeight / 2 - 40;
        btn.clickCallback = onClickBuy;
        _source.addChild(btn);
        _arrCTex.push(btn);
        _arrCTex.push(txt);

        btn = new CButton();
        btn.addButtonTexture(172, 45, CButton.YELLOW, true);
        txt =  new CTextField(172,45,"Отказать");
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_YELLOW_COLOR);
        btn.addChild(txt);
        btn.clickCallback = onClickDelete;
        btn.x = - 120;
        btn.y = _woHeight / 2 - 40;
        _source.addChild(btn);
        _arrCTex.push(btn);
        _arrCTex.push(txt);
        txt =  new CTextField(_woWidth,_woHeight,"Покупатель");
        txt.setFormat(CTextField.BOLD30, 30, ManagerFilters.ORANGE_COLOR, Color.WHITE);
        txt.x = -_woWidth/2;
        txt.y = -_woHeight+50;
        _source.addChild(txt);
        _arrCTex.push(txt);
    }

    private function onClickExit(e:Event=null):void {
        super.hideIt();
    }

    override public function showItParams(callback:Function, params:Array):void {
        var im:Image;
        switch (params[0]) {
            case 1:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('nyash_blue'));
                im.x = 20;
                im.y = -20;
                _source.addChild(im);
                break;
            case 2:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('nyash_red'));
                im.x = 20;
                im.y = -20;
                _source.addChild(im);
                break;
        }
        _data = params[1];
        _nyashuk = params[2];
        fillItBot(_data);
        super.showIt();
    }

    public function fillItBot(ob:Object):void {
        if (!_data) {
            Cc.error('WOPapperItem fillItBot:: empty _data');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woPapperItem');
            return;
        }
        var dataResource:Object = {};
        var txt:CTextField =  new CTextField(172,45,"Здравствуйте!");
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        txt.x = -165;
        txt.y = -120;
        _source.addChild(txt);
        _arrCTex.push(txt);
        txt =  new CTextField(250,45,"Можете продать мне это?");
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        txt.x = -200;
        txt.y = -95;
        _source.addChild(txt);
        _arrCTex.push(txt);
        dataResource = g.allData.getResourceById(_data.resourceId);
     var im:Image;
        if (dataResource.buildType == BuildType.PLANT)
            im = new Image(g.allData.atlas['resourceAtlas'].getTexture(dataResource.imageShop + '_icon'));
        else
            im = new Image(g.allData.atlas[dataResource.url].getTexture(dataResource.imageShop));
        if (!im) {
            Cc.error('WOPapperItem fillItBot:: no such image: ' + dataResource.imageShop);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woPapperItem');
            return;
        }
        MCScaler.scale(im,70,70);
        im.x = -170;
        im.y = -60;
        _source.addChild(im);

        txt = new CTextField(40,40,"/" + _data.resourceCount);
        txt.x = - 135;
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        txt.alignH = Align.LEFT;
        _source.addChild(txt);
        _arrCTex.push(txt);
        txt = new CTextField(40,40,String(g.userInventory.getCountResourceById(_data.resourceId)));
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        if (g.userInventory.getCountResourceById(_data.resourceId) >= _data.resourceCount) txt.changeTextColor = ManagerFilters.LIGHT_GREEN_COLOR;
        else txt.changeTextColor = ManagerFilters.ORANGE_COLOR;
        txt.x = - 179;
        txt.alignH = Align.RIGHT;
        _source.addChild(txt);
        _arrCTex.push(txt);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('tutorial_arrow_pink'));
        MCScaler.scale(im, im.height -50, im.width -50);
        im.x = -95;
        im.y = -45;
        _source.addChild(im);

        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_small'));
        im.x = -20;
        im.y = -50;
        _source.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star_small'));
        im.x = -20;
        im.y = -10;
        _source.addChild(im);

        txt = new CTextField(40,40,_data.cost);
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        txt.y = -55;
        txt.x = 10;
        _source.addChild(txt);
        _arrCTex.push(txt);
        txt = new CTextField(40,40,_data.xp);
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        txt.x = 10;
        txt.y = -10;
        _source.addChild(txt);
        _arrCTex.push(txt);

    }

    private function onClickBuy(noResource:Boolean = false):void {
        var ob:Object = {};
        if (g.userInventory.getCountResourceById(_data.resourceId) < _data.resourceCount) {
            ob.data = g.allData.getResourceById(_data.resourceId);
            ob.count = _data.resourceCount - g.userInventory.getCountResourceById(_data.resourceId);
            ob.dataNyashuk = _data;
            super.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, onClickBuy, 'nyashuk', ob, _nyashuk);
            return;
        }
        if (!noResource && _data.type == BuildType.PLANT && g.userInventory.getCountResourceById(_data.resourceId) == _data.resourceCount &&  !g.userInventory.checkLastResource(_data.resourceId)) {
            super.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_LAST_RESOURCE, onClickBuy, _data, 'nyashuk', _nyashuk);
            return;
        }
        ob.id = DataMoney.SOFT_CURRENCY;
        ob.count = _data.cost;
        new DropItem(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2,ob);
        _data.visible = false;
        new XPStar(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2., 5);
        g.userInventory.addResource(_data.resourceId,-_data.resourceCount);
        g.directServer.updateUserPapperBuy(_data.buyerId,0,0,0,0,0,0);
        if (_data.buyerId == 1) g.userTimer.buyerNyashukBlue(1200);
        else  g.userTimer.buyerNyashukRed(1200);
        g.managerBuyerNyashuk.onReleaseOrder(_nyashuk,false);
        g.managerQuest.onActionForTaskType(ManagerQuest.NIASH_BUYER);
        super.hideIt();
    }

    private function onClickDelete():void {
        g.managerBuyerNyashuk.onReleaseOrder(_nyashuk,false);
        if (_data.buyerId == 1) g.userTimer.buyerNyashukBlue(1200);
        else  g.userTimer.buyerNyashukRed(1200);
        _data.timeToNext = int(new Date().getTime()/1000);
        g.directServer.updateUserPapperBuy(_data.buyerId,0,0,0,0,0,0);
        super.hideIt();
    }

    override protected function deleteIt():void {
        _data = null;
        _nyashuk = null;
        for (var i:int = 0; i <_arrCTex.length; i++) {
            if (_arrCTex[i])_arrCTex[i].deleteIt();
            _arrCTex[i] = null;
        }
        super.deleteIt();
    }
}
}
