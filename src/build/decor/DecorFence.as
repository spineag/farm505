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
        createAtlasBuild(null);
    }

    override public function clearIt():void {
        _source.touchable = false;
        super.clearIt();
    }

    override public function onHover():void {
        if (g.selectedBuild) return;
        super.onHover();
        _source.filter = ManagerFilters.BUILD_STROKE;
    }

    override public function onOut():void {
        super.onOut();
        if (g.isActiveMapEditor) return;
        _source.filter = null;
    }
}
}
