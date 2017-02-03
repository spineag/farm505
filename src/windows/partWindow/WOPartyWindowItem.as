/**
 * Created by user on 2/2/17.
 */
package windows.partWindow {
import com.greensock.TweenMax;
import com.greensock.easing.Back;

import data.BuildType;

import flash.display.StageDisplayState;

import manager.ManagerFilters;
import manager.Vars;

import starling.core.Starling;
import starling.display.Image;

import starling.utils.Color;

import utils.CButton;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;

public class WOPartyWindowItem {
    public var source:CSprite;
    private var _btn:CButton;
    private var _txtBtn:CTextField;
    private var _txtCountToGift:CTextField;
    private var g:Vars = Vars.getInstance();

    public function WOPartyWindowItem(id:int, type:int, count:int, countToGift:int, number:int) {
        source = new CSprite();
        _btn = new CButton();
        var im:Image;
        if (number == 5) im  = new Image(g.allData.atlas['partyAtlas'].getTexture('place_2'));
        else im  = new Image(g.allData.atlas['partyAtlas'].getTexture('place_1'));
        source.addChild(im);
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
        MCScaler.scale(im, 80,80);
        _btn.addButtonTexture(80, 20, CButton.GREEN, true);
        _txtBtn = new CTextField(80,20,"ВЗЯТЬ");
        _txtBtn.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _btn.addChild(_txtBtn);
        _btn.y = 90;
//        _btn.clickCallback = onClick;
        source.addChild(_btn);

        _txtCountToGift = new CTextField(110,100,String(countToGift));
        _txtCountToGift.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        source.addChild(_txtCountToGift);
    }

//    private function onClick():void {
//        if (int(_itemToday.type) == BuildType.DECOR || int(_itemToday.type) == BuildType.DECOR_ANIMATION) flyItDecor();
//        else new DropItem(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2, _itemToday);
//
//    }
//
//    private function flyItDecor():void {
//        var f1:Function = function (dbId:int):void {
//            g.userInventory.addToDecorInventory(_itemToday.id, dbId);
//            deleteIt();
//        };
//        var f:Function = function ():void {
//            g.directServer.buyAndAddToInventory(_itemToday.id, f1);
//        };
//        var v:Number;
//        if (Starling.current.nativeStage.displayState == StageDisplayState.NORMAL) v = .5;
//        else v = .2;
//        var im:Image;
//        if (int(_itemToday.type) == BuildType.DECOR) im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.dataBuilding.objectBuilding[_itemToday.id].image + '_icon'));
//        else if (int(_itemToday.type) == BuildType.DECOR_ANIMATION) im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.dataBuilding.objectBuilding[_itemToday.id].url + '_icon'));
//        new TweenMax(im, v, {scaleX:.3, scaleY:.3, ease:Back.easeIn, onComplete:f});
//    }
}
}
