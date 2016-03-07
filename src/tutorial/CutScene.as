/**
 * Created by yusjanja on 05.03.2016.
 */
package tutorial {
import com.greensock.TweenMax;

import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.events.AnimationEvent;

import manager.Vars;

import starling.display.Sprite;

public class CutScene {
    private var _source:Sprite;
    private var _armature:Armature;
    private var g:Vars = Vars.getInstance();
    private var _bubble:CutSceneTextBubble;
    private var _cont:Sprite;
    private var _xStart:int;
    private var _xEnd:int;

    public function CutScene() {
        _cont = g.cont.popupCont;
        _source = new Sprite();
        _bubble = new CutSceneTextBubble(_source);
        _xStart = -65;
        _xEnd = 85;
        _armature = g.allData.factory['tutorialCatBig'].buildArmature('cat');
        (_armature.display as Sprite).scaleX = -1;
        _source.addChild(_armature.display as Sprite);
        _source.y = 615;
    }

    public function showIt(st:String, stBtn:String, callback:Function, delay:Number):void {
        _cont.addChild(_source);
        _source.x = _xStart;
        TweenMax.to(_source, .5, {x:_xEnd, onComplete:showBubble, onCompleteParams: [st, stBtn, callback], delay:delay});
        WorldClock.clock.add(_armature);
        animateCat();
    }

    private function showBubble(st:String, stBtn:String, callback:Function):void {
        _bubble.showBubble(st, stBtn, callback);
    }

    private function animateCat(e:AnimationEvent = null):void {
        if (_armature.hasEventListener(AnimationEvent.LOOP_COMPLETE)) _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, animateCat);
        if (_armature.hasEventListener(AnimationEvent.COMPLETE)) _armature.removeEventListener(AnimationEvent.COMPLETE, animateCat);

        var label:String;
        var d:Number = Math.random();
        if (d < .5) label = 'idle';
            else if (d < .75) label = '_idle_2';
            else label = 'idle_3';
        _armature.addEventListener(AnimationEvent.COMPLETE, animateCat);
        _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, animateCat);
        _armature.animation.gotoAndPlay(label);
    }
}
}
