/**
 * Created by user on 1/30/17.
 */
package windows.partyWindow {
import com.junkbyte.console.Cc;

import data.BuildType;

import flash.geom.Point;

import manager.ManagerFilters;
import manager.ManagerLanguage;
import manager.ManagerPartyNew;

import social.SocialNetworkEvent;
import social.SocialNetworkSwitch;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;

import starling.events.Event;
import starling.utils.Align;
import starling.utils.Color;

import ui.xpPanel.XPStar;

import user.Someone;

import utils.CButton;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import utils.TimeUtils;

import windows.WOComponents.Birka;
import windows.WOComponents.DefaultVerticalScrollSprite;
import windows.WOComponents.DefaultVerticalScrollSprite;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOPartyWindow extends WindowMain {

    private var _woBG:WindowBackground;
    private var _btn:CButton;
    private var _txtBtn:CTextField;
    private var _txtName:CTextField;
    private var _txtCoefficient:CTextField;
    private var _arrItem:Array;
    private var _sprItem:Sprite;
    private var _imTime:Image;
    private var _txtBabl:CTextField;
    private var _txtTime:CTextField;
    private var _txtTimeLost:CTextField;
    private var _isHover:Boolean;
    private var _btnMinus:CButton;
    private var _btnPlus:CButton;
    private var _btnLoad:CButton;
    private var _txtCountLoad:CTextField;
    private var _countLoad:int;
    private var _imName:Image;
    private var _btnParty:CButton;
    private var _activityType:int;
    private var _btnEvent:CButton;
    private var _imEvent:Image;
    private var _btnRating:CButton;
    private var _imRating:Image;
    private var _btnLast:CButton;
    private var _imLast:Image;
    private var _sprEvent:Sprite;
    private var _sprRating:Sprite;
    private var _sprLast:Sprite;
    private var _scrollSprite:DefaultVerticalScrollSprite;
    private var _arrItemRating:Array;

    public function WOPartyWindow() {
        _windowType = WindowsManager.WO_PARTY;
        _arrItem= [];
        _woHeight = 500;
        _woWidth = 690;
        _isHover = false;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        _activityType = ManagerPartyNew.TYPE_EVENT;

        _sprEvent = new Sprite();
        _sprRating = new Sprite();
        _sprRating.visible = false;
        _sprLast = new Sprite();
        _sprLast.visible = false;
        _source.addChild(_sprEvent);
        _source.addChild(_sprRating);
        _source.addChild(_sprLast);
        _sprItem = new Sprite();
        if (g.allData.atlas['partyAtlas']) {
            fuckingButton();
            eventWO(false);
            if (g.managerParty.typeParty == 3 || g.managerParty.typeParty == 4 || g.managerParty.typeParty == 5) {
                ratingWO();
                lastWO();
            }
        } else g.gameDispatcher.addEnterFrame(afterAtlas);

    }

    private function afterAtlas():void {
        if (g.allData.atlas['partyAtlas']) {
            g.gameDispatcher.removeEnterFrame(afterAtlas);
            fuckingButton();
            eventWO(false);
            if (g.managerParty.typeParty == 3 || g.managerParty.typeParty == 4 || g.managerParty.typeParty == 5) {
                ratingWO();
                lastWO();
            }
        }
    }

    private function onClickShow():void {
        hideIt();
        var arr:Array;
        var i:int;
        if (g.managerParty.typeParty == 5) {
            arr = g.townArea.getCityObjectsByType(BuildType.ORDER);
            var arrT:Array;
            arrT = g.townArea.getCityObjectsByType(BuildType.RIDGE);
            if (arrT.length > 0) {
                for (i = 0; i < arrT.length; i++) {
                    if (arrT[i].stateRidge > 1) arr.push(arrT[i]);
                }
            }
            arrT = [];
            arrT = g.townArea.getCityObjectsByType(BuildType.MARKET);
            arr.push(arrT[0]);
            g.cont.moveCenterToPos(arr[0].posX, arr[0].posY);
            for (i = 0; i < arr.length; i++) {
                arr[i].showArrow(3);
            }
        } else {
            arr = g.townArea.getCityObjectsByType(g.managerParty.typeBuilding);
            var b:Boolean = false;
            if (BuildType.FABRICA == g.managerParty.typeBuilding) {
                for (i = 0; i < arr.length; i++) {
                    for (var j:int = 0; j < arr[i].arrRecipes.length; j++) {
                        if (arr[i].arrRecipes[j].idResource == g.managerParty.idResource) {
                            arr[0] = arr[i];
                            b = true;
                            break;
                        }
                    }
                    if (b) break;
                }
            } else if (BuildType.TREE == g.managerParty.typeBuilding) {
                for (i = 0; i < arr.length; i++) {
                    if (arr[i].dataBuild.craftIdResource == g.managerParty.idResource) {
                        arr[0] = arr[i];
                        b = true;
                        break;
                    }
                }
            } else if (BuildType.FARM == g.managerParty.typeBuilding) {
                for (i = 0; i < arr.length; i++) {
                    if (arr[i].dataAnimal.idResource == g.managerParty.idResource) {
                        arr[0] = arr[i];
                        b = true;
                        break;
                    }
                }
            }
            if (g.managerParty.idResource == 0) b = true;
            if (!b) return;
            if (!arr[0]) return;
            g.cont.moveCenterToPos(arr[0].posX, arr[0].posY);
            if (BuildType.FABRICA == g.managerParty.typeBuilding) arr[0].showArrow();
            else arr[0].showArrow(3);
        }
    }

    private function onClickMinus():void {
      if (_countLoad == 1) {
          _btnMinus.setEnabled = false;
          return;
      } else if (_countLoad -1 == 1) {
          _countLoad -=1;
          _txtCountLoad.text = String(_countLoad);
          _btnPlus.setEnabled = true;
          _btnMinus.setEnabled = false;
      } else {
          _countLoad -=1;
          _txtCountLoad.text = String(_countLoad);
          _btnPlus.setEnabled = true;
      }
    }

    private function onClickPlus():void {
        if (_countLoad + 1 > g.userInventory.getCountResourceById(g.managerParty.idResource)) {
            _btnPlus.setEnabled = false;
            return;
        } else if (_countLoad + 1 == g.userInventory.getCountResourceById(g.managerParty.idResource)){
            _countLoad +=1;
            _txtCountLoad.text = String(_countLoad);
            _btnMinus.setEnabled = true;
            _btnPlus.setEnabled = false;
        } else {
            _countLoad +=1;
            _txtCountLoad.text = String(_countLoad);
            _btnMinus.setEnabled = true;
        }
    }

    private function onClickLoad():void {
        var st:String = g.managerParty.userParty.tookGift[0] + '&' + g.managerParty.userParty.tookGift[1] + '&' + g.managerParty.userParty.tookGift[2] + '&'
                + g.managerParty.userParty.tookGift[3] + '&' + g.managerParty.userParty.tookGift[4];
        g.managerParty.userParty.countResource += _countLoad;
        g.directServer.updateUserParty(st,g.managerParty.userParty.countResource,0,null);
        var p:Point = new Point(0, 0);
        p = _btnLoad.localToGlobal(p);
        new XPStar(p.x, p.y,_countLoad * g.allData.getResourceById(g.managerParty.idResource).orderXP);
        g.userInventory.addResource(g.managerParty.idResource, - _countLoad);
        _countLoad =  g.userInventory.getCountResourceById(g.managerParty.idResource);
        _txtCountLoad.text = String(_countLoad);
        for (var i:int = 0; i < _arrItem.length; i++) {
            _arrItem[i].reload();
        }
        if (_countLoad > 0) {
            _countLoad = _countLoad/2;
            if (_countLoad <= 0) {
                _countLoad = 1;
                _btnMinus.setEnabled = false;
                _btnPlus.setEnabled = false;
            } else if (_countLoad == 1) _btnMinus.setEnabled = false;
        } else {
            _btnMinus.setEnabled = false;
            _btnPlus.setEnabled = false;
            _btnLoad.setEnabled = false;
        }

    }

    override public function showItParams(callback:Function, params:Array):void {
//        if (!g.allData.atlas['partyAtlas']) {
//            g.windowsManager.hideWindow(WindowsManager.WO_PARTY);
////            g.windowsManager.closeAllWindows();
//            return;
//        }
        if (g.managerParty.typeParty == 1 || g.managerParty.typeParty == 2) {
            super.showIt();
            return;
        }
        if (params[0]) _activityType = params[0];
//        _btnRating.setEnabled = false;
        if (_activityType == ManagerPartyNew.TYPE_LAST) {
            _imEvent.visible = true;
            _imRating.visible = true;
            _imLast.visible = false;
            _sprEvent.visible = false;
            _sprRating.visible = false;
            _sprLast.visible = true;

            _btnEvent.setEnabled = false;
            _btnLast.setEnabled = true;
            _btnEvent.touchable = false;
            _btnRating.touchable = true;
            _btnLast.touchable = false;
        } else {
            var item:WOPartyWindowItem;
            for (var i:int = 0; i < 5; i++) {
                item = new WOPartyWindowItem(g.managerParty.idGift[i], g.managerParty.typeGift[i], g.managerParty.countGift[i], g.managerParty.countToGift[i], i + 1);
                item.source.x = (98 * i);
                _sprItem.addChild(item.source);
                _arrItem.push(item);
            }

            _imTime = new Image(g.allData.atlas['partyAtlas'].getTexture('valik_timer'));
            _imTime.x = 275;
            _imTime.y = -205;
            _sprEvent.addChild(_imTime);
            _sprItem.x = -195;
            _sprItem.y = -125;

            _txtTimeLost = new CTextField(120, 60, String(g.managerLanguage.allTexts[357]));
            _txtTimeLost.setFormat(CTextField.BOLD18, 16, 0xff7575);
            _sprEvent.addChild(_txtTimeLost);
            _txtTimeLost.x = 287;
            _txtTimeLost.y = -183;
            _txtTime = new CTextField(120, 60, '');
            _txtTime.setFormat(CTextField.BOLD18, 16, 0xd30102);
            _txtTime.x = 286;
            _txtTime.y = -150;
            _sprEvent.addChild(_txtTime);
            g.gameDispatcher.addToTimer(startTimer);
        }
        super.showIt();
    }

    private function startTimer():void {
        if (g.userTimer.partyToEndTimer > 0) {
            if (_txtTime)_txtTime.text = TimeUtils.convertSecondsToStringClassic(g.userTimer.partyToEndTimer);
            if (_txtTime && (g.managerParty.typeParty == 1 || g.managerParty.typeParty == 2) && _txtTime.x == 0) _txtTime.x = -(160 + _txtTime.textBounds.width/2);
        } else {
            onClickExit();
            g.gameDispatcher.removeFromTimer(startTimer);
        }
    }

    private function fuckingButton():void {
        if (!g.allData.atlas['partyAtlas']) {
            Cc.error('WOPartyWindow:: no g.allData.atlas[partyAtlas]');
            return;
        }
        var im:Image;
        _btnEvent = new CButton();
        if (!g.allData.atlas['partyAtlas']) return;
        im = new Image(g.allData.atlas['partyAtlas'].getTexture('tabs_bt_1'));
        _btnEvent.addDisplayObject(im);
        im = new Image(g.allData.atlas['partyAtlas'].getTexture('tabs_event_on'));
        im.x = 10;
        im.y = 5;
        _btnEvent.addDisplayObject(im);
        _source.addChild(_btnEvent);
        _btnEvent.x = 310;
        _btnEvent.y = -40;
        _imEvent = new Image(g.allData.atlas['partyAtlas'].getTexture('tabs_bt_2'));
        _source.addChild(_imEvent);
        _imEvent.x = 310;
        _imEvent.y = -40;
        _imEvent.visible = false;
        _btnEvent.touchable = false;
        _btnEvent.clickCallback = function():void {
            _activityType = ManagerPartyNew.TYPE_EVENT;
            _imEvent.visible = false;
            _imRating.visible = true;
            _imLast.visible = true;

            _sprEvent.visible = true;
            _sprRating.visible = false;
            _sprLast.visible = false;

            _btnEvent.touchable = false;
            _btnRating.touchable = true;
            _btnLast.touchable = true;
        };

        _btnRating = new CButton();
        im = new Image(g.allData.atlas['partyAtlas'].getTexture('tabs_bt_1'));
        _btnRating.addDisplayObject(im);
        im = new Image(g.allData.atlas['partyAtlas'].getTexture('tabs_top_on'));
        im.x = 10;
        im.y = 5;
        _btnRating.addDisplayObject(im);
        _source.addChild(_btnRating);
        _btnRating.x = 310;
        _btnRating.y = 35;
        _imRating = new Image(g.allData.atlas['partyAtlas'].getTexture('tabs_bt_2'));
        _source.addChild(_imRating);
        _imRating.x = 310;
        _imRating.y = 35;
//        var f1:Function = function ():void {

//        };
        _btnRating.clickCallback = function():void {
//            g.directServer.getRatingParty(f1);

            _activityType = ManagerPartyNew.TYPE_RATING;
            _imEvent.visible = true;
            _imRating.visible = false;
            _imLast.visible = true;

            _sprEvent.visible = false;
            _sprRating.visible = true;
            _sprLast.visible = false;

            _btnEvent.touchable = true;
            _btnRating.touchable = false;
            _btnLast.touchable = true;
        };

        _btnLast = new CButton();
        im = new Image(g.allData.atlas['partyAtlas'].getTexture('tabs_bt_1'));
        _btnLast.addDisplayObject(im);
        im = new Image(g.allData.atlas['partyAtlas'].getTexture('tabs_bonus_on'));
        im.x = 10;
        im.y = 5;
        _btnLast.addDisplayObject(im);
        _source.addChild(_btnLast);
        _btnLast.x = 310;
        _btnLast.y = 110;
        _btnLast.setEnabled = false;
        _imLast = new Image(g.allData.atlas['partyAtlas'].getTexture('tabs_bt_2'));
        _source.addChild(_imLast);
        _imLast.x = 310;
        _imLast.y = 110;
        _btnLast.clickCallback = function():void {
            _activityType = ManagerPartyNew.TYPE_LAST;
            _imEvent.visible = true;
            _imRating.visible = true;
            _imLast.visible = false;

            _sprEvent.visible = false;
            _sprRating.visible = false;
            _sprLast.visible = true;

            _btnEvent.touchable = true;
            _btnRating.touchable = true;
            _btnLast.touchable = false;
        };
        if (g.managerParty.typeParty == 1 || g.managerParty.typeParty == 2) {
            _btnRating.setEnabled = false;
            _imRating.visible = true;
            _btnLast.setEnabled = false;
            _imLast.visible = true;
        }
    }

    private function eventWO(open:Boolean = true):void {
//        if (g.allData.atlas['partyAtlas']) {
//            g.gameDispatcher.removeEnterFrame(eventWO);
            var im:Image;
            if (g.managerParty.typeParty == 1 || g.managerParty.typeParty == 2) {
                im = new Image(g.allData.atlas['partyAtlas'].getTexture('new_event_window_l'));
                im.x = -10 - im.width;
                im.y = -im.height / 2 + 30;
                _sprEvent.addChild(im);
                if (g.managerParty.typeBuilding == BuildType.ORDER) im = new Image(g.allData.atlas['partyAtlas'].getTexture('new_event_window_r_2'));
                else if (g.managerParty.typeBuilding == BuildType.TRAIN) im = new Image(g.allData.atlas['partyAtlas'].getTexture('new_event_window_r'));
                im.y = -im.height / 2 + 30;
                _sprEvent.addChild(im);
                if (ManagerLanguage.ENGLISH == g.user.language) _imName = new Image(g.allData.atlas['partyAtlas'].getTexture('market_bonus'));
                else _imName = new Image(g.allData.atlas['partyAtlas'].getTexture('market_bonus_rus'));
//                _imName = new Image(g.allData.atlas['partyAtlas'].getTexture('market_bonus_rus'));
                _imName.x = -_imName.width / 2 + 5;
                _imName.y = -205;
                _sprEvent.addChild(_imName);
                _txtTime = new CTextField(120, 60, '    ');
                _txtTime.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_COLOR);
                _txtTime.alignH = Align.LEFT;
                _txtTime.y = 130;
                _sprEvent.addChild(_txtTime);
                g.gameDispatcher.addToTimer(startTimer);
                _txtTimeLost = new CTextField(250, 100, String(g.managerLanguage.allTexts[357]));
                _txtTimeLost.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_COLOR);
                _sprEvent.addChild(_txtTimeLost);
                _txtTimeLost.alignH = Align.LEFT;
                _txtTimeLost.x = -(160 + _txtTimeLost.textBounds.width / 2);
                _txtTimeLost.y = 85;
                _txtBabl = new CTextField(260, 200, String(g.managerParty.description));
                _txtBabl.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_COLOR);
                _sprEvent.addChild(_txtBabl);
                _txtBabl.x = -295;
                _txtBabl.y = -130;
                if (g.managerParty.typeParty == 1) im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_medium'));
                else im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star_medium'));
                MCScaler.scale(im, im.height, im.width);
                im.x = 154;
                im.y = -133;
                _sprEvent.addChild(im);

                _txtCoefficient = new CTextField(172, 200, 'X' + g.managerParty.coefficient);
                _txtCoefficient.setFormat(CTextField.BOLD30, 30, 0xffde00, ManagerFilters.BROWN_COLOR);
                _sprEvent.addChild(_txtCoefficient);
                _txtCoefficient.x = 38;
                _txtCoefficient.y = -214;
            } else {
//                if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID || g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) {
                    im = new Image(g.allData.atlas['partyAtlas'].getTexture('event_window_standard'));
//                } else {
//                    im = new Image(g.allData.atlas['partyAtlas'].getTexture('event_window_independence_day'));
//                }
                im.x = -im.width / 2 - 4;
//                im.y = -im.height / 2 - 12;
                im.y = -im.height / 2 - 6;
                _sprEvent.addChild(im);
                im = new Image(g.allData.atlas['partyAtlas'].getTexture('event_window_baloon'));
                im.x = -im.width / 2 - 295;
                im.y = -im.height / 2 - 115;
                _sprEvent.addChild(im);
                if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID || g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) {
                    _imName = new Image(g.allData.atlas['partyAtlas'].getTexture('cornbread_rus'));
                    _imName.x = -_imName.width / 2 + 41;
                    _imName.y = -211;
                } else {
                    if (ManagerLanguage.ENGLISH == g.user.language) _imName = new Image(g.allData.atlas['partyAtlas'].getTexture('seven_milk_desserts'));
                    else _imName = new Image(g.allData.atlas['partyAtlas'].getTexture('milk_text'));
                    _imName.x = -_imName.width / 2 + 45;
                    _imName.y = -218;
                }

                _sprEvent.addChild(_imName);
                _txtBabl = new CTextField(220, 200, String(g.managerParty.description));
                _txtBabl.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BLUE_COLOR);
                _sprEvent.addChild(_txtBabl);
                _txtBabl.x = -410;
                _txtBabl.y = -225;
                _sprEvent.addChild(_sprItem);
                im = new Image(g.allData.atlas['partyAtlas'].getTexture('progress'));
                im.x = -158;
                im.y = 31;

                _sprEvent.addChild(im);
                if (g.managerParty.typeParty == 3 || g.managerParty.typeParty == 5) {
                    im = new Image(g.allData.atlas['partyAtlas'].getTexture('event_window_w'));
                    im.x = -215;
                    im.y = 17;
                    _sprEvent.addChild(im);

                    im = new Image(g.allData.atlas['partyAtlas'].getTexture('usa_badge'));
                    MCScaler.scale(im, 45, 45);
                    im.x = -199;
                    im.y = 33;
                    _sprEvent.addChild(im);
                } else {
//                    if (g.managerParty.userParty.countResource < g.managerParty.countToGift[4]) {
                        im = new Image(g.allData.atlas['partyAtlas'].getTexture('place_1'));
                        im.x = -59;
                        im.y = 75;
                        _sprEvent.addChild(im);
                        _countLoad = g.userInventory.getCountResourceById(g.managerParty.idResource);
                        _btnMinus = new CButton();
                        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plus_button'));
                        MCScaler.scale(im, 27, 27);
                        _btnMinus.addDisplayObject(im);
                        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('minus'));
                        MCScaler.scale(im, 16, 16);
                        im.x = 6;
                        im.y = 10;
                        _btnMinus.addDisplayObject(im);
                        _btnMinus.x = -79;
                        _btnMinus.y = 125;
                        _sprEvent.addChild(_btnMinus);
                        if (_countLoad <= 1) _btnMinus.setEnabled = false;
                        _btnMinus.clickCallback = onClickMinus;
                        _btnPlus = new CButton();
                        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plus_button'));
                        MCScaler.scale(im, 27, 27);
                        _btnPlus.addDisplayObject(im);
                        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cross'));
                        MCScaler.scale(im, 16, 16);
                        im.x = 6;
                        im.y = 6;
                        _btnPlus.addDisplayObject(im);
                        _btnPlus.x = 50;
                        _btnPlus.y = 125;
                        _sprEvent.addChild(_btnPlus);
                        if (_countLoad <= 0) _btnPlus.setEnabled = false;
                        _btnPlus.clickCallback = onClickPlus;

                        _btnLoad = new CButton();
                        _btnLoad.addButtonTexture(92, 24, CButton.GREEN, true);
                        _txtBtn = new CTextField(92, 24, String(g.managerLanguage.allTexts[294]));
                        _txtBtn.setFormat(CTextField.BOLD18, 14, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
                        _btnLoad.addChild(_txtBtn);
                        _btnLoad.clickCallback = onClickLoad;
                        _btnLoad.y = 198;
                        _sprEvent.addChild(_btnLoad);
                        if (_countLoad <= 0) _btnLoad.setEnabled = false;
                        if (g.allData.getResourceById(g.managerParty.idResource).buildType == BuildType.RESOURCE) {
                            im = new Image(g.allData.atlas[g.allData.getResourceById(g.managerParty.idResource).url].getTexture(g.allData.getResourceById(g.managerParty.idResource).imageShop));
                        } else if (g.allData.getResourceById(g.managerParty.idResource).buildType == BuildType.PLANT) {
                            im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(g.managerParty.idResource).imageShop + '_icon'));
                        }
                        MCScaler.scale(im, 80, 80);
                        im.y = 90;
                        im.x = -im.width / 2;
                        _sprEvent.addChild(im);
                        if (_countLoad > 0) {
                            _countLoad = _countLoad / 2;
                            if (_countLoad <= 0) {
                                _countLoad = 1;
                                _btnMinus.setEnabled = false;
                                _btnPlus.setEnabled = false;
                            } else if (_countLoad == 1) _btnMinus.setEnabled = false;
                        }
                        _txtCountLoad = new CTextField(220, 200, String(_countLoad));
                        _txtCountLoad.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
                        _txtCountLoad.alignH = Align.RIGHT;
                        _sprEvent.addChild(_txtCountLoad);
                        _txtCountLoad.x = -190;
                        _txtCountLoad.y = 60;
