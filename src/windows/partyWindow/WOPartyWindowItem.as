/**
 * Created by user on 2/2/17.
 */
package windows.partyWindow {
import com.greensock.TweenMax;
import com.greensock.easing.Back;

import data.BuildType;
import data.DataMoney;

import flash.display.StageDisplayState;

import manager.ManagerFilters;
import manager.Vars;

import resourceItem.DropItem;

import starling.core.Starling;
import starling.display.Image;
import starling.display.Quad;
import starling.utils.Align;

import starling.utils.Color;

import temp.DropResourceVariaty;

import utils.CButton;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;

public class WOPartyWindowItem {
    public var source:CSprite;
    private var _sprItem:CSprite;
    private var _btn:CButton;
    private var _txtBtn:CTextField;
    private var _txtCountResource:CTextField;
    private var _txtCountToGift:CTextField;
    private var _txtCountUser:CTextField;
    private var g:Vars = Vars.getInstance();
    private var _bg:Image;
    private var _data:Object;
    private var _imCheck:Image;

    public function WOPartyWindowItem(id:int, type:int, countResource:int, countToGift:int, number:int) {
        source = new CSprite();
        _sprItem = new CSprite();
        _btn = new CButton();
        _data = {};
        _data.idResource = id;
        _data.typeResource = type;
        _data.countResource = countResource;
        _data.countToGift = countToGift;
        _data.number = number;

        _txtCountResource = new CTextField(119,100,' ');
        _txtCountResource.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtCountResource.alignH = Align.RIGHT;
        _txtCountResource.x = -19;
        if (number == 5) _txtCountResource.y = 35;
        else _txtCountResource.y = 35;
        var im:Image;
//        if (number == 5) {
//            _bg  = new Image(g.allData.atlas['partyAtlas'].getTexture('place_2'));
//            _bg.y = -30;
//        }
//        else _bg  = new Image(g.allData.atlas['partyAtlas'].getTexture('place_1'));
        _bg  = new Image(g.allData.atlas['partyAtlas'].getTexture('place_1'));
        source.addChild(_bg);
        if (id == 1 && type  == 1) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
            _sprItem.addChild(im);
            _txtCountResource.text = String(countResource);
        } else if (id == 2 && type == 2) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
            _sprItem.addChild(im);
            _txtCountResource.text = String(countResource);
        }  else if (type == BuildType.RESOURCE || type == BuildType.INSTRUMENT || type == BuildType.PLANT) {
            im = new Image(g.allData.atlas[g.allData.getResourceById(id).url].getTexture(g.allData.getResourceById(id).imageShop));
            _sprItem.addChild(im);
            _txtCountResource.text = String(countResource);
            _sprItem.hoverCallback = function():void { g.hint.showIt(String(g.allData.getResourceById(id).name)); };
            _sprItem.outCallback = function():void { g.hint.hideIt(); };
        } else if (type == BuildType.DECOR_ANIMATION) {
            im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.allData.getBuildingById(id).url + '_icon'));
            _sprItem.addChild(im);
            _sprItem.hoverCallback = function():void { g.hint.showIt(String(g.allData.getBuildingById(id).name)); };
            _sprItem.outCallback = function():void { g.hint.hideIt(); };
        } else if (type == BuildType.DECOR) {
            im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.allData.getBuildingById(id).image +'_icon'));
            _sprItem.addChild(im);
            _sprItem.hoverCallback = function():void { g.hint.showIt(String(g.allData.getBuildingById(id).name)); };
            _sprItem.outCallback = function():void { g.hint.hideIt(); };

        }
        im.pivotX = im.width/2;
        im.pivotY = im.height/2;
        MCScaler.scale(im, 80,80);
        source.addChild(_sprItem);

//        if (number == 5) {
//            im.x = _bg.width/2;
//            im.y = _bg.height/2 - 30;
//        } else {
            im.x = _bg.width/2;
            im.y = _bg.height/2;
