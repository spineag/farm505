/**
 * Created by user on 9/29/15.
 */
package build.lockedLand {
import build.WorldObject;
import build.wild.Wild;
import com.greensock.TweenMax;
import com.junkbyte.console.Cc;
import data.DataMoney;
import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.events.AnimationEvent;
import flash.geom.Point;
import hint.FlyMessage;
import manager.ManagerFilters;
import mouse.ToolsModifier;
import starling.display.Image;
import starling.display.Sprite;
import utils.CreateTile;
import windows.WindowsManager;

public class LockedLand extends WorldObject {
    private var _dataLand:Object;
    private var _arrWilds:Array;
    private var _topRibbon:Sprite;
    private var _bottomRibbon:Sprite;
    private var _armatureOpen:Armature;
    private var _contOpen:Sprite;
    public function LockedLand(_data:Object) {
        super(_data);
        if (!_data) {
            Cc.error('no data for LockedLand');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'no data for LockedLand');
            return;
        }
        _arrWilds = [];
        _dataLand = g.allData.lockedLandData[_data.dbId];
        if (!_dataLand) {
            Cc.error('no dataLand for LockedLand _data.dbId: ' + _data.dbId);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'no dataLand');
            return;
        }
        _build.touchable = false;
        _sizeX = _dataBuild.width;
        _sizeY = _dataBuild.height;

        _source.releaseContDrag = true;
        _contOpen = new Sprite();

        var s:Sprite = CreateTile.createSimpleTile(10);
        s.alpha = 0;
        _source.addChild(s);

        _topRibbon = new Sprite();
        _source.addChild(_topRibbon);
        _source.addChild(_build);
        _bottomRibbon = new Sprite();
        _source.addChild(_bottomRibbon);
        createRibbons();

        if (!g.isAway) {
            _source.hoverCallback = onHover;
            _source.endClickCallback = onClick;
            _source.outCallback = onOut;
        }
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
        return _depth;
    }

    public function addWild(w:Wild, _x:int, _y:int):void {
        _arrWilds.push(w);
        if (g.isActiveMapEditor) {
            g.cont.contentCont.addChild(w.source);
        } else {
            w.source.x = _x - _source.x;
            w.source.y = _y - _source.y;
            w.updateDepth();
            _build.addChild(w.source);
        }
    }

    public function sortWilds():void {
        if (g.isActiveMapEditor) return;
        _arrWilds.sortOn('depth', Array.NUMERIC);
        for (var i:int = 0; i < _arrWilds.length; i++) {
            _build.setChildIndex(_arrWilds[i].source, i);
        }
    }

    override public function onHover():void {
        if (g.selectedBuild) return;
        super.onHover();
        if (g.managerTutorial.isTutorial && !g.managerTutorial.isTutorialBuilding(this)) return;
        if (g.isActiveMapEditor) return;
        _build.filter = ManagerFilters.RED_LIGHT_TINT_FILTER;
        _topRibbon.filter = ManagerFilters.RED_LIGHT_TINT_FILTER;
        _bottomRibbon.filter = ManagerFilters.RED_LIGHT_TINT_FILTER;
    }

    override public function onOut():void {
        super.onOut();
        if (g.managerTutorial.isTutorial && !g.managerTutorial.isTutorialBuilding(this)) return;
        if (g.isActiveMapEditor) return;
        _build.filter = null;
        if (_topRibbon) _topRibbon.filter = null;
        if (_bottomRibbon) _bottomRibbon.filter = null;
    }

    private function onClick():void {
        if (g.managerTutorial.isTutorial) return;
        if (g.managerCutScenes.isCutScene) return;
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
                onOut();
                g.windowsManager.openWindow(WindowsManager.WO_LOCKED_LAND, null, _dataLand, this);
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
            (_arrWilds[i] as Wild).removeLockedLand();
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

    public function showBoom():void {
        onEndAnimation();
        _build.addChild(_contOpen);
        _armatureOpen = g.allData.factory['explode'].buildArmature("expl");
        _armatureOpen.display.scaleX = _armatureOpen.display.scaleY = 1.5;
        _armatureOpen.display.x = 10;
        _armatureOpen.display.y = _source.height/2 - 20;
        _contOpen.addChild(_armatureOpen.display as Sprite);
        WorldClock.clock.add(_armatureOpen);
        _armatureOpen.addEventListener(AnimationEvent.COMPLETE, onBoom);
        _armatureOpen.addEventListener(AnimationEvent.LOOP_COMPLETE, onBoom);
        _armatureOpen.animation.gotoAndPlay("start");
    }

    private function onEndAnimation():void {
        TweenMax.to(_bottomRibbon, 1, {alpha: 0, delay: .3});
        TweenMax.to(_topRibbon, 1, {alpha: 0, delay: .3});
    }

    private function onBoom(e:AnimationEvent=null):void {
        if (_armatureOpen.hasEventListener(AnimationEvent.COMPLETE)) _armatureOpen.removeEventListener(AnimationEvent.COMPLETE, onBoom);
        if (_armatureOpen.hasEventListener(AnimationEvent.LOOP_COMPLETE)) _armatureOpen.removeEventListener(AnimationEvent.LOOP_COMPLETE, onBoom);
        WorldClock.clock.remove(_armatureOpen);
        _contOpen.removeChild(_armatureOpen.display as Sprite);
        _armatureOpen.dispose();
        _armatureOpen = null;
        openIt();
    }
}
}
