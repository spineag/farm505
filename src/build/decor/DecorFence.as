/**
 * Created by user on 6/8/15.
 */
package build.decor {
import build.WorldObject;

import com.junkbyte.console.Cc;

import manager.ManagerFilters;

import starling.display.Image;

import windows.WindowsManager;

// для забора как в Птичем Городке
public class DecorFence extends WorldObject {
    public function DecorFence(_data:Object) {
        super(_data);
        createBuildDecor();
    }

    private function createBuildDecor():void {
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
            Cc.error('Ambar:: no such image: ' + _dataBuild.image + ' for ' + _dataBuild.id);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'AreaObject:: no such image');
            return;
        }
        _build.addChild(im);
        _rect = _build.getBounds(_build);
        _sizeX = _dataBuild.width;
        _sizeY = _dataBuild.height;
        _source.addChild(_build);
    }

    override public function clearIt():void {
        _source.touchable = false;
        super.clearIt();
    }

    private function onHover():void {
        _source.filter = ManagerFilters.BUILD_STROKE;
    }

    private function onOut():void {
        if (g.isActiveMapEditor) return;
        _source.filter = null;
    }
}
}
