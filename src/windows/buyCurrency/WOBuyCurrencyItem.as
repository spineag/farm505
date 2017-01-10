/**
 * Created by user on 7/17/15.
 */
package windows.buyCurrency {
import analytic.AnalyticManager;

import com.junkbyte.console.Cc;

import data.DataMoney;

import flash.display.StageDisplayState;
import flash.geom.Point;
import flash.geom.Rectangle;

import manager.ManagerFilters;
import manager.Vars;
import resourceItem.DropItem;

import social.SocialNetworkEvent;
import social.SocialNetworkSwitch;

import starling.core.Starling;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import utils.MCScaler;

import windows.WindowsManager;

public class WOBuyCurrencyItem {
    public var source:Sprite;
    private var _bg:Sprite;
    private var _btn:CButton;
    private var _txtBtn:CTextField;
    private var _txtCount:CTextField;
    private var _im:Image;
    private var _action:Sprite;
    private var _currency:int;
    private var _costRealMoney:int;
    private var _countGameMoney:int;
    private var _packId:int;
    private var g:Vars = Vars.getInstance();

    public function WOBuyCurrencyItem(currency:int, count:int, bonus:Array, cost:int, packId:int) {
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
        _im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('carton_line_c'));
        _im.tileGrid = new Rectangle();
        _im.width = 477 + 2;
        _im.x = 58 - 1;
        _bg.addChildAt(_im, 0);
        _im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('carton_line_c'));
        _im.tileGrid = new Rectangle();
        _im.width = 477 + 6;
        _im.x = 58 - 3;
        _im.height -=2;
        _im.y = 1;
        _bg.addChildAt(_im, 0);
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

        _txtCount = new CTextField(135, 52, String(count));
        _txtCount.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_COLOR);
        _txtCount.x = 70;
        _txtCount.y = 4;
        source.addChild(_txtCount);

        _btn = new CButton();
        _btn.addButtonTexture(120, 40, CButton.GREEN, true);
        var valuta:String;
        if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) {
            valuta = ' голосов';
        } else if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID) {
            valuta = ' OK';
        }
        _txtBtn = new CTextField(120, 30, String(cost) + valuta);
        _txtBtn.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _txtBtn.y = 6;
        _btn.addChild(_txtBtn);
        _btn.x = 493;
        _btn.y = 31;
        source.addChild(_btn);
        _action = new Sprite();
        var im:Image;
        var txt:CTextField;
        if (bonus[0] == 1) {
             im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('best_price'));
            im.x = 280;
            source.addChild(im);
        } else if (bonus[0] == 2) {
             im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('top_sells'));
            im.x = 280;
            source.addChild(im);
        }
        if (bonus[1] > 0) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('bonus'));
            _action.addChild(im);
             txt= new CTextField(60, 30, bonus[1] + '%');
            txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.ORANGE_COLOR);
            txt.y = 5;
            _action.addChild(txt);
            txt = new CTextField(60, 30, 'Выгода');
            txt.y = 20;
            txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.ORANGE_COLOR);
            _action.addChild(txt);
            source.addChild(_action);
            _action.x = 350;
        }

        _btn.clickCallback = onClick;
    }

    public function updateTextField():void {
        _txtBtn.updateIt();
        _txtCount.updateIt();
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
        while (_action.numChildren) {
            _action.removeChildAt(0);
        }
        _action.dispose();
        _action = null;
        g = null;
    }

    private function onClick():void {
        if (g.isDebug) {5
            onBuy();
        } else {
            if (Starling.current.nativeStage.displayState != StageDisplayState.NORMAL) {
                g.optionPanel.makeFullScreen();
//                g.windowsManager.hideWindow(WindowsManager.WO_BUY_CURRENCY); ??
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
        var p:Point = new Point(0, 0);
        p = _im.localToGlobal(p);
        obj.id =  _currency;
        new DropItem(p.x + 30, p.y + 30, obj);
    }
}
}
