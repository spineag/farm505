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

import manager.ManagerFilters;

import mouse.ToolsModifier;

import starling.display.Image;

import starling.display.Quad;
import starling.display.Sprite;
import starling.filters.BlurFilter;
import starling.filters.ColorMatrixFilter;
import starling.utils.Color;

import utils.CSprite;

import utils.CreateTile;


public class LockedLand extends AreaObject {
    private var _dataLand:Object;
    private var _arrWilds:Array;
    private var _topRibbon:Sprite;
    private var _bottomRibbon:Sprite;

    public function LockedLand(_data:Object) {
        super(_data);
        if (!_data) {
            Cc.error('no data for LockedLand');
            g.woGameError.showIt();
            return;
        }
        _arrWilds = [];
        _dataLand = g.allData.lockedLandData[_data.dbId];
        if (!_dataLand) {
            Cc.error('no dataLand for LockedLand _data.dbId: ' + _data.dbId);
            g.woGameError.showIt();
            return;
        }
        _build.touchable = false;
        _sizeX = _dataBuild.width;
        _sizeY = _dataBuild.height;

        if (!g.isAway) {
            _source.hoverCallback = onHover;
            _source.endClickCallback = onClick;
            _source.outCallback = onOut;
        }
        _source.releaseContDrag = true;

        var s:Sprite = CreateTile.createSimpleTile(10);
        s.alpha = 0;
        _source.addChild(s);

        _topRibbon = new Sprite();
        _source.addChild(_topRibbon);
        _source.addChild(_build);
        _bottomRibbon = new Sprite();
        _source.addChild(_bottomRibbon);
        createRibbons();
    }

    private function createRibbons():void {
        var im:Image;
        im = new Image(g.allData.atlas['buildAtlas'].getTexture('ribbon_dark_green'));
        im.rotation = -28*Math.PI/180;
        im.x = -367 * g.scaleFactor;
        im.y = 182 * g.scaleFactor;
        _topRibbon.addChild(im);
        im = new Image(g.allData.atlas['buildAtlas'].getTexture('ribbon_dark_green'));
        im.rotation = 24*Math.PI/180;
        im.x = 2 * g.scaleFactor;
        im.y = 4 * g.scaleFactor;
        _topRibbon.addChild(im);
        im = new Image(g.allData.atlas['buildAtlas'].getTexture('bow_dark_green_3'));
        im.x = -36 * g.scaleFactor;
        im.y = -9 * g.scaleFactor;
        _topRibbon.addChild(im);
        _topRibbon.flatten();

        im = new Image(g.allData.atlas['buildAtlas'].getTexture('ribbon_dark_green'));
        im.rotation = 24*Math.PI/180;
        im.x = -338 * g.scaleFactor;
        im.y = 187 * g.scaleFactor;
        _bottomRibbon.addChild(im);
        im = new Image(g.allData.atlas['buildAtlas'].getTexture('ribbon_dark_green'));
        im.rotation = -28*Math.PI/180;
        im.x = -3 * g.scaleFactor;
        im.y = 352 * g.scaleFactor;
        _bottomRibbon.addChild(im);
        im = new Image(g.allData.atlas['buildAtlas'].getTexture('bow_dark_green_2'));
        im.x = -398 * g.scaleFactor;
        im.y = 161 * g.scaleFactor;
        _bottomRibbon.addChild(im);
        im = new Image(g.allData.atlas['buildAtlas'].getTexture('bow_dark_green_2'));
        im.scaleX = -1;
        im.x = 412 * g.scaleFactor;
        im.y = 162 * g.scaleFactor;
        _bottomRibbon.addChild(im);
        im = new Image(g.allData.atlas['buildAtlas'].getTexture('bow_dark_green_1'));
        im.x = -36 * g.scaleFactor;
        im.y = 333 * g.scaleFactor;
        _bottomRibbon.addChild(im);
        _bottomRibbon.flatten();
    }

    override public function get depth():Number {
        return _depth - 1000;
    }

    public function addWild(w:Wild, _x:int, _y:int):void {
        _arrWilds.push(w);
        if (g.isActiveMapEditor) {
            g.cont.contentCont.addChild(w.source);
        } else {
            w.source.x = _x - _source.x;
            w.source.y = _y - _source.y;
            _build.addChild(w.source);
        }
    }

