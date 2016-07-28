/**
 * Created by user on 7/17/15.
 */
package windows.buyCurrency {
import analytic.AnalyticManager;

import com.junkbyte.console.Cc;

import data.DataMoney;

import flash.display.StageDisplayState;
import flash.geom.Point;
import manager.ManagerFilters;
import manager.Vars;
import resourceItem.DropItem;

import social.SocialNetworkEvent;

import starling.core.Starling;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;
import utils.CButton;
import utils.MCScaler;

import windows.WindowsManager;

public class WOBuyCurrencyItem {
    public var source:Sprite;
    private var _bg:Sprite;
    private var _btn:CButton;
    private var _im:Image;
    private var _currency:int;
    private var _costRealMoney:int;
    private var _countGameMoney:int;
    private var _packId:int;
    private var g:Vars = Vars.getInstance();

    public function WOBuyCurrencyItem(currency:int, count:int, profit:String, cost:int, packId:int) {
        _currency = currency;
        _packId = packId;
        _countGameMoney = count;
        _costRealMoney = cost;
        source = new Sprite();
        _bg = new Sprite();
        _bg.touchable = false;
        _im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('carton_line_l'));
        _bg.addChild(_im);
        _im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('carton_line_r'));
        _im.x = 593 - _im.width;
        _bg.addChild(_im);
        for (var i:int=0; i<8; i++) {
            _im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('carton_line_c'));
            _im.x = 58*(i+1);
            _bg.addChild(_im);
        }
        _im.width = 71;
        _bg.flatten();
        source.addChild(_bg);

        if (_currency == DataMoney.HARD_CURRENCY) {
            _im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_medium'));
        } else {
            _im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_medium'));
        }
        MCScaler.scale(_im, 38, 38);
        _im.x = 15;
        _im.y = 9;
        _im.filter = ManagerFilters.SHADOW_TINY;
        source.addChild(_im);

        var txt:TextField = new TextField(135, 52, String(count), g.allData.fonts['BloggerBold'], 24, ManagerFilters.TEXT_BLUE_COLOR);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_WHITE;
        txt.x = 70;
        txt.y = 4;
        source.addChild(txt);

        _btn = new CButton();
        _btn.addButtonTexture(120, 40, CButton.GREEN, true);
        txt = new TextField(120, 38, String(cost) + ' голосов', g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        _btn.addChild(txt);
        _btn.x = 493;
        _btn.y = 31;
        source.addChild(_btn);
        _btn.clickCallback = onClick;
    }

    public function deleteIt():void {
        _im.filter = null;
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_SUCCESS, orderWindowSuccessHandler);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_CANCEL, orderWindowFailHandler);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_FAIL, orderWindowFailHandler);
        source.removeChild(_btn);
        _btn.deleteIt();
        _btn = null;
        source.dispose();
        source = null;
        g = null;
    }

    private function onClick():void {
        if (g.isDebug) {
            onBuy();
        } else {
            if (Starling.current.nativeStage.displayState != StageDisplayState.NORMAL) {
                g.optionPanel.makeFullScreen();
                g.windowsManager.hideWindow(WindowsManager.WO_BUY_CURRENCY);
            }
            g.socialNetwork.addEventListener(SocialNetworkEvent.ORDER_WINDOW_SUCCESS, orderWindowSuccessHandler);
            g.socialNetwork.addEventListener(SocialNetworkEvent.ORDER_WINDOW_CANCEL, orderWindowFailHandler);
            g.socialNetwork.addEventListener(SocialNetworkEvent.ORDER_WINDOW_FAIL, orderWindowFailHandler);
            g.socialNetwork.showOrderWindow({id: _packId});
            Cc.info('try to buy packId: ' + _packId);
        }
    }

    private function orderWindowSuccessHandler(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_SUCCESS, orderWindowSuccessHandler);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_CANCEL, orderWindowFailHandler);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_FAIL, orderWindowFailHandler);
        Cc.info('Seccuss for buy pack');
        if (_currency == DataMoney.HARD_CURRENCY) {
            g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.BUY_HARD_FOR_REAL, {id: _packId});
        } else {
            g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.BUY_SOFT_FOR_REAL, {id: _packId});
        }
        onBuy();
    }

    private function orderWindowFailHandler(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_SUCCESS, orderWindowSuccessHandler);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_CANCEL, orderWindowFailHandler);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_FAIL, orderWindowFailHandler);
        Cc.info('Fail for buy pack');
    }

    private function onBuy():void {
        var obj:Object;
        obj = {};
        obj.count = _countGameMoney;
        var p:Point = new Point(_im.x, _im.y);
        p = _im.localToGlobal(p);
        obj.id =  _currency;
        new DropItem(p.x + 30, p.y + 30, obj);
    }
}
}
