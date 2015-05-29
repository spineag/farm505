/**
 * Created by andy on 5/28/15.
 */
package build.testBuild {
import build.AreaObject;

public class TestBuild extends AreaObject{
    public function TestBuild(_data:Object) {
        super(_data);

        _source.hoverCallback = onHover;
        _source.endClickCallback = onClick;
        _source.outCallback = onOut;
    }

    private function onHover():void {

    }

    private function onClick():void {

    }

    private function onOut():void {

    }
}
}
