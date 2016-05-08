/**
 * Created by user on 6/8/15.
 */
package build.decor {
import build.WorldObject;

import manager.ManagerFilters;

// для забора как в Птичем Городке
public class DecorFence extends WorldObject {
    public function DecorFence(_data:Object) {
        super(_data);
        createBuild();

//        _source.hoverCallback = onHover;
//        _source.endClickCallback = onClick;
//        _source.outCallback = onOut;
        _source.releaseContDrag = true;
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
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
