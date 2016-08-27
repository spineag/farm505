/**
 * Created by andy on 6/20/16.
 */
package tutorial.pretuts {
import com.greensock.TweenMax;
import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingArmatureDisplay;

import manager.Vars;
import starling.display.Sprite;
import starling.events.Event;

public class MultCat {
    private var _source:Sprite;
    private var _parent:Sprite;
    private var _armature:Armature;
    private var g:Vars = Vars.getInstance();

    public function MultCat(_x:int, _y:int, p:Sprite) {
        _source = new Sprite();
        _armature = g.allData.factory['main_cat'].buildArmature('cat');
        _source.addChild(_armature.display as StarlingArmatureDisplay);
        _source.x = _x;
        _source.y = _y;
        _parent = p;
        _parent.addChild(_source);
        _source.scaleX = _source.scaleY = .37;
    }

    public function flipIt():void {
        _source.scaleX *= -1;
    }

    public function moveTo(newX:int, newY:int, d:Number):void {
        WorldClock.clock.add(_armature);
        _armature.addEventListener(EventObject.COMPLETE, onWalk);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, onWalk);
        _armature.animation.gotoAndPlayByFrame('run');
        TweenMax.to(_source, 1.2, {x:newX, y:newY, onComplete:showHello, delay:d});
    }

    private function onWalk(e:Event=null):void {
        _armature.animation.gotoAndPlayByFrame('run');
    }

    private function showHello():void {
        _armature.removeEventListener(EventObject.COMPLETE, onWalk);
        _armature.removeEventListener(EventObject.LOOP_COMPLETE, onWalk);
        _armature.addEventListener(EventObject.COMPLETE, onHello);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, onHello);
        _armature.animation.gotoAndPlayByFrame('hello');
    }

    private function onHello(e:Event=null):void {
        _armature.animation.gotoAndPlayByFrame('hello');
    }

    public function deleteIt():void {
        _armature.removeEventListener(EventObject.COMPLETE, onHello);
        _armature.removeEventListener(EventObject.LOOP_COMPLETE, onHello);
        WorldClock.clock.remove(_armature);
        _parent.removeChild(_source);
        _source.dispose();
    }
}
}
