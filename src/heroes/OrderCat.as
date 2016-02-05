/**
 * Created by user on 2/5/16.
 */
package heroes {
import dragonBones.Armature;
import dragonBones.Bone;
import dragonBones.animation.WorldClock;
import dragonBones.events.AnimationEvent;

import flash.geom.Point;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import utils.IsoUtils;
import utils.Point3D;

public class OrderCat {
    public static var BLACK:int = 1;
    public static var BLUE:int = 2;
    public static var GREEN:int = 3;
    public static var ORANGE:int = 4;
    public static var PINK:int = 5;
    public static var WHITE:int = 6;

    protected var _posX:int;
    protected var _posY:int;
    protected var _depth:Number;
    protected var _source:Sprite;
    protected var _typeCat:int;
    protected var _speedWalk:int = 2;
    private var _catImage:Sprite;
    private var _catBackImage:Sprite;
    private var heroEyes:HeroEyesAnimation;
    private var armature:Armature;
    private var armatureBack:Armature;
    protected var g:Vars = Vars.getInstance();

    public function OrderCat(type:int) {
        _typeCat = type;
        _source = new Sprite();
        _source.touchable = false;
        _catImage = new Sprite();
        _catBackImage = new Sprite();

        armature = g.allData.factory['cat_queue'].buildArmature("cat");
        armatureBack = g.allData.factory['cat_queue'].buildArmature("cat_back");
        _catImage.addChild(armature.display as Sprite);
        _catBackImage.addChild(armatureBack.display as Sprite);
        WorldClock.clock.add(armature);
        WorldClock.clock.add(armatureBack);

        if (_typeCat != BLACK) {
            changeCatTexture();
        } else {
            heroEyes = new HeroEyesAnimation(g.allData.factory['cat_queue'], armature, 'heads/head' ,false);
        }
        _source.addChild(_catImage);
        _source.addChild(_catBackImage);
        showFront(true);

        addShadow();
    }

    public function get source():Sprite {
        return _source;
    }

    private function addShadow():void {
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cat_shadow'));
        im.scaleX = im.scaleY = g.scaleFactor;
        im.x = -44*g.scaleFactor;
        im.y = -28*g.scaleFactor;
        im.alpha = .5;
        _source.addChild(im);
    }

    public function get depth():Number {
        if (_posX < 0 || _posY < 0) {
            _depth = _source.y - 500;
        } else {
            var point3d:Point3D = IsoUtils.screenToIso(new Point(_source.x, _source.y));
            point3d.x += g.matrixGrid.FACTOR/2;
            point3d.z += g.matrixGrid.FACTOR/2;
            _depth = point3d.x + point3d.z;
        }
        return _depth;
    }

    public function showFront(v:Boolean):void {
        _catImage.visible = v;
        _catBackImage.visible = !v;
        if (v) {
            heroEyes.startAnimations();
        } else {
            heroEyes.stopAnimations();
        }
    }

    private function changeCatTexture():void {
        var st:String;
        var isWoman:Boolean;
        switch (_typeCat) {
            case BLUE:   st = '_bl'; isWoman = false; break;
            case GREEN:  st = '_gr'; isWoman = false; break;
            case ORANGE: st = '_or'; isWoman = true;  break;
            case PINK:   st = '_pk'; isWoman = true;  break;
            case WHITE:  st = '_w';  isWoman = true;  break;
        }
        releaseFrontTexture(st);
        releaseBackTexture(st);
        heroEyes = new HeroEyesAnimation(g.allData.factory['cat_queue'], armature, 'heads/head' + st ,isWoman);
    }

    private function releaseFrontTexture(st:String):void {
        changeTexture("head", "heads/head" + st, armature);
        changeTexture("body", "bodys/body" + st, armature);
        changeTexture("handLeft", "left_hand/handLeft" + st, armature);
        changeTexture("handLeft 2copy", "left_hand/handLeft" + st, armature);
        changeTexture("legLeft", "left_leg/legLeft" + st, armature);
        changeTexture("handRight", "right_hand/handRight" + st, armature);
        changeTexture("legRight", "right_leg/legRight" + st, armature);
        changeTexture("tail", "tails/tail" + st, armature);
    }

    private function releaseBackTexture(st:String):void {
        changeTexture("head", "heads_b/head_b" + st, armatureBack);
        changeTexture("body", "bodys_b/body_b" + st, armatureBack);
        changeTexture("handLeft", "left_hand_b/handLeft_b" + st, armatureBack);
        changeTexture("legLeft", "left_leg_b/legLeft_b" + st, armatureBack);
        changeTexture("handRight", "right_hand_b/handRight_b" + st, armatureBack);
        changeTexture("legRight", "right_leg_b/legRight_b" + st, armatureBack);
        changeTexture("tail11", "tails/tail" + st, armatureBack);
    }

    private function changeTexture(oldName:String, newName:String, arma:Armature):void {
        var im:Image = g.allData.factory['cat_queue'].getTextureDisplay(newName) as Image;
        var b:Bone = arma.getBone(oldName);
        b.display.dispose();
        b.display = im;
    }

    public function setTailPositions(posX:int, posY:int, needQuick:Boolean = true):void {
        var p:Point = new Point(posX, posY);
        p = g.matrixGrid.getXYFromIndex(p);
        _source.x = p.x;
        _source.y = p.y;

        g.townArea.addOrderCatToCont(this);
        g.townArea.addOrderCatToCityObjects(this);
    }


    //  ------------------ ANIMATIONS -----------------------

    private var count:int;
    public function idleFrontAnimation():void {
        var r:int = int(Math.random()*50);
        if (r != 9) {
            armature.addEventListener(AnimationEvent.COMPLETE, onFinishIdle);
            armature.addEventListener(AnimationEvent.LOOP_COMPLETE, onFinishIdle);
        }
        if (r > 9) {
            armature.animation.gotoAndPlay("breath");
        } else {
            switch (r) {
                case 0: armature.animation.gotoAndPlay("idle1"); break;
                case 1: armature.animation.gotoAndPlay("idle2"); break;
                case 2: armature.animation.gotoAndPlay("idle3"); break;
                case 3: armature.animation.gotoAndPlay("idle4"); break;
                case 4: armature.animation.gotoAndPlay("idle5"); break;
                case 5: armature.animation.gotoAndPlay("idle6"); break;
                case 6: armature.animation.gotoAndPlay("idle7"); break;
                case 7: armature.animation.gotoAndPlay("idle8"); break;
                case 8: armature.animation.gotoAndPlay("idle9"); break;
                case 9: releaseBackIdle(); break;
            }
        }
    }

    private function onFinishIdle(e:AnimationEvent):void {
        armature.removeEventListener(AnimationEvent.COMPLETE, onFinishIdle);
        armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, onFinishIdle);
        idleFrontAnimation();
    }

    private function releaseBackIdle():void {
        showFront(false);
        count = 3;
        armatureBack.addEventListener(AnimationEvent.COMPLETE, onFinishIdleBack);
        armatureBack.addEventListener(AnimationEvent.LOOP_COMPLETE, onFinishIdleBack);
        armatureBack.animation.gotoAndPlay("idle");
    }

    private function onFinishIdleBack(e:AnimationEvent):void {
        count--;
        armatureBack.removeEventListener(AnimationEvent.COMPLETE, onFinishIdleBack);
        armatureBack.removeEventListener(AnimationEvent.LOOP_COMPLETE, onFinishIdleBack);
        if (count > 0) {
            armatureBack.addEventListener(AnimationEvent.COMPLETE, onFinishIdleBack);
            armatureBack.addEventListener(AnimationEvent.LOOP_COMPLETE, onFinishIdleBack);
            armatureBack.animation.gotoAndPlay("idle");
        } else {
            showFront(true);
            idleFrontAnimation();
        }
    }

    public function forceStopAnamation():void {
        if (armature.hasEventListener(AnimationEvent.COMPLETE)) armature.removeEventListener(AnimationEvent.COMPLETE, onFinishIdle);
        if (armature.hasEventListener(AnimationEvent.LOOP_COMPLETE)) armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, onFinishIdle);
        if (armatureBack.hasEventListener(AnimationEvent.COMPLETE)) armatureBack.removeEventListener(AnimationEvent.COMPLETE, onFinishIdleBack);
        if (armatureBack.hasEventListener(AnimationEvent.LOOP_COMPLETE)) armatureBack.removeEventListener(AnimationEvent.LOOP_COMPLETE, onFinishIdleBack);
        showFront(true);
    }

}
}
