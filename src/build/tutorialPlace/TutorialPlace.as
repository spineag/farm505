/**
 * Created by user on 4/7/16.
 */
package build.tutorialPlace {
import build.AreaObject;

import com.junkbyte.console.Cc;

public class TutorialPlace extends AreaObject{

    public function TutorialPlace(_data:Object) {
        super(_data);
        if (!_data) {
            Cc.error('TutorialPlace:: no data');
            return;
        }
//        createBuild();

        _source.releaseContDrag = true;
    }


}
}
