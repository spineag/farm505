package build {

import com.junkbyte.console.Cc;

import starling.display.Image;
import starling.display.Sprite;

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

    protected function checkBuildState():void {
        if (g.user.userBuildingData[_dataBuild.id]) {
            if (g.user.userBuildingData[_dataBuild.id].isOpen) {
                _stateBuild = STATE_ACTIVE;
                createBuild();                                           // уже построенно и открыто
            } else {
                _leftBuildTime = int(g.user.userBuildingData[_dataBuild.id].timeBuildBuilding);  // сколько времени уже строится
                _leftBuildTime = int(_dataBuild.buildTime) - _leftBuildTime;                                 // сколько времени еще до конца стройки
                if (_leftBuildTime <= 0) {  // уже построенно, но не открыто
                    _stateBuild = STATE_WAIT_ACTIVATE;
                    createBuild();
                    addTempGiftIcon();
                } else {  // еще строится
                    _stateBuild = STATE_BUILD;
                    createBuild();
                    addTempBuildIcon();
                    g.gameDispatcher.addToTimer(renderBuildProgress);
                }
            }
        } else {
            _stateBuild = STATE_ACTIVE;
            createBuild();
        }
    }

    public function createBuild():void {
        var im:Image;
        if (_build) {
            if (_source.contains(_build)) {
                _source.removeChild(_build);
            }
        }

        if (_dataBuild.url == "buildAtlas") {
            im  = new Image(g.tempBuildAtlas.getTexture(_dataBuild.image));
            im.x = _dataBuild.innerX;
            im.y = _dataBuild.innerY;
        } else if (_dataBuild.url == "treeAtlas") {
            Cc.error('TREE in createBuild in AreaObject!');
        } else {
            im  = new Image(g.mapAtlas.getTexture(_dataBuild.image));
            im.x = -im.width/2;
        }

        _build.addChild(im);
        _defaultScale = _build.scaleX;
        _rect = _build.getBounds(_build);
        _sizeX = _dataBuild.width;
        _sizeY = _dataBuild.height;

        (_build as Sprite).alpha = 1;
        if (_flip) _build.scaleX = -_defaultScale;

        _source.addChild(_build);
    }

    protected function addTempGiftIcon():void {
        if (_craftSprite) {
            var im:Image = new Image(g.interfaceAtlas.getTexture('temp_gift_icon'));
            im.x = -im.width/2;
            im.y = -10;
            _craftSprite.addChild(im);
        } else {
            Cc.error('_craftSprite == null  :(')
        }
    }

    protected function addTempBuildIcon():void {
        if (_craftSprite) {
            var im:Image = new Image(g.interfaceAtlas.getTexture('work_icon'));
            im.x = -im.width/2;
            im.y = -10;
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
