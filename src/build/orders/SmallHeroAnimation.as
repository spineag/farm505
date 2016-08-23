/**
 * Created by andy on 8/5/16.
 */
package build.orders {
import dragonBones.Armature;
import dragonBones.Slot;
import dragonBones.animation.WorldClock;
import dragonBones.starling.StarlingArmatureDisplay;

import starling.display.Sprite;

public class SmallHeroAnimation {
    private var _arma:Armature;
    private var _armaClip:StarlingArmatureDisplay;
    private var _armaClipCont:Sprite;
    private var _building:Order;

    public function SmallHeroAnimation(b:Order) {
        _building = b;
    }
    
    public function set armature(arma:Armature):void {
        if (!arma) return;
        var b:Slot = _building.getArmature.getSlot('table');
        if (b.display) b.display.dispose();
        _arma = arma;
        _armaClip = arma.display as StarlingArmatureDisplay;
        _armaClipCont = new Sprite();
        _armaClipCont.addChild(_armaClip);
        b.display = _armaClipCont;
        _armaClip.touchable = false;
        _armaClip.visible = false;
    }

    public function animateIt(v:Boolean):void {
        if (!_arma) return;
        if (v) {
            WorldClock.clock.add(_arma);
            _arma.animation.gotoAndPlayByFrame('start');
            _armaClip.visible = true;
        } else {
            _arma.animation.gotoAndStopByFrame('start');
            WorldClock.clock.remove(_arma);
            _armaClip.visible = false;
        }
    }

    public function deleteIt():void {
        _armaClipCont.removeChild(_armaClip);
        _arma.dispose();
        _armaClip = null;
        _building = null;
    }
}
}
