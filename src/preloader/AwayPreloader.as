/**
 * Created by andy on 1/21/16.
 */
package preloader {
import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.starling.StarlingArmatureDisplay;

import manager.Vars;

import starling.core.Starling;

import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;

import tutorial.TutorialAction;

public class AwayPreloader {
    private var _source:Sprite;
    private var _bg:Quad;
    private var _armature:Armature;
    private var _armatureSprite:Sprite;
    private var g:Vars = Vars.getInstance();
    private var isShowing:Boolean;
    private var afterTimer:Boolean;
    private var counter:int;
    private var _deleteCallback:Function;

    public function AwayPreloader() {
        _source = new Sprite();
        _armature = g.allData.factory['visit_preloader'].buildArmature("cat");
        _armatureSprite = new Sprite();
        _armatureSprite.addChild(_armature.display as StarlingArmatureDisplay);
        _source.addChild(_armatureSprite);
    }

    public function showIt(isBackHome:Boolean):void {
        _bg = new Quad(g.managerResize.stageWidth, g.managerResize.stageHeight, Color.BLACK);
        _bg.x = -g.managerResize.stageWidth/2;
        _bg.y = -g.managerResize.stageHeight/2;
        _source.addChildAt(_bg, 0);
        _bg.alpha = .8;
        if (!isBackHome) {
            _armatureSprite.scaleX = -1;
        } else {
            _armatureSprite.scaleX = 1;
        }
        WorldClock.clock.add(_armature);
        _armature.animation.gotoAndPlayByFrame('run');

        _source.x = g.managerResize.stageWidth/2;
        _source.y = g.managerResize.stageHeight/2;
        g.cont.windowsCont.addChild(_source);

        isShowing = true;
        afterTimer = false;
        counter = 1;
        g.gameDispatcher.addToTimer(onTimer);
        g.managerButterfly.hideButterfly(true);
    }

    public function deleteIt(f:Function = null):void {
        isShowing = false;
        _deleteCallback = f;
        if (afterTimer) {
            g.cont.windowsCont.removeChild(_source);
            WorldClock.clock.remove(_armature);
            _source.removeChild(_bg);
            _bg.dispose();
            _bg = null;
            _source.removeChild(_armature as Sprite);
            _armature = null;
            _source.dispose();
            _source = null;
            if (g.managerTutorial.isTutorial && (g.managerTutorial.currentAction == TutorialAction.VISIT_NEIGHBOR || g.managerTutorial.currentAction == TutorialAction.GO_HOME)) {
                g.managerTutorial.checkTutorialCallback();
            }
            g.managerButterfly.hideButterfly(false);
            if (_deleteCallback != null) {
                _deleteCallback.apply();
                _deleteCallback = null;
            }
        }
    }

    private function onTimer():void {
        counter--;
        if (counter <0) {
            g.gameDispatcher.removeFromTimer(onTimer);
            afterTimer = true;
            if (!isShowing) deleteIt();
        }
    }
}
}
