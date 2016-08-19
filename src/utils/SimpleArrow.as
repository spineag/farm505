/**
 * Created by user on 3/1/16.
 */
package utils {
import com.greensock.TweenMax;

import dragonBones.Armature;
import dragonBones.animation.WorldClock;

import flash.events.TimerEvent;
import flash.utils.Timer;

import manager.Vars;
import starling.display.Sprite;

public class SimpleArrow {
    public static const POSITION_TOP:int=1;
    public static const POSITION_BOTTOM:int=2;
    public static const POSITION_LEFT:int=3;
    public static const POSITION_RIGHT:int=4;

    private var _source:Sprite;
    private var _parent:Sprite;
    private var _armature:Armature;
    private var _timer:Timer;
    private var _onTimerCallback:Function;
    private var g:Vars = Vars.getInstance();

    public function SimpleArrow(posType:int, parent:Sprite) {
        _parent = parent;
        _source = new Sprite();
        _source.visible = false;
        _source.touchable = false;
        _armature = g.allData.factory['arrow'].buildArmature("arrow");
        _source.addChild(_armature.display as Sprite);
        _source.scaleX = _source.scaleY = .7;
        switch (posType) {
            case POSITION_TOP: _source.rotation = 0; break;
            case POSITION_BOTTOM: _source.rotation = Math.PI; break;
            case POSITION_RIGHT: _source.rotation = Math.PI/2; break;
            case POSITION_LEFT: _source.rotation = -Math.PI/2; break;
        }
    }

    public function scaleIt(n:Number):void {
        _source.scaleX = _source.scaleY = n;
    }

    public function animateAtPosition(_x:int, _y:int):void {
        _source.x = _x;
        _source.y = _y;
        _source.visible = true;
        _parent.addChild(_source);
        _source.alpha = 0;
        TweenMax.to(_source, .5, {alpha:1});
        animateIt();
    }

    public function changeY(_y:int):void {
        _source.y = _y;
    }

    public function set visible(v:Boolean):void {
        _source.visible = v;
    }

    private function animateIt():void {
        WorldClock.clock.add(_armature);
        _armature.animation.gotoAndPlayByFrame('start');
    }
    
    public function activateTimer(n:Number, f:Function):void {
        _onTimerCallback = f;
        _timer = new Timer(n*1000, 1);
        _timer.addEventListener(TimerEvent.TIMER, onTimer);
        _timer.start();
    }

    private function onTimer(e:TimerEvent):void {
        if (_onTimerCallback != null) {
            _onTimerCallback.apply();
        }
        if (_timer) {
            _timer.removeEventListener(TimerEvent.TIMER, onTimer);
            _timer.stop();
            _timer = null;
        }
    }

    public function deleteIt():void {
        if (_timer) {
            _timer.removeEventListener(TimerEvent.TIMER, onTimer);
            _timer.stop();
            _timer = null;
            _onTimerCallback = null;
        }
        TweenMax.killTweensOf(_source);
        if (_parent.contains(_source)) _parent.removeChild(_source);
        WorldClock.clock.remove(_armature);
        _armature.dispose();
        _source.dispose();
        _armature = null;
        _source = null;
        _parent = null;
    }

}
}
