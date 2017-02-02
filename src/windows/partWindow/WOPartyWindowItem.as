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

public class WOPartyWindowItem {
    public var source:CSprite;
    private var _btn:CButton;
    private var _txtBtn:CTextField;
    private var _txtCount:CTextField;
    private var g:Vars = Vars.getInstance();

    public function WOPartyWindowItem() {
        source = new CSprite();
        _btn = new CButton();
        _btn.addButtonTexture(172, 45, CButton.GREEN, true);
        _txtBtn = new CTextField(110,100,"ВЗЯТЬ");
        _txtBtn.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _btn.addChild(_txtBtn);
//        _btn.clickCallback = onClick;
        source.addChild(_btn);

        _txtCount = new CTextField(110,100,"");
        _txtCount.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        source.addChild(_txtCount);
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
