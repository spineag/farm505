/**
 * Created by andy on 8/31/16.
 */
package heroes {
import dragonBones.Armature;
import dragonBones.Slot;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingArmatureDisplay;
import flash.geom.Point;
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import utils.IsoUtils;
import utils.Point3D;

public class AddNewHero {
    private var g:Vars = Vars.getInstance();
    private var _armature:Armature;
    private var _source:Sprite;
    private var _cat:HeroCat;
    private var p:Point;
    private var _depth:Number;
    private var _isWoman:int;
    private var callback:Function;

    public function AddNewHero() {
        _source = new Sprite();
    }
    
    public function get source():Sprite {
        return _source;
    }

    public function get depth():Number {
        return _depth;
    }

    public function updateDepth():void {
        var point3d:Point3D = IsoUtils.screenToIso(new Point(_source.x, _source.y));
        point3d.x += g.matrixGrid.FACTOR/2;
        point3d.z += g.matrixGrid.FACTOR/2;
        _depth = point3d.x + point3d.z;
    }

    public function addHero(isW:int, f:Function):void {
        _isWoman = isW;
        callback = f;
        if (g.allData.factory['catsShow']) {
            showCat();
        } else {
            g.loadAnimation.load('animations_json/x1/cats_show', 'catsShow', showCat);
        }
    }

    private function showCat():void {
        _armature = g.allData.factory['catsShow'].buildArmature('cat');
        _source.addChild(_armature.display as StarlingArmatureDisplay);
        p = new Point(31, 30);
        p = g.matrixGrid.getXYFromIndex(p);
        _source.x = p.x;
        _source.y = p.y;
        g.cont.contentCont.addChild(_source);
        _source.touchable = false;
        if (_isWoman == BasicCat.WOMAN) {
            releaseFrontWoman(_armature);
        } else {
            var b:Slot = _armature.getSlot('viyi');
            if (b) b.displayList = null;
        }
        
        updateDepth();
        g.townArea.addNonWorldObjectToCityObjects(this);
        WorldClock.clock.add(_armature);
        _armature.addEventListener(EventObject.COMPLETE, fEnd);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, fEnd);
        _armature.animation.gotoAndPlayByFrame('idle');
    }

    private function fEnd(e:Event):void {
        g.townArea.removeNonWorldObjectToCityObjects(this);
        _armature.removeEventListener(EventObject.COMPLETE, fEnd);
        _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEnd);
        WorldClock.clock.remove(_armature);
        g.cont.contentCont.removeChild(_source);
        _armature = null;
        _source.dispose();
        if (callback != null) {
            callback.apply(null, [_isWoman]);
        }
    }

    private function releaseFrontWoman(arma:Armature):void {
        changeTexture("head", "head_w", arma);
        changeTexture("body", "body_w", arma);
        changeTexture("handLeft", "hand_w_l", arma);
        changeTexture("legLeft", "leg_w_l", arma);
        changeTexture("handRight", "hand_w_r", arma);
        changeTexture("legRight", "leg_w_r", arma);
        changeTexture("tail", "tail_w", arma);
        changeTexture("handRight copy", "hand_w_r", arma);
    }

    private function changeTexture(oldName:String, newName:String, arma:Armature):void {
        var im:Image = new Image(g.allData.atlas['customisationAtlas'].getTexture(newName));
        var b:Slot = arma.getSlot(oldName);
        if (b && im) {
            b.displayList = null;
            b.display = im;
        }
    }
}
}
