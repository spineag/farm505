/**
 * Created by andy on 8/5/16.
 */
package build.orders {
import dragonBones.Armature;
import dragonBones.Slot;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingArmatureDisplay;

import manager.Vars;

import starling.display.Sprite;
import starling.events.Event;

public class SmallHeroAnimation {
    private var _arma:Armature;
    private var _armaClip:StarlingArmatureDisplay;
    private var _armaClipCont:Sprite;
    private var _building:Order;
    private var _isHas:Boolean;
    private var _arrLabels:Array;
    private var _needShow:Boolean =  true;
    private var g:Vars = Vars.getInstance();

    public function SmallHeroAnimation(b:Order) {
        _armaClipCont = new Sprite();
        _building = b;
        _isHas = false;
        _arrLabels = ['start', 'idle_1', 'idle_2', 'idle_3', 'idle_4', 'idle_5', 'idle_7'];
    }
    
    public function set armature(arma:Armature):void {
        if (!arma) return;
        var b:Slot = _building.getArmature.getSlot('table');
        if (b.display) b.display.dispose();
        _arma = arma;
        _armaClip = arma.display as StarlingArmatureDisplay;
        _armaClipCont.addChild(_armaClip);
        (_arma.display as StarlingArmatureDisplay).y = 5;
        (_arma.display as StarlingArmatureDisplay).x = 26;
        b.display = _armaClipCont;
        _armaClip.touchable = false;
        if (g.managerTutorial && g.managerTutorial.isTutorial) {
            _armaClipCont.visible = false;
            _needShow = false;
        } else {
            _armaClipCont.visible = true;
            _needShow = true;
            WorldClock.clock.add(_arma);
            _arma.addEventListener(EventObject.COMPLETE, fEnd);
            _arma.addEventListener(EventObject.LOOP_COMPLETE, fEnd);
        }
    }

    public function needShowIt(v:Boolean):void {
        _needShow = v;
        if (_arma) {
            if (_needShow) {
                _armaClipCont.visible = true;
                WorldClock.clock.add(_arma);
                _arma.addEventListener(EventObject.COMPLETE, fEnd);
                _arma.addEventListener(EventObject.LOOP_COMPLETE, fEnd);
            } else {
                _armaClipCont.visible = false;
                WorldClock.clock.remove(_arma);
                _arma.removeEventListener(EventObject.COMPLETE, fEnd);
                _arma.removeEventListener(EventObject.LOOP_COMPLETE, fEnd);
            }
        }
    }

    public function animateIt(v:Boolean):void {
        if (!_arma) return;
        _isHas = v;
        fEnd();
    }

    private function fEnd(e:Event=null):void {
        if (_isHas) {
//            _arma.animation.gotoAndPlayByFrame('idle_6');
            _arma.animation.gotoAndPlayByFrame('tabl_on');

        } else {
//            _arma.animation.gotoAndPlayByFrame(_arrLabels[int(Math.random()*7)]);
            _arma.animation.gotoAndPlayByFrame('tabl');
        }
    }

    public function deleteIt():void {
        _arma.removeEventListener(EventObject.COMPLETE, fEnd);
        _arma.removeEventListener(EventObject.LOOP_COMPLETE, fEnd);
        WorldClock.clock.remove(_arma);
        _armaClipCont.removeChild(_armaClip);
        _arma.dispose();
        _armaClip = null;
        _building = null;
    }
}
}
