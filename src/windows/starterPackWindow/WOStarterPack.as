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

    public function WOStarterPack() {
        super();
        if (g.user.starterPack) return;
        _decorSpr = new Sprite();
        _woHeight = 538;
        _woWidth = 732;
        _windowType = WindowsManager.WO_STARTER_PACK;
        g.load.loadImage(g.dataPath.getGraphicsPath() + 'qui/sp_back_empty.png',onLoad);
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
    }

    private function createWindow():void {
        var txt:CTextField;
        var im:Image;

        txt = new CTextField(350, 40, 'Уникальное предложение');
        txt.setFormat(CTextField.BOLD30, 30, Color.RED, Color.WHITE);
        txt.x = -165;
        txt.y = -230;
        _source.addChild(txt);

        txt = new CTextField(77, 40, String(_data.soft_count));
        txt.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.x = -196;
        txt.y = -40;
        _source.addChild(txt);

        txt = new CTextField(77, 40, String(_data.hard_count));
        txt.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.x = -17;
        txt.y = -40;
        _source.addChild(txt);

        txt = new CTextField(90, 50, 'Монеты');
        txt.setFormat(CTextField.BOLD30, 28, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.x = -200;
        txt.y = -170;
        _source.addChild(txt);

        txt = new CTextField(90, 50, "Рубины");
        txt.setFormat(CTextField.BOLD30, 28, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.y = -170;
        txt.x = -20;
        _source.addChild(txt);

        txt = new CTextField(77, 40, "Бонус");
        txt.setFormat(CTextField.BOLD30, 28, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.x = 175;
        txt.y = -170;
        _source.addChild(txt);

        if (_data.object_type == BuildType.RESOURCE || _data.object_type == BuildType.INSTRUMENT || _data.object_type == BuildType.PLANT) {
            im = new Image(g.allData.atlas[g.dataResource.objectResources[_data.object_id].url].getTexture(g.dataResource.objectResources[_data.object_id].imageShop));
            txt = new CTextField(120, 40, String(_data.object_count));
            txt.setFormat(CTextField.BOLD30, 28, Color.WHITE, ManagerFilters.BLUE_COLOR);
            txt.x = 165;
            txt.y = -40;
            _source.addChild(txt);
            _source.addChild(im);
        } else if (_data.object_type == BuildType.DECOR_ANIMATION) {
            im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.dataBuilding.objectBuilding[_data.object_id].url + '_icon'));
            txt = new CTextField(120, 40, String(g.dataBuilding.objectBuilding[_data.object_id].name));
            txt.setFormat(CTextField.BOLD30, 28, Color.WHITE, ManagerFilters.BLUE_COLOR);
            txt.x = 165;
            txt.y = -40;
            _source.addChild(_decorSpr);
            _decorSpr.addChild(im);
            _source.addChild(txt);
        } else if (_data.object_type == BuildType.DECOR) {
            im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.dataBuilding.objectBuilding[_data.object_id].image +'_icon'));
            txt = new CTextField(120, 40, String(g.dataBuilding.objectBuilding[_data.object_id].name));
            txt.setFormat(CTextField.BOLD30, 26, Color.WHITE, ManagerFilters.BLUE_COLOR);
            txt.x = 150;
            txt.y = -40;
            _source.addChild(_decorSpr);
            _decorSpr.addChild(im);
            _source.addChild(txt);
        }
        MCScaler.scale(im,110,110);
        im.x = 160;
        im.y = -145;


        if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID) {
            txt = new CTextField(160, 40, String(_data.old_cost) +' ок');
            txt.setFormat(CTextField.BOLD30, 24, ManagerFilters.BLUE_COLOR);
            txt.x = -100;
            txt.y = 40;
            _source.addChild(txt);

            txt = new CTextField(160, 40, 'за ' +String(_data.new_cost) + ' ок');
            txt.setFormat(CTextField.BOLD30, 26, ManagerFilters.BLUE_COLOR);
            txt.x = -100;
            txt.y = 80;
            _source.addChild(txt);
        } else {
            txt = new CTextField(160, 40, String(_data.old_cost) +' голосов');
            txt.setFormat(CTextField.BOLD30, 24, ManagerFilters.BLUE_COLOR);
            txt.x = -100;
            txt.y = 40;
            _source.addChild(txt);


            txt = new CTextField(160, 40, 'за ' +String(_data.new_cost) + ' голосов');
            txt.setFormat(CTextField.BOLD30, 26,  ManagerFilters.BLUE_COLOR);
            txt.x = -100;
            txt.y = 80;
            _source.addChild(txt);
        }
        var quad:Quad = new Quad(160, 3, Color.RED);
        quad.x = -100;
        quad.y = 62;
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
    }
    override public function showItParams(callback:Function, params:Array):void {
        super.showIt();
    }

    override public function hideIt():void {
        if (g.user.level >= 5 && g.user.dayDailyGift == 0) g.directServer.getDailyGift(null);
        else {
            var todayDailyGift:Date = new Date(g.user.dayDailyGift * 1000);
            var today:Date = new Date();
            if (g.user.level >= 5 && todayDailyGift.date != today.date) {
                g.directServer.getDailyGift(null);
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
//                g.windowsManager.hideWindow(WindowsManager.WO_BUY_CURRENCY); ??
            }
            g.socialNetwork.addEventListener(SocialNetworkEvent.ORDER_WINDOW_SUCCESS, orderWindowSuccessHandler);
            g.socialNetwork.addEventListener(SocialNetworkEvent.ORDER_WINDOW_CANCEL, orderWindowFailHandler);
            g.socialNetwork.addEventListener(SocialNetworkEvent.ORDER_WINDOW_FAIL, orderWindowFailHandler);
            g.socialNetwork.showOrderWindow({id: 12});
            Cc.info('try to buy packId: ' + 12);
        }
    }

    private function orderWindowSuccessHandler(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_SUCCESS, orderWindowSuccessHandler);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_CANCEL, orderWindowFailHandler);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_FAIL, orderWindowFailHandler);
        Cc.info('Seccuss for buy pack');
