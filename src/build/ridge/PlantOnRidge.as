/**
 * Created by user on 6/2/15.
 */
package build.ridge {
import com.junkbyte.console.Cc;

import manager.Vars;

import starling.display.Image;

import starling.display.Sprite;

public class PlantOnRidge {
    private var _source:Sprite;
    private var _ridge:Ridge;
    private var _data:Object;

    private var g:Vars = Vars.getInstance();

    public function PlantOnRidge(ridge:Ridge, data:Object) {
        _ridge = ridge;
        _data = data;
        _source = new Sprite();
        _ridge.source.addChild(_source);

        checkStateRidge();
    }

    private function checkStateRidge():void {
        switch (_ridge.stateRidge) {
            case Ridge.EMPTY:
                Cc.error('PlantOnRidge:: Wrong ridge state!');
                return;

            case Ridge.GROW1:
                addPlantImage(_data.image1, _data.innerPositions[0], _data.innerPositions[1]);
                break;
            case Ridge.GROW2:
                addPlantImage(_data.image2, _data.innerPositions[2], _data.innerPositions[3]);
                break;
            case Ridge.GROW3:
                addPlantImage(_data.image3, _data.innerPositions[4], _data.innerPositions[5]);
                break;
            case Ridge.GROWED:
                addPlantImage(_data.image4, _data.innerPositions[6], _data.innerPositions[7]);
                break;
        }
    }

    private function addPlantImage(st:String, _x:int, _y:int):void {
        while (_source.numChildren) {
            _source.removeChildAt(0);
        }
        var im:Image = new Image(g.plantAtlas.getTexture(st));
        im.x = _x;
        im.y = _y;
        _source.addChild(im);
    }
}
}
