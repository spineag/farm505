/**
 * Created by user on 2/15/17.
 */
package windows.salePack {
import com.junkbyte.console.Cc;

import data.BuildType;

import data.DataMoney;

import flash.display.StageDisplayState;

import flash.geom.Point;

import manager.ManagerFilters;

import resourceItem.DropItem;

import social.SocialNetworkEvent;

import social.SocialNetworkSwitch;

import starling.core.Starling;

import starling.display.Image;
import starling.display.Quad;

import starling.display.Sprite;
import starling.events.Event;
import starling.utils.Align;
import starling.utils.Color;

import temp.DropResourceVariaty;

import utils.CButton;

import utils.CTextField;

import utils.TimeUtils;

import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOSalePack extends WindowMain{
    private var _woBG:WindowBackground;
    private var _txtTime:CTextField;
    private var _txtName:CTextField;
    private var _txtDescription:CTextField;
    private var _txtBtn:CTextField;
    private var _txtProfit:CTextField;
    private var _txtOldCost:CTextField;
    private var _txtNewCost:CTextField;
    private var _sprItem:Sprite;
    private var _imPercent:Image;
    private var _btnBuy:CButton;
    private var _arrItem:Array;
    private var _txtVugoda:CTextField;
    private var _boolOpen:Boolean = false;

    public function WOSalePack() {
        _woHeight = 505;
        _woWidth = 740;
        _windowType = WindowsManager.WO_SALE_PACK;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        var im:Image;
        im = new Image(g.allData.atlas['saleAtlas'].getTexture('sale_window'));
        im.x = -340;
        im.y = -245;
        _source.addChild(im);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;
        _arrItem = [];
        _imPercent = new Image(g.allData.atlas['saleAtlas'].getTexture('percent_w'));
        _imPercent.x = -370;
        _imPercent.y = -253;
        _source.addChild(_imPercent);
        _txtTime = new CTextField(120,60,'');
        _txtTime.setFormat(CTextField.BOLD24, 20, 0x4b7200);
        _txtTime.alignH = Align.LEFT;

        _txtTime.y = -137;
        _source.addChild(_txtTime);
        _txtName = new CTextField(740, 70, String(g.managerSalePack.dataSale.name));
        _txtName.setFormat(CTextField.BOLD30, 40, Color.RED, Color.WHITE);
//        _txtName.alignH = Align.LEFT;
        _txtName.x = -360;
        _txtName.y = -222;
        _source.addChild(_txtName);

        _txtDescription = new CTextField(740,70,String(g.managerSalePack.dataSale.description));
        _txtDescription.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtDescription.x = -360;
        _txtDescription.y = -167;
        _source.addChild(_txtDescription);

        var st:String;
        if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID) {
            st = ' ' + String(g.managerLanguage.allTexts[328]);
        } else if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) {
            st = ' ' + String(g.managerLanguage.allTexts[330]);
        } else if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID ) {
            st = ' $';
        }

        _txtOldCost = new CTextField(200,60,String(g.managerSalePack.dataSale.oldCost) + st);
        _txtOldCost.setFormat(CTextField.BOLD24, 24, Color.RED);
        _txtOldCost.y = 80;
        _txtOldCost.x = -110;
        _source.addChild(_txtOldCost);

        _txtNewCost = new CTextField(200,60,'за ' + String(g.managerSalePack.dataSale.newCost) + st);
        _txtNewCost.setFormat(CTextField.BOLD24, 22, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtNewCost.y = 110;
        _txtNewCost.x = -110;
        _source.addChild(_txtNewCost);

        var quad:Quad = new Quad(_txtOldCost.textBounds.width, 3, Color.RED);
        if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID || g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID )  {
            quad.x = -50;
            quad.y = 110;
        } else {
            quad.x = -80;
            quad.y = 113;
        }
        quad.alpha = .6;
        _source.addChild(quad);
        _txtProfit = new CTextField(150,60,String(g.managerSalePack.dataSale.profit) + '%');
        _txtProfit.setFormat(CTextField.BOLD24, 24, Color.WHITE, Color.RED);
        _txtProfit.x = 145;
        _txtProfit.y = 100;
        _source.addChild(_txtProfit);
        _txtVugoda = new CTextField(150,60,String(g.managerLanguage.allTexts[354]));
        _txtVugoda.setFormat(CTextField.BOLD18, 18, Color.WHITE, Color.RED);
        _txtVugoda.x = 147;
        _txtVugoda.y = 120;
        _source.addChild(_txtVugoda);

        g.gameDispatcher.addToTimer(startTimer);
        _sprItem = new Sprite();
        _source.addChild(_sprItem);

        _btnBuy = new CButton();
        _btnBuy.addButtonTexture(100, 45, CButton.GREEN, true);
        _txtBtn = new CTextField(100, 45, String(g.managerLanguage.allTexts[355]));
        _txtBtn.setFormat(CTextField.BOLD30, 26,  Color.WHITE,ManagerFilters.GREEN_COLOR);
        _btnBuy.addChild(_txtBtn);
        _btnBuy.clickCallback = onClick;
        _source.addChild(_btnBuy);
        _btnBuy.y = 230;
        _btnBuy.x = 15;
    }

    override public function showItParams(callback:Function, params:Array):void {
        var item:WOSalePackItem;
        for (var i:int = 0; i < g.managerSalePack.dataSale.objectId.length; i++) {
            item = new WOSalePackItem(g.managerSalePack.dataSale.objectId[i],g.managerSalePack.dataSale.objectType[i],g.managerSalePack.dataSale.objectCount[i]);
            item.source.x = 175 * i;
            _sprItem.addChild(item.source);
            _arrItem.push(item);
        }
        if (_arrItem.length == 1) {
            _sprItem.x = -70;
        } else if (_arrItem.length == 2) {
            _sprItem.x = -150;
        } else {
            _sprItem.x = -240;
        }
        _sprItem.y = -105;
        _boolOpen = params[0];
        super.showIt();
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
            g.socialNetwork.showOrderWindow({id: 14, price: int(g.managerSalePack.dataSale.newCost)});
            Cc.info('try to buy packId: ' + 14);
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

    private function onBuy():void {
        g.directServer.updateUserSalePack(null);
        var obj:Object;
        var p:Point = new Point(0, 0);
        p = _source.localToGlobal(p);
        for (var i:int = 0; i < g.managerSalePack.dataSale.objectId.length; i++) {
            obj = {};
            if (g.managerSalePack.dataSale.objectId[i] == 1 && g.managerSalePack.dataSale.objectType[i]  == 1) {
                p = new Point(0, 0);
                obj.id = DataMoney.SOFT_CURRENCY;
                obj.type = DropResourceVariaty.DROP_TYPE_MONEY;

            } else if (g.managerSalePack.dataSale.objectId[i] == 2 && g.managerSalePack.dataSale.objectType[i] == 2) {
                obj.id = DataMoney.HARD_CURRENCY;
                obj.type = DropResourceVariaty.DROP_TYPE_MONEY;
            }  else if (g.managerSalePack.dataSale.objectType[i] == BuildType.RESOURCE || g.managerSalePack.dataSale.objectType[i] == BuildType.INSTRUMENT || g.managerSalePack.dataSale.objectType[i] == BuildType.PLANT) {
                obj.id = g.managerSalePack.dataSale.objectId[i];
                obj.type = DropResourceVariaty.DROP_TYPE_RESOURSE;

            } else if (g.managerSalePack.dataSale.objectType[i] == BuildType.DECOR_ANIMATION) {
                obj.id = g.managerSalePack.dataSale.objectId[i];
                obj.type = DropResourceVariaty.DROP_TYPE_DECOR_ANIMATION;

            } else if (g.managerSalePack.dataSale.objectType[i] == BuildType.DECOR) {
                obj.id = g.managerSalePack.dataSale.objectId[i];
                obj.type = DropResourceVariaty.DROP_TYPE_DECOR;
            }
            obj.count = g.managerSalePack.dataSale.objectCount[i];
            new DropItem(p.x + 30, p.y + 30, obj);
        }
        hideIt();
        g.salePanel.visiblePartyPanel(false);
    }

    public function startTimer():void {
        if (g.userTimer.saleTimerToEnd > 0) {
            if (_txtTime) {
                _txtTime.text = TimeUtils.convertSecondsForHint(g.userTimer.saleTimerToEnd);
                _txtTime.x = -315 - _txtTime.textBounds.width/2;
            }
        } else {
            onClickExit();
            g.gameDispatcher.removeFromTimer(startTimer);
        }
    }

    override protected function deleteIt():void {
        super.deleteIt();
    }

    private function onClickExit(e:Event=null):void {
        hideIt();
    }

    override public function hideIt():void {
        g.gameDispatcher.removeFromTimer(startTimer);
        if (_boolOpen) {
            if (g.user.level >= 5 && g.user.dayDailyGift == 0) g.directServer.getDailyGift(null);
            else {
                var todayDailyGift:Date = new Date(g.user.dayDailyGift * 1000);
                var today:Date = new Date(g.user.day * 1000);
                if (g.user.level >= 5 && todayDailyGift.date != today.date) {
                    g.directServer.getDailyGift(null);
                } else {
                    g.managerCats.helloCats();
                    if ( g.managerParty.eventOn && g.user.level >= g.managerParty.levelToStart) {
                        g.windowsManager.openWindow(WindowsManager.WO_PARTY,null);
                    }
//                    else if (g.managerParty.userParty && !g.managerParty.userParty.showWindow) g.managerParty.endPartyWindow();
                }
            }
        }
        super.hideIt();
    }
}
}
