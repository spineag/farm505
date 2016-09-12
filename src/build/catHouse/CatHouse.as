/**
 * Created by user on 9/12/16.
 */
package build.catHouse {
import build.WorldObject;

import com.junkbyte.console.Cc;

import flash.geom.Point;

import hint.FlyMessage;

import media.SoundConst;

import windows.WindowsManager;

public class CatHouse extends WorldObject {

    private var _isHover:Boolean;

    public function CatHouse(_data:Object) {
        super(_data);
        if (!_data) {
            Cc.error('no data for CatHouse');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'no data for CatHouse');
            return;
        }
        createAtlasBuild(onCreateBuild);

        _source.releaseContDrag = true;
        _dbBuildingId = _data.dbId;
        _isHover = false;
    }

    private function onCreateBuild():void {
        if (!g.isAway) {
            _source.endClickCallback = onClick;
        }
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
    }

//    override public function afterPasteBuild():void {
//        _craftSprite.x = 104*g.scaleFactor + _source.x;
//        _craftSprite.y = 109*g.scaleFactor + _source.y;
//        super.afterPasteBuild();
//    }

    override public function clearIt():void {
        onOut();
        _source.touchable = false;
        super.clearIt();
    }

    override public function onHover():void {
        if (_isHover) return;
        super.onHover();
        _isHover = true;
        g.hint.showIt(_dataBuild.name);
    }

    override public function onOut():void {
        super.onOut();
        _isHover = false;
        g.hint.hideIt();
    }

    private function onClick():void {
        var p0:Point = new Point(g.ownMouse.mouseX, g.ownMouse.mouseY);
        p0.y -= 50;
        g.soundManager.playSound(SoundConst.EMPTY_CLICK);
        new FlyMessage(p0,"Скоро будет!!!");
    }

}
}
