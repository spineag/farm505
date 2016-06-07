/**
 * Created by user on 6/11/15.
 */
package build.tree {
import analytic.AnalyticManager;

import build.WorldObject;
import build.wild.RemoveWildAnimation;
import com.greensock.TweenMax;
import dragonBones.Bone;
import dragonBones.animation.WorldClock;
import dragonBones.events.AnimationEvent;
import flash.geom.Point;
import hint.MouseHint;
import manager.ManagerFilters;
import resourceItem.CraftItem;
import com.junkbyte.console.Cc;
import resourceItem.ResourceItem;
import mouse.ToolsModifier;
import starling.display.Image;
import starling.display.Sprite;
import ui.xpPanel.XPStar;
import utils.MCScaler;
import windows.WindowsManager;

public class Tree extends WorldObject {
    public static const GROW1:int = 1;
    public static const GROW_FLOWER1:int = 2;
    public static const GROWED1:int = 3;
    public static const GROW2:int = 4;
    public static const GROW_FLOWER2:int = 5;
    public static const GROWED2:int = 6;
    public static const GROW3:int = 7;
    public static const GROW_FLOWER3:int = 8;
    public static const GROWED3:int = 9;
    public static const DEAD:int = 10;
    public static const ASK_FIX:int = 11;
    public static const FIXED:int = 12;
    public static const GROW_FIXED:int = 13;
    public static const GROWED_FIXED:int = 14;
    public static const GROW_FIXED_FLOWER:int = 15;
    public static const FULL_DEAD:int = 16;

    private var _state:int;
    private var _resourceItem:ResourceItem;
    private var _timeToEndState:int;
//    private var _arrCrafted:Array;
    private var _countCrafted:int;
    private var _isOnHover:Boolean;
    private var _count:int;
    private var _wateringIcon:Sprite;
    public var tree_db_id:String;    // id в табличке user_tree
    private var _wateringUserSocialId:String;
    private var _craftedCountFromServer:int;
    private var _countMouse:int;
//    private var arrFruits:Array;
    private var _needShopView:Boolean;

    private var _fruits1:Bone;
    private var _fruits2:Bone;
    private var _fruits3:Bone;
    private var _fruits4:Bone;

    public function Tree(_data:Object) {
        super(_data);
//        _arrCrafted = [];
//        arrFruits = [];
        _state = GROW1;

        _source.releaseContDrag = true;
        _resourceItem = new ResourceItem();
        _resourceItem.fillIt(g.dataResource.objectResources[_dataBuild.craftIdResource]);
        _craftSprite = new Sprite();
        createAnimatedBuild(onCreateBuild);
    }

    private function onCreateBuild():void {
        if (!g.isAway) {
            _source.hoverCallback = onHover;
            _source.outCallback = onOut;
        }
        _source.endClickCallback = onClick;
        WorldClock.clock.add(_armature);
        var b:Bone;
        _fruits1 = _armature.getBone('fruit1');
        _fruits2 = _armature.getBone('fruit2');
        _fruits3 = _armature.getBone('fruit3');
        _fruits4 = _armature.getBone('fruit4');
//        for (var i:int = 0; i < arrFruits.length; i++) {
//            b = _armature.getBone('fruit' + String(i + 1));
//            arrFruits.push(b);
//            (b.display as Sprite).touchable = false;
//        }
//        _source.addChild(_craftSprite);
        setBuildImage();
        if (_needShopView) showShopView();
    }

    public function showShopView():void {
        _needShopView = true;
        if (_armature) _armature.animation.gotoAndStop("small", 0);
    }

    public function removeShopView():void {
        _needShopView = false;
        if (_armature) _armature.animation.gotoAndStop("small", 0);
    }

    public function releaseTreeFromServer(ob:Object):void {
        tree_db_id = ob.id;
        _wateringUserSocialId = ob.fixed_user_id;
        ob.time_work = int(ob.time_work);
        _craftedCountFromServer = int(ob.crafted_count);
        switch (int(ob.state)) {
            case GROW1:
                if (ob.time_work > _resourceItem.buildTime) {
                    _state = GROWED1;
                    _timeToEndState = 0;
                } else if (ob.time_work < int(_resourceItem.buildTime / 2 + .5)) {
                    _state = GROW1;
                    _timeToEndState = int(_resourceItem.buildTime / 2 + .5) - ob.time_work;
                } else {
                    _state = GROW_FLOWER1;
                    _timeToEndState = _resourceItem.buildTime - ob.time_work;
                }
                break;
            case GROW2:
                if (ob.time_work > _resourceItem.buildTime) {
                    _state = GROWED2;
                    _timeToEndState = 0;
                } else if (ob.time_work < int(_resourceItem.buildTime / 2 + .5)) {
                    _state = GROW2;
                    _timeToEndState = int(_resourceItem.buildTime / 2 + .5) - ob.time_work;
                } else {
                    _state = GROW_FLOWER2;
                    _timeToEndState = _resourceItem.buildTime - ob.time_work;
                }
                break;
            case GROW3:
                if (ob.time_work > _resourceItem.buildTime) {
                    _state = GROWED3;
                    _timeToEndState = 0;
                } else if (ob.time_work < int(_resourceItem.buildTime / 2 + .5)) {
                    _state = GROW3;
                    _timeToEndState = int(_resourceItem.buildTime / 2 + .5) - ob.time_work;
                } else {
                    _state = GROW_FLOWER3;
                    _timeToEndState = _resourceItem.buildTime - ob.time_work;
                }
                break;
            case GROW_FIXED:
                if (ob.time_work > _resourceItem.buildTime) {
                    _state = GROWED_FIXED;
                    _timeToEndState = 0;
                } else if (ob.time_work < int(_resourceItem.buildTime / 2 + .5)) {
                    _state = GROW_FIXED;
                    _timeToEndState = int(_resourceItem.buildTime / 2 + .5) - ob.time_work;
                } else {
                    _state = GROW_FIXED_FLOWER;
                    _timeToEndState = _resourceItem.buildTime - ob.time_work;
                }
                break;
            default:
                _state = int(ob.state);
                break;
        }

        if (!g.isAway) {
            if (_state == GROW1 || _state == GROW_FLOWER1 || _state == GROW2 || _state == GROW_FLOWER2
                    || _state == GROW3 || _state == GROW_FLOWER3 || _state == GROW_FIXED || _state == GROW_FIXED_FLOWER) {
                g.gameDispatcher.addToTimer(render);
            }
        }
        if (_armature) quickCheckState(true);
    }

    private function setBuildImage():void {
        var i:int;
        var item:CraftItem;
        switch (_state) {
            case GROW1:
                _armature.animation.gotoAndStop("small", 0);
                _hitArea = g.managerHitArea.getHitArea(_source, 'tree' + _dataBuild.id + 'small');
                _source.registerHitArea(_hitArea);
                break;
            case GROW_FLOWER1:
                _armature.animation.gotoAndStop("small_flower", 0);
                _hitArea = g.managerHitArea.getHitArea(_source, 'tree' + _dataBuild.id + 'small');
                _source.registerHitArea(_hitArea);
                break;
            case GROWED1:
                _armature.animation.gotoAndStop("small_fruits", 0);
                _hitArea = g.managerHitArea.getHitArea(_source, 'tree' + _dataBuild.id + 'small');
                _source.registerHitArea(_hitArea);
                _countCrafted = 2;
                if (_craftedCountFromServer >= _dataBuild.countCraftResource[0]) {
                    Cc.error('Tree setBuildImage:: _craftedCountFromServer >= _dataBuild.countCraftResource[0] for dbId: ' + tree_db_id);
                }
//                rechekFruits(true);
                break;
            case GROW2:
                _armature.animation.gotoAndStop("middle", 0);
                _hitArea = g.managerHitArea.getHitArea(_source, 'tree' + _dataBuild.id + 'middle');
                _source.registerHitArea(_hitArea);
                break;
            case GROW_FLOWER2:
                _armature.animation.gotoAndStop("middle_flower", 0);
                _hitArea = g.managerHitArea.getHitArea(_source, 'tree' + _dataBuild.id + 'middle');
                _source.registerHitArea(_hitArea);
                break;
            case GROWED2:
                _armature.addBone(_fruits1);
                _armature.addBone(_fruits2);
               _armature.animation.gotoAndStop("middle_fruits", 0);
                _hitArea = g.managerHitArea.getHitArea(_source, 'tree' + _dataBuild.id + 'middle');
                _source.registerHitArea(_hitArea);
                _countCrafted = 3;
                if (_craftedCountFromServer >= _dataBuild.countCraftResource[1]) {
                    Cc.error('Tree setBuildImage:: _craftedCountFromServer >= _dataBuild.countCraftResource[1] for dbId: ' + tree_db_id);
                }
//                rechekFruits(true);
                break;
            case GROW3:
                _armature.animation.gotoAndStop("big", 0);
                _hitArea = g.managerHitArea.getHitArea(_source, 'tree' + _dataBuild.id + 'big');
                _source.registerHitArea(_hitArea);
                break;
            case GROW_FLOWER3:
                _armature.animation.gotoAndStop("big_flower", 0);
                _hitArea = g.managerHitArea.getHitArea(_source, 'tree' + _dataBuild.id + 'big');
                _source.registerHitArea(_hitArea);
                break;
            case GROWED3:
                _armature.addBone(_fruits1);
                _armature.addBone(_fruits2);
                _armature.addBone(_fruits3);
                _armature.animation.gotoAndStop("big_fruits", 0);
                _hitArea = g.managerHitArea.getHitArea(_source, 'tree' + _dataBuild.id + 'big');
                _source.registerHitArea(_hitArea);
                _countCrafted = 4;
                if (_craftedCountFromServer >= _dataBuild.countCraftResource[2]) {
                    Cc.error('Tree setBuildImage:: _craftedCountFromServer >= _dataBuild.countCraftResource[2] for dbId: ' + tree_db_id);
                }
//                rechekFruits(true);
                break;
            case DEAD:
                _armature.animation.gotoAndStop("dead", 0);
                _hitArea = g.managerHitArea.getHitArea(_source, 'tree' + _dataBuild.id + 'big');
                _source.registerHitArea(_hitArea);
                break;
            case FULL_DEAD:
                _armature.animation.gotoAndStop("dead", 0);
                _hitArea = g.managerHitArea.getHitArea(_source, 'tree' + _dataBuild.id + 'big');
                _source.registerHitArea(_hitArea);
                break;
            case ASK_FIX:
                _armature.animation.gotoAndStop("dead", 0);
                _hitArea = g.managerHitArea.getHitArea(_source, 'tree' + _dataBuild.id + 'big');
                _source.registerHitArea(_hitArea);
                break;
            case FIXED:
                _armature.animation.gotoAndStop("dead", 0);
                _hitArea = g.managerHitArea.getHitArea(_source, 'tree' + _dataBuild.id + 'big');
                _source.registerHitArea(_hitArea);
                break;
            case GROW_FIXED:
                _armature.animation.gotoAndStop("big", 0);
                _hitArea = g.managerHitArea.getHitArea(_source, 'tree' + _dataBuild.id + 'big');
                _source.registerHitArea(_hitArea);
                break;
            case GROW_FIXED_FLOWER:
                _armature.animation.gotoAndStop("big_flower", 0);
                _hitArea = g.managerHitArea.getHitArea(_source, 'tree' + _dataBuild.id + 'big');
                _source.registerHitArea(_hitArea);
                break;
            case GROWED_FIXED:
                _armature.addBone(_fruits1);
                _armature.addBone(_fruits2);
                _armature.addBone(_fruits3);
                _armature.addBone(_fruits4);
                _armature.animation.gotoAndStop("big_fruits", 0);
                _hitArea = g.managerHitArea.getHitArea(_source, 'tree' + _dataBuild.id + 'big');
                _source.registerHitArea(_hitArea);
                _countCrafted = 4;
                if (_craftedCountFromServer >= _dataBuild.countCraftResource[2]) {
                    Cc.error('Tree setBuildImage:: _craftedCountFromServer >= _dataBuild.countCraftResource[2] for dbId: ' + tree_db_id);
                }
//                rechekFruits(true);
                break;
            default:
                Cc.error('tree state is WRONG');
        }

        if (_state == ASK_FIX || _state == FIXED) makeWateringIcon();
        _rect = _build.getBounds(_build);

        if (g.isAway && _state == ASK_FIX) {
            _source.hoverCallback = onHover;
            _source.outCallback = onOut;
        }
    }

    private function rechekFruits():void {
        var st:String;
        var b:Bone;
        var item:CraftItem = new CraftItem(0, 0, _resourceItem, _source, 1);
        item.flyIt();
        st = 'fruit' + _countCrafted;
        b = _armature.getBone(st);
        _armature.removeBone(b, true);
        _countCrafted--;
        if (_countCrafted == 0) onCraftItemClick();
        else g.managerTree.updateTreeCraftCount(tree_db_id,_countCrafted);

    }

    private function quickCheckState(server:Boolean = false):void {
        switch (_state) {
            case GROW1:
                _armature.animation.gotoAndStop("small", 0);
                break;
            case GROW_FLOWER1:
                _armature.animation.gotoAndStop("small_flower", 0);
                break;
            case GROWED1:
                if (server) _countCrafted = 2;
                _armature.animation.gotoAndStop("small_fruits", 0);
                break;
            case GROW2:
                _armature.animation.gotoAndStop("middle", 0);
                break;
            case GROW_FLOWER2:
                _armature.animation.gotoAndStop("middle_flower", 0);
                break;
            case GROWED2:
                if (server) _countCrafted = 3;
                _armature.animation.gotoAndStop("middle_fruits", 0);
                break;
            case GROW3:
                _armature.animation.gotoAndStop("big", 0);
                break;
            case GROW_FLOWER3:
                _armature.animation.gotoAndStop("big_flower", 0);
                break;
            case GROWED3:
                if (server) _countCrafted = 4;
                _armature.animation.gotoAndStop("big_fruits", 0);
                break;
            case DEAD:
                _armature.animation.gotoAndStop("dead", 0);
                break;
            case FULL_DEAD:
                _armature.animation.gotoAndStop("dead", 0);
                break;
            case ASK_FIX:
                _armature.animation.gotoAndStop("dead", 0);
                break;
            case FIXED:
                _armature.animation.gotoAndStop("dead", 0);
                break;
            case GROW_FIXED:
                _armature.animation.gotoAndStop("big", 0);
                break;
            case GROW_FIXED_FLOWER:
                _armature.animation.gotoAndStop("big_flower", 0);
                break;
            case GROWED_FIXED:
                if (server) _countCrafted = 4;
                _armature.animation.gotoAndStop("big_fruits", 0);
                break;
            default:
                Cc.error('tree state is WRONG');
        }

        if (server) {
            var st:String;
            var b:Bone;
            if (_countCrafted > _craftedCountFromServer) {
                for (var i:int = 0; i < _countCrafted - _craftedCountFromServer; i++) {
                    st = 'fruit' + (_countCrafted - i);
                    b = _armature.getBone(st);
                    _armature.removeBone(b, true);
                    _countCrafted--;
                }
            }
        }
    }

    override public function onHover():void {
        if (g.selectedBuild) return;
        super.onHover();
        if (g.isActiveMapEditor) return;
        if (_isOnHover) return;
        _source.filter = ManagerFilters.BUILD_STROKE;
        _isOnHover = true;
        if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            _count = 20;
            _countMouse = 7;
            g.timerHint.managerHide();
            g.wildHint.managerHide();
            g.treeHint.managerHide();
            g.gameDispatcher.addEnterFrame(countMouseEnterFrame);
        } else {
            g.mouseHint.hideIt();
        }

        var fEndOver:Function = function():void {
            _armature.removeEventListener(AnimationEvent.COMPLETE, fEndOver);
            _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, fEndOver);
            quickCheckState();
        };
        _armature.addEventListener(AnimationEvent.COMPLETE, fEndOver);
        _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, fEndOver);

        switch (_state) {
            case GROW1:
                _armature.animation.gotoAndPlay('over_s');
                break;
            case GROW_FLOWER1:
                _armature.animation.gotoAndPlay('over_sfl');
                break;
            case GROWED1:
                _armature.animation.gotoAndPlay('over_sfr');
                break;
            case GROW2:
                _armature.animation.gotoAndPlay('over_m');
                break;
            case GROW_FLOWER2:
                _armature.animation.gotoAndPlay('over_mfl');
                break;
            case GROWED2:
                _armature.animation.gotoAndPlay('over_mfr');
                break;
            case GROW3:
                _armature.animation.gotoAndPlay('over_b');
                break;
            case GROW_FLOWER3:
                _armature.animation.gotoAndPlay('over_bfl');
                break;
            case GROWED3:
                _armature.animation.gotoAndPlay('over_bfr');
                break;
            case DEAD:
                _armature.animation.gotoAndPlay('over_d');
                break;
            case FULL_DEAD:
                _armature.animation.gotoAndPlay('over_d');
                break;
            case ASK_FIX:
                _armature.animation.gotoAndPlay('over_d');
                break;
            case FIXED:
                _armature.animation.gotoAndPlay('over_d');
                break;
            case GROW_FIXED:
                _armature.animation.gotoAndPlay('over_b');
                break;
            case GROW_FIXED_FLOWER:
                _armature.animation.gotoAndPlay('over_bfl');
                break;
            case GROWED_FIXED:
                _armature.animation.gotoAndPlay('over_bfr');
                break;
            default:
                Cc.error('tree state is WRONG');
        }
    }

    override public function onOut():void {
        if (g.isActiveMapEditor) return;
        if (g.selectedBuild) return;
        super.onOut();
        _source.filter = null;
        _isOnHover = false;
//        g.timerHint.hideIt();
//        g.treeHint.hideIt();
        if (_state == ASK_FIX) makeWateringIcon();
        if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            _count = 20;
//            _countMouse = 2;
            g.gameDispatcher.addEnterFrame(countMouseEnterFrame);
        } else {
            g.mouseHint.hideIt();
        }

    }

    private function onClick():void {
        g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.ACTION_TEST, {id:1}); // temp
        if (g.managerCutScenes.isCutScene) return;
        if (g.isActiveMapEditor) return;
        if (g.isAway) {
            if (_state == ASK_FIX) {
                _state = FIXED;
                for (var i:int = 0; i < g.visitedUser.userDataCity.treesInfo.length; i++) {
                    if (g.visitedUser.userDataCity.treesInfo[i].dbId == tree_db_id) {
                        g.visitedUser.userDataCity.treesInfo[i].state = String(FIXED);
                        break;
                    }
                }
                onOut();
                g.directServer.makeWateringUserTree(tree_db_id, _state, null);
                makeWateringIcon();
            }
            return;
        }
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            onOut();
            if (g.selectedBuild) {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                } else return;
            } else {
                g.townArea.moveBuild(this);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            g.townArea.deleteBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            releaseFlip();
            if (_state == ASK_FIX) makeWateringIcon();
            g.directServer.userBuildingFlip(_dbBuildingId, int(_flip), null);
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            if (_source.wasGameContMoved) {
                onOut();
                return;
            }
             if (_state == GROWED1 || _state == GROWED2 || _state == GROWED3 || _state == GROWED_FIXED) {
//                if (_arrCrafted.length) {
                if (_countCrafted) {
                    if (g.userInventory.currentCountInAmbar >= g.user.ambarMaxCount) {
                        _source.filter = null;
                        g.windowsManager.openWindow(WindowsManager.WO_AMBAR_FILLED, null, true);
                        return;
                    }
                    onCraftItemClick();
                } else Cc.error('TREE:: state == GROWED*, but empty _arrCrafted');
            } else if (_state == GROW1 || _state == GROW2 || _state == GROW3 || _state == GROW_FLOWER1 ||
                    _state == GROW_FLOWER2 || _state == GROW_FLOWER3 || _state == GROW_FIXED || _state == GROW_FIXED_FLOWER ||
                    _state == DEAD || _state == FULL_DEAD || _state == ASK_FIX) {
                var time:int = _timeToEndState;
                if (_state == GROW1 || _state == GROW2 || _state == GROW3 || _state == GROW_FIXED) {
                    time += int(_resourceItem.buildTime / 2 + .5);
                }
                var newX:int;
                var newY:int;
                if (_dataBuild.id == 25) { //Яблоня
                    if (_state == ASK_FIX) makeWateringIcon(true);
                    newX = g.cont.gameCont.x + _source.x * g.currentGameScale;
                    newY = g.cont.gameCont.y + (_source.y - _source.height / 1.3) * g.currentGameScale;
                }else if (_dataBuild.id == 26) { // Вишня
                    if (_state == ASK_FIX) makeWateringIcon(true);
                    newX = g.cont.gameCont.x + (_source.x + _source.width /12) * g.currentGameScale;
                    newY = g.cont.gameCont.y + (_source.y - _source.height / 1.3) * g.currentGameScale;
                } else if (_dataBuild.id == 41) { //Малина
                    if (_state == ASK_FIX) makeWateringIcon(true);
                    if (_state == GROW3 || _state == GROW_FLOWER3 || _state == GROW_FIXED || _state == GROW_FIXED_FLOWER) {
                    newX = g.cont.gameCont.x + (_source.x + _source.width / 3) * g.currentGameScale;
                    newY = g.cont.gameCont.y + (_source.y - _source.height / 2) * g.currentGameScale;
                } else{
                    newX = g.cont.gameCont.x + (_source.x + _source.width / 5) * g.currentGameScale;
                    newY = g.cont.gameCont.y + (_source.y - _source.height / 9) * g.currentGameScale;
                }
                } else if (_dataBuild.id == 42) { //Черника
                    if (_state == ASK_FIX) makeWateringIcon(true);
                    if (_state == GROW3 || _state == GROW_FLOWER3 || _state == GROW_FIXED || _state == GROW_FIXED_FLOWER) {
                        newX = g.cont.gameCont.x + (_source.x + _source.width / 3) * g.currentGameScale;
                        newY = g.cont.gameCont.y + (_source.y - _source.height / 6) * g.currentGameScale;
                    } else{
                        newX = g.cont.gameCont.x + (_source.x +  _source.width / 12) * g.currentGameScale;
                        newY = g.cont.gameCont.y + (_source.y - _source.height / 9) * g.currentGameScale;
                    }
                }if (_state == DEAD) {
                     g.treeHint.onDelete = deleteTree;
                     g.treeHint.showIt(_source.height,_dataBuild, newX, newY, _dataBuild.name, this, onOut);
                     g.treeHint.onWatering = askWateringTree;
                 } else if (_state == FULL_DEAD || _state == ASK_FIX) {
                     g.wildHint.onDelete = deleteTree;
                     g.wildHint.showIt(_source.height,newX, newY, _dataBuild.removeByResourceId, _dataBuild.name,onOut);
                 }  else {
//                     g.timerHint.showIt(_source.height,newX,newY, time, _dataBuild.priceSkipHard, _dataBuild.name, callbackSkip,onOut);
                 }
            } else if (_state == FIXED) {
                _state = GROW_FIXED;
                setBuildImage();
                startGrow();
                g.managerTree.updateTreeState(tree_db_id, _state);
                makeWateringIcon();
            }
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }
    }

    private function startGrow():void {
        _timeToEndState = int(_resourceItem.buildTime / 2 + .5);
        g.gameDispatcher.addToTimer(render);
    }

    private function render():void {
        _timeToEndState--;
        if (_timeToEndState <= 0) {
            switch (_state) {
                case GROW1:
                    _state = GROW_FLOWER1;
                    _timeToEndState = int(_resourceItem.buildTime + .5);
                    break;
                case GROW_FLOWER1:
                    _state = GROWED1;
                    g.managerTree.updateTreeCraftCount(tree_db_id,2);
                    g.gameDispatcher.removeFromTimer(render);
                    break;
                case GROW2:
                    _state = GROW_FLOWER2;
                    _timeToEndState = int(_resourceItem.buildTime + .5);
                    break;
                case GROW_FLOWER2:
                    _state = GROWED2;
                    g.managerTree.updateTreeCraftCount(tree_db_id,3);
                    g.gameDispatcher.removeFromTimer(render);
                    break;
                case GROW3:
                    _state = GROW_FLOWER3;
                    _timeToEndState = int(_resourceItem.buildTime + .5);
                    break;
                case GROW_FLOWER3:
                    _state = GROWED3;
                    g.managerTree.updateTreeCraftCount(tree_db_id,4);
                    g.gameDispatcher.removeFromTimer(render);
                    break;
                case GROW_FIXED:
                    _state = GROW_FIXED_FLOWER;
                    _timeToEndState = int(_resourceItem.buildTime + .5);
                    break;
                case GROW_FIXED_FLOWER:
                    _state = GROWED_FIXED;
                    g.gameDispatcher.removeFromTimer(render);
                    break;
            }
            setBuildImage();
        }
    }

    private function onCraftItemClick(item:CraftItem=null):void {
        if (_countCrafted > 0) { // dont use with == 0 because of optimisation
            g.directServer.craftUserTree(tree_db_id, _state, null);
        }

        if (_countCrafted <= 0) {
            switch (_state) {
                case GROWED1:
                    _state = GROW2;
                    startGrow();
                    _craftedCountFromServer = 0;
                    g.managerTree.updateTreeState(tree_db_id, _state);
                    break;
                case GROWED2:
                    _state = GROW3;
                    startGrow();
                    _craftedCountFromServer = 0;
                    g.managerTree.updateTreeState(tree_db_id, _state);
                    break;
                case GROWED3:
                    _state = DEAD;
                    _craftedCountFromServer = 0;
                    g.managerTree.updateTreeState(tree_db_id, _state);
                    break;
                case GROWED_FIXED:
                    _state = FULL_DEAD;
                    _craftedCountFromServer = 0;
                    g.managerTree.updateTreeState(tree_db_id, _state);
            }
            onOut();
            setBuildImage();
        } else {
            rechekFruits();
        }
    }

    public function countMouseEnterFrame():void {
        _countMouse--;
        if (_countMouse <= 5) {
            if (_isOnHover == true) {
                if (_state == GROWED1 || _state == GROWED2 || _state == GROWED3 || _state == GROWED_FIXED) {
                    g.mouseHint.checkMouseHint(MouseHint.KORZINA);
                } else if (_state == GROW1 || _state == GROW2 || _state == GROW3 || _state == GROW_FLOWER1 ||
                        _state == GROW_FLOWER2 || _state == GROW_FLOWER3 || _state == GROW_FIXED || _state == GROW_FIXED_FLOWER) {
                    g.mouseHint.checkMouseHint(MouseHint.CLOCK);
                }
            }
        }
        if (_countMouse <= 0) {
            g.gameDispatcher.removeEnterFrame(countMouseEnterFrame);
            if (_isOnHover == true) {
                if (_state == GROWED1 || _state == GROWED2 || _state == GROWED3 || _state == GROWED_FIXED) {
                    g.mouseHint.checkMouseHint(MouseHint.KORZINA);
                } else if (_state == GROW1 || _state == GROW2 || _state == GROW3 || _state == GROW_FLOWER1 ||
                        _state == GROW_FLOWER2 || _state == GROW_FLOWER3 || _state == GROW_FIXED || _state == GROW_FIXED_FLOWER || _state == FULL_DEAD || _state == ASK_FIX || _state == DEAD) {
                var time:int = _timeToEndState;
                if (_timeToEndState == 0) time += int(_resourceItem.buildTime +.5);
                else time += int(_resourceItem.buildTime /2 + .5);
                var newX:int;
                var newY:int;
//                    var rect:flash.geom.Rectangle = armatureClip.getBounds(armatureClip);
                if (_dataBuild.id == 25) { //Яблоня
                    if (_state == ASK_FIX) makeWateringIcon(true);
                    newX = g.cont.gameCont.x + _source.x * g.currentGameScale;
                    newY = g.cont.gameCont.y + (_source.y - _source.height / 1.3) * g.currentGameScale;
                }else if (_dataBuild.id == 26) { // Вишня
                    if (_state == ASK_FIX) makeWateringIcon(true);
                    newX = g.cont.gameCont.x + (_source.x + _source.width /12) * g.currentGameScale;
                    newY = g.cont.gameCont.y + (_source.y - _source.height / 1.3) * g.currentGameScale;
                } else if (_dataBuild.id == 41) { //Малина
                    if (_state == ASK_FIX) makeWateringIcon(true);
                    if (_state == GROW3 || _state == GROW_FLOWER3 || _state == GROW_FIXED || _state == GROW_FIXED_FLOWER) {
                        newX = g.cont.gameCont.x + (_source.x + _source.width / 3) * g.currentGameScale;
                        newY = g.cont.gameCont.y + (_source.y - _source.height / 2) * g.currentGameScale;
                    } else{
                        newX = g.cont.gameCont.x + (_source.x + _source.width / 5) * g.currentGameScale;
                        newY = g.cont.gameCont.y + (_source.y - _source.height / 9) * g.currentGameScale;
                    }
                } else if (_dataBuild.id == 42) { //Черника
                    if (_state == ASK_FIX) makeWateringIcon(true);
                    if (_state == GROW3 || _state == GROW_FLOWER3 || _state == GROW_FIXED || _state == GROW_FIXED_FLOWER) {
                        newX = g.cont.gameCont.x + (_source.x + _source.width / 3) * g.currentGameScale;
                        newY = g.cont.gameCont.y + (_source.y - _source.height / 6) * g.currentGameScale;
                    } else{
                        newX = g.cont.gameCont.x + (_source.x +  _source.width / 12) * g.currentGameScale;
                        newY = g.cont.gameCont.y + (_source.y - _source.height / 9) * g.currentGameScale;
                    }
                }if (_state == DEAD) {
                    g.treeHint.onDelete = deleteTree;
                    g.treeHint.showIt(_source.height,_dataBuild, newX, newY, _dataBuild.name, this, onOut);
                    g.treeHint.onWatering = askWateringTree;
                } else if (_state == FULL_DEAD || _state == ASK_FIX) {
                    g.wildHint.onDelete = deleteTree;
                    g.wildHint.showIt(_source.height,newX, newY, _dataBuild.removeByResourceId, _dataBuild.name,onOut);
                }  else {
                     g.timerHint.showIt(_source.height,newX,newY, time, _dataBuild.priceSkipHard, _dataBuild.name, callbackSkip,onOut);
                }
                }
            } else {
//                _source.filter = null;
                g.mouseHint.hideIt();
                g.timerHint.hideIt();
                g.gameDispatcher.removeEnterFrame(countMouseEnterFrame);
            }
        }
    }

    override public function addXP():void {
        if (_dataBuild.xpForBuild) {
            var start:Point = new Point(int(_source.x), int(_source.y));
            start = _source.parent.localToGlobal(start);
            new XPStar(start.x, start.y, _dataBuild.xpForBuild);
        }
    }

    private function deleteTree():void {
        g.directServer.deleteUserTree(tree_db_id, _dbBuildingId, null);
        new RemoveWildAnimation(_source, onEndAnimation, onEndAnimationTotal, _dataBuild.removeByResourceId);
    }

    private function onEndAnimation():void {
        TweenMax.to(_build, 1, {alpha: 0, delay: .3});
    }

    private function onEndAnimationTotal():void {
        g.townArea.deleteBuild(this);
    }

    private function askWateringTree():void {
        _state = ASK_FIX;
        g.directServer.askWateringUserTree(tree_db_id, _state, null);
        makeWateringIcon();
    }

    override public function clearIt():void {
        onOut();
        WorldClock.clock.remove(_armature);
        g.gameDispatcher.removeFromTimer(render);
        _resourceItem = null;
//        _arrCrafted.length = 0;
        _source.touchable = false;
        super.clearIt();
    }

    private function callbackSkip():void {
        onOut();
        if (_state == GROW1 || _state == GROW_FLOWER1) {
            _state = GROWED1;
            setBuildImage();
            g.directServer.skipTimeOnTree(GROWED1, _dbBuildingId, afterSkip);
        } else if (_state == GROW2 || _state == GROW_FLOWER2) {
            _state = GROWED2;
            setBuildImage();
            g.directServer.skipTimeOnTree(GROWED2, _dbBuildingId, afterSkip);
        } else if (_state == GROW3 || _state == GROW_FLOWER3) {
            _state = GROWED3;
            setBuildImage();
            g.directServer.skipTimeOnTree(GROWED3, _dbBuildingId, afterSkip);
        } else if (_state == GROW_FIXED || _state == GROW_FIXED_FLOWER) {
            _state = GROWED_FIXED;
            setBuildImage();
            g.directServer.skipTimeOnTree(GROWED_FIXED, _dbBuildingId, null);
        }
    }

    private function afterSkip():void {
        if (_state == GROWED1) g.managerTree.updateTreeCraftCount(tree_db_id,2);
        if (_state == GROWED2) g.managerTree.updateTreeCraftCount(tree_db_id,3);
        if (_state == GROWED3) g.managerTree.updateTreeCraftCount(tree_db_id,4);
        if (_state == GROWED_FIXED) g.managerTree.updateTreeCraftCount(tree_db_id,4);
    }

    public function get stateTree():int {
        return _state;
    }

    private function makeWateringIcon(ask:Boolean = false):void {
        if (_wateringIcon) {
            if (_build.contains(_wateringIcon)) _build.removeChild(_wateringIcon);
            while (_wateringIcon.numChildren) _wateringIcon.removeChildAt(0);
            _wateringIcon = null;
            _wateringUserSocialId = '0';
        }
        if (!ask) {
            if (_state == ASK_FIX || _state == FIXED) {
                _wateringIcon = new Sprite();
                var im:Image;
                var watering:Image;
                if (_dataBuild.width == 2) {
                    im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('hint_arrow'));
                    im.pivotX = im.width / 2;
                    im.pivotY = im.height / 2;
                    _wateringIcon.addChild(im);
                    watering = new Image(g.allData.atlas['interfaceAtlas'].getTexture('watering_can'));


                    MCScaler.scale(watering, 45, 45);
                    _wateringIcon.addChild(watering);
                    watering.visible = true;
                    if (_dataBuild.id == 25) { //Яблоня
                        im.y = -_source.height / 2 - im.height;
                        watering.pivotX = watering.width / 2;
                        watering.pivotY = watering.height / 2;
                        watering.y = -_source.height / 2 - watering.height - 80;
                        watering.x = -10;
                    }else if (_dataBuild.id == 26) { // Вишня
                        im.y = -_source.height / 2 - im.height + 20;
                        im.x = 5;
                        watering.pivotX = watering.width / 2;
                        watering.pivotY = watering.height / 2;
                        watering.y = -_source.height / 2 - watering.height - 60;
                        watering.x = -5;
                    }
                    if (_state == FIXED) {
                        watering.visible = false;
                        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
                        im.pivotX = im.width / 2;
                        im.pivotY = im.height / 2;
                        im.y = -_source.height / 2 - im.height - 80;
                        _wateringIcon.addChild(im);
                        if (_dataBuild.id == 25) { //Яблоня
                        }else if (_dataBuild.id == 26) { // Вишня
                            im.y = -_source.height / 2 - im.height - 60;
                            im.x = 6;

                        }
//                if (_wateringUserSocialId != '0' || _wateringUserSocialId != '-1') {
//                    var p:Someone = g.user.getSomeoneBySocialId(_wateringUserSocialId);
//                    if (!p.photo) {
//                        var f1:Function = function():void {
//                            p = g.user.getSomeoneBySocialId(_wateringUserSocialId);
//                            g.load.loadImage(p.photo, onLoadPhoto, p);
//                        };
//                        g.socialNetwork.getTempUsersInfoById([_wateringUserSocialId], f1);
//                    } else {
//                        g.load.loadImage(p.photo, onLoadPhoto, p);
//                    }
//                }
                    }
                } else {
                    im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('hint_arrow'));
                    im.pivotX = im.width / 2 - 8;
                    im.pivotY = im.height / 2;
                    im.y = -_source.height + 20;
                    _wateringIcon.addChild(im);
                    watering = new Image(g.allData.atlas['interfaceAtlas'].getTexture('watering_can'));
                    watering.pivotX = im.width / 2;
                    watering.pivotY = im.height / 2;
                    watering.x = 3;
                    watering.y = -_source.height + 8;
                    watering.visible = true;
                    MCScaler.scale(watering, 45, 45);
                    _wateringIcon.addChild(watering);
                    if (_state == FIXED) {
                        watering.visible = false;
                        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
                        im.pivotX = im.width / 2;
                        im.pivotY = im.height / 2;
                        im.x = 8;
                        im.y = -_source.height + 8;
                        _wateringIcon.addChild(im);
                    }
                }


                if (_dataBuild.id == 41) { //Малина

                } else if (_dataBuild.id == 42) { //Черника

                    }
                _build.addChild(_wateringIcon);
                if (_flip) {
                    _wateringIcon.scaleX = -1;
                    _wateringIcon.x = _wateringIcon.x + 10;
                }else
                    _wateringIcon.scaleX = 1;
            }
        }
    }

//    private function onLoadPhoto(bitmap:Bitmap, p:Someone):void {
//        if (!bitmap) {
//            bitmap = g.pBitmaps[p.photo].create() as Bitmap;
//        }
//        if (!bitmap) {
//            Cc.error('WOPapperItem:: no photo for userId: ' + p.userSocialId);
//            return;
//        }
//        var ava:Image = new Image(Texture.fromBitmap(bitmap));
//        MCScaler.scale(ava, 50, 50);
//        ava.x = -60;
//        _wateringIcon.addChild(ava);
//}
}
}

