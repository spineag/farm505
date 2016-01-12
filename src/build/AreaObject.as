package build {

import com.junkbyte.console.Cc;

import flash.geom.Point;

import map.MatrixGrid;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;

import utils.CSprite;

public class AreaObject extends WorldObject {
    protected var _leftBuildTime:int;                   // сколько осталось времени до окончания постройки здания
    private var _buildingBuild:BuildingBuild;

    public function AreaObject(dataBuild:Object) {
        _source = new CSprite();
        _build = new Sprite();
        _dataBuild = dataBuild;
        _flip = _dataBuild.isFlip || false;
        _sizeX = 0;
        _sizeY = 0;
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
    }

    protected function checkBuildState():void {
        try {
            if (g.user.userBuildingData[_dataBuild.id]) {
                if (g.user.userBuildingData[_dataBuild.id].isOpen) {
                    _stateBuild = STATE_ACTIVE;
                    createBuild();                                           // уже построенно и открыто
                } else {
                    _leftBuildTime = int(g.user.userBuildingData[_dataBuild.id].timeBuildBuilding);  // сколько времени уже строится
                    _leftBuildTime = int(_dataBuild.buildTime) - _leftBuildTime;                                 // сколько времени еще до конца стройки
                    if (_leftBuildTime <= 0) {  // уже построенно, но не открыто
                        _stateBuild = STATE_WAIT_ACTIVATE;
//                    createBuild();
                        addDoneBuilding();
                    } else {  // еще строится
                        _stateBuild = STATE_BUILD;
//                    createBuild();
                        addFoundationBuilding();
                        g.gameDispatcher.addToTimer(renderBuildProgress);
                    }
                }
            } else {
                _stateBuild = STATE_ACTIVE;
                createBuild();
            }
        } catch (e:Error) {
            Cc.error('AreaObject checkBuildstate:: error: ' + e.errorID + ' - ' + e.message);
            g.woGameError.showIt();
        }
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
            g.woGameError.showIt();
            return;
        }
        _build.addChild(im);
        if (!isImageClicked) im.touchable = false;
        _defaultScale = _build.scaleX;
        _rect = _build.getBounds(_build);
        _sizeX = _dataBuild.width;
        _sizeY = _dataBuild.height;

        (_build as Sprite).alpha = 1;
//        if (_flip) _build.scaleX = -_defaultScale;

        _source.addChild(_build);

        //createIsoView();
    }

    protected function createIsoView():void {
        var im:Image;
        _isoView = new Sprite();
        try {
            for (var i:int = 0; i < _dataBuild.width; i++) {
                for (var j:int = 0; j < _dataBuild.height; j++) {
                    im = new Image(MatrixGrid.buildUnderTexture);
                    im.pivotX = im.width/2;
                    g.matrixGrid.setSpriteFromIndex(im, new Point(i, j));
                    _isoView.addChild(im);
                }
            }
            _source.addChildAt(_isoView, 0);
        } catch (e:Error) {
            Cc.error('AreaObject createIsoView error id: ' + e.errorID + ' - ' + e.message);
            g.woGameError.showIt();
        }
    }

    protected function deleteIsoView():void {
        while (_isoView.numChildren) _isoView.removeChildAt(0);
        _source.removeChild(_isoView);
        _isoView = null;
    }

    protected function addDoneBuilding():void {
        if (_craftSprite) {
            if (!_buildingBuild) {
                _buildingBuild = new BuildingBuild('done');
            } else {
                _buildingBuild.doneAnimation();
            }
            _craftSprite.addChild(_buildingBuild.source);
        } else {
            Cc.error('_craftSprite == null  :(')
        }
    }

    protected function addFoundationBuilding():void {
        if (_craftSprite) {
            if (!_buildingBuild) {
                _buildingBuild = new BuildingBuild('work');
            } else {
                _buildingBuild.workAnimation();
            }
            _craftSprite.addChild(_buildingBuild.source);
        } else {
            Cc.error('_craftSprite == null  :(')
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
        }
    }
}
}
