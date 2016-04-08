/**
 * Created by user on 4/7/16.
 */
package build.tutorialPlace {
import build.AreaObject;

import com.junkbyte.console.Cc;

import flash.geom.Point;

import flash.geom.Rectangle;

import starling.display.Image;

import windows.WindowsManager;

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
            createPlaceBuild();
            _rect = new flash.geom.Rectangle(0, 0, 10, 10);
            showArrow();
        } else {
            g.cont.contentCont.removeChild(_source);
            hideArrow();
            deleteIsoView();
            clearIt();
        }
    }

    private function createPlaceBuild():void {
        var im:Image;
        try {
            for (var i:int = 0; i < _dataBuild.width; i++) {
                for (var j:int = 0; j < _dataBuild.height; j++) {
                    im = new Image(g.matrixGrid.buildUnderTexture);
                    im.pivotX = im.width/2;
                    g.matrixGrid.setSpriteFromIndex(im, new Point(i, j));
                    _source.addChild(im);
                }
            }
            _source.addChildAt(_isoView, 0);
        } catch (e:Error) {
            Cc.error('TutorialPlace createPlaceBuild error id: ' + e.errorID + ' - ' + e.message);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'TutorialPlace createPlaceBuild ');
        }
    }
}
}