    private function onHover():void {
        if (g.selectedBuild) return;
        if (g.isActiveMapEditor) return;
        _build.filter = ManagerFilters.RED_LIGHT_TINT_FILTER;
        _topRibbon.filter = ManagerFilters.RED_LIGHT_TINT_FILTER;
        _bottomRibbon.filter = ManagerFilters.RED_LIGHT_TINT_FILTER;
    }

    private function onOut():void {
        if (g.isActiveMapEditor) return;
        _build.filter = null;
        _topRibbon.filter = null;
        _bottomRibbon.filter = null;
    }

    private function onClick():void {
        if (g.selectedBuild) return;
        if (g.isActiveMapEditor) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            if (!checkIsFree()) {
                var p0:Point = new Point(g.ownMouse.mouseX, g.ownMouse.mouseY);
                p0.y -= 50;
                new FlyMessage(p0,"Откройте соседние территории");
                return;
            }
            if (g.user.level < _dataLand.blockByLevel) {
                var p:Point = new Point(g.ownMouse.mouseX, g.ownMouse.mouseY);
                p.y -= 50;
                new FlyMessage(p,"Будет доступно на " + String(_dataLand.blockByLevel) + ' уровне');
                return;
            } else {
                g.woLockedLand.showItWithParams(_dataLand, this);
                onOut();
                return;
            }
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }
    }

    public function openIt():void {
        var _x:int = _source.x;
        var _y:int = _source.y;
        if (_dataLand.currencyCount > 0) g.userInventory.addMoney(DataMoney.SOFT_CURRENCY, -_dataLand.currencyCount);
        if (_dataLand.resourceCount > 0) g.userInventory.addResource(_dataLand.resourceId, -_dataLand.resourceCount);
        g.directServer.removeUserLockedLand(_dataLand.id);
        while (_build.numChildren) _build.removeChildAt(0);
        g.townArea.deleteBuild(this);
        for (var i:int=0; i<_arrWilds.length; i++) {
            g.townArea.pasteBuild(_arrWilds[i], _arrWilds[i].source.x + _x, _arrWilds[i].source.y + _y, false, false);
        }
        _dataLand = null;
        _arrWilds.length = 0;
    }

    override public function clearIt():void {
        onOut();
        _source.touchable = false;
        _dataLand = null;
        super.clearIt();
    }

    private function checkIsFree():Boolean {
        var count:int = 0;
        var m:Array = g.townArea.townMatrix;
        if (m[posY-1] && m[posY-1][posX]) {
            if (m[posY-1][posX].build) {
                if (m[posY-1][posX].build is LockedLand) {
                    count++;
                } else {
                    return true;
                }
            } else {
                return true;
            }
        } else {
            count++;
        }

        if (m[posY][posX-1]) {
            if (m[posY][posX-1].build) {
                if (m[posY][posX-1].build is LockedLand) {
                    count++
                } else {
                    return true;
                }
            } else {
                return true;
            }
        } else {
            count++;
        }

        if (m[posY][posX+_sizeX]) {
            if (m[posY][posX+_sizeX].build) {
                if (m[posY][posX+_sizeX].build is LockedLand) {
                    count++
                } else {
                    return true;
                }
            } else {
                return true;
            }
        } else {
            count++;
        }

        if (m[posY+_sizeY] && m[posY+_sizeY][posX]) {
            if (m[posY+_sizeY][posX].build) {
                if (m[posY+_sizeY][posX].build is LockedLand) {
                    count++;
                } else {
                    return true;
                }
            } else {
                return true;
            }
        } else {
            count++;
        }

        return count != 4;
    }

    public function onOpenMapEditor():void {
        for (var i:int=0; i< _arrWilds.length; i++) {
            _build.removeChild(_arrWilds[i].source);
            _arrWilds[i].source.x += _source.x;
            _arrWilds[i].source.y += _source.y;
            g.cont.contentCont.addChild(_arrWilds[i].source);
        }
    }

    public function activateOnMapEditor(w:Wild):void {
        _build.removeChild(w.source);
        w.source.x += _source.x;
        w.source.y += _source.y;
        g.cont.contentCont.addChild(w.source);
        _arrWilds.splice(_arrWilds.indexOf(w), 1);
    }

    public function onCloseMapEditor():void {
        for (var i:int=0; i< _arrWilds.length; i++) {
            g.cont.contentCont.removeChild(_arrWilds[i].source);
            _arrWilds[i].source.x -= _source.x;
            _arrWilds[i].source.y -= _source.y;
            _build.addChild(_arrWilds[i].source);
        }
    }
}
}
