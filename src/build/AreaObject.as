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

    public function AreaObject(dataBuild:Object) {
        _source = new CSprite();
        _build = new Sprite();
        _dataBuild = dataBuild;
        _flip = false;
        _sizeX = 0;
        _sizeY = 0;
    }

    override public function clearIt():void {
        if (_isoView) {
            while (_isoView.numChildren) _isoView.removeChildAt(0);
            _isoView = null;
        }
        while (_craftSprite.numChildren) _craftSprite.removeChildAt(0);
        while (_build.numChildren) _build.removeChildAt(0);
        while (_source.numChildren) _source.removeChildAt(0);
        _dataBuild = null;
        _build = null;
        _source = null;
        _rect = null;
        super.clearIt();
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
                        addTempGiftIcon();
                    } else {  // еще строится
                        _stateBuild = STATE_BUILD;
//                    createBuild();
                        addTempBuildIcon();
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
        }

        if (_dataBuild.url == "buildAtlas") {
            im = new Image(g.tempBuildAtlas.getTexture(_dataBuild.image));
            im.x = _dataBuild.innerX;
            im.y = _dataBuild.innerY;
        } else if (_dataBuild.url == "treeAtlas") {
            Cc.error('TREE in createBuild in AreaObject!');
        } else {
            im  = new Image(g.mapAtlas.getTexture(_dataBuild.image));
            im.x = -im.width/2;
        }

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
        if (_flip) _build.scaleX = -_defaultScale;

        _source.addChild(_build);

        createIsoView();
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

    protected function addTempGiftIcon():void {
        if (_craftSprite) {
//            var im:Image = new Image(g.interfaceAtlas.getTexture('temp_gift_icon'));
//            im.x = -im.width/2;
//            im.y = -10;
            var im:Image = new Image(g.tempBuildAtlas.getTexture('done_building'));
            if (!im) {
                Cc.error('AreaObject:: no image "done_building"');
                g.woGameError.showIt();
            }
            im.x = -191;
            im.y = -249;
            _craftSprite.addChild(im);
        } else {
            Cc.error('_craftSprite == null  :(')
        }
    }

    protected function addTempBuildIcon():void {
        if (_craftSprite) {
//            var im:Image = new Image(g.interfaceAtlas.getTexture('work_icon'));
//            im.x = -im.width/2;
//            im.y = -10;
            var im:Image = new Image(g.tempBuildAtlas.getTexture('foundation'));
            if (!im) {
                Cc.error('AreaObject:: no image "foundation"');
            }
            im.x = -262;
            im.y = -274;
            _craftSprite.addChild(im);
        } else {
            Cc.error('_craftSprite == null  :(')
        }
    }

    protected function clearCraftSprite():void {
        if (_craftSprite) {
            while (_craftSprite.numChildren) _craftSprite.removeChildAt(0);
        }
    }

    protected function renderBuildProgress():void {
        _leftBuildTime--;
        if (_leftBuildTime <= 0) {
            g.gameDispatcher.removeFromTimer(renderBuildProgress);
            clearCraftSprite();
            addTempGiftIcon();
            _stateBuild = STATE_WAIT_ACTIVATE;
        }
    }
}
}
