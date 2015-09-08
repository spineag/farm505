/**
 * Created by user on 6/8/15.
 */
package build.decor {
import build.AreaObject;


// для забора как в Птичем Городке
public class DecorFence extends AreaObject {
    public function DecorFence(_data:Object) {
        super(_data);
        createBuild();

//        _source.hoverCallback = onHover;
//        _source.endClickCallback = onClick;
//        _source.outCallback = onOut;
        _source.releaseContDrag = true;
        _dataBuild.isFlip = _flip;
    }
}
}
