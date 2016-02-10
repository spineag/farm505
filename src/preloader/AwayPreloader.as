/**
 * Created by andy on 1/21/16.
 */
package preloader {
import dragonBones.Armature;
import dragonBones.animation.WorldClock;

import manager.Vars;

import starling.core.Starling;

import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;

public class AwayPreloader {
    private var _source:Sprite;
    private var _bg:Quad;
    private var _armature:Armature;
    private var _armatureSprite:Sprite;
    private var g:Vars = Vars.getInstance();
    private var isShowing:Boolean;
    private var afterTimer:Boolean;

    public function AwayPreloader() {
        _source = new Sprite();
        _armature = g.allData.factory['visitPreloader'].buildArmature("cat");
        _armatureSprite = new Sprite();
        _armatureSprite.addChild(_armature.display as Sprite);
        _source.addChild(_armatureSprite);
    }

    public function showIt(isBackHome:Boolean):void {
        _bg = new Quad(Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight, Color.BLACK);
        _bg.x = -Starling.current.nativeStage.stageWidth/2;
        _bg.y = -Starling.current.nativeStage.stageHeight/2;
        _source.addChildAt(_bg, 0);
        _bg.alpha = .7;
        if (!isBackHome) {
            _armatureSprite.scaleX = -1;
        } else {
            _armatureSprite.scaleX = 1;
        }
        WorldClock.clock.add(_armature);
        _armature.animation.gotoAndPlay('run');

        _source.x = Starling.current.nativeStage.stageWidth/2;
        _source.y = Starling.current.nativeStage.stageHeight/2;
        g.cont.windowsCont.addChild(_source);

        isShowing = true;
        afterTimer = false;
        g.gameDispatcher.addToTimer(onTimer);
    }

    public function hideIt():void {
        isShowing = false;
        if (afterTimer) {
            WorldClock.clock.remove(_armature);
            _source.removeChild(_bg);
            _bg.dispose();
            _bg = null;
            g.cont.windowsCont.removeChild(_source);
        }
    }

    private function onTimer():void {
        g.gameDispatcher.removeFromTimer(onTimer);
        afterTimer = true;
        if (!isShowing) hideIt();
    }
}
}
