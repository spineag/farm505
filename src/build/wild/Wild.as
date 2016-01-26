/**
 * Created by user on 6/11/15.
 */
package build.wild {
import build.AreaObject;
import build.lockedLand.LockedLand;
import com.junkbyte.console.Cc;

import manager.ManagerFilters;

import mouse.ToolsModifier;

import starling.filters.BlurFilter;
import starling.filters.ColorMatrixFilter;
import starling.utils.Color;

import ui.xpPanel.XPStar;

public class Wild extends AreaObject{
    private var _isOnHover:Boolean;
    private var _curLockedLand:LockedLand;

    public function Wild(_data:Object) {
        super(_data);
        if (!_data) {
            Cc.error('Wild:: no data');
            g.woGameError.showIt();
            return;
        }
        createBuild();

        if (!g.isAway) {
            _source.hoverCallback = onHover;
            _source.endClickCallback = onClick;
            _source.outCallback = onOut;
        }
        _source.releaseContDrag = true;
        _isOnHover = false;
    }

    public function setLockedLand(l:LockedLand):void {
        _curLockedLand = l;
    }

    public function removeLockedLand():void {
        _curLockedLand = null;
    }

    private function onHover():void {
        if (g.selectedBuild) return;
        if (_curLockedLand && !g.isActiveMapEditor) return;
        _source.filter = ManagerFilters.BUILD_STROKE;
        _isOnHover = true;
    }

    private function onOut():void {
        _isOnHover = false;
            if (!_isOnHover) g.wildHint.hideIt();
        _source.filter = null;
    }

    private function onClick():void {
        if (g.selectedBuild) {
            if (g.selectedBuild == this && g.isActiveMapEditor) {
                g.toolsModifier.onTouchEnded();
                onOut();
            }
            return;
        }
        if (_curLockedLand && !g.isActiveMapEditor) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            if (g.isActiveMapEditor) {
                if (_curLockedLand) {
                    _curLockedLand.activateOnMapEditor(this);
                    _curLockedLand = null;
                }
                onOut();
                g.townArea.moveBuild(this);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            if (g.isActiveMapEditor) {
                if (_curLockedLand) {
                    _curLockedLand.activateOnMapEditor(this);
                    _curLockedLand = null;
                }
                onOut();
                g.directServer.ME_removeWild(_dbBuildingId, null);
                g.townArea.deleteBuild(this);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            if (g.isActiveMapEditor) {
                releaseFlip();
                g.directServer.ME_flipWild(_dbBuildingId, int(_dataBuild.isFlip), null);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            if (g.isAway) return;
            if (_source.wasGameContMoved) {
                onOut();
                return;
            }
            if (_isOnHover)  {
                onOut();
                g.wildHint.onDelete = wildDelete;
                var newX:int;
                var newY:int;
                if(_dataBuild.id == 30) { // старое бревно1
                    newX = g.cont.gameCont.x + _source.x * g.currentGameScale;
                    newY = g.cont.gameCont.y + (_source.y - _source.height / 12) * g.currentGameScale;
                }else if( _dataBuild.id == 31){ //  старое бревно2
                    newX = g.cont.gameCont.x + (_source.x + _source.width/3) * g.currentGameScale;
                    newY = g.cont.gameCont.y + (_source.y - _source.height / 12) * g.currentGameScale;
                }else if( _dataBuild.id == 32){ //ель
                    newX = g.cont.gameCont.x + _source.x * g.currentGameScale;
                    newY = g.cont.gameCont.y + (_source.y - _source.height / 1.9) * g.currentGameScale;
                }else if( _dataBuild.id == 33){ //ёлочка
                    newX = g.cont.gameCont.x + (_source.x + _source.width/12) * g.currentGameScale;
                    newY = g.cont.gameCont.y + (_source.y - _source.height / 2) * g.currentGameScale;
                }else if( _dataBuild.id == 34){ // большой дуб
                    newX = g.cont.gameCont.x + _source.x * g.currentGameScale;
                    newY = g.cont.gameCont.y + (_source.y - _source.height / 1.5) * g.currentGameScale;
                }else if( _dataBuild.id == 35){ // дубок
                    newX = g.cont.gameCont.x + _source.x * g.currentGameScale;
                    newY = g.cont.gameCont.y + (_source.y - _source.height / 1.5) * g.currentGameScale;
                }else if( _dataBuild.id == 56){ // пень
                    newX = g.cont.gameCont.x + _source.x * g.currentGameScale;
                    newY = g.cont.gameCont.y + (_source.y - _source.height / 3) * g.currentGameScale;
                }else if( _dataBuild.id == 57){ // болотце
                    newX = g.cont.gameCont.x + _source.x * g.currentGameScale;
                    newY = g.cont.gameCont.y + (_source.y - _source.height / 13) * g.currentGameScale;
                }else if( _dataBuild.id == 58){ // тополь
                    newX = g.cont.gameCont.x + _source.x * g.currentGameScale;
                    newY = g.cont.gameCont.y + (_source.y - _source.height / 1.3) * g.currentGameScale;
                }else if( _dataBuild.id == 59){ // большой камень
                    newX = g.cont.gameCont.x + _source.x * g.currentGameScale;
                    newY = g.cont.gameCont.y + (_source.y - _source.height / 8) * g.currentGameScale;
                }else if( _dataBuild.id == 60){ // булыжник
                    newX = g.cont.gameCont.x + _source.x * g.currentGameScale;
                    newY = g.cont.gameCont.y + (_source.y - _source.height / 8) * g.currentGameScale;
                }else if( _dataBuild.id == 61){ // маленький камень
                    newX = g.cont.gameCont.x + _source.x * g.currentGameScale;
                    newY = g.cont.gameCont.y + (_source.y - _source.height / 8) * g.currentGameScale;
                }else if( _dataBuild.id == 62){ // маленький камень
                    newX = g.cont.gameCont.x + _source.x * g.currentGameScale;
                    newY = g.cont.gameCont.y + (_source.y - _source.height / 8) * g.currentGameScale;
                }
                g.wildHint.showIt(_source.height,newX, newY, _dataBuild.removeByResourceId,_dataBuild.name);
            }
        } else {
            Cc.error('Wild:: unknown g.toolsModifier.modifierType')
        }
    }

    private function wildDelete():void {
//        if (_dataBuild.xp) new XPStar(_source.x, _source.y, _dataBuild.xp);
        for (var i:int=0; i< g.user.userDataCity.objects.length; i++) {
            if (g.user.userDataCity.objects[i].dbId == _dbBuildingId) {
                g.user.userDataCity.objects.splice(i, 1);
                break;
            }
        }
        g.directServer.deleteUserWild(_dbBuildingId, null);
        g.townArea.deleteBuild(this);
    }

    override public function clearIt():void {
        onOut();
        _source.touchable = false;
        super.clearIt();
    }

}
}