//                    }
                }
            }
            _btnParty = new CButton();
            _btnParty.addButtonTexture(172, 45, CButton.YELLOW, true);
            _txtBtn = new CTextField(172, 45, String(g.managerLanguage.allTexts[1029]));
            _txtBtn.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_YELLOW_COLOR);
            _btnParty.addChild(_txtBtn);
            _btnParty.clickCallback = onClickShow;
            _btnParty.y = 255;
            _sprEvent.addChild(_btnParty);
            createExitButton(onClickExit);
            _callbackClickBG = onClickExit;
//        }
        if (open) showItParams(null, null);
    }

    private function ratingWO():void {
        var im:Image;
        var txt:CTextField;
        if (!g.allData.atlas['partyAtlas']) return;
        im = new Image(g.allData.atlas['partyAtlas'].getTexture('tabs_top_2'));
        im.x = -45;
        im.y = 115;
//        _sprRating.addChild(im);

        im = new Image(g.allData.atlas['partyAtlas'].getTexture('best_players_3'));
        im.x = -im.width / 2 - 4;
        im.y = -im.height / 2 + 10;
        _sprRating.addChild(im);

        if (g.user.language == ManagerLanguage.RUSSIAN) im = new Image(g.allData.atlas['partyAtlas'].getTexture('best_players_1'));
        else im = new Image(g.allData.atlas['partyAtlas'].getTexture('best_players_2'));
        im.x = -im.width / 2 + 5;
        im.y = -225;
        _sprRating.addChild(im);
        _scrollSprite = new DefaultVerticalScrollSprite(280, 300, 280, 60);
        _scrollSprite.createScoll(290, 40, 240, g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_line'), g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_c'));
        var item:WOPartyRatingFriend;
        var b:Boolean = true;
        var needHelp:Boolean = false;
        _arrItemRating = [];
        var sp:Sprite = new Sprite();
        _scrollSprite.addNewCell(sp);
        for (var i:int = 0; i < g.managerParty.arrBestPlayers.length; i++) {
            if (b && g.user.userId != g.managerParty.arrBestPlayers[i].userId) b = true;
            else {
                b = false;
                needHelp = true;
            }
            item = new WOPartyRatingFriend(g.managerParty.arrBestPlayers[i], i+1, !b);
            _scrollSprite.addNewCell(item.source);
//            _scrollSprite.y = 10;
            _arrItemRating.push(item);
            b = true;
        }
        checkSocialInfoForArray();
        if (g.managerParty.arrBestPlayers.length < 20 && !needHelp) {
            item = new WOPartyRatingFriend(null, i+1, true);
            _scrollSprite.addNewCell(item.source)
        } else {
            if (!needHelp) {
                item = new WOPartyRatingFriend(null, g.managerParty.playerPosition, true);
                item.source.y = 150;
                item.source.x = -10;
                _sprRating.addChild(item.source)
            }
        }
        _sprRating.addChild(_scrollSprite.source);
        _scrollSprite.source.y = -150;
        _scrollSprite.source.x = -10;
        if (g.allData.getBuildingById(g.managerParty.idDecorBest).buildType == BuildType.DECOR || g.allData.getBuildingById(g.managerParty.idDecorBest).buildType == BuildType.DECOR_FULL_FENСE 
                || g.allData.getBuildingById(g.managerParty.idDecorBest).buildType == BuildType.DECOR_POST_FENCE || g.allData.getBuildingById(g.managerParty.idDecorBest).buildType == BuildType.DECOR_FENCE_ARKA
                || g.allData.getBuildingById(g.managerParty.idDecorBest).buildType == BuildType.DECOR_FENCE_GATE || g.allData.getBuildingById(g.managerParty.idDecorBest).buildType == BuildType.DECOR_TAIL 
                || g.allData.getBuildingById(g.managerParty.idDecorBest).buildType == BuildType.DECOR_POST_FENCE_ARKA)
            im = new Image(g.allData.atlas[g.allData.getBuildingById(g.managerParty.idDecorBest).url].getTexture(g.allData.getBuildingById(g.managerParty.idDecorBest).image));
        else im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.allData.getBuildingById(g.managerParty.idDecorBest).url + '_icon'));
        if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID || g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) {
            im.x = -240;
        } else {
            im.x = -240;
        }
