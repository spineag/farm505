/**
 * Created by andy on 8/5/16.
 */
package build.orders {
import dragonBones.Armature;
import dragonBones.Bone;
import dragonBones.animation.WorldClock;
import starling.display.Sprite;

public class SmallHeroAnimation {
    private var _arma:Armature;
    private var _armaClip:Sprite;
    private var _armaClipCont:Sprite;
    private var _building:Order;

    public function SmallHeroAnimation(b:Order) {
        _building = b;
    }
    
    public function set armature(arma:Armature):void {
        if (!arma) return;
        var headBone:Bone = _building.getArmature.getBone('table');
        headBone.display.dispose();
        _arma = arma;
        _armaClip = arma.display as Sprite;
        _armaClipCont = new Sprite();
        _armaClipCont.addChild(_armaClip);
        headBone.display = _armaClipCont;
        _armaClip.touchable = false;
        _armaClip.visible = false;
    }

    public function animateIt(v:Boolean):void {
        if (!_arma) return;
        if (v) {
            WorldClock.clock.add(_arma);
            _arma.animation.gotoAndPlay('start');
            _armaClip.visible = true;
        } else {
            _arma.animation.gotoAndStop('start', 0);
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
