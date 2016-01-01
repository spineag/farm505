/**
 * Created by user on 6/2/15.
 */
package build.ridge {
import com.junkbyte.console.Cc;

import dragonBones.Armature;

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
    public var _timeToEndState:int;
    public var idFromServer:String; // в табличке user_plant_ridge
    private var armature:Armature;

    private var g:Vars = Vars.getInstance();

    public function PlantOnRidge(ridge:Ridge, data:Object) {
        if (!data) {
            Cc.error('no data for PlantOnRidge');
            g.woGameError.showIt();
            return;
        }
        _ridge = ridge;
        _data = data;
        _source = new Sprite();
        _ridge.addChildPlant(_source);
        armature = g.allData.factory[_data.url].buildArmature(_data.imageShop);
        (armature.display as Sprite).y = 35;
        _source.addChild(armature.display as Sprite);

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
                armature.animation.gotoAndPlay("state1");
                if (needSetTimer) _timeToEndState = _data.timeToGrow2;
                break;
            case Ridge.GROW2:
                armature.animation.gotoAndPlay("state2");
                if (needSetTimer) _timeToEndState = _data.timeToGrow3;
                break;
            case Ridge.GROW3:
                armature.animation.gotoAndPlay("state3");
                if (needSetTimer) _timeToEndState = _data.timeToStateGwoned;
                break;
            case Ridge.GROWED:
                armature.animation.gotoAndPlay("state4");
                break;
        }
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

    public function renderSkip():void {
        checkStateRidge();
        g.gameDispatcher.removeFromTimer(render);
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

    public function clearIt():void {
        _ridge = null;
        _data = null;
        g.gameDispatcher.removeFromTimer(render);
        while (_source.numChildren) _source.removeChildAt(0);
        _source = null;
    }
}
}