//        im.x = -210;
        im.y = -120;
        _sprRating.addChild(im);
        txt = new CTextField(250, 100, String(g.allData.getBuildingById(g.managerParty.idDecorBest).name));
        txt.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.alignH = Align.LEFT;
        txt.x = -165 - txt.textBounds.width/2;
        _sprRating.addChild(txt);
        if (g.allData.getBuildingById(g.managerParty.idDecorBest).buildType == BuildType.DECOR_ANIMATION) {
            var cSpr:CSprite  = new CSprite();
            _sprRating.addChild(cSpr);
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('animated_decor'));
            cSpr.addChild(im);

            cSpr.hoverCallback = function():void { g.hint.showIt(String(g.managerLanguage.allTexts[339])); };
            cSpr.outCallback = function():void { g.hint.hideIt(); };
            cSpr.x = -120;
            cSpr.y = -120;
        }
        txt = new CTextField(230, 100, String(g.managerLanguage.allTexts[1059]));
        txt.setFormat(CTextField.BOLD18, 18, ManagerFilters.BLUE_COLOR);
        txt.x = -285;
        txt.y = 70;
        _sprRating.addChild(txt);

        var cSp:CSprite  = new CSprite();
        _sprRating.addChild(cSp);
        im = new Image(g.allData.atlas['partyAtlas'].getTexture('hint_button'));
        cSp.addChild(im);

        cSp.hoverCallback = function():void { g.hint.showIt(String(g.managerLanguage.allTexts[1083])); };
        cSp.outCallback = function():void { g.hint.hideIt(); };
        cSp.x = -305;
        cSp.y = 165;


    }

    private function lastWO():void {
        var im:Image;
        if (!g.allData.atlas['partyAtlas']) return;
        im = new Image(g.allData.atlas['partyAtlas'].getTexture('tabs_congratulations'));
        im.x = -im.width / 2 - 4;
        im.y = -im.height / 2 - 8;
        _sprLast.addChild(im);

        if (g.user.language == ManagerLanguage.RUSSIAN) im = new Image(g.allData.atlas['partyAtlas'].getTexture('end_event_title'));
        else im = new Image(g.allData.atlas['partyAtlas'].getTexture('congratulations'));
        im.x = -im.width / 2 + 5;
        im.y = -205;
        _sprLast.addChild(im);
        var spr:Sprite;
        var source:Sprite = new Sprite();
        for (var i:int = 0; i < 5; i++) {
            if (g.managerParty.userParty.countResource >= g.managerParty.countToGift[i]) {
                spr = lastWoItem(g.managerParty.idGift[i], g.managerParty.typeGift[i], g.managerParty.countGift[i]);
                spr.x = (98 * i);
                source.addChild(spr);
            }
        }

        if (g.managerParty.playerPosition <= 5) {
            spr = lastWoItem(g.managerParty.idDecorBest, g.allData.getBuildingById(g.managerParty.idDecorBest).buildType, 1);
            spr.x = (98 * (i));
            source.addChild(spr);
        }
        source.x = -source.width/2+5;
        source.y = 50;
        _sprLast.addChild(source);

        var myPattern:RegExp = /party/;
        var str:String =  String(g.managerLanguage.allTexts[1061]);

        var txt:CTextField = new CTextField(500, 100, String(str.replace(myPattern,g.managerParty.name)));
        txt.setFormat(CTextField.BOLD24, 22, ManagerFilters.BLUE_COLOR);
        txt.alignH = Align.LEFT;
        txt.x = -txt.textBounds.width/2;
        txt.y = -160;
        _sprLast.addChild(txt);

        txt = new CTextField(300, 100, String(g.managerLanguage.allTexts[1060]));
        txt.setFormat(CTextField.BOLD24, 22, ManagerFilters.BLUE_COLOR);
        txt.alignH = Align.LEFT;
        txt.x = -txt.textBounds.width/2;
        txt.y = 120;
        _sprLast.addChild(txt);

        txt = new CTextField(300, 100, String(g.managerLanguage.allTexts[626]));
        txt.setFormat(CTextField.BOLD24, 22, ManagerFilters.BLUE_COLOR);
        txt.alignH = Align.LEFT;
        txt.x = -txt.textBounds.width/2;
        txt.y = -5;
        _sprLast.addChild(txt);

        txt = new CTextField(300, 100, String(g.managerLanguage.allTexts[1064]));
        txt.setFormat(CTextField.BOLD24, 22, ManagerFilters.BLUE_COLOR);
        txt.alignH = Align.LEFT;
        txt.x = -txt.textBounds.width/2;
        txt.y = -105;
        _sprLast.addChild(txt);

        if (g.managerParty.typeParty == 4) txt = new CTextField(300, 100, String(g.managerParty.userParty.countResource + ' ' + g.allData.getResourceById(g.managerParty.idResource).name));
        else txt = new CTextField(300, 100, String(g.managerParty.userParty.countResource + ' ' + g.managerLanguage.allTexts[1065]));
        txt.setFormat(CTextField.BOLD24, 22, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.alignH = Align.LEFT;
        txt.x = -txt.textBounds.width/2;
        txt.y = -50;
        _sprLast.addChild(txt);

    }

    private function lastWoItem(id:int, type:int, countResource:int):Sprite {
        var source:Sprite = new Sprite();
        var im:Image = new Image(g.allData.atlas['partyAtlas'].getTexture('place_1'));
        source.addChild(im);
        var txt:CTextField = new CTextField(119,100,' ');
        txt.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.alignH = Align.RIGHT;
        txt.x = -19;
        txt.y = 35;
        if (id == 1 && type  == 1) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
            source.addChild(im);
            txt.text = String(countResource);
        } else if (id == 2 && type == 2) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
            source.addChild(im);
            txt.text = String(countResource);
        }  else if (type == BuildType.RESOURCE || type == BuildType.INSTRUMENT || type == BuildType.PLANT) {
            im = new Image(g.allData.atlas[g.allData.getResourceById(id).url].getTexture(g.allData.getResourceById(id).imageShop));
            source.addChild(im);
            txt.text = String(countResource);

        } else if (type == BuildType.DECOR_ANIMATION) {
            im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.allData.getBuildingById(id).url + '_icon'));
            source.addChild(im);

        } else if (type == BuildType.DECOR) {
            im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.allData.getBuildingById(id).image +'_icon'));
            source.addChild(im);
        }
        im.pivotX = im.width/2;
        im.pivotY = im.height/2;
        MCScaler.scale(im, 80,80);
        im.x = 59;
        im.y = 59;
        source.addChild(txt);
        return source;
    }

    private function checkSocialInfoForArray():void {
        var userIds:Array = [];
        var p:Someone;

        for (var i:int=0; i < g.managerParty.arrBestPlayers.length; i++) {
            p = g.user.getSomeoneBySocialId(g.managerParty.arrBestPlayers[i].userSocialId);
            if (!p.photo && userIds.indexOf(g.managerParty.arrBestPlayers[i].userSocialId) == -1 && g.managerParty.arrBestPlayers[i].userSocialId != g.user.userSocialId) userIds.push(g.managerParty.arrBestPlayers[i].userSocialId);
            else if (p.photo && g.managerParty.arrBestPlayers[i].userSocialId != g.user.userSocialId) userIds.push(g.managerParty.arrBestPlayers[i].userSocialId);
        }
        if (userIds.length) {
            g.socialNetwork.addEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingInfo);
            g.socialNetwork.getTempUsersInfoById(userIds);
        }
    }

    private function onGettingInfo(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingInfo);
        for (var i:int = 0; i < _arrItemRating.length; i++) {
            (_arrItemRating[i] as WOPartyRatingFriend).updateAvatar();
        }
    }

    override protected function deleteIt():void {
        for (var i:int = 0; i <_arrItem.length; i++) {
            _arrItem[i].deleteIt();
        }
        if (_txtBtn) {
            if (_btn)_btn.removeChild(_txtBtn);
            _txtBtn.deleteIt();
            _txtBtn = null;
        }
        if (_txtBabl) {
            if (_sprEvent) _sprEvent.removeChild(_txtBabl);
            _txtBabl.deleteIt();
            _txtBabl = null;
        }
        if (_txtTime) {
            if (_sprEvent) _sprEvent.removeChild(_txtTime);
            _txtTime.deleteIt();
            _txtTime = null;
        }
        if (_txtTimeLost) {
            if (_sprEvent) _sprEvent.removeChild(_txtTimeLost);
            _txtTimeLost.deleteIt();
            _txtTimeLost = null;
        }
        if (_txtName) {
            if (_sprEvent) _sprEvent.removeChild(_txtName);
            _txtName.deleteIt();
            _txtName = null;
        }
        if (_btn) {
            if (_sprEvent) _sprEvent.removeChild(_btn);
            _btn.deleteIt();
            _btn = null;
        }
        super.deleteIt();
    }

    private function onClickExit(e:Event=null):void {
        g.gameDispatcher.removeFromTimer(startTimer);
        super.hideIt();
    }

    private function onClick():void {
        onClickExit();
    }
}
}
