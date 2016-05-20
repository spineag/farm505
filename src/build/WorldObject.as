package build {
import com.greensock.TweenMax;
import com.junkbyte.console.Cc;
import data.BuildType;
import flash.geom.Point;
import flash.geom.Rectangle;
import manager.Vars;
import manager.hitArea.OwnHitArea;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import tutorial.SimpleArrow;
import tutorial.TutorialAction;
import utils.IsoUtils;
import utils.Point3D;
import utils.CSprite;
import windows.WindowsManager;

public class WorldObject {
    public static var STATE_UNACTIVE:int = 1;       // только для стандартных зданий
    public static var STATE_BUILD:int = 2;          // состояние стройки
    public static var STATE_WAIT_ACTIVATE:int = 3;  // построенное, но еще не открытое
    public static var STATE_ACTIVE:int = 4;         // активное состояние, после стройки

    protected var _dataBuild:Object;
    protected var _flip:Boolean;
    protected var _defaultScale:Number;
    public var posX:int = 0;
    public var posY:int = 0;
    public var useIsometricOnly:Boolean = true;
    protected var _sizeX:int;
    protected var _sizeY:int;
    protected var _source:CSprite;
    protected var _build:Sprite;
    protected var _isoView:Sprite;
    protected var _craftSprite:Sprite;
    protected var _depth:Number = 0;
    protected var _rect:Rectangle;
    protected var _dbBuildingId:int = 0;   // id в таблице user_building
    protected var _stateBuild:int;  // состояние постройки (активное, в процесе стройки..)
    protected var _arrow:SimpleArrow;
    protected var _tutorialCallback:Function;
    protected var _hitArea:OwnHitArea;
    protected var _leftBuildTime:int;                   // сколько осталось времени до окончания постройки здания
    private var _buildingBuild:BuildingBuild;
    public var countShopCost:int;

    protected static var g:Vars = Vars.getInstance();

    public function WorldObject(dataBuildObject:Object) {
        _tutorialCallback = null;
        _source = new CSprite();
        _build = new Sprite();
        _dataBuild = dataBuildObject;
        _defaultScale = 1;
        _flip = _dataBuild.isFlip || false;
        _dataBuild.isFlip = _flip;
        _sizeX = 0;
        _sizeY = 0;
        _source.woObject = this;
    }

    public function get sizeX():uint {
        return _flip ? _sizeY : _sizeX;
    }

    public function get sizeY():uint {
        return _flip ? _sizeX : _sizeY;
    }

    public function get source():CSprite {
        return _source;
    }

    public function get build():DisplayObject {
        return _build;
    }

    public function get rect():Rectangle {
        return _rect;
    }

    public function get depth():Number {
        return _depth;
    }

    public function get dataBuild():Object{
        return _dataBuild;
    }

    public function get dbBuildingId():int{
        return _dbBuildingId;
    }

    public function set dbBuildingId(a:int):void{
        _dbBuildingId = a;
    }

    public function get stateBuild():int{
        return _stateBuild;
    }

    public function set stateBuild(a:int):void{
        _stateBuild = a;
    }

    public function addXP():void {}

    public function get craftSprite():Sprite {
        return _craftSprite;
    }

    public function updateDepth():void {
        var point3d:Point3D = IsoUtils.screenToIso(new Point(_source.x, _source.y));

        point3d.x += g.matrixGrid.FACTOR * _sizeX * 0.5;
        point3d.z += g.matrixGrid.FACTOR * _sizeY * 0.5;

        _depth = point3d.x + point3d.z + posX/10000;
        if (!useIsometricOnly) _depth -= 1000;
    }

    public function set enabled(value:Boolean):void { }

    public function get flip():Boolean {
        return _flip;
    }

    public function makeFlipBuilding():void {
        if (_flip) {
            _source.scaleX = -_defaultScale;
            if (_craftSprite) _craftSprite.scaleX = -_defaultScale;
        } else {
            _source.scaleX = _defaultScale;
            if (_craftSprite) _craftSprite.scaleX = _defaultScale;
        }
    }

    public function releaseFlip():void {
        if (_sizeX == _sizeY) {
            _flip = !_flip;
            makeFlipBuilding();
            _dataBuild.isFlip = _flip;
            return;
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

    public function isContDrag():Boolean {
        return _source.isContDrag;
    }

    public function showArrow():void {
        hideArrow();
        if (_rect) {
            _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, _source);
            _arrow.animateAtPosition(_rect.x + _rect.width/2, _rect.y);
        }
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
        if (_craftSprite) while (_craftSprite.numChildren) _craftSprite.removeChildAt(0);
        if (_build) while (_build.numChildren) _build.removeChildAt(0);
        if (_source) while (_source.numChildren) _source.removeChildAt(0);
        _dataBuild = null;
        _build = null;
        _source = null;
        _rect = null;
        _hitArea = null;
    }

    public function createBuild(isImageClicked:Boolean = true):void {
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
            Cc.error('AreaObject:: no such image: ' + _dataBuild.image + ' for ' + _dataBuild.id);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'AreaObject:: no such image');
            return;
        }
        _build.addChild(im);
        if (!isImageClicked) im.touchable = false;
        _rect = _build.getBounds(_build);
        _sizeX = _dataBuild.width;
        _sizeY = _dataBuild.height;
        (_build as Sprite).alpha = 1;
        _source.addChild(_build);
    }

    protected function createIsoView():void {
        if (_isoView) return;
        var im:Image;
        _isoView = new Sprite();
        try {
            for (var i:int = 0; i < _dataBuild.width; i++) {
                for (var j:int = 0; j < _dataBuild.height; j++) {
                    im = new Image(g.matrixGrid.buildUnderTexture);
                    im.pivotX = im.width/2;
                    g.matrixGrid.setSpriteFromIndex(im, new Point(i, j));
                    _isoView.addChild(im);
                }
            }
            _source.addChildAt(_isoView, 0);
        } catch (e:Error) {
            Cc.error('AreaObject createIsoView error id: ' + e.errorID + ' - ' + e.message);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'AreaObject createIsoView ');
        }
    }

    protected function deleteIsoView():void {
        if (_isoView) {
            while (_isoView.numChildren) _isoView.removeChildAt(0);
            _source.removeChild(_isoView);
            _isoView = null;
        }
    }

    protected function addDoneBuilding():void {
        if (_craftSprite) {
            if (g.allData.factory['buildingBuild']) {
                addDoneBuilding1();
            } else {
                g.loadAnimation.load('animations/x1/building/', 'buildingBuild', addDoneBuilding1);
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
        _craftSprite.addChild(_buildingBuild.source);
        _rect = _craftSprite.getBounds(_craftSprite);
        _hitArea = g.managerHitArea.getHitArea(_source, 'buildingBuild');
        _source.registerHitArea(_hitArea);
    }

    protected function addFoundationBuilding():void {
        if (_craftSprite) {
            if (g.allData.factory['buildingBuild']) {
                addFoundationBuilding1();
            } else {
                g.loadAnimation.load('animations/x1/building/', 'buildingBuild', addFoundationBuilding1);
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
        _craftSprite.addChild(_buildingBuild.source);
        _rect = _craftSprite.getBounds(_craftSprite);
        _hitArea = g.managerHitArea.getHitArea(_source, 'buildingBuild');
        _source.registerHitArea(_hitArea);
    }

    protected function buildingBuildDoneOver():void {
        if (_buildingBuild) {
            _buildingBuild.overItDone();
        }
    }

    protected function buildingBuildFoundationOver():void {
        if (_buildingBuild) {
            _buildingBuild.overItFoundation();
        }
    }

    protected function clearCraftSprite():void {
        if (_craftSprite) {
            while (_craftSprite.numChildren) _craftSprite.removeChildAt(0);
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
            clearCraftSprite();
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