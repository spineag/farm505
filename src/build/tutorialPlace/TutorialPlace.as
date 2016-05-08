/**
 * Created by user on 4/7/16.
 */
package build.tutorialPlace {
import build.WorldObject;
import com.junkbyte.console.Cc;
import flash.geom.Point;
import flash.geom.Rectangle;
import starling.display.Image;
import windows.WindowsManager;

public class TutorialPlace extends WorldObject{

    public function TutorialPlace(_data:Object) {
        super(_data);
        if (!_data) {
            Cc.error('TutorialPlace:: no data');
            return;
        }
        _sizeX = _dataBuild.width;
        _sizeY = _dataBuild.height;
        _source.touchable = false;
        useIsometricOnly = true;
        _source.releaseContDrag = true;
        createPlaceBuild();
        _source.visible = false;
    }

    public function activateIt(v:Boolean):void {
        if (v) {
            g.townArea.fillMatrixWithTutorialBuildings(posX, posY, _sizeX, _sizeY, this);
            _source.visible = true;
            _rect = new flash.geom.Rectangle(0, 0, 10, 10);
            showArrow();
        } else {
            hideArrow();
            g.townArea.deleteBuild(this);
            clearIt();
        }
    }

    private function createPlaceBuild():void {
        var im:Image;
        var j:int;
        try {
            for (var i:int = 0; i < _dataBuild.width; i++) {
                for (j = 0; j < _dataBuild.height; j++) {
                    im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('yellow_tile'));
                    if (!im) {
                        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('green_tile'));
                    }
                    im.scaleX = im.scaleY = g.scaleFactor;
                    im.pivotX = im.width/2;
                    im.alpha = .5;
                    g.matrixGrid.setSpriteFromIndex(im, new Point(i, j));
                    im.y += 3;
                    im.x -= 11; // ???????? kakogo hrena prihoditsa smewat'??
                    _source.addChild(im);
                }
            }
//            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('red_tile'));  // for test
//            im.x = -im.width/2;
//            _source.addChild(im);
        } catch (e:Error) {
            Cc.error('TutorialPlace createPlaceBuild error id: ' + e.errorID + ' - ' + e.message);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'TutorialPlace createPlaceBuild ');
        }
    }
}
}
