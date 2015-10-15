/**
 * Created by user on 6/11/15.
 */
package build.tree {
import build.AreaObject;

import data.BuildType;

import flash.geom.Point;

import hint.MouseHint;

import hint.FlyMessage;

import resourceItem.CraftItem;

import com.junkbyte.console.Cc;

import resourceItem.ResourceItem;

import mouse.ToolsModifier;

import starling.display.Image;

import starling.display.Sprite;

import starling.filters.BlurFilter;
import starling.utils.Color;

import ui.xpPanel.XPStar;

import utils.MCScaler;

public class Tree extends AreaObject{
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
    private var _arrCrafted:Array;
    private var _isOnHover:Boolean;
    private var _count:int;
    public var tree_db_id:String;    // id в табличке user_tree

    public function Tree(_data:Object) {
        super(_data);
        _arrCrafted = [];
        createTreeBuild();

        _source.hoverCallback = onHover;
        _source.endClickCallback = onClick;
        _source.outCallback = onOut;
        _source.releaseContDrag = true;
        _dataBuild.isFlip = _flip;

        _craftSprite = new Sprite();
        _source.addChild(_craftSprite);
        _resourceItem = new ResourceItem();
        _resourceItem.fillIt(g.dataResource.objectResources[_dataBuild.craftIdResource]);
    }

    public function releaseNewTree():void {
        _state = GROW1;
        setBuildImage();
        startGrow();
    }

    public function releaseTreeFromServer(ob:Object):void {
        tree_db_id = ob.id;
        ob.time_work = int(ob.time_work);
        switch (int(ob.state)) {
            case GROW1:
                if (ob.time_work > _resourceItem.buildTime) {
                    _state = GROWED1;
                    _timeToEndState = 0;
                } else if (ob.time_work <int(_resourceItem.buildTime/2 + .5)) {
                    _state = GROW1;
                    _timeToEndState = int(_resourceItem.buildTime/2 + .5) - ob.time_work;
                } else {
                    _state = GROW_FLOWER1;
                    _timeToEndState = _resourceItem.buildTime - ob.time_work;
                }
                break;
            case GROW2:
                if (ob.time_work > _resourceItem.buildTime) {
                    _state = GROWED2;
                    _timeToEndState = 0;
                } else if (ob.time_work <int(_resourceItem.buildTime/2 + .5)) {
                    _state = GROW2;
                    _timeToEndState = int(_resourceItem.buildTime/2 + .5) - ob.time_work;
                } else {
                    _state = GROW_FLOWER2;
                    _timeToEndState = _resourceItem.buildTime - ob.time_work;
                }
                break;
            case GROW3:
                if (ob.time_work > _resourceItem.buildTime) {
                    _state = GROWED3;
                    _timeToEndState = 0;
                } else if (ob.time_work <int(_resourceItem.buildTime/2 + .5)) {
                    _state = GROW3;
                    _timeToEndState = int(_resourceItem.buildTime/2 + .5) - ob.time_work;
                } else {
                    _state = GROW_FLOWER3;
                    _timeToEndState = _resourceItem.buildTime - ob.time_work;
                }
                break;
            default:
                _state = FULL_DEAD;
                break;
        }
        setBuildImage();
        if (_state == GROW1 || _state == GROW_FLOWER1 || _state == GROW2 || _state == GROW_FLOWER2
                || _state == GROW3 || _state == GROW_FLOWER3) {
            g.gameDispatcher.addToTimer(render);
        }
    }

    private function createTreeBuild():void {
        _defaultScale = _build.scaleX;
        _sizeX = _dataBuild.width;
        _sizeY = _dataBuild.height;

        (_build as Sprite).alpha = 1;
        if (_flip) {
            _build.scaleX = -_defaultScale;
        }
        _source.addChild(_build);

        createIsoView();
    }

    private function setBuildImage():void {
        var im:Image;
        var im2:Image;
        var i:int;
        var item:CraftItem;

        while (_build.numChildren) { _build.removeChildAt(0); }

        switch (_state) {
            case GROW1:
                im = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowSmall));
                im.x = _dataBuild.innerPositionsGrow1[0];
                im.y = _dataBuild.innerPositionsGrow1[1];
                break;
            case GROW_FLOWER1:
                im = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowSmall));
                im2 = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowSmallFlower));
                im.x = _dataBuild.innerPositionsGrow1[0];
                im.y = _dataBuild.innerPositionsGrow1[1];
                im2.x = _dataBuild.innerPositionsGrow1[2];
                im2.y = _dataBuild.innerPositionsGrow1[3];
                break;
            case GROWED1:
                im = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowSmall));
                im.x = _dataBuild.innerPositionsGrow1[0];
                im.y = _dataBuild.innerPositionsGrow1[1];
                for (i=0; i < _dataBuild.countCraftResource[0]; i++) {
                    item = new CraftItem(-3 + int(Math.random()*3), im.y + 7 - int(Math.random()*3), _resourceItem, _craftSprite, 1);
                    MCScaler.scale(item.source, 30, 30);
                    item.removeDefaultCallbacks();
                    item.callback = function():void {onCraftItemClick(item)};
                    _arrCrafted.push(item);
                }
                break;
            case GROW2:
                im = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowMiddle));
                im.x = _dataBuild.innerPositionsGrow2[0];
                im.y = _dataBuild.innerPositionsGrow2[1];
                break;
            case GROW_FLOWER2:
                im = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowMiddle));
                im2 = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowMiddleFlower));
                im.x = _dataBuild.innerPositionsGrow2[0];
                im.y = _dataBuild.innerPositionsGrow2[1];
                im2.x = _dataBuild.innerPositionsGrow2[2];
                im2.y = _dataBuild.innerPositionsGrow2[3];
                break;
            case GROWED2:
                im = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowMiddle));
                im.x = _dataBuild.innerPositionsGrow2[0];
                im.y = _dataBuild.innerPositionsGrow2[1];
                for (i=0; i < _dataBuild.countCraftResource[1]; i++) {
                    item = new CraftItem(-3 + int(Math.random()*3), im.y + 7 - int(Math.random()*3), _resourceItem, _craftSprite, 1);
                    MCScaler.scale(item.source, 30, 30);
                    item.removeDefaultCallbacks();
                    item.callback = function():void {onCraftItemClick(item)};
                    _arrCrafted.push(item);
                }
                break;
            case GROW3:
                im = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowBig));
                im.x = _dataBuild.innerPositionsGrow3[0];
                im.y = _dataBuild.innerPositionsGrow3[1];
                break;
            case GROW_FLOWER3:
                im = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowBig));
                im2 = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowBigFlower));
                im.x = _dataBuild.innerPositionsGrow3[0];
                im.y = _dataBuild.innerPositionsGrow3[1];
                im2.x = _dataBuild.innerPositionsGrow3[2];
                im2.y = _dataBuild.innerPositionsGrow3[3];
                break;
            case GROWED3:
                im = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowBig));
                im.x = _dataBuild.innerPositionsGrow3[0];
                im.y = _dataBuild.innerPositionsGrow3[1];
                for (i=0; i < _dataBuild.countCraftResource[2]; i++) {
                    item = new CraftItem(-3 + int(Math.random()*3), im.y + 7 - int(Math.random()*3), _resourceItem, _craftSprite, 1);
                    MCScaler.scale(item.source, 30, 30);
                    item.removeDefaultCallbacks();
                    item.callback = function():void {onCraftItemClick(item)};
                    _arrCrafted.push(item);
                }
                break;
            case DEAD:
                im = new Image(g.treeAtlas.getTexture(_dataBuild.imageDead));
                im.x = _dataBuild.innerPositionsDead[0];
                im.y = _dataBuild.innerPositionsDead[1];
                break;
            case FULL_DEAD:
                im = new Image(g.treeAtlas.getTexture(_dataBuild.imageDead));
                im.x = _dataBuild.innerPositionsDead[0];
                im.y = _dataBuild.innerPositionsDead[1];
                break;
            case ASK_FIX:
                im = new Image(g.treeAtlas.getTexture(_dataBuild.imageDead));
                im.x = _dataBuild.innerPositionsDead[0];
                im.y = _dataBuild.innerPositionsDead[1];
                break;
            case FIXED:
                im = new Image(g.treeAtlas.getTexture(_dataBuild.imageDead));
                im.x = _dataBuild.innerPositionsDead[0];
                im.y = _dataBuild.innerPositionsDead[1];
                break;
            case GROW_FIXED:
                im = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowBig));
                im.x = _dataBuild.innerPositionsGrow3[0];
                im.y = _dataBuild.innerPositionsGrow3[1];
                break;
            case GROW_FIXED_FLOWER:
                im = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowBig));
                im2 = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowBigFlower));
                im.x = _dataBuild.innerPositionsGrow3[0];
                im.y = _dataBuild.innerPositionsGrow3[1];
                im2.x = _dataBuild.innerPositionsGrow3[2];
                im2.y = _dataBuild.innerPositionsGrow3[3];
                break;
            case GROWED_FIXED:
                im = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowBig));
                im.x = _dataBuild.innerPositionsGrow3[0];
                im.y = _dataBuild.innerPositionsGrow3[1];
                for (i=0; i < _dataBuild.countCraftResource[2]; i++) {
                    item = new CraftItem(-3 + int(Math.random()*3), im.y + 7 - int(Math.random()*3), _resourceItem, _craftSprite, 1);
                    MCScaler.scale(item.source, 30, 30);
                    item.removeDefaultCallbacks();
                    item.callback = function():void {onCraftItemClick(item)};
                    _arrCrafted.push(item);
                }
                break;
            default:
                Cc.error('tree state is WRONG');
        }

        if (!im) {
            Cc.error('Tree setBuildImage:: no such image state = ' + _state  + ' for _dataBuild.id: ' + _dataBuild.id);
            g.woGameError.showIt();
            return;
        }
        _build.addChild(im);
        if (im2) _build.addChild(im2);
        _rect = _build.getBounds(_build);
    }

    private function onHover():void {
        _source.filter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1);
        _isOnHover = true;
        _count = 20;
        if(_state == GROW1 || _state == GROW2 || _state == GROW3 || _state == GROW_FLOWER1 || _state == GROW_FLOWER2 || _state == GROW_FLOWER3){
            g.gameDispatcher.addEnterFrame(countEnterFrame);
        }
