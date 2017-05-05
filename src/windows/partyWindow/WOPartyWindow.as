/**
 * Created by user on 1/30/17.
 */
package windows.partyWindow {
import data.BuildType;

import flash.geom.Point;

import manager.ManagerFilters;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;

import starling.events.Event;
import starling.utils.Align;
import starling.utils.Color;

import ui.xpPanel.XPStar;

import utils.CButton;
import utils.CTextField;
import utils.MCScaler;
import utils.TimeUtils;

import windows.WOComponents.Birka;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOPartyWindow extends WindowMain{
    private var _woBG:WindowBackground;
    private var _btn:CButton;
    private var _txtBtn:CTextField;
    private var _txtName:CTextField;
//    private var _data:Object;
    private var _txtCoefficient:CTextField;
    private var _arrItem:Array;
    private var _sprItem:Sprite;
    private var _imTime:Image;
    private var _txtBabl:CTextField;
    private var _txtTime:CTextField;
    private var _txtTimeLost:CTextField;
    private var _time:int;
    private var _btnHint:CButton;
    private var _isHover:Boolean;
    private var _btnMinus:CButton;
    private var _btnPlus:CButton;
    private var _btnLoad:CButton;
    private var _txtCountLoad:CTextField;
    private var _countLoad:int;
    private var _imName:Image;

    public function WOPartyWindow() {
        _windowType = WindowsManager.WO_PARTY;
        _arrItem= [];
        _woHeight = 500;
        _woWidth = 690;
        _isHover = false;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        _sprItem = new Sprite();
        if (!g.allData.atlas['partyAtlas']) {
            g.gameDispatcher.addEnterFrame(checkAtlas);
        } else {
            var im:Image;
            if (g.managerParty.typeParty == 1 || g.managerParty.typeParty == 2) {
                im = new Image(g.allData.atlas['partyAtlas'].getTexture('new_event_window_l'));
                im.x = -10 - im.width;
                im.y = - im.height/2 + 30;
                _source.addChild(im);
                if (g.managerParty.typeBuilding == BuildType.ORDER) im = new Image(g.allData.atlas['partyAtlas'].getTexture('new_event_window_r_2'));
                else if (g.managerParty.typeBuilding == BuildType.TRAIN) im = new Image(g.allData.atlas['partyAtlas'].getTexture('new_event_window_r'));
                im.y = - im.height/2 + 30;
                _source.addChild(im);
                _txtName = new CTextField(_woWidth, 70, String(g.managerParty.name));
                _txtName.setFormat(CTextField.BOLD30, 38, Color.RED, Color.WHITE);
                _txtName.alignH = Align.LEFT;
                _txtName.x = -_txtName.textBounds.width/2;
                _txtName.y = -215;
                _source.addChild(_txtName);
                _txtTime = new CTextField(120,60,'    ');
                _txtTime.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_COLOR);
                _txtTime.alignH = Align.LEFT;
                _txtTime.y = 130;
                _source.addChild(_txtTime);
                g.gameDispatcher.addToTimer(startTimer);
                _txtTimeLost = new CTextField(250,100,String(g.managerLanguage.allTexts[357]));
                _txtTimeLost.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_COLOR);
                _source.addChild(_txtTimeLost);
                _txtTimeLost.alignH = Align.LEFT;
                _txtTimeLost.x = -(160 + _txtTimeLost.textBounds.width/2);
                _txtTimeLost.y = 85;
                _txtBabl = new CTextField(260,200,String(g.managerParty.description));
                _txtBabl.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_COLOR);
                _source.addChild(_txtBabl);
                _txtBabl.x = -295;
                _txtBabl.y = -160;
                if (g.managerParty.typeParty == 1) im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_medium'));
                else im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star_medium'));
                MCScaler.scale(im,im.height,im.width);
                im.x = 154;
                im.y = -133;
                _source.addChild(im);

                _txtCoefficient = new CTextField(172,200,g.managerParty.coefficient +'X');
                _txtCoefficient.setFormat(CTextField.BOLD30, 30, 0xffde00, ManagerFilters.BROWN_COLOR);
                _source.addChild(_txtCoefficient);
                _txtCoefficient.x = 38;
                _txtCoefficient.y = -214;

                _btn = new CButton();
                _btn.addButtonTexture(172, 45, CButton.GREEN, true);
                _txtBtn = new CTextField(172, 45, String(g.managerLanguage.allTexts[328]));
                _txtBtn.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
                _btn.addChild(_txtBtn);
                _btn.clickCallback = onClick;
                _btn.y = 220;
                _source.addChild(_btn);

            } else {
                im = new Image(g.allData.atlas['partyAtlas'].getTexture('event_picnic_window'));
//                im.x = -im.width / 2 - 10;
//                im.y = -im.height / 2;
                im.x = -im.width / 2 - 4;
                im.y = -im.height / 2 - 12;
                _source.addChild(im);
                im = new Image(g.allData.atlas['partyAtlas'].getTexture('event_window_baloon'));
                im.x = -im.width / 2 - 295;
                im.y = -im.height / 2 - 115;
                _source.addChild(im);

//                _txtName = new CTextField(_woWidth, 70, String(g.managerParty.name));
//                _txtName.setFormat(CTextField.BOLD30, 38, Color.RED, Color.WHITE);
//                _txtName.alignH = Align.LEFT;
//                _txtName.x = -_txtName.textBounds.width/2;
//                _txtName.y = -215;
//                _source.addChild(_txtName);
                _imName = new Image(g.allData.atlas['partyAtlas'].getTexture('event_picnic_text'));
                _imName.x = -_imName.width/2 + 5;
                _imName.y = -205;
                _source.addChild(_imName);
                if (g.managerParty.typeParty == 3) {
                    _btn = new CButton();
                    _btn.addButtonTexture(172, 45, CButton.GREEN, true);
                    _txtBtn = new CTextField(172, 45, String(g.managerLanguage.allTexts[328]));
                    _txtBtn.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
                    _btn.addChild(_txtBtn);
                    _btn.clickCallback = onClick;
                    _btn.y = 220;
                    _source.addChild(_btn);
                }
                _txtBabl = new CTextField(220,200,String(g.managerParty.description));
                _txtBabl.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
                _source.addChild(_txtBabl);
                _txtBabl.x = -413;
                _txtBabl.y = -235;
                _source.addChild(_sprItem);
                im = new Image(g.allData.atlas['partyAtlas'].getTexture('progress'));
                im.x = -158;
                im.y = 31;

                _source.addChild(im);
                if (g.managerParty.typeParty == 3) {
                    im = new Image(g.allData.atlas['partyAtlas'].getTexture('event_window_w'));
                    im.x = -215;
                    im.y = 17;
                    _source.addChild(im);

                    im = new Image(g.allData.atlas['partyAtlas'].getTexture('zefir_100'));
                    MCScaler.scale(im, 45, 45);
                    im.x = -199;
                    im.y = 33;
                    _source.addChild(im);
                } else {
                    if (g.managerParty.userParty.countResource < g.managerParty.countToGift[4]) {
                        im = new Image(g.allData.atlas['partyAtlas'].getTexture('place_1'));
                        im.x = -59;
                        im.y = 75;
                        _source.addChild(im);
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
                        _source.addChild(_btnMinus);
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
                        _source.addChild(_btnPlus);
                        if (_countLoad <= 0) _btnPlus.setEnabled = false;
                        _btnPlus.clickCallback = onClickPlus;

                        _btnLoad = new CButton();
                        _btnLoad.addButtonTexture(92, 24, CButton.GREEN, true);
                        _txtBtn = new CTextField(92, 24, String(g.managerLanguage.allTexts[294]));
                        _txtBtn.setFormat(CTextField.BOLD18, 14, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
                        _btnLoad.addChild(_txtBtn);
                        _btnLoad.clickCallback = onClickLoad;
                        _btnLoad.y = 198;
                        _source.addChild(_btnLoad);
                        if (_countLoad <= 0) _btnLoad.setEnabled = false;
                        if (g.allData.getResourceById(g.managerParty.idResource).buildType == BuildType.RESOURCE) {
                            im = new Image(g.allData.atlas[g.allData.getResourceById(g.managerParty.idResource).url].getTexture(g.allData.getResourceById(g.managerParty.idResource).imageShop));
                        } else if (g.allData.getResourceById(g.managerParty.idResource).buildType == BuildType.PLANT) {
                            im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(g.managerParty.idResource).imageShop + '_icon'));
                        }
                        MCScaler.scale(im, 80, 80);
                        im.y = 90;
                        im.x = -im.width / 2;
                        _source.addChild(im);
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
                        _source.addChild(_txtCountLoad);
                        _txtCountLoad.x = -190;
                        _txtCountLoad.y = 60;
                    }
                }
            }
            createExitButton(onClickExit);
            _callbackClickBG = onClickExit;
        }
    }

    private function checkAtlas():void {
        if (g.allData.atlas['partyAtlas']) {
            g.gameDispatcher.removeEnterFrame(checkAtlas);
            var im:Image;
            if (g.managerParty.typeParty == 1 || g.managerParty.typeParty == 2) {
                im = new Image(g.allData.atlas['partyAtlas'].getTexture('new_event_window_l'));
                im.x = -10 - im.width;
                im.y = -im.height / 2 + 30;
                _source.addChild(im);
                if (g.managerParty.typeBuilding == BuildType.ORDER) im = new Image(g.allData.atlas['partyAtlas'].getTexture('new_event_window_r_2'));
                else if (g.managerParty.typeBuilding == BuildType.TRAIN) im = new Image(g.allData.atlas['partyAtlas'].getTexture('new_event_window_r'));
                im.y = -im.height / 2 + 30;
                _source.addChild(im);
                _txtName = new CTextField(_woWidth, 70, String(g.managerParty.name));
                _txtName.setFormat(CTextField.BOLD30, 38, Color.RED, Color.WHITE);
                _txtName.alignH = Align.LEFT;
                _txtName.x = -_txtName.textBounds.width/2;
                _txtName.y = -215;
                _source.addChild(_txtName);
                _txtTime = new CTextField(120, 60, '    ');
                _txtTime.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_COLOR);
                _txtTime.alignH = Align.LEFT;
                _txtTime.y = 130;
                _source.addChild(_txtTime);
                g.gameDispatcher.addToTimer(startTimer);
                _txtTimeLost = new CTextField(250, 100, String(g.managerLanguage.allTexts[357]));
                _txtTimeLost.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_COLOR);
                _source.addChild(_txtTimeLost);
                _txtTimeLost.alignH = Align.LEFT;
                _txtTimeLost.x = -(160 + _txtTimeLost.textBounds.width / 2);
                _txtTimeLost.y = 85;
                _txtBabl = new CTextField(260, 200, String(g.managerParty.description));
                _txtBabl.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_COLOR);
                _source.addChild(_txtBabl);
                _txtBabl.x = -295;
                _txtBabl.y = -160;
                if (g.managerParty.typeParty == 1) im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_medium'));
                else im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star_medium'));
                MCScaler.scale(im, im.height, im.width);
                im.x = 154;
                im.y = -133;
                _source.addChild(im);

                _txtCoefficient = new CTextField(172, 200, g.managerParty.coefficient + 'X');
                _txtCoefficient.setFormat(CTextField.BOLD30, 30, 0xffde00, ManagerFilters.BROWN_COLOR);
                _source.addChild(_txtCoefficient);
                _txtCoefficient.x = 38;
                _txtCoefficient.y = -214;

                _btn = new CButton();
                _btn.addButtonTexture(172, 45, CButton.GREEN, true);
                _txtBtn = new CTextField(172, 45, String(g.managerLanguage.allTexts[328]));
                _txtBtn.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
                _btn.addChild(_txtBtn);
                _btn.clickCallback = onClick;
                _btn.y = 220;
                _source.addChild(_btn);

            } else {
                im = new Image(g.allData.atlas['partyAtlas'].getTexture('event_picnic_window'));
                im.x = -im.width / 2 - 4;
                im.y = -im.height / 2 - 12;
                _source.addChild(im);
                im = new Image(g.allData.atlas['partyAtlas'].getTexture('event_window_baloon'));
                im.x = -im.width / 2 - 295;
                im.y = -im.height / 2 - 115;
                _source.addChild(im);

//                _txtName = new CTextField(_woWidth, 70, String(g.managerParty.name));
//                _txtName.setFormat(CTextField.BOLD30, 38, Color.RED, Color.WHITE);
//                _txtName.alignH = Align.LEFT;
//                _txtName.x = -_txtName.textBounds.width/2;
//                _txtName.y = -215;
//                _source.addChild(_txtName);
                _imName = new Image(g.allData.atlas['partyAtlas'].getTexture('event_picnic_text'));
                _imName.x = -_imName.width/2 + 5;
                _imName.y = -205;
                _source.addChild(_imName);
                if (g.managerParty.typeParty == 3) {
                    _btn = new CButton();
                    _btn.addButtonTexture(172, 45, CButton.GREEN, true);
                    _txtBtn = new CTextField(172, 45, String(g.managerLanguage.allTexts[328]));
                    _txtBtn.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
                    _btn.addChild(_txtBtn);
                    _btn.clickCallback = onClick;
                    _btn.y = 220;
                    _source.addChild(_btn);
                }
                _txtBabl = new CTextField(220,200,String(g.managerParty.description));
                _txtBabl.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
                _source.addChild(_txtBabl);
                _txtBabl.x = -413;
                _txtBabl.y = -235;
                _source.addChild(_sprItem);
                im = new Image(g.allData.atlas['partyAtlas'].getTexture('progress'));
                im.x = -158;
                im.y = 31;
                _source.addChild(im);
                if (g.managerParty.typeParty == 3) {
                    im = new Image(g.allData.atlas['partyAtlas'].getTexture('event_window_w'));
                    im.x = -215;
                    im.y = 17;
                    _source.addChild(im);

                    im = new Image(g.allData.atlas['partyAtlas'].getTexture('zefir_100'));
                    MCScaler.scale(im, 45, 45);
                    im.x = -199;
                    im.y = 33;
                    _source.addChild(im);
                } else {
                    if (g.managerParty.userParty.countResource < g.managerParty.countToGift[4]) {
                        im = new Image(g.allData.atlas['partyAtlas'].getTexture('place_1'));
                        im.x = -59;
                        im.y = 95;
                        _source.addChild(im);
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
                        _btnMinus.y = 145;
                        _source.addChild(_btnMinus);
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
                        _btnPlus.y = 145;
                        _source.addChild(_btnPlus);
                        if (_countLoad <= 0) _btnPlus.setEnabled = false;
                        _btnPlus.clickCallback = onClickPlus;

                        _btnLoad = new CButton();
                        _btnLoad.addButtonTexture(92, 24, CButton.GREEN, true);
                        _txtBtn = new CTextField(92, 24, String(g.managerLanguage.allTexts[294]));
                        _txtBtn.setFormat(CTextField.BOLD18, 14, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
                        _btnLoad.addChild(_txtBtn);
                        _btnLoad.clickCallback = onClickLoad;
                        _btnLoad.y = 205;
                        _source.addChild(_btnLoad);
                        if (_countLoad <= 0) _btnLoad.setEnabled = false;
                        if (g.allData.getResourceById(g.managerParty.idResource).buildType == BuildType.RESOURCE) {
                            im = new Image(g.allData.atlas[g.allData.getResourceById(g.managerParty.idResource).url].getTexture(g.allData.getResourceById(g.managerParty.idResource).imageShop));
                        } else if (g.allData.getResourceById(g.managerParty.idResource).buildType == BuildType.PLANT) {
                            im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(g.managerParty.idResource).imageShop + '_icon'));
                        }
                        MCScaler.scale(im, 80, 80);
                        im.y = 110;
                        im.x = -im.width / 2;
                        _source.addChild(im);
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
                        _source.addChild(_txtCountLoad);
                        _txtCountLoad.x = -190;
                        _txtCountLoad.y = 80;
                    }
                }
            }
            createExitButton(onClickExit);
            _callbackClickBG = onClickExit;
            showItParams(null,null);
        }
    }

    private function onHoverHint():void {
        if (_isHover) return;
        _isHover = true;
        g.hint.showIt(String(g.managerLanguage.allTexts[356]));
    }

    private function onOutHint():void {
        g.hint.hideIt();
        _isHover = false;
    }

    private function onClickHint():void {
        g.hint.hideIt();
        g.windowsManager.cashWindow = this;
        g.windowsManager.openWindow(WindowsManager.WO_PARTY_HELP,null);
        onClickExit();
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
        if (_countLoad > 0 && g.managerParty.userParty.countResource < g.managerParty.countToGift[4]) {
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
        if (!g.allData.atlas['partyAtlas']) return;
        if (g.managerParty.typeParty == 1 || g.managerParty.typeParty == 2) {
            super.showIt();
            return;
        }
//        _data = g.managerParty.dataParty;
//        _txtName = new CTextField(500, 70, String(g.managerParty.name));
//        _txtName.setFormat(CTextField.BOLD30, 38, Color.RED, Color.WHITE);
//        _txtName.alignH = Align.LEFT;
//        _txtName.x = -170;
//        _txtName.y = -215;
//        _source.addChild(_txtName);
//        _source.addChild(_sprItem);
        var item:WOPartyWindowItem;
        for (var i:int = 0; i < 5; i++) {
            item = new WOPartyWindowItem(g.managerParty.idGift[i], g.managerParty.typeGift[i], g.managerParty.countGift[i],  g.managerParty.countToGift[i], i+1);
            item.source.x = (98 * i);
//            item.source.y = -70;
            _sprItem.addChild(item.source);
            _arrItem.push(item);
        }

        _imTime = new Image(g.allData.atlas['partyAtlas'].getTexture('valik_timer'));
        _imTime.x = 275;
        _imTime.y = -205;
        _source.addChild(_imTime);
        _sprItem.x = -195;
        _sprItem.y = -125;

        _txtTimeLost = new CTextField(120,60,String(g.managerLanguage.allTexts[357]));
        _txtTimeLost.setFormat(CTextField.BOLD18, 16, 0xff7575);
        _source.addChild(_txtTimeLost);
        _txtTimeLost.x = 287;
        _txtTimeLost.y = -183;
        _txtTime = new CTextField(120,60,'');
        _txtTime.setFormat(CTextField.BOLD18, 24, 0xd30102);
        _txtTime.x = 286;
        _txtTime.y = -150;
        _source.addChild(_txtTime);
        g.gameDispatcher.addToTimer(startTimer);

//        _txtBabl = new CTextField(172,200,String(g.managerParty.description));
//        _txtBabl.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
//        _source.addChild(_txtBabl);
//        _txtBabl.x = -365;
//        _txtBabl.y = -215;

//        _txtTimeLost = new CTextField(120,60,String(g.managerLanguage.allTexts[357]));
//        _txtTimeLost.setFormat(CTextField.BOLD18, 16, 0xff7575);
//        _source.addChild(_txtTimeLost);
//        _txtTimeLost.x = 287;
//        _txtTimeLost.y = -163;
//
//        var im:Image = new Image(g.allData.atlas['partyAtlas'].getTexture('progress'));
//        im.x = -230;
//        im.y = 40;
//        _source.addChild(im);
//
//        im = new Image(g.allData.atlas['partyAtlas'].getTexture('tulip_icon'));
//        im.x = -215;
//        im.y = 55;
//        MCScaler.scale(im,45,45);
//        _source.addChild(im);
//        var date:Date = new Date();
//        var dateClose:int = new Date(g.managerParty.dataParty.timeToEnd * 1000).dateUTC;
        super.showIt();
    }

    private function startTimer():void {
        if (g.userTimer.partyToEndTimer > 0) {
            if (_txtTime)_txtTime.text = TimeUtils.convertSecondsForHint(g.userTimer.partyToEndTimer);
            if (g.managerParty.typeParty == 1 || g.managerParty.typeParty == 2 && _txtTime.x == 0) _txtTime.x = -(160 + _txtTime.textBounds.width/2);
        } else {
            onClickExit();
            g.gameDispatcher.removeFromTimer(startTimer);
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
            if (_source) _source.removeChild(_txtBabl);
            _txtBabl.deleteIt();
            _txtBabl = null;
        }
        if (_txtTime) {
            if (_source) _source.removeChild(_txtTime);
            _txtTime.deleteIt();
            _txtTime = null;
        }
        if (_txtTimeLost) {
            if (_source) _source.removeChild(_txtTimeLost);
            _txtTimeLost.deleteIt();
            _txtTimeLost = null;
        }
        if (_txtName) {
            if (_source) _source.removeChild(_txtName);
            _txtName.deleteIt();
            _txtName = null;
        }
//        if (_btnHint) {
//            if (_source) _source.removeChild(_btnHint);
//            _btnHint.deleteIt();
//            _btnHint = null;
//        }
        if (_btn) {
            if (_source) _source.removeChild(_btn);
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
