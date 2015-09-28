/**
 * Created by user on 6/2/15.
 */
package build.ridge {
import manager.Vars;

import starling.display.Image;

import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

public class PlantOnRidge {
    private var _source:Sprite;
    private var _ridge:Ridge;
    private var _data:Object;
    private var _timeToEndState:int;
     public var idFromServer:String; // в табличке user_plant_ridge

    private var g:Vars = Vars.getInstance();

    public function PlantOnRidge(ridge:Ridge, data:Object) {
        _ridge = ridge;
        _data = data;
        _source = new Sprite();
        _ridge.addChildPlant(_source);

        _data.timeToGrow2 = _data.timeToGrow3 = int(_data.buildTime/3);
        _data.timeToStateGwoned = _data.buildTime -  _data.timeToGrow2 -  _data.timeToGrow3;
    }

    public function activateRender():void {
        g.gameDispatcher.addToTimer(render);
    }

    public function checkStateRidge(needSetTimer:Boolean = true):void {
        switch (_ridge.stateRidge) {
            case Ridge.EMPTY:
                while (_source.numChildren) {
                    _source.removeChildAt(0);
                }
                return;

            case Ridge.GROW1:
                addPlantImage(_data.image1, _data.innerPositions[0], _data.innerPositions[1]);
                if (needSetTimer) _timeToEndState = _data.timeToGrow2;
                break;
            case Ridge.GROW2:
                addPlantImage(_data.image2, _data.innerPositions[2], _data.innerPositions[3]);
                if (needSetTimer) _timeToEndState = _data.timeToGrow3;
                break;
            case Ridge.GROW3:
                addPlantImage(_data.image3, _data.innerPositions[4], _data.innerPositions[5]);
                if (needSetTimer) _timeToEndState = _data.timeToStateGwoned;
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

    public function render():void {
        _timeToEndState--;
        if (_timeToEndState <=0) {
            _ridge.stateRidge = _ridge.stateRidge + 1;
            checkStateRidge();
            if (_ridge.stateRidge == Ridge.GROWED) {
                g.gameDispatcher.removeFromTimer(render);
            }
        }
    }

    public function getTimeToGrowed():int {
        var n:int;
      switch  (_ridge.stateRidge) {
            case Ridge.GROW1:
                n = _timeToEndState + _data.timeToGrow3 + _data.timeToStateGwoned;
                break;
            case Ridge.GROW2:
                n = _timeToEndState + _data.timeToStateGwoned;
                break;
            case Ridge.GROW3:
                n = _timeToEndState;
                break;
        }
        return n;
    }

    public function checkTimeGrowing(timeWork:int):void {
        if (_data.buildTime - timeWork < _data.timeToStateGwoned) {
            _timeToEndState = _data.buildTime - timeWork;
            _ridge.stateRidge = Ridge.GROW3;
        } else if (timeWork < _data.timeToGrow2) {
            _timeToEndState = _data.timeToGrow2 - timeWork;
            _ridge.stateRidge = Ridge.GROW1;
        } else if (timeWork > _data.buildTime) {
            _timeToEndState = 0;
            _ridge.stateRidge = Ridge.GROWED;
        } else {
            _timeToEndState = _data.timeToGrow3 - (timeWork - _data.timeToGrow2);
            _ridge.stateRidge = Ridge.GROW2;
        }
    }
}
}
