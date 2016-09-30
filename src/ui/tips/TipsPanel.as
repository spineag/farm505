/**
 * Created by user on 8/8/16.
 */
package ui.tips {
import com.greensock.TweenMax;
import dragonBones.Armature;
import dragonBones.Slot;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingArmatureDisplay;
import manager.ManagerFilters;
import manager.Vars;
import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;
import starling.utils.Color;
import utils.CSprite;
import utils.CTextField;
import utils.SimpleArrow;
import windows.WindowsManager;

public class TipsPanel {
    private var _source:CSprite;
    private var _armature:Armature;
    private var _txt:CTextField;
    private var _spriteTxt:Sprite;
    private var _arrow:SimpleArrow;
    private var _onHover:Boolean;
    private var g:Vars = Vars.getInstance();

    public function TipsPanel() {
        _onHover = false;
        _source = new CSprite();
    }

    public function showIt():void {
        _armature = g.allData.factory['icon_tips'].buildArmature('table');
        (_armature.display as StarlingArmatureDisplay).x = 60;
        (_armature.display as StarlingArmatureDisplay).y = -48;
        _source.addChild(_armature.display as StarlingArmatureDisplay);
        g.cont.interfaceCont.addChild(_source);
        _source.y = Starling.current.nativeStage.stageHeight + 120;
        WorldClock.clock.add(_armature);
        TweenMax.to(_source, .5, {y:Starling.current.nativeStage.stageHeight, onComplete: animateGuys});
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
        _source.endClickCallback = onClick;

        _spriteTxt = new Sprite();
        _spriteTxt.touchable = false;
        _txt = new CTextField(40, 40, "0");
        _txt.setFormat(CTextField.BOLD24, 22, Color.RED);
        _txt.x = -16;
        _txt.y = -12;
        _spriteTxt.addChild(_txt);
        var b:Slot = _armature.getSlot('number');
        if (b) {
            b.displayList = null;
            b.display = _spriteTxt;
        }
        g.managerTips.calculateAvailableTips();
    }

    public function onResize():void {
        _source.y = Starling.current.nativeStage.stageHeight;
        _source.x = 0;
    }

    public function deleteIt():void {
        deleteArrow();
        if (g.cont.interfaceCont.contains(_source)) g.cont.interfaceCont.removeChild(_source);
        _source.removeChild(_armature.display as StarlingArmatureDisplay);
        _armature.dispose();
        _source.deleteIt();
        _source = null;
    }

    public function updateAvailableActionCount(count:int):void {
        if (_txt) _txt.text = String(count);
    }

    private function onClick():void {
        deleteArrow();
        if (g.managerCutScenes.isCutScene || g.managerTutorial.isTutorial || g.isAway) return;
        TweenMax.killTweensOf(_source);
        g.windowsManager.openWindow(WindowsManager.WO_TIPS);
    }

    public function onHideWO():void {
        animateGuys();
    }

    private function onHover():void {
        if (_onHover) return;
        _onHover = true;
        TweenMax.killTweensOf(_source);
        g.hint.showIt("Подсказки",'none',1);
    }

    private function onOut():void {
        if (!_onHover) return;
        _onHover = false;
        g.hint.hideIt()
    }

    public function setUnvisible(v:Boolean):void {
        _source.visible = !v;
    }

    public function showArrow():void {
        deleteArrow();
//        _arrow = new SimpleArrow(SimpleArrow.POSITION_RIGHT, _source);
//        _arrow.scaleIt(.5);
//        _arrow.animateAtPosition(60, 15);
//        _arrow.activateTimer(5, deleteArrow);
    }

    private function deleteArrow():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
    }

    private var _counter:int=0;
    private function animateGuys():void {
        var n:int = int(Math.random()*7);
        switch (n) {
            case 0:
            case 1:
                _armature.animation.gotoAndPlayByFrame('idle_1');
                _armature.addEventListener(EventObject.COMPLETE, fEnd);
                _armature.addEventListener(EventObject.LOOP_COMPLETE, fEnd);
                break;
            case 2:
            case 3:
                _armature.animation.gotoAndPlayByFrame('idle_2');
                _armature.addEventListener(EventObject.COMPLETE, fEnd);
                _armature.addEventListener(EventObject.LOOP_COMPLETE, fEnd);
                break;
            case 4:
            case 5:
                _armature.animation.gotoAndPlayByFrame('idle_3');
                _armature.addEventListener(EventObject.COMPLETE, fEnd);
                _armature.addEventListener(EventObject.LOOP_COMPLETE, fEnd);
                break;
            case 6:
                _counter = 3;
                _armature.animation.gotoAndPlayByFrame('idle_6');
                _armature.addEventListener(EventObject.COMPLETE, fEnd6);
                _armature.addEventListener(EventObject.LOOP_COMPLETE, fEnd6);
                break;
        }
    }

    private function fEnd(e:Event=null):void {
        _armature.removeEventListener(EventObject.COMPLETE, fEnd);
        _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEnd);
        animateGuys();
    }

    private function fEnd6(e:Event=null):void {
        _counter--;
        if (_counter <=0) {
            _armature.removeEventListener(EventObject.COMPLETE, fEnd6);
            _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEnd6);
            _armature.addEventListener(EventObject.COMPLETE, fEnd7);
            _armature.addEventListener(EventObject.LOOP_COMPLETE, fEnd7);
            _armature.animation.gotoAndPlayByFrame('idle_7');
        } else {
            _armature.animation.gotoAndPlayByFrame('idle_6');
        }
    }

    private function fEnd7(e:Event=null):void {
        _armature.removeEventListener(EventObject.COMPLETE, fEnd7);
        _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEnd7);
        animateGuys();
    }

}
}
