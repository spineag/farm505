/**
 * Created by user on 9/29/15.
 */
package build.lockedLand {
import build.AreaObject;

import com.junkbyte.console.Cc;

import data.DataMoney;

import flash.geom.Point;

import hint.FlyMessage;

import mouse.ToolsModifier;

import starling.display.Quad;
import starling.display.Sprite;
import starling.filters.BlurFilter;
import starling.utils.Color;


public class LockedLand extends AreaObject {
    private var _dataLand:Object;
    public function LockedLand(_data:Object) {
        super(_data);
        _dataLand = g.allData.lockedLandData[_data.dbId];
        createBuild(false);

        _source.hoverCallback = onHover;
        _source.endClickCallback = onClick;
        _source.outCallback = onOut;
        _source.releaseContDrag = true;
        deleteIsoView();

        var tempSprite:Sprite = new Sprite();
        var q:Quad = new Quad(60*_dataBuild.width, 60*_dataBuild.width, Color.BLACK);
        q.rotation = Math.PI / 4;
        q.alpha = 0;
        q.y = -45;
        tempSprite.addChild(q);
        tempSprite.scaleY = .5;
        tempSprite.flatten();
        _source.addChildAt(tempSprite, 0);
    }

    private function onHover():void {
        _source.filter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1);
//        g.hint.showIt(_dataBuild.name, "0");
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
            if (g.user.level < _dataLand.blockByLevel) {
                var p:Point = new Point(g.ownMouse.mouseX, g.ownMouse.mouseY);
                p.y -= 50;
                new FlyMessage(p,"Будет доступно на " + String(_dataLand.blockByLevel) + ' уровне');
                return;
            } else {
                g.woLockedLand.showItWithParams(_dataLand, this);
                _source.filter = null;
                return;
            }
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }

    }

    private function onOut():void {
        _source.filter = null;
//        g.hint.hideIt();
    }

    public function openIt():void {
        if (_dataLand.currencyCount > 0) g.userInventory.addMoney(DataMoney.SOFT_CURRENCY, -_dataLand.currencyCount);
        if (_dataLand.resourceCount > 0) g.userInventory.addResource(_dataLand.resourceId, _dataLand.resourceCount);
        g.directServer.removeUserLockedLand(_dataLand.id);
        while (_source.numChildren) {
            _source.removeChildAt(0);
        }
        _dataLand = null;
        g.townArea.deleteBuild(this);
    }

}
}
