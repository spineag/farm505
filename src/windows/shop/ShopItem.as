/**
 * Created by user on 6/24/15.
 */
package windows.shop {
import build.farm.Farm;

import data.BuildType;

import manager.Vars;

import mouse.ToolsModifier;

import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

public class ShopItem {
    public var source:CSprite;
    private var _bg:Image;
    private var _im:Image;
    private var _nameTxt:TextField;
    private var _countTxt:TextField;
    private var _data:Object;

    private var g:Vars = Vars.getInstance();

    public function ShopItem(data:Object) {
        _data = data;
        source = new CSprite();
        _bg = new Image(g.interfaceAtlas.getTexture('shop_item'));
        source.addChild(_bg);
        if (_data.url == "buildAtlas") {
            _im  = new Image(g.tempBuildAtlas.getTexture(_data.image));
        } else if (_data.url == "treeAtlas") {
            _im = new Image(g.treeAtlas.getTexture(_data.image));
        }
        MCScaler.scale(_im, 100, 100);
        _im.x = 35    + 50 - _im.width/2;
        _im.y = 30    + 50 - _im.height/2;
        source.addChild(_im);

        _nameTxt = new TextField(150, 70, String(_data.name), "Arial", 20, Color.BLACK);
        _nameTxt.x = 7;
        _nameTxt.y = 140;
        source.addChild(_nameTxt);

        _countTxt = new TextField(122, 30, String(_data.cost), "Arial", 16, Color.WHITE);
        _countTxt.x = 22;
        _countTxt.y = 220;
        source.addChild(_countTxt);

        source.endClickCallback = onClick;
    }

    public function clearIt():void {
        while (source.numChildren) {
            source.removeChildAt(0);
        }
    }

    private function onClick():void {
        if (!g.user.checkMoney(_data)) return;
        g.softHardCurrency.deleteSoft(_data.cost);
        if (_data.buildType != BuildType.ANIMAL) {
            g.woShop.hideIt();
            g.toolsModifier.modifierType = ToolsModifier.MOVE;
            g.toolsModifier.startMove(_data, afterMove);
        } else {
            //додаємо на відповідну ферму
            var arr:Array = g.townArea.cityObjects;
            for (var i:int = 0; i < arr.length; i++) {
                if (arr[i] is Farm  &&  arr[i].dataBuild.id == _data.buildId  &&  !arr[i].isFull) {
                    (arr[i] as Farm).addAnimal();
                    return;
                }
            }
            trace('no such Farm :(');
        }
    }

    private function afterMove(_x:Number, _y:Number):void {
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        g.townArea.createNewBuild(_data, _x, _y);
    }


}
}