//        }
        _btn.addButtonTexture(80, 20, CButton.GREEN, true);
        _txtBtn = new CTextField(80,20,String(g.managerLanguage.allTexts[358]));
        _txtBtn.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _btn.addChild(_txtBtn);
        _btn.y = 120;
        _btn.x = 60;
        _btn.clickCallback = onClick;
        if (!Boolean(g.managerParty.userParty.tookGift[_data.number - 1]) && g.managerParty.userParty.countResource >= _data.countToGift)  {
            _btn.setEnabled = true;
        } else if (Boolean(g.managerParty.userParty.tookGift[_data.number - 1])) {
            _btn.setEnabled = false;
            _btn.visible = false;
            _imCheck = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
            _imCheck.x = 45;
            _imCheck.y = 106;
            source.addChild(_imCheck);
        } else _btn.setEnabled = false;

        source.addChild(_btn);


        source.addChild(_txtCountResource);

        _txtCountToGift = new CTextField(119,100,String(countToGift));
        _txtCountToGift.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtCountToGift.y = 93;
        source.addChild(_txtCountToGift);

        _txtCountUser = new CTextField(119,100,String(g.managerParty.userParty.countResource));
        _txtCountUser.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.PURPLE_COLOR);
        _txtCountUser.y = 130;
        if (_txtCountUser) {
            if (number == 1) {
                _txtCountUser.x = 22;
            } else if (number == 2) {
                _txtCountUser.x = 15;
            } else if (number == 3) {
                _txtCountUser.x = 10;
            } else if (number == 4) {
//                _txtCountUser.x = 1;
            }else if (number == 5) {
                _txtCountUser.x = -6;
            }
        }
        var _quad:Quad;
        var width:int;
        if (number > 1) {
            width = ((100 * (g.managerParty.userParty.countResource - g.managerParty.countToGift[number - 2])) / (countToGift - g.managerParty.countToGift[number -2])) * .75;

        } else width = (100 * g.managerParty.userParty.countResource / countToGift) * .75;
        if (g.managerParty.userParty.countResource > countToGift) {
            _quad = new Quad(75, 30, 0xff3da5);
            _quad.y = 165;
            source.addChild(_quad);
        }
        else if (number != 1 && g.managerParty.userParty.countResource > g.managerParty.countToGift[number - 2]) {
//            width = 1;
            if (width > 0) {
                _quad = new Quad(width, 30, 0xff3da5);
                _quad.x = 20;
                _quad.y = 165;
                source.addChild(_quad);
            }
            source.addChild(_txtCountUser);

        } else if (number == 1 && g.managerParty.userParty.countResource > 0) {
            if (width > 0) {
                _quad = new Quad(width, 30, 0xff3da5);
                _quad.x = 20;
                _quad.y = 165;
                source.addChild(_quad);
            }
            source.addChild(_txtCountUser);
        }
        if (number == 1 && g.managerParty.userParty.countResource == 0) {
            source.addChild(_txtCountUser);
        }
        if (number == 5 && g.managerParty.userParty.countResource > countToGift) {
            source.addChild(_txtCountUser);
        }
        if (_quad) {
            if (number == 1) {
                _quad.x = 50;
            } else if (number == 2) {
                _quad.x = 43;
            } else if (number == 3) {
                _quad.x = 36;
            } else if (number == 4) {
                _quad.x = 28;
            }else if (number == 5) {
                _quad.x = 20;
            }
        }
    }

    public function reload():void {
        source.removeChild(_imCheck);
        source.removeChild(_btn);
        source.removeChild(_txtCountResource);
        source.removeChild(_txtCountToGift);
        source.removeChild(_txtCountUser);
        if (!Boolean(g.managerParty.userParty.tookGift[_data.number - 1]) && g.managerParty.userParty.countResource >= _data.countToGift)  {
            _btn.setEnabled = true;
        } else if (Boolean(g.managerParty.userParty.tookGift[_data.number - 1])) {
            _btn.setEnabled = false;
            _btn.visible = false;
            _imCheck = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
            _imCheck.x = 45;
            _imCheck.y = 106;
            source.addChild(_imCheck);
        } else _btn.setEnabled = false;
        source.addChild(_btn);
        source.addChild(_txtCountResource);
        _txtCountToGift = new CTextField(119,100,String(_data.countToGift));
        _txtCountToGift.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtCountToGift.y = 93;
        source.addChild(_txtCountToGift);
        _txtCountUser = new CTextField(119,100,String(g.managerParty.userParty.countResource));
        _txtCountUser.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.PURPLE_COLOR);
        _txtCountUser.y = 130;
        if (_txtCountUser) {
            if (_data.number == 1) {
                _txtCountUser.x = 18;
            } else if (_data.number == 2) {
                _txtCountUser.x = 11;
            } else if (_data.number == 3) {
                _txtCountUser.x = 5;
            } else if (_data.number == 4) {
                _txtCountUser.x = -3;
            }else if (_data.number == 5) {
                _txtCountUser.x = -11;
            }
        }
        var _quad:Quad;
        var width:int;
        if (_data.number > 1) {
            width = ((100 * (g.managerParty.userParty.countResource - g.managerParty.countToGift[_data.number - 2])) / (_data.countToGift - g.managerParty.countToGift[_data.number -2])) * .75;

        } else width = (100 * g.managerParty.userParty.countResource / _data.countToGift) * .75;
        if (g.managerParty.userParty.countResource > _data.countToGift) {
            _quad = new Quad(75, 30, 0xff3da5);
            _quad.y = 165;
            source.addChild(_quad);
        }
        else if (_data.number != 1 && g.managerParty.userParty.countResource > g.managerParty.countToGift[_data.number - 2]) {
//            width = 1;
            if (width > 0) {
                _quad = new Quad(width, 30, 0xff3da5);
                _quad.x = 20;
                _quad.y = 165;
                source.addChild(_quad);
            }
            source.addChild(_txtCountUser);

        } else if (_data.number == 1 && g.managerParty.userParty.countResource > 0) {
            if (width > 0) {
                _quad = new Quad(width, 30, 0xff3da5);
                _quad.x = 20;
                _quad.y = 165;
                source.addChild(_quad);
            }
            source.addChild(_txtCountUser);
        }
        if (_data.number == 1 && g.managerParty.userParty.countResource == 0) {
            source.addChild(_txtCountUser);
        }
        if (_data.number == 5 && g.managerParty.userParty.countResource > _data.countToGift) {
            source.addChild(_txtCountUser);
        }
        if (_quad) {
            if (_data.number == 1) {
                _quad.x = 44;
            } else if (_data.number == 2) {
                _quad.x = 37;
            } else if (_data.number == 3) {
                _quad.x = 31;
            } else if (_data.number == 4) {
                _quad.x = 23;
            }else if (_data.number == 5) {
                _quad.x = 16;
            }
        }
    }

    private function onClick():void {
        _btn.setEnabled = false;
        g.managerParty.userParty.tookGift[_data.number - 1] = 1;
        var st:String = g.managerParty.userParty.tookGift[0] + '&' + g.managerParty.userParty.tookGift[1] + '&' + g.managerParty.userParty.tookGift[2] + '&'
                + g.managerParty.userParty.tookGift[3] + '&' + g.managerParty.userParty.tookGift[4];
        g.directServer.updateUserParty(st,g.managerParty.userParty.countResource,0, null);
        var prise:Object = {};
        if (_data.typeResource == BuildType.DECOR_ANIMATION) {
            prise.count = 1;
            prise.id =  _data.idResource;
            prise.type = DropResourceVariaty.DROP_TYPE_DECOR_ANIMATION;
        } else if (_data.typeResource == BuildType.DECOR) {
            prise.count = 1;
            prise.id =  _data.idResource;
            prise.type = DropResourceVariaty.DROP_TYPE_DECOR;
        } else {
            if (_data.idResource == 1 && _data.typeResource == 1) {
                prise.id = DataMoney.SOFT_CURRENCY;
                prise.type = DropResourceVariaty.DROP_TYPE_MONEY;
            }
            else if (_data.idResource == 2 && _data.typeResource == 2) {
                prise.id = DataMoney.HARD_CURRENCY;
                prise.type = DropResourceVariaty.DROP_TYPE_MONEY;
            }
            else {
                prise.id = _data.idResource;
                prise.type = DropResourceVariaty.DROP_TYPE_RESOURSE;

            }
            prise.count = _data.countResource;
        }
        new DropItem(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2, prise);
    }

    public function deleteIt():void {
        if (_txtBtn) {
            if (_btn) _btn.removeChild(_txtBtn);
            _txtBtn.deleteIt();
            _txtBtn = null;
        }
        if (_btn) {
            source.removeChild(_btn);
            _btn.deleteIt();
            _btn = null;
        }
        if (_txtCountResource) {
            if (source) source.removeChild(_txtCountResource);
            _txtCountResource.deleteIt();
            _txtCountResource = null;
        }
        if (_txtCountToGift) {
            if (source) source.removeChild(_txtCountToGift);
            _txtCountToGift.deleteIt();
            _txtCountToGift = null;
        }
        if(_txtCountUser) {
            if (source) source.removeChild(_txtCountUser);
            _txtCountUser.deleteIt();
            _txtCountUser = null;
        }
        if(_bg) {
            _bg = null;
        }
        if (_data) {
            _data = null;
        }
    }
}
}