//        if (_currency == DataMoney.HARD_CURRENCY) {
//            g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.BUY_HARD_FOR_REAL, {id: 13});
//        } else {
//            g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.BUY_SOFT_FOR_REAL, {id: 13});
//        }
        onBuy();
    }

    private function orderWindowFailHandler(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_SUCCESS, orderWindowSuccessHandler);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_CANCEL, orderWindowFailHandler);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_FAIL, orderWindowFailHandler);
        Cc.info('Fail for buy pack');
    }

    override protected function deleteIt():void {
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
            var f1:Function = function (dbId:int):void {
                g.userInventory.addToDecorInventory(_data.object_id, dbId);
            };
            var f:Function = function ():void {
                g.directServer.buyAndAddToInventory(_data.object_id, f1);
            };
            var v:Number;
            if (Starling.current.nativeStage.displayState == StageDisplayState.NORMAL) v = .5;
            else v = .2;
            var im:Image;
            var spr:Sprite = new Sprite();
            if (_data.object_type == BuildType.RESOURCE || _data.object_type == BuildType.INSTRUMENT || _data.object_type == BuildType.PLANT) {
                im = new Image(g.allData.atlas[g.dataResource.objectResources[_data.object_id].url].getTexture(g.dataResource.objectResources[_data.object_id].imageShop));
            } else if (_data.object_type == BuildType.DECOR_ANIMATION) {
                im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.dataBuilding.objectBuilding[_data.object_id].url + '_icon'));
            } else if (_data.object_type == BuildType.DECOR) {
                im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.dataBuilding.objectBuilding[_data.object_id].image +'_icon'));
            }
            MCScaler.scale(im,110,110);
            im.x = 160;
            im.y = -145;
            spr.addChild(im);
            new TweenMax(spr, v, {scaleX:.3, scaleY:.3, ease:Back.easeIn, onComplete:f});
        }
    }

}
}
