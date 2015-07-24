package build.cave {
import build.AreaObject;

import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import com.junkbyte.console.Cc;

import data.BuildType;

import data.DataMoney;

import flash.geom.Point;


import mouse.ToolsModifier;

import resourceItem.CraftItem;

import resourceItem.RawItem;

import resourceItem.ResourceItem;

import starling.display.Image;

import starling.display.Sprite;

import starling.filters.BlurFilter;
import starling.textures.Texture;
import starling.utils.Color;

import windows.cave.WOBuyCave;


public class Cave extends AreaObject{
    private static const UNACTIVE:int = 1;
    private static const ACTIVE:int = 2;

    private var _woBuy:WOBuyCave;
    private var _state:int;

    public function Cave(data:Object) {
        super (data);
        _woBuy = new WOBuyCave();
        _state = UNACTIVE;
        _source.hoverCallback = onHover;
        _source.endClickCallback = onClick;
        _source.outCallback = onOut;
        _dataBuild.isFlip = _flip;

        _craftSprite = new Sprite();
        _source.addChild(_craftSprite);

        g.woCave.fillIt(_dataBuild.idResourceRaw, onItemClick);
    }

    private function onHover():void {
        _source.filter = BlurFilter.createGlow(Color.RED, 10, 2, 1);
        g.hint.showIt(_dataBuild.name, "0");
    }

    private function onOut():void {
        _source.filter = null;
        g.hint.hideIt();
    }

    private function onClick():void {
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            _source.filter = null;
            if (_state == UNACTIVE) {
                _woBuy.showItWithParams(_dataBuild, onBuy);
                g.hint.hideIt();
            } else {
                g.woCave.showIt();
                g.hint.hideIt();
            }
        } else {
            Cc.error('Cave:: unknown g.toolsModifier.modifierType')
        }
    }

    private function onBuy():void {
        g.userInventory.addMoney(DataMoney.SOFT_CURRENCY, _dataBuild.cost);
        _state = ACTIVE;

        while (_build.numChildren) {
            _build.removeChildAt(0);
        }
        var im:Image = new Image(g.tempBuildAtlas.getTexture(_dataBuild.imageActive));
        im.x = _dataBuild.innerX;
        im.y = _dataBuild.innerY;
        _build.addChild(im);
    }

    private function onItemClick(id:int):void {
        var v:Number = _dataBuild.variaty[_dataBuild.idResourceRaw.indexOf(id)];
        var c:int = 2 + int(Math.random()*3);
        var l1:Number = v;
        var l2:Number = (1-l1)*v;
        var l3:Number = (1-l1-l2)/2;
        l3 += l2 + l1;
        l2 += l1;
        var r:Number;
        var craftItem:CraftItem;
        var item:ResourceItem;
        for (var i:int = 0; i < c; i++) {
            r = Math.random();
            if (r < l1) {
                item = new ResourceItem();
                item.fillIt(g.dataResource.objectResources[_dataBuild.idResource[0]]);
                craftItem = new CraftItem(0, 0, item, _craftSprite, 1);
            } else if (r < l2) {
                item = new ResourceItem();
                item.fillIt(g.dataResource.objectResources[_dataBuild.idResource[1]]);
                craftItem = new CraftItem(0, 0, item, _craftSprite, 1);
            } else if (r < l3) {
                item = new ResourceItem();
                item.fillIt(g.dataResource.objectResources[_dataBuild.idResource[2]]);
                craftItem = new CraftItem(0, 0, item, _craftSprite, 1);
            } else {
                item = new ResourceItem();
                item.fillIt(g.dataResource.objectResources[_dataBuild.idResource[3]]);
                craftItem = new CraftItem(0, 0, item, _craftSprite, 1);
            }
        }
    }

}
}
