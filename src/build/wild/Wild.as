/**
 * Created by user on 6/11/15.
 */
package build.wild {
import build.WorldObject;
import build.lockedLand.LockedLand;
import com.greensock.TweenMax;
import com.junkbyte.console.Cc;
import flash.geom.Point;
import manager.ManagerFilters;
import manager.hitArea.ManagerHitArea;

import media.SoundConst;

import mouse.ToolsModifier;

import starling.display.Image;

import tutorial.TutorialAction;

import ui.xpPanel.XPStar;
import windows.WindowsManager;

public class Wild extends WorldObject{
    private var _isOnHover:Boolean;
    private var _curLockedLand:LockedLand;
    private var _delete:Boolean;
    private var _countTimer:int;

    public function Wild(_data:Object) {
        super(_data);
        if (!_data) {
            Cc.error('Wild:: no data');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'no data for Wild');
            return;
        }
        createBuildWild();

        _source.releaseContDrag = true;
        _isOnHover = false;
        _delete = false;
    }

    private function createBuildWild():void {
        var im:Image;
        if (_build) {
            if (_source.contains(_build)) {
                _source.removeChild(_build);
            }
            while (_build.numChildren) _build.removeChildAt(0);
        }
        im = new Image(g.allData.atlas[_dataBuild.url].getTexture(_dataBuild.image));
        im.x = _dataBuild.innerX;
        im.y = _dataBuild.innerY;

        if (!im) {
            Cc.error('Wild:: no such image: ' + _dataBuild.image + ' for ' + _dataBuild.id);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'AreaObject:: no such image');
            return;
        }
        _build.addChild(im);
        _rect = _build.getBounds(_build);
        _source.addChild(_build);
        if (!g.isAway) {
            _source.hoverCallback = onHover;
            _source.endClickCallback = onClick;
            _source.outCallback = onOut;
            _hitArea = g.managerHitArea.getHitArea(_source, _dataBuild.image, ManagerHitArea.TYPE_FROM_ATLAS);
            _source.registerHitArea(_hitArea);
        }
    }

    public function setLockedLand(l:LockedLand):void {
        _curLockedLand = l;
    }
    
    public function get isAtLockedLand():Boolean {
        if (_curLockedLand) return true;
            else return false;
    }

    public function removeLockedLand():void {
        _curLockedLand = null;
    }

    override public function onHover():void {
        if (g.selectedBuild) return;
        super.onHover();
        if (g.managerCutScenes.isCutScene) return;
        if (g.managerTutorial.isTutorial && !g.managerTutorial.isTutorialBuilding(this)) return;
        if (_curLockedLand && !g.isActiveMapEditor) return;
        if (_delete) return;
        if(_isOnHover) return;
        _source.filter = ManagerFilters.BUILD_STROKE;
        _isOnHover = true;
//        _countTimer = 7;
//        g.timerHint.managerHide();
//        g.wildHint.managerHide();
//        g.treeHint.managerHide();
//        g.gameDispatcher.addEnterFrame(countEnterFrame);
    }

    override public function onOut():void {
        super.onOut();
        if (g.managerTutorial.isTutorial && !g.managerTutorial.isTutorialBuilding(this)) return;
        if (_delete) return;
        _isOnHover = false;
//            if (!_isOnHover) g.wildHint.hideIt();
        if (_source) {
            if (_source.filter) _source.filter.dispose();
            _source.filter = null;
        }
//        g.gameDispatcher.addEnterFrame(countEnterFrame);
    }

