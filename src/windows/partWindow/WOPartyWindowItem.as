/**
 * Created by user on 2/2/17.
 */
package windows.partWindow {
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
    private var _btn:CButton;
    private var _txtBtn:CTextField;
    private var _txtCountResource:CTextField;
    private var _txtCountToGift:CTextField;
    private var g:Vars = Vars.getInstance();
    private var _bg:Image;
    private var _data:Object;

    public function WOPartyWindowItem(id:int, type:int, countResource:int, countToGift:int, number:int) {
        source = new CSprite();
        _btn = new CButton();
        _data = {};
        _data.idResource = id;
        _data.typeResource = type;
        _data.countResource = countResource;
        _data.countToGift = countToGift;
        _data.number = number;

        var im:Image;
        if (number == 5) {
            _bg  = new Image(g.allData.atlas['partyAtlas'].getTexture('place_2'));
            _bg.y = -30;
        }
        else _bg  = new Image(g.allData.atlas['partyAtlas'].getTexture('place_1'));
        source.addChild(_bg);
        if (id == 1 && type  == 1) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
            source.addChild(im);
        } else if (id == 2 && type == 2) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
            source.addChild(im);
        }  else if (type == BuildType.RESOURCE || type == BuildType.INSTRUMENT || type == BuildType.PLANT) {
            im = new Image(g.allData.atlas[g.dataResource.objectResources[id].url].getTexture(g.dataResource.objectResources[id].imageShop));
            source.addChild(im);
        } else if (type == BuildType.DECOR_ANIMATION) {
            im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.dataBuilding.objectBuilding[id].url + '_icon'));
            source.addChild(im);

        } else if (type == BuildType.DECOR) {
            im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.dataBuilding.objectBuilding[id].image +'_icon'));
            source.addChild(im);
        }
        im.pivotX = im.width/2;
        im.pivotY = im.height/2;
        MCScaler.scale(im, 80,80);
        if (number == 5) {
            im.x = _bg.width/2;
            im.y = _bg.height/2 - 30;
        } else {
            im.x = _bg.width/2;
            im.y = _bg.height/2;
        }
        _btn.addButtonTexture(80, 20, CButton.GREEN, true);
        _txtBtn = new CTextField(80,20,"ВЗЯТЬ");
        _txtBtn.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _btn.addChild(_txtBtn);
        _btn.y = 120;
        _btn.x = 60;
        _btn.clickCallback = onClick;
        source.addChild(_btn);

        _txtCountResource = new CTextField(119,100,String(countResource));
        _txtCountResource.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtCountResource.alignH = Align.RIGHT;
        _txtCountResource.x = -19;
        if (number == 5) _txtCountResource.y = 35;
        else _txtCountResource.y = 35;
        source.addChild(_txtCountResource);

        _txtCountToGift = new CTextField(119,100,String(countToGift));
        _txtCountToGift.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtCountToGift.y = 93;
        source.addChild(_txtCountToGift);  _txtCountToGift = new CTextField(110,100,String(countToGift));
        var _quad:Quad;
        if (g.managerParty.userParty.countResource > countToGift) _quad = new Quad(20, 28, 0xff3da5);
        else _quad = new Quad(1, 30, 0xff3da5);
        _quad.x = 20;
        _quad.y = 162;
        source.addChild(_quad);

    }

    private function onClick():void {
        var prise:Object = {};
        if (_data.typeResource == BuildType.DECOR_ANIMATION) {
            prise.count = 0;
            prise.id =  _data.idResource;
            prise.type = DropResourceVariaty.DROP_TYPE_DECOR_ANIMATION;
        } else if (_data.typeResource == BuildType.DECOR) {
            prise.count = 0;
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

    private function flyItDecor():void {
        var f1:Function = function (dbId:int):void {
            g.userInventory.addToDecorInventory(_data.idResource, dbId);
            deleteIt();
        };
        var f:Function = function ():void {
            g.directServer.buyAndAddToInventory(_data.idResource, f1);
        };
        var v:Number;
        if (Starling.current.nativeStage.displayState == StageDisplayState.NORMAL) v = .5;
        else v = .2;
        var im:Image;
        if (int(_data.typeResource) == BuildType.DECOR) im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.dataBuilding.objectBuilding[_data.idResource].image + '_icon'));
        else if (int(_data.typeResource) == BuildType.DECOR_ANIMATION) im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.dataBuilding.objectBuilding[_data.idResource].url + '_icon'));
        new TweenMax(im, v, {scaleX:.3, scaleY:.3, ease:Back.easeIn, onComplete:f});
    }

    private function deleteIt():void {

    }
}
}
