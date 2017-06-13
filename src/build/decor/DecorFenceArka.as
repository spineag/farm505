/**
 * Created by user on 6/8/15.
 */
package build.decor {
import build.WorldObject;

import com.junkbyte.console.Cc;

import data.BuildType;

import flash.geom.Point;

import manager.ManagerFilters;
import data.OwnEvent;

import manager.hitArea.ManagerHitArea;

import mouse.ToolsModifier;

import starling.display.Image;
import starling.events.Event;

import windows.WindowsManager;

public class DecorFenceArka extends WorldObject {
    private var _part:DecorFenceArka;
    private var _isMainPart:Boolean;
    private var _shopViewImage:Image;
    private var _isHover:Boolean;

    public function DecorFenceArka(_data:Object, mainPart:DecorFenceArka = null) {
        super(_data);
        _isHover = false;
        var im:Image;
        if (!mainPart) {
            _isMainPart = true;
            im = new Image(g.allData.atlas[_dataBuild.url].getTexture(_dataBuild.image + '_11'));
            im.x = _dataBuild.innerX[0];
            im.y = _dataBuild.innerY[0];
        } else {
            _isMainPart = false;
            _part = mainPart;
            im = new Image(g.allData.atlas[_dataBuild.url].getTexture(_dataBuild.image + '_12'));
            im.x = _dataBuild.innerX[1];
            im.y = _dataBuild.innerY[1];
        }

        if (!im) {
            Cc.error('DecorFenceGate:: no such image: ' + _dataBuild.image + ' for ' + _dataBuild.id);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'AreaObject:: no such image');
            return;
        }
        _build.addChild(im);
        _rect = _build.getBounds(_build);
        _source.addChild(_build);
        onCreateBuild();
    }

    public function createSecondPart():void {
        if (_part) return;
        _part = new DecorFenceArka(_dataBuild, this);
        var p:Point = new Point();
        if (_dataBuild.isFlip) {
            p.x = posX + 2;
            p.y = posY;
            if (g.isAway) {
                g.townArea.pasteAwayBuild(_part, p.x, p.y);
            } else {
                p = g.matrixGrid.getXYFromIndex(p);
                g.townArea.pasteBuild(_part, p.x, p.y);
            }
            _part.source.scaleX = -_defaultScale;
        } else {
            p.x = posX;
            p.y = posY + 2;
            if (g.isAway) {
                g.townArea.pasteAwayBuild(_part, p.x, p.y);
            } else {
                p = g.matrixGrid.getXYFromIndex(p);
                g.townArea.pasteBuild(_part, p.x, p.y);
            }
        }
    }

    public function deleteSecondPart():void {
        if (g.isAway) {
            g.townArea.deleteAwayBuild(_part);
        } else {
            g.townArea.deleteBuild(_part);
        }
        _part = null;
    }

    public function showFullView():void {
        if (_isMainPart && !_shopViewImage) {
            _shopViewImage = new Image(g.allData.atlas[_dataBuild.url].getTexture(_dataBuild.image + '_12'));
            _shopViewImage.x = _dataBuild.innerX[2];
            _shopViewImage.y = _dataBuild.innerY[2];
            _build.addChild(_shopViewImage);
        }
    }

    public function removeFullView():void {
        if (_isMainPart && _shopViewImage) {
            if (_build.contains(_shopViewImage)) _build.removeChild(_shopViewImage);
            _shopViewImage.dispose();
            _shopViewImage = null;
        }
    }

    public function get isMain():Boolean {
        return _isMainPart;
    }

    private function onCreateBuild():void {
        if (!g.isAway) {
            _source.endClickCallback = onClick;
            _source.hoverCallback = onHover;
            _source.outCallback = onOut;
            _hitArea = g.managerHitArea.getHitArea(_source, _dataBuild.image + '_11', ManagerHitArea.TYPE_FROM_ATLAS); // remake for hitArea !!
            _source.registerHitArea(_hitArea);
        }
    }

    public function onClick():void {
        if (!_isMainPart) {
            if (_part) _part.onClick();
            return;
        }
        if (g.isActiveMapEditor) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            if (g.selectedBuild) {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                } else return;
            } else {
                deleteSecondPart();
                showFullView();
                g.townArea.moveBuild(this);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            g.townArea.deleteBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            releaseFlip();
            g.directServer.userBuildingFlip(_dbBuildingId, int(_flip), null);
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            if (!g.selectedBuild) {
                g.directServer.addToInventory(_dbBuildingId, null);
                g.userInventory.addToDecorInventory(_dataBuild.id, _dbBuildingId);
                deleteSecondPart();
                g.townArea.deleteBuild(this);
                g.event.dispatchEvent(new Event(OwnEvent.UPDATE_REPOSITORY));
            } else {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                }
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.PLANT_TREES;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            // ничего не делаем
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }
    }

    override public function clearIt():void {
        _source.touchable = false;
        super.clearIt();
    }

    override public function onHover():void {
        if (g.selectedBuild) return;
        if (_isHover) return;
        if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY || g.toolsModifier.modifierType == ToolsModifier.MOVE || g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            _isHover = true;
            if (_part) _part.onHover();
            _source.filter = ManagerFilters.BUILD_STROKE;
        }
    }

    override public function onOut():void {
        if (!_isHover) return;
        _isHover = false;
        if (_part) _part.onOut();
        if (_source) {
            if (_source.filter) _source.filter.dispose();
            _source.filter = null;
        }
    }

    override public function releaseFlip():void {
        if (_isMainPart && _part) {
            deleteSecondPart();
        }
        super.releaseFlip();
        createSecondPart();
    }

}
}