//    private function countEnterFrame():void {
//        _countTimer--;
//        if (_countTimer <= 0) {
//            g.gameDispatcher.removeEnterFrame(countEnterFrame);
//            if (_isOnHover) {
//                g.wildHint.onDelete = wildDelete;
//                var newX:int;
//                var newY:int;
//                if(_dataBuild.id == 30) { // старое бревно1
//                    newX = g.cont.gameCont.x + _source.x * g.currentGameScale;
//                    newY = g.cont.gameCont.y + (_source.y - _source.height / 12) * g.currentGameScale;
//                }else if( _dataBuild.id == 31){ //  старое бревно2
//                    newX = g.cont.gameCont.x + (_source.x + _source.width/3) * g.currentGameScale;
//                    newY = g.cont.gameCont.y + (_source.y - _source.height / 12) * g.currentGameScale;
//                }else if( _dataBuild.id == 32){ //ель
//                    newX = g.cont.gameCont.x + _source.x * g.currentGameScale;
//                    newY = g.cont.gameCont.y + (_source.y - _source.height / 1.9) * g.currentGameScale;
//                }else if( _dataBuild.id == 33){ //ёлочка
//                    newX = g.cont.gameCont.x + (_source.x + _source.width/12) * g.currentGameScale;
//                    newY = g.cont.gameCont.y + (_source.y - _source.height / 2) * g.currentGameScale;
//                }else if( _dataBuild.id == 34){ // большой дуб
//                    newX = g.cont.gameCont.x + _source.x * g.currentGameScale;
//                    newY = g.cont.gameCont.y + (_source.y - _source.height / 1.5) * g.currentGameScale;
//                }else if( _dataBuild.id == 35){ // дубок
//                    newX = g.cont.gameCont.x + _source.x * g.currentGameScale;
//                    newY = g.cont.gameCont.y + (_source.y - _source.height / 1.5) * g.currentGameScale;
//                }else if( _dataBuild.id == 56){ // пень
//                    newX = g.cont.gameCont.x + _source.x * g.currentGameScale;
//                    newY = g.cont.gameCont.y + (_source.y - _source.height / 3) * g.currentGameScale;
//                }else if( _dataBuild.id == 57){ // болотце
//                    newX = g.cont.gameCont.x + _source.x * g.currentGameScale;
//                    newY = g.cont.gameCont.y + (_source.y - _source.height / 13) * g.currentGameScale;
//                }else if( _dataBuild.id == 58){ // тополь
//                    newX = g.cont.gameCont.x + _source.x * g.currentGameScale;
//                    newY = g.cont.gameCont.y + (_source.y - _source.height / 1.3) * g.currentGameScale;
//                }else if( _dataBuild.id == 59){ // большой камень
//                    newX = g.cont.gameCont.x + _source.x * g.currentGameScale;
//                    newY = g.cont.gameCont.y + (_source.y - _source.height / 8) * g.currentGameScale;
//                }else if( _dataBuild.id == 60){ // булыжник
//                    newX = g.cont.gameCont.x + _source.x * g.currentGameScale;
//                    newY = g.cont.gameCont.y + (_source.y - _source.height / 8) * g.currentGameScale;
//                }else if( _dataBuild.id == 61){ // маленький камень
//                    newX = g.cont.gameCont.x + _source.x * g.currentGameScale;
//                    newY = g.cont.gameCont.y + (_source.y - _source.height / 8) * g.currentGameScale;
//                }else if( _dataBuild.id == 62){ // маленький камень
//                    newX = g.cont.gameCont.x + _source.x * g.currentGameScale;
//                    newY = g.cont.gameCont.y + (_source.y - _source.height / 8) * g.currentGameScale;
//                }
//                g.wildHint.showIt(_source.height, newX, newY, _dataBuild.removeByResourceId, _dataBuild.name, onOut);
//            }
//        }
//    }

    private function onClick():void {
        if (g.managerCutScenes.isCutScene) return;
        if (g.managerTutorial.isTutorial && !g.useNewTuts) return;
        if (g.managerTutorial.isTutorial && g.useNewTuts && g.managerTutorial.currentAction != TutorialAction.REMOVE_WILD) return;
        if (_delete) return;
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
            if (g.timerHint.isShow) {
                g.timerHint.managerHide(callbackClose);
                return;
            }
            else if (g.wildHint.isShow){
                g.wildHint.managerHide(callbackClose);
                return;
            }
            else if (g.treeHint.isShow) {
                g.treeHint.managerHide(callbackClose);
                return;
            }
//            if (_isOnHover)  {
                onOut();
                g.wildHint.onDelete = wildDelete;
                var newX:int;
                var newY:int;
                if(_dataBuild.id == 30) { // старое бревно1
                    newX = g.cont.gameCont.x + _source.x * g.currentGameScale;
                    newY = g.cont.gameCont.y + (_source.y - _source.height / 12) * g.currentGameScale;
                }else if( _dataBuild.id == 31){ //  старое бревно2
                    if (dataBuild.isFlip) {
                        newX = g.cont.gameCont.x + (_source.x - _source.width/4) * g.currentGameScale;
                        newY = g.cont.gameCont.y + (_source.y - _source.height / 12) * g.currentGameScale;
                    } else {
                        newX = g.cont.gameCont.x + (_source.x + _source.width / 3) * g.currentGameScale;
                        newY = g.cont.gameCont.y + (_source.y - _source.height / 12) * g.currentGameScale;
                    }
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
                g.wildHint.showIt(_source.height,newX, newY, _dataBuild.removeByResourceId,_dataBuild.name,onOut);
            if (g.managerTutorial.isTutorial && g.useNewTuts && g.managerTutorial.currentAction == TutorialAction.REMOVE_WILD) {
                g.wildHint.addArrow();
                g.managerTutorial.checkTutorialCallback();
            }
//            }
        } else {
            Cc.error('Wild:: unknown g.toolsModifier.modifierType')
        }
    }

    private function callbackClose():void {
        onOut();
        g.wildHint.onDelete = wildDelete;
        var newX:int;
        var newY:int;
        if(_dataBuild.id == 30) { // старое бревно1
            newX = g.cont.gameCont.x + _source.x * g.currentGameScale;
            newY = g.cont.gameCont.y + (_source.y - _source.height / 12) * g.currentGameScale;
        }else if( _dataBuild.id == 31){ //  старое бревно2
            if (dataBuild.isFlip) {
                newX = g.cont.gameCont.x + (_source.x - _source.width/4) * g.currentGameScale;
                newY = g.cont.gameCont.y + (_source.y - _source.height / 12) * g.currentGameScale;
            } else {
                newX = g.cont.gameCont.x + (_source.x + _source.width / 3) * g.currentGameScale;
                newY = g.cont.gameCont.y + (_source.y - _source.height / 12) * g.currentGameScale;
            }
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
        g.wildHint.showIt(_source.height,newX, newY, _dataBuild.removeByResourceId,_dataBuild.name,onOut);
    }

    private function wildDelete():void {
        _source.filter = null;
        for (var i:int=0; i< g.user.userDataCity.objects.length; i++) {
            if (int(g.user.userDataCity.objects[i].dbId) == _dbBuildingId) {
                g.user.userDataCity.objects.splice(i, 1);
                break;
            }
        }
        new RemoveWildAnimation(_source, onEndAnimation, onEndAnimationTotal, _dataBuild.removeByResourceId);
        _delete = true;
        g.wildHint.managerHide();
    }

    private function onEndAnimation():void {
        TweenMax.to(_build, 1, {alpha: 0, delay: .3});
    }

    private function onEndAnimationTotal():void {
        var p:Point = new Point(_source.x, _source.y);
        p = _source.parent.localToGlobal(p);
        new XPStar(p.x,p.y, _dataBuild.xpForBuild);
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
