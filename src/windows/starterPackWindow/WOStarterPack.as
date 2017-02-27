/**
 * Created by user on 12/28/16.
 */
package windows.starterPackWindow {
import analytic.AnalyticManager;

import com.greensock.TweenMax;
import com.greensock.easing.Back;
import com.junkbyte.console.Cc;

import data.BuildType;
import data.DataMoney;

import flash.display.Bitmap;
import flash.display.StageDisplayState;
import flash.geom.Point;

import manager.ManagerFilters;

import manager.Vars;

import resourceItem.DropItem;

import social.SocialNetworkEvent;

import social.SocialNetworkSwitch;

import starling.core.Starling;


import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;

import starling.textures.Texture;
import starling.utils.Align;
import starling.utils.Color;

import temp.DropResourceVariaty;

import utils.CButton;
import utils.CTextField;
import utils.MCScaler;

import windows.WindowMain;
import windows.WindowsManager;

public class WOStarterPack extends WindowMain{
    private var _data:Object;
    private var _decorSpr:Sprite;
    private var _arrCTex:Array;

    public function WOStarterPack() {
        super();
        _decorSpr = new Sprite();
        _arrCTex = [];
        _woHeight = 538;
        _woWidth = 732;
        _windowType = WindowsManager.WO_STARTER_PACK;
        g.directServer.getStarterPack(callbackServer);
    }

    private function onLoad(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + 'qui/sp_back_empty.png'].create() as Bitmap;
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        var image:Image = new Image(tex);
        image.pivotX = image.width/2;
        image.pivotY = image.height/2;
        _source.addChild(image);
        createExitButton(hideIt);
        createWindow();
    }

    private function callbackServer(ob:Object):void {
        _data = ob;
        g.load.loadImage(g.dataPath.getGraphicsPath() + 'qui/sp_back_empty.png',onLoad);
    }

    private function createWindow():void {
        var txt:CTextField;
        var im:Image;

        txt = new CTextField(500, 70, 'Уникальное предложение');
        txt.setFormat(CTextField.BOLD30, 35, Color.RED, Color.WHITE);
        txt.alignH = Align.LEFT;
        txt.x = -190;
        txt.y = -250;
        _source.addChild(txt);
        _arrCTex.push(txt);

        txt = new CTextField(77, 40, String(_data.soft_count));
        txt.setFormat(CTextField.BOLD24, 28, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.alignH = Align.LEFT;
        txt.x = -155 - txt.textBounds.width/2 ;
        txt.y = -40;
        _source.addChild(txt);
        _arrCTex.push(txt);

        txt = new CTextField(50, 40, String(_data.hard_count));
        txt.setFormat(CTextField.BOLD24, 28, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.alignH = Align.LEFT;
        txt.x = 25 - txt.textBounds.width/2 ;
//        txt.x = -17;
        txt.y = -40;
        _source.addChild(txt);
        _arrCTex.push(txt);

        txt = new CTextField(90, 50, 'Монеты');
        txt.setFormat(CTextField.BOLD30, 28, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.x = -200;
        txt.y = -170;
        _source.addChild(txt);
        _arrCTex.push(txt);

        txt = new CTextField(90, 50, "Рубины");
        txt.setFormat(CTextField.BOLD30, 28, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.y = -170;
        txt.x = -20;
        _source.addChild(txt);
        _arrCTex.push(txt);

        txt = new CTextField(77, 40, "Бонус");
        txt.setFormat(CTextField.BOLD30, 28, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.x = 175;
        txt.y = -170;
        _source.addChild(txt);
        _arrCTex.push(txt);

        if (_data.object_type == BuildType.RESOURCE || _data.object_type == BuildType.INSTRUMENT || _data.object_type == BuildType.PLANT) {
            im = new Image(g.allData.atlas[g.allData.resource[_data.object_id].url].getTexture(g.allData.resource[_data.object_id].imageShop));
            txt = new CTextField(120, 40, String(_data.object_count));
            txt.setFormat(CTextField.BOLD30, 28, Color.WHITE, ManagerFilters.BLUE_COLOR);
            txt.alignH = Align.LEFT;
            txt.x = 210 - txt.textBounds.width/2 ;
            txt.y = -45;
            _source.addChild(txt);
            _arrCTex.push(txt);
            _source.addChild(im);
        } else if (_data.object_type == BuildType.DECOR_ANIMATION) {
            im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.dataBuilding.objectBuilding[_data.object_id].url + '_icon'));
            txt = new CTextField(120, 40, String(g.dataBuilding.objectBuilding[_data.object_id].name));
            txt.setFormat(CTextField.BOLD30, 28, Color.WHITE, ManagerFilters.BLUE_COLOR);
            txt.alignH = Align.LEFT;
            txt.x = 210 - txt.textBounds.width/2 ;
            txt.y = -45;
            _source.addChild(_decorSpr);
            _decorSpr.addChild(im);
            _arrCTex.push(txt);
            _source.addChild(txt);
        } else if (_data.object_type == BuildType.DECOR) {
            im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.dataBuilding.objectBuilding[_data.object_id].image +'_icon'));
            txt = new CTextField(120, 40, String(g.dataBuilding.objectBuilding[_data.object_id].name));
            txt.setFormat(CTextField.BOLD30, 26, Color.WHITE, ManagerFilters.BLUE_COLOR);
            txt.alignH = Align.LEFT;
            txt.x = 210 - txt.textBounds.width/2 ;
            txt.y = -45;
            _source.addChild(_decorSpr);
            _decorSpr.addChild(im);
            _source.addChild(txt);
            _arrCTex.push(txt);
        }
        MCScaler.scale(im,105,105);
        im.x = 160;
        im.y = -138;


        if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID) {
            txt = new CTextField(160, 40, String(_data.old_cost) +' ок');
            txt.setFormat(CTextField.BOLD30, 24, ManagerFilters.BLUE_COLOR);
            txt.x = -100;
            txt.y = 40;
            _source.addChild(txt);
            _arrCTex.push(txt);

            txt = new CTextField(160, 40, 'за ' +String(_data.new_cost) + ' ок');
            txt.setFormat(CTextField.BOLD30, 26, ManagerFilters.BLUE_COLOR);
            txt.x = -100;
            txt.y = 80;
            _source.addChild(txt);
            _arrCTex.push(txt);
        } else {
            txt = new CTextField(160, 40, String(_data.old_cost) +' голосов');
            txt.setFormat(CTextField.BOLD30, 24, ManagerFilters.BLUE_COLOR);
            txt.x = -100;
            txt.y = 40;
            _source.addChild(txt);
            _arrCTex.push(txt);

            txt = new CTextField(160, 40, 'за ' +String(_data.new_cost) + ' голосов');
            txt.setFormat(CTextField.BOLD30, 26,  ManagerFilters.BLUE_COLOR);
            txt.x = -100;
            txt.y = 80;
            _source.addChild(txt);
            _arrCTex.push(txt);
        }
        var quad:Quad = new Quad(160, 3, Color.RED);
        quad.x = -100;
        quad.y = 62;
        quad.alpha = .6;
        _source.addChild(quad);

        var btn:CButton = new CButton();
        btn.addButtonTexture(200, 45, CButton.GREEN, true);
        txt = new CTextField(200, 45, 'Купить сейчас!');
        txt.setFormat(CTextField.BOLD30, 26,  Color.WHITE,ManagerFilters.GREEN_COLOR);
        btn.addChild(txt);
        btn.clickCallback = onClick;
        _source.addChild(btn);
        btn.y = 260;
        btn.x = 15;
        _arrCTex.push(btn);
    }

    override public function showItParams(callback:Function, params:Array):void {
        super.showIt();
    }

    override public function hideIt():void {
        if (g.user.level >= 5 && g.user.dayDailyGift == 0) g.directServer.getDailyGift(null);
        else {
            var todayDailyGift:Date = new Date(g.user.dayDailyGift * 1000);
            var today:Date = new Date(g.user.day * 1000);
            if (g.user.level >= 5 && todayDailyGift.date != today.date) {
                g.directServer.getDailyGift(null);
            } else {
                g.managerCats.helloCats();
                if (g.userTimer.partyTimer > 0 ) g.windowsManager.openWindow(WindowsManager.WO_PARTY,null);
                else if (!g.managerParty.userParty.showWindow) g.managerParty.endPartyWindow();
            }
        }
     super.hideIt();
    }

    private function onClick():void {
        if (g.isDebug) {
            onBuy();
        } else {
            if (Starling.current.nativeStage.displayState != StageDisplayState.NORMAL) {
                g.optionPanel.makeFullScreen();
            }
            g.socialNetwork.addEventListener(SocialNetworkEvent.ORDER_WINDOW_SUCCESS, orderWindowSuccessHandler);
            g.socialNetwork.addEventListener(SocialNetworkEvent.ORDER_WINDOW_CANCEL, orderWindowFailHandler);
            g.socialNetwork.addEventListener(SocialNetworkEvent.ORDER_WINDOW_FAIL, orderWindowFailHandler);
            g.socialNetwork.showOrderWindow({id: 13, price: int(_data.new_cost)});
            Cc.info('try to buy packId: ' + 13);
        }
    }

    private function orderWindowSuccessHandler(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_SUCCESS, orderWindowSuccessHandler);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_CANCEL, orderWindowFailHandler);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_FAIL, orderWindowFailHandler);
        Cc.info('Seccuss for buy pack');
        onBuy();
    }

    private function orderWindowFailHandler(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_SUCCESS, orderWindowSuccessHandler);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_CANCEL, orderWindowFailHandler);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_FAIL, orderWindowFailHandler);
        Cc.info('Fail for buy pack');
    }

    override protected function deleteIt():void {
        for (var i:int = 0; i < _arrCTex.length; i++) {
            if (_source && _arrCTex[i]) _source.removeChild(_arrCTex[i]);
            if (_arrCTex[i]) _arrCTex[i].deleteIt();
            _arrCTex[i] = null;
        }
        super.deleteIt();
    }

    private function onBuy():void {
        g.directServer.updateStarterPack(null);
        var obj:Object;
        obj = {};
        obj.count = _data.soft_count;
        var p:Point = new Point(0, 0);
        p = _source.localToGlobal(p);
        obj.id =  DataMoney.SOFT_CURRENCY;
        new DropItem(p.x + 30, p.y + 30, obj);

        obj = {};
        obj.count = _data.hard_count;
        p = new Point(0, 0);
        p = _source.localToGlobal(p);
        obj.id =  DataMoney.HARD_CURRENCY;
        new DropItem(p.x + 30, p.y + 30, obj);

        if (_data.object_type == BuildType.RESOURCE || _data.object_type == BuildType.INSTRUMENT || _data.object_type == BuildType.PLANT) {
            obj = {};
            obj.count = _data.object_count;
            p = new Point(0, 0);
            p = _source.localToGlobal(p);
            obj.id =  _data.object_id;
            obj.type = DropResourceVariaty.DROP_TYPE_RESOURSE;
            new DropItem(p.x + 30, p.y + 30, obj);
        } else if (_data.object_type == BuildType.DECOR_ANIMATION || _data.object_type == BuildType.DECOR) {
            if (_data.object_type == BuildType.DECOR_ANIMATION) {
                obj = {};
                obj.count = 0;
                p = new Point(0, 0);
                p = _source.localToGlobal(p);
                obj.id =  _data.object_id;
                obj.type = DropResourceVariaty.DROP_TYPE_DECOR_ANIMATION;
                new DropItem(p.x + 30, p.y + 30, obj);
            } else if (_data.object_type == BuildType.DECOR) {
                obj = {};
                obj.count = 0;
                p = new Point(0, 0);
                p = _source.localToGlobal(p);
                obj.id =  _data.object_id;
                obj.type = DropResourceVariaty.DROP_TYPE_DECOR;
                new DropItem(p.x + 30, p.y + 30, obj);
            }
        }
        hideIt();
    }
}
}
