/**
 * Created by user on 9/29/15.
 */
package build.lockedLand {
import build.AreaObject;
import build.wild.Wild;

import com.junkbyte.console.Cc;

import data.DataMoney;

import flash.geom.Point;

import hint.FlyMessage;

import mouse.ToolsModifier;

import starling.display.Quad;
import starling.display.Sprite;
import starling.filters.BlurFilter;
import starling.filters.ColorMatrixFilter;
import starling.utils.Color;


public class LockedLand extends AreaObject {
    private var _dataLand:Object;
    private var _arrWilds:Array;
    private var _filter:ColorMatrixFilter;

    public function LockedLand(_data:Object) {
        super(_data);
        if (!_data) {
            Cc.error('no data for LockedLand');
            g.woGameError.showIt();
            return;
        }
        _dataLand = g.allData.lockedLandData[_data.dbId];
        if (!_dataLand) {
            Cc.error('no dataLand for LockedLand _data.dbId: ' + _data.dbId);
            g.woGameError.showIt();
            return;
        }
        createBuild(false);

        if (!g.isAway) {
            _source.hoverCallback = onHover;
            _source.endClickCallback = onClick;
            _source.outCallback = onOut;
        }
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

        _arrWilds = [];

        _filter = new ColorMatrixFilter();
        _filter.tint(Color.YELLOW, .5);
    }

    override public function get depth():Number {
        return _depth - 1000;
    }

    public function addWild(w:Wild):void {
        _arrWilds.push(w);
    }

    private function onHover():void {
        if (g.isActiveMapEditor) return;
//        _source.filter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1);
        _source.filter = _filter;
        for (var i:int=0; i<_arrWilds.length; i++) {
            _arrWilds[i].setFilter(_filter);
        }
    }

    private function onClick():void {
        if (g.isActiveMapEditor) return;
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
        if (g.isActiveMapEditor) return;
        _source.filter = null;
        for (var i:int=0; i<_arrWilds.length; i++) {
            _arrWilds[i].setFilter(null);
        }
    }

    public function openIt():void {
        if (_dataLand.currencyCount > 0) g.userInventory.addMoney(DataMoney.SOFT_CURRENCY, -_dataLand.currencyCount);
        if (_dataLand.resourceCount > 0) g.userInventory.addResource(_dataLand.resourceId, -_dataLand.resourceCount);
        g.directServer.removeUserLockedLand(_dataLand.id);
        _dataLand = null;
        g.townArea.deleteBuild(this);
        for (var i:int=0; i<_arrWilds.length; i++) {
            (_arrWilds[i] as Wild).addItToMatrix();
        }
        _arrWilds.length = 0;
    }

    override public function clearIt():void {
        onOut();
        _source.touchable = false;
        _dataLand = null;
        super.clearIt();
    }
}
}