// else if (_state == FULL_DEAD) {
//            g.gameDispatcher.addEnterFrame(countEnterFrameDead);
//        }
        if (_state == GROWED1 || _state == GROWED2 || _state == GROWED3 || _state == GROWED_FIXED) {
            g.mouseHint.checkMouseHint(MouseHint.KORZINA);
        }

        if (g.toolsModifier.modifierType == ToolsModifier.MOVE || g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            g.mouseHint.hideHintMouse();
        }
    }

    private function onOut():void {
        _source.filter = null;
        _isOnHover = false;
        g.gameDispatcher.addEnterFrame(countEnterFrame);
        g.gameDispatcher.addEnterFrame(countEnterFrameDead);
        g.mouseHint.hideHintMouse();
    }

    private function onClick():void {
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            _isOnHover = false;
            g.gameDispatcher.addEnterFrame(countEnterFrame);

            g.townArea.moveBuild(this, _state);
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            g.townArea.deleteBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            if (_source.wasGameContMoved) return;
            if (_state ==  FULL_DEAD){
                _isOnHover = true;
                g.gameDispatcher.addEnterFrame(countEnterFrameDead);
//                g.treeHint.showIt(_dataBuild, g.cont.gameCont.x + _source.x, g.cont.gameCont.y + _source.y - _source.height, _dataBuild.name,this);
            } else if (_state == GROWED1 || _state == GROWED2 || _state == GROWED3 || _state == GROWED_FIXED) {
                if (_arrCrafted.length) {
                    if (g.userInventory.currentCountInAmbar + 1 >= g.user.ambarMaxCount) {
                        g.woAmbarFilled.showAmbarFilled(true);
                        var p:Point = new Point(_source.x, _source.y);
                        p = _source.parent.localToGlobal(p);
//                        new FlyMessage(p,"Амбар заполнен");
                        return;
                    }
                    _arrCrafted.shift().flyIt();
                } else Cc.error('TREE:: state == GROWED*, but empty _arrCrafted');
            }
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }
    }

    private function startGrow():void {
        _timeToEndState = int(_resourceItem.buildTime/2 + .5);
        g.gameDispatcher.addToTimer(render);
    }

    private function render():void {
        _timeToEndState--;
        if (_timeToEndState <=0) {
            switch (_state) {
                case GROW1:
                    _state = GROW_FLOWER1;
                    _timeToEndState = int(_resourceItem.buildTime + .5);
                    break;
                case GROW_FLOWER1:
                    _state = GROWED1;
                    g.gameDispatcher.removeFromTimer(render);
                    break;
                case GROW2:
                    _state = GROW_FLOWER2;
                    _timeToEndState = int(_resourceItem.buildTime + .5);
                    break;
                case GROW_FLOWER2:
                    _state = GROWED2;
                    g.gameDispatcher.removeFromTimer(render);
                    break;
                case GROW3:
                    _state = GROW_FLOWER3;
                    _timeToEndState = int(_resourceItem.buildTime + .5);
                    break;
                case GROW_FLOWER3:
                    _state = GROWED3;
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

    private function onCraftItemClick(item:CraftItem):void {
//        if (item.source) {
//            item.source.scaleX = item.source.scaleY = 1;
//        }
//        _arrCrafted.splice(0, 1);
        _source.filter = null;
        _isOnHover = false;
        g.treeHint.hideIt();

        if (!_arrCrafted.length) {
            switch (_state) {
                case GROWED1:
                    _state = GROW2;
                    startGrow();
                    g.managerTree.updateTreeState(tree_db_id, _state);
                    break;
                case GROWED2:
                    _state = GROW3;
                    startGrow();
                    g.managerTree.updateTreeState(tree_db_id, _state);
                    break;
                case GROWED3:
                    //_state = DEAD;
                    _state = FULL_DEAD; // временно, потом добавить поливание
                    g.managerTree.updateTreeState(tree_db_id, _state);
                    break;
                case GROWED_FIXED:
                    _state = FULL_DEAD;
                    g.managerTree.updateTreeState(tree_db_id, _state);
            }
            setBuildImage();
        }
    }

    private function countEnterFrame():void {
        _count--;
        if(_count <=0){
            g.gameDispatcher.removeEnterFrame(countEnterFrame);
            if (_isOnHover == true) {
                var time:int = _timeToEndState;
                if (_state == GROW1 || _state == GROW2 || _state == GROW3) {
                    time += int(_resourceItem.buildTime/2 + .5);
                }
                g.timerHint.showIt(g.cont.gameCont.x + _source.x, g.cont.gameCont.y + _source.y - _source.height, time, _dataBuild.priceSkipHard, _dataBuild.name);
            }
            if (_isOnHover == false) {
                _source.filter = null;
                g.timerHint.hideIt();
            }
        }
    }

    private function countEnterFrameDead():void {
        _count--;

            g.gameDispatcher.removeEnterFrame(countEnterFrameDead);
            if (_isOnHover == true) {
                    g.treeHint.showIt(_dataBuild, g.cont.gameCont.x + _source.x, g.cont.gameCont.y + _source.y - _source.height, _dataBuild.name,this);
                    if (g.userInventory.getCountResourceById(_dataBuild.removeByResourceId) == 0) return;
                    g.treeHint.onDelete = deleteTree;
            }
        if (_count <= 0) {
            if (_isOnHover == false) {
                _source.filter = null;
                g.treeHint.hideIt();
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
        g.userInventory.addResource(g.dataResource.objectResources[_dataBuild.removeByResourceId].id, -1);
        g.townArea.deleteBuild(this);
        g.directServer.deleteUserTree(tree_db_id, _dbBuildingId, null);
    }

    override public function clearIt():void {
        onOut();
        g.gameDispatcher.removeEnterFrame(countEnterFrameDead);
        g.gameDispatcher.removeEnterFrame(countEnterFrame);
        g.gameDispatcher.removeFromTimer(render);
        _resourceItem = null;
        _arrCrafted.length = 0;
        _source.touchable = false;
        super.clearIt();
    }
}
}

