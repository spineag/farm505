/**
 * Created by user on 6/11/15.
 */
package build.tree {
import build.AreaObject;

import flash.geom.Point;

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
    private const GROW1:int = 1;
    private const GROW_FLOWER1:int = 100;
    private const GROWED1:int = 2;
    private const GROW2:int = 3;
    private const GROW_FLOWER2:int = 101;
    private const GROWED2:int = 4;
    private const GROW3:int = 5;
    private const GROW_FLOWER3:int = 102;
    private const GROWED3:int = 6;
    private const DEAD:int = 9;
    private const ASK_FIX:int = 10;
    private const FIXED:int = 11;
    private const GROW_FIXED:int = 12;
    private const GROWED_FIXED:int = 13;
    private const GROW_FIXED_FLOWER:int = 103;
    private const FULL_DEAD:int = 14;

    private var _state:int;
    private var _resourceItem:ResourceItem;
    private var _timeToEndState:int;
    private var _arrCrafted:Array;
    private var _isOnHover:Boolean;
    private var _count:int;

    public function Tree(_data:Object) {
        super(_data);
        _arrCrafted = [];
        createTreeBuild();

        _source.hoverCallback = onHover;
        _source.endClickCallback = onClick;
        _source.outCallback = onOut;
        _dataBuild.isFlip = _flip;

        _craftSprite = new Sprite();
        _source.addChild(_craftSprite);
        _resourceItem = new ResourceItem();
        _resourceItem.fillIt(g.dataResource.objectResources[_dataBuild.craftIdResource]);
        _state = GROW1;
        setBuildImage();
        startGrow();
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
    }

    private function setBuildImage():void {
        var im:Image;
        var im2:Image;
        var i:int;
        var item:CraftItem;
        var f:Function;

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
                    item = new CraftItem(-5 + int(Math.random()*10), im.y - int(Math.random()*10), _resourceItem, _craftSprite, 1);
                    MCScaler.scale(item.source, 30, 30);
                    f = function():void {onCraftItemClick(item)};
                    item.callback = f;
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
                    item = new CraftItem(-5 + int(Math.random()*10), im.y - int(Math.random()*10), _resourceItem, _craftSprite, 1);
                    MCScaler.scale(item.source, 30, 30);
                    f = function():void {onCraftItemClick(item)};
                    item.callback = f;
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
                    item = new CraftItem(-5 + int(Math.random()*10), im.y - int(Math.random()*10), _resourceItem, _craftSprite, 1);
                    MCScaler.scale(item.source, 30, 30);
                    f = function():void {onCraftItemClick(item)};
                    item.callback = f;
                    _arrCrafted.push(item);
                }
                break;
            case DEAD:
            case FULL_DEAD:
            case ASK_FIX:
            case FIXED:
                im = new Image(g.treeAtlas.getTexture(_dataBuild.imageDead));
                im.x = _dataBuild.innerPositionsDead[0];
                im.y = _dataBuild.innerPositionsDead[1];
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
                    item = new CraftItem(-5 + int(Math.random()*10), im.y - int(Math.random()*10), _resourceItem, _craftSprite, 1);
                    MCScaler.scale(item.source, 30, 30);
                    item.callback = function():void {onCraftItemClick(item)};
                    _arrCrafted.push(item);
                }
                break;
            default:
                Cc.error('tree state is WRONG');
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
    }

    private function onOut():void {
        _source.filter = null;
        _isOnHover = false;
        g.gameDispatcher.addEnterFrame(countEnterFrame);
        g.gameDispatcher.addEnterFrame(countEnterFrameDead);
    }

    private function onClick():void {
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            g.townArea.moveBuild(this);
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
            if (_state == DEAD){
//                g.gameDispatcher.addEnterFrame(countEnterFrameDead);
                g.treeHint.showIt(_dataBuild, g.cont.gameCont.x + _source.x, g.cont.gameCont.y + _source.y - _source.height, _dataBuild.name,this);
            }
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }
    }

    private function startGrow():void {
        _timeToEndState = int(_resourceItem.leftTime/2 + .5);
        g.gameDispatcher.addToTimer(render);
    }

    private function render():void {
        _timeToEndState--;
        if (_timeToEndState <=0) {
            switch (_state) {
                case GROW1:
                    _state = GROW_FLOWER1;
                    _timeToEndState = int(_resourceItem.leftTime + .5);
                    break;
                case GROW_FLOWER1:
                    _state = GROWED1;
                    g.gameDispatcher.removeFromTimer(render);
                    break;
                case GROW2:
                    _state = GROW_FLOWER2;
                    _timeToEndState = int(_resourceItem.leftTime + .5);
                    break;
                case GROW_FLOWER2:
                    _state = GROWED2;
                    g.gameDispatcher.removeFromTimer(render);
                    break;
                case GROW3:
                    _state = GROW_FLOWER3;
                    _timeToEndState = int(_resourceItem.leftTime + .5);
                    break;
                case GROW_FLOWER3:
                    _state = GROWED3;
                    g.gameDispatcher.removeFromTimer(render);
                    break;
                case GROW_FIXED:
                    _state = GROW_FIXED_FLOWER;
                    _timeToEndState = int(_resourceItem.leftTime + .5);
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
        if (item.source) {
            item.source.scaleX = item.source.scaleY = 1;
        }
        if (_arrCrafted.indexOf(item)) {
            _arrCrafted.splice(_arrCrafted.indexOf(item), 1);
        }

        if (!_arrCrafted.length) {
            switch (_state) {
                case GROWED1:
                    _state = GROW2;
                    startGrow();
                    break;
                case GROWED2:
                    _state = GROW3;
                    startGrow();
                    break;
                case GROWED3:
                    _state = DEAD;
                    break;
                case GROWED_FIXED:
                    _state = FULL_DEAD;
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
                    time += int(_resourceItem.leftTime/2 + .5);
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
        if (_count <= 0) {
            g.gameDispatcher.removeEnterFrame(countEnterFrameDead);
            if (_isOnHover == true) {
                    g.treeHint.showIt(_dataBuild, g.cont.gameCont.x + _source.x, g.cont.gameCont.y + _source.y - _source.height, _dataBuild.name,this)
            }
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

    public function treeImage():void {
    var im:Image;
    var im2:Image;
    switch (_state) {
        case GROW1:
            im = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowSmall));
            im.x = _dataBuild.innerPositionsGrow1[0];
            im.y = _dataBuild.innerPositionsGrow1[1];
            g.toolsModifier.contImage.addChild(im);
            break;
        case GROW_FLOWER1:
            im = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowSmall));
            im2 = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowSmallFlower));
            im.x = _dataBuild.innerPositionsGrow1[0];
            im.y = _dataBuild.innerPositionsGrow1[1];
            im2.x = _dataBuild.innerPositionsGrow1[2];
            im2.y = _dataBuild.innerPositionsGrow1[3];
            g.toolsModifier.contImage.addChild(im);
            g.toolsModifier.contImage.addChild(im2);
            break;
        case GROWED1:
            im = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowSmall));
            im.x = _dataBuild.innerPositionsGrow1[0];
            im.y = _dataBuild.innerPositionsGrow1[1];
            g.toolsModifier.contImage.addChild(im);
            break;
        case GROW2:
            im = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowMiddle));
            im.x = _dataBuild.innerPositionsGrow2[0];
            im.y = _dataBuild.innerPositionsGrow2[1];
            g.toolsModifier.contImage.addChild(im);
            break;
        case GROW_FLOWER2:
            im = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowMiddle));
            im2 = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowMiddleFlower));
            im.x = _dataBuild.innerPositionsGrow2[0];
            im.y = _dataBuild.innerPositionsGrow2[1];
            im2.x = _dataBuild.innerPositionsGrow2[2];
            im2.y = _dataBuild.innerPositionsGrow2[3];
            g.toolsModifier.contImage.addChild(im);
            g.toolsModifier.contImage.addChild(im2);
            break;
        case GROWED2:
            im = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowMiddle));
            im.x = _dataBuild.innerPositionsGrow2[0];
            im.y = _dataBuild.innerPositionsGrow2[1];
            g.toolsModifier.contImage.addChild(im);
            break;
        case GROW3:
            im = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowBig));
            im.x = _dataBuild.innerPositionsGrow3[0];
            im.y = _dataBuild.innerPositionsGrow3[1];
            g.toolsModifier.contImage.addChild(im);
            break;
        case GROW_FLOWER3:
            im = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowBig));
            im2 = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowBigFlower));
            im.x = _dataBuild.innerPositionsGrow3[0];
            im.y = _dataBuild.innerPositionsGrow3[1];
            im2.x = _dataBuild.innerPositionsGrow3[2];
            im2.y = _dataBuild.innerPositionsGrow3[3];
            g.toolsModifier.contImage.addChild(im);
            g.toolsModifier.contImage.addChild(im2);
            break;
        case GROWED3:
            im = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowBig));
            im.x = _dataBuild.innerPositionsGrow3[0];
            im.y = _dataBuild.innerPositionsGrow3[1];
            g.toolsModifier.contImage.addChild(im);
            break;
        case DEAD:
        case FULL_DEAD:
        case ASK_FIX:
        case FIXED:
            im = new Image(g.treeAtlas.getTexture(_dataBuild.imageDead));
            im.x = _dataBuild.innerPositionsDead[0];
            im.y = _dataBuild.innerPositionsDead[1];
            g.toolsModifier.contImage.addChild(im);
        case GROW_FIXED:
            im = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowBig));
            im.x = _dataBuild.innerPositionsGrow3[0];
            im.y = _dataBuild.innerPositionsGrow3[1];
            g.toolsModifier.contImage.addChild(im);
            break;
        case GROW_FIXED_FLOWER:
            im = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowBig));
            im2 = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowBigFlower));
            im.x = _dataBuild.innerPositionsGrow3[0];
            im.y = _dataBuild.innerPositionsGrow3[1];
            im2.x = _dataBuild.innerPositionsGrow3[2];
            im2.y = _dataBuild.innerPositionsGrow3[3];
            g.toolsModifier.contImage.addChild(im);
            g.toolsModifier.contImage.addChild(im2);
            break;
        case GROWED_FIXED:
            im = new Image(g.treeAtlas.getTexture(_dataBuild.imageGrowBig));
            im.x = _dataBuild.innerPositionsGrow3[0];
            im.y = _dataBuild.innerPositionsGrow3[1];
            g.toolsModifier.contImage.addChild(im);
            break;
        default:
        }
    }
}
}

