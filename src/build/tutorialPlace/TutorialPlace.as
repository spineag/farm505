/**
 * Created by user on 4/7/16.
 */
package build.tutorialPlace {
import build.AreaObject;

import com.junkbyte.console.Cc;

import flash.geom.Rectangle;

public class TutorialPlace extends AreaObject{

    public function TutorialPlace(_data:Object) {
        super(_data);
        if (!_data) {
            Cc.error('TutorialPlace:: no data');
            return;
        }
        _source.touchable = false;
        useIsometricOnly = true;
        _source.releaseContDrag = true;
    }

    public function activateIt(v:Boolean):void {
        if (v) {
            createIsoView();
            _rect = new flash.geom.Rectangle(0, 0, 10, 10);
            showArrow();
        } else {
            g.cont.contentCont.removeChild(_source);
            hideArrow();
            deleteIsoView();
            clearIt();
        }
    }
}
}
