package build {
import com.greensock.TweenMax;
import com.junkbyte.console.Cc;
import data.BuildType;
import dragonBones.Armature;
import dragonBones.starling.StarlingArmatureDisplay;

import flash.display.Bitmap;
import flash.geom.Point;
import flash.geom.Rectangle;
import manager.Vars;
import manager.hitArea.ManagerHitArea;
import manager.hitArea.OwnHitArea;
import preloader.miniPreloader.FlashAnimatedPreloader;

import quest.ManagerQuest;

import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Color;
import utils.SimpleArrow;
import tutorial.TutorialAction;
import utils.IsoUtils;
import utils.Point3D;
import windows.WindowsManager;

public class WorldObject {
    public static var STATE_UNACTIVE:int = 1;       // только для стандартных зданий
    public static var STATE_BUILD:int = 2;          // состояние стройки
    public static var STATE_WAIT_ACTIVATE:int = 3;  // построенное, но еще не открытое
    public static var STATE_ACTIVE:int = 4;         // активное состояние, после стройки
    public static var STATE_DEFAULT_UNKNOWN:int = 0;// еще не определенное

    protected var _dataBuild:Object;
    protected var _flip:Boolean;
    protected var _defaultScale:Number;
    public var posX:int = 0;
    public var posY:int = 0;
    public var useIsometricOnly:Boolean = true;
    protected var _sizeX:int;
    protected var _sizeY:int;
    protected var _source:TownAreaBuildSprite;
    protected var _build:Sprite;
    protected var _isoView:Sprite;
    private var _preloader:FlashAnimatedPreloader;
    protected var _craftSprite:Sprite;
    protected var _buildingBuildSprite:Sprite;
    protected var _depth:Number = 0;
    protected var _rect:Rectangle;
    protected var _dbBuildingId:int = 0;   // id в таблице user_building
    protected var _stateBuild:int;  // состояние постройки (активное, в процесе стройки..)
    protected var _arrow:SimpleArrow;
    protected var _tutorialCallback:Function;
    protected var _hitArea:OwnHitArea;
    protected var _leftBuildTime:int;                   // сколько осталось времени до окончания постройки здания
    protected var _armature:Armature;
    private var _buildingBuild:BuildingBuild;
    public var countShopCost:int;
    public var idResourceArrow:int = 0;

    protected static var g:Vars = Vars.getInstance();

    public function WorldObject(dataBuildObject:Object) {
        _tutorialCallback = null;
        _source = new TownAreaBuildSprite();
        _build = new Sprite();
        _dataBuild = dataBuildObject;
        _defaultScale = 1;
        _flip = _dataBuild.isFlip || false;
        _dataBuild.isFlip = _flip;
        _sizeX = 0;
        _sizeY = 0;
        _source.woObject = this;
        _sizeX = _dataBuild.width;
        _sizeY = _dataBuild.height;
    }

    public function onOut():void {}
    public function onHover():void {}
    public function afterPasteBuild():void {}
    public function get sizeX():uint { return _flip ? _sizeY : _sizeX; }
    public function get sizeY():uint { return _flip ? _sizeX : _sizeY; }
    public function get getArmature():Armature { return _armature; }
    public function get source():TownAreaBuildSprite { return _source; }
    public function get build():DisplayObject { return _build; }
    public function get rect():Rectangle { return _rect; }
    public function get depth():Number { return _depth; }
    public function get dataBuild():Object{ return _dataBuild; }
    public function get dbBuildingId():int{ return _dbBuildingId; }
    public function set dbBuildingId(a:int):void{ _dbBuildingId = a; }
    public function get stateBuild():int{ return _stateBuild; }
    public function set stateBuild(a:int):void{ _stateBuild = a; }
    public function get hitArea():OwnHitArea { return _hitArea; }
    public function addXP():void {}
    public function get craftSprite():Sprite {return _craftSprite; }
    public function get buildingBuildSprite():Sprite { return _buildingBuildSprite; }
    public function set enabled(value:Boolean):void { }
    public function get flip():Boolean { return _flip; }
    public function isContDrag():Boolean { return _source.isContDrag; }
    protected function buildingBuildDoneOver():void { if (_buildingBuild) _buildingBuild.overItDone(); }
    protected function buildingBuildFoundationOver():void { if (_buildingBuild)  _buildingBuild.overItFoundation(); }
    public function showForOptimisation(needShow:Boolean):void { if (_source) _source.visible = needShow; }

    public function updateDepth():void {
        var point3d:Point3D = IsoUtils.screenToIso(new Point(_source.x, _source.y));
        point3d.x += g.matrixGrid.FACTOR * _sizeX * 0.5;
        point3d.z += g.matrixGrid.FACTOR * _sizeY * 0.5;
        _depth = point3d.x + point3d.z + posX/10000;
        if (!useIsometricOnly) _depth -= 1000;
    }

    public function makeFlipBuilding():void {
        if (_flip) {
            _source.scaleX = -_defaultScale;
            if (_buildingBuildSprite) _buildingBuildSprite.scaleX = -_defaultScale;
        } else {
            _source.scaleX = _defaultScale;
            if (_buildingBuildSprite) _buildingBuildSprite.scaleX = _defaultScale;
        }
    }

    public function releaseFlip():void {
        if (_sizeX == _sizeY) {
            _flip = !_flip;
            makeFlipBuilding();
            _dataBuild.isFlip = _flip;
            return;
        }
        if (_dataBuild.buildType == BuildType.DECOR_TAIL) {
            if (_flip) {
                g.townArea.unFillTailMatrix(posX, posY, _sizeY, _sizeX);
            } else {
                g.townArea.unFillTailMatrix(posX, posY, _sizeX, _sizeY);
            }

            if (_flip) {
                if (g.toolsModifier.checkFreeTailGrids(posX, posY, _sizeX, _sizeY)) {
                    _flip = false;
                    g.townArea.fillTailMatrix(posX, posY, _sizeX, _sizeY, this);
                } else {
                    g.townArea.fillTailMatrix(posX, posY, _sizeY, _sizeX, this);
                }
            } else {
                if (g.toolsModifier.checkFreeTailGrids(posX, posY, _sizeY, _sizeX)) {
                    _flip = true;
                    g.townArea.fillTailMatrix(posX, posY, _sizeY, _sizeX, this);
                } else {
                    g.townArea.fillTailMatrix(posX, posY, _sizeX, _sizeY, this);
                }
            }

        }
        if (_flip) {
            g.townArea.unFillMatrix(posX, posY, _sizeY, _sizeX);
        } else {
            g.townArea.unFillMatrix(posX, posY, _sizeX, _sizeY);
        }

        if (_flip) {
            if (g.toolsModifier.checkFreeGrids(posX, posY, _sizeX, _sizeY)) {
                _flip = false;
                g.townArea.fillMatrix(posX, posY, _sizeX, _sizeY, this);
            } else {
                g.townArea.fillMatrix(posX, posY, _sizeY, _sizeX, this);
            }
        } else {
            if (g.toolsModifier.checkFreeGrids(posX, posY, _sizeY, _sizeX)) {
                _flip = true;
                g.townArea.fillMatrix(posX, posY, _sizeY, _sizeX, this);
            } else {
                g.townArea.fillMatrix(posX, posY, _sizeX, _sizeY, this);
            }
        }
        _dataBuild.isFlip = _flip;
        makeFlipBuilding();
    }

    public function showArrow(t:Number = 0, id:int = 0):void {
        hideArrow();
        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, _source);
        idResourceArrow = id;
        if (_rect) {
            var xX:int = 0;
            if (_sizeX != _sizeY) xX = _rect.x + _rect.width/2;
            _arrow.animateAtPosition(xX, _rect.y);
        } else {
            _arrow.animateAtPosition(0, -10);
        }
        if (t>0) _arrow.activateTimer(t, hideArrow);
    }

    public function hideArrow():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
    }

    public function set tutorialCallback(f:Function):void {
        _tutorialCallback = f;
    }

    public function clearIt():void {
//        if (_isoView) {
//            while (_isoView.numChildren) _isoView.removeChildAt(0);
//            _isoView = null;
//        }
        if (_buildingBuildSprite) while (_buildingBuildSprite.numChildren) _buildingBuildSprite.removeChildAt(0);
        if (_craftSprite) while (_craftSprite.numChildren) _craftSprite.removeChildAt(0);
        if (_build) while (_build.numChildren) _build.removeChildAt(0);
        if (_source) while (_source.numChildren) _source.removeChildAt(0);
        if (_craftSprite) {
            if (g.isAway) {
                if (g.cont.craftAwayCont.contains(_craftSprite)) g.cont.craftAwayCont.removeChild(_craftSprite);
            } else {
                if (g.cont.craftCont.contains(_craftSprite)) g.cont.craftCont.removeChild(_craftSprite);
            }
        }
        if (_source) _source.deleteIt();
        _dataBuild = null;
        _build = null;
        _source = null;
        _rect = null;
        _hitArea = null;
    }

    public function createAnimatedBuild(onCreate:Function):void {
        if (_build) {
            if (_source.contains(_build)) {
                _source.removeChild(_build);
            }
            while (_build.numChildren) _build.removeChildAt(0);
        }
        if (g.allData.factory[_dataBuild.url]) {
            createAnimBuild1(onCreate);
        } else {
            createIsoView();
            g.loadAnimation.load('animations_json/x1/' + _dataBuild.url, _dataBuild.url, createAnimBuild1, onCreate);
        }
    }

    private function createAnimBuild1(onCreate:Function):void {
        deleteIsoView();
        if (_dataBuild) {
            _armature = g.allData.factory[_dataBuild.url].buildArmature(_dataBuild.image);
            _build.addChild(_armature.display as StarlingArmatureDisplay);
            _rect = _build.getBounds(_build);
            _source.addChild(_build);
        }
        if (onCreate != null) onCreate.apply();
    }

    public function createAtlasBuild(onCreate:Function):void {
        if (_build) {
            if (_source.contains(_build)) {
                _source.removeChild(_build);
            }
            while (_build.numChildren) _build.removeChildAt(0);
        }
        if (g.allData.atlas[_dataBuild.url]) {
            createAtlasBuild1(onCreate);
        } else {
            createIsoView();
            g.load.loadAtlas(_dataBuild.url, _dataBuild.url, createAtlasBuild1);
        }
    }

    private function createAtlasBuild1(onCreate:Function=null):void {
        deleteIsoView();
        var im:Image = new Image(g.allData.atlas[_dataBuild.url].getTexture(_dataBuild.image));
        im.x = _dataBuild.innerX;
        im.y = _dataBuild.innerY;

        if (!im) {
            Cc.error('Ambar:: no such image: ' + _dataBuild.image + ' for ' + _dataBuild.id);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'AreaObject:: no such image');
            return;
        }
        _build.addChild(im);
        _rect = _build.getBounds(_build);
        _source.addChild(_build);
        if (onCreate != null) onCreate.apply();
    }

    public function createPNGBuild(onCreate:Function):void {
        createIsoView();
        if (_build) {
            if (_source.contains(_build)) {
                _source.removeChild(_build);
            }
            while (_build.numChildren) _build.removeChildAt(0);
        }
        if (g.pBitmaps[_dataBuild.url]) {
            createPNGBuild1(null, onCreate);
        } else {
            g.load.loadImage(_dataBuild.url, createPNGBuild1, onCreate);
        }
    }

    private function createPNGBuild1(b:Bitmap, onCreate:Function):void {
        deleteIsoView();
        var im:Image = new Image(Texture.fromBitmap(g.pBitmaps[_dataBuild.url].create() as Bitmap));
        im.x = _dataBuild.innerX;
        im.y = _dataBuild.innerY;

        if (!im) {
            Cc.error('Ambar:: no such image: ' + _dataBuild.image + ' for ' + _dataBuild.id);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'AreaObject:: no such image');
            return;
        }
        _build.addChild(im);
        _rect = _build.getBounds(_build);
        _source.addChild(_build);
        if (onCreate != null) onCreate.apply();
    }

    protected function createIsoView():void {
        if (_isoView) return;
        _isoView = new Sprite();
        var q:Quad  = new Quad(_dataBuild.width*g.matrixGrid.WIDTH_CELL, _dataBuild.height*g.matrixGrid.WIDTH_CELL, Color.WHITE);
        q.alpha = .15;
        q.rotation = Math.PI/4;
        _isoView.addChild(q);
        _isoView.scaleY = .5;
        _isoView.touchable = false;
        _source.addChildAt(_isoView, 0);
        _preloader = new FlashAnimatedPreloader();
        _preloader.source.x = (_dataBuild.width - _dataBuild.height)*g.matrixGrid.FACTOR/2;
        _preloader.source.y = _isoView.height/2;
        _preloader.source.scaleX = _preloader.source.scaleY = .8;
        _source.addChild(_preloader.source);
    }

    protected function deleteIsoView():void {
        if (_isoView) {
            if (_source) _source.removeChild(_isoView);
            _isoView.dispose();
            _isoView = null;
        }
        if (_preloader) {
            if (_source)_source.removeChild(_preloader.source);
            _preloader.deleteIt();
            _preloader = null;
        }
    }

    protected function addDoneBuilding():void {
        if (_buildingBuildSprite) {
            if (g.allData.factory['buildingBuild']) {
                addDoneBuilding1();
            } else {
                g.loadAnimation.load('animations_json/x1/building/', 'buildingBuild', addDoneBuilding1);
            }
        } else {
            Cc.error('_craftSprite == null  :(')
        }
    }

    private function addDoneBuilding1():void {
        if (!_buildingBuild) {
            _buildingBuild = new BuildingBuild('done');
        } else {
            _buildingBuild.doneAnimation();
        }
        _buildingBuildSprite.addChild(_buildingBuild.source);
        _rect = _buildingBuildSprite.getBounds(_buildingBuildSprite);
        _hitArea = g.managerHitArea.getHitArea(_source, 'buildingBuild', ManagerHitArea.TYPE_LOADED);
        _source.registerHitArea(_hitArea);
    }

    protected function addFoundationBuilding():void {
        if (_buildingBuildSprite) {
            if (g.allData.factory['buildingBuild']) {
                addFoundationBuilding1();
            } else {
                g.loadAnimation.load('animations_json/x1/building/', 'buildingBuild', addFoundationBuilding1);
            }
        } else {
            Cc.error('_craftSprite == null  :(')
        }
    }

    private function addFoundationBuilding1():void {
        if (!_buildingBuild) {
            _buildingBuild = new BuildingBuild('work');
        } else {
            _buildingBuild.workAnimation();
        }
        _buildingBuildSprite.addChild(_buildingBuild.source);
        _rect = _buildingBuildSprite.getBounds(_buildingBuildSprite);
        var isVisible:Boolean = _buildingBuildSprite.visible;
//        _buildingBuildSprite.visible = true;
        _hitArea = g.managerHitArea.getHitArea(_source, 'buildingBuild', ManagerHitArea.TYPE_LOADED);
//        _buildingBuildSprite.visible = isVisible;
        _source.registerHitArea(_hitArea);
    }

    protected function clearBuildingBuildSprite():void {
        g.managerQuest.onActionForTaskType(ManagerQuest.BUILD_BUILDING, {id:_dataBuild.id});
        if (_buildingBuildSprite) {
            while (_buildingBuildSprite.numChildren) _buildingBuildSprite.removeChildAt(0);
            if (_buildingBuild) {
                _buildingBuild.deleteIt();
                _buildingBuild = null;
            }
        }
    }

    protected function renderBuildProgress():void {
        _leftBuildTime--;
        if (_leftBuildTime <= 0) {
            g.gameDispatcher.removeFromTimer(renderBuildProgress);
            clearBuildingBuildSprite();
            addDoneBuilding();
            _stateBuild = STATE_WAIT_ACTIVATE;
            if (g.managerTutorial.isTutorial && _dataBuild.buildType == BuildType.FABRICA && g.managerTutorial.currentAction == TutorialAction.FABRICA_SKIP_FOUNDATION) {
                g.timerHint.canHide = true;
                g.timerHint.hideArrow();
                g.timerHint.hideIt(true);
                g.managerTutorial.checkTutorialCallback();
            }
        }
    }

    protected function makeOverAnimation():void {
        var time:Number = .15;
        TweenMax.killTweensOf(_build);
        _build.scaleX = _build.scaleY = 1;
        _build.y = 0;

        var f1:Function = function ():void {
            TweenMax.to(_build, time, {scaleX: 1.02, scaleY: 0.98, y: 0, onComplete: f2});
        };
        var f2:Function = function ():void {
            TweenMax.to(_build, time, {scaleX: 1, scaleY: 1});
        };
        TweenMax.to(_build, time, {scaleX: 0.98, scaleY: 1.02, y: -6*g.scaleFactor, onComplete: f1});
    }

}
}