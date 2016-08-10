/**
 * Created by user on 10/1/15.
 */
package windows.lockedLand {
import build.lockedLand.LockedLand;
import com.junkbyte.console.Cc;
import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.events.AnimationEvent;
import manager.ManagerFilters;
import manager.ManagerWallPost;

import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;
import utils.CButton;
import windows.WOComponents.Birka;
import windows.WOComponents.CartonBackground;
import windows.WOComponents.HintBackground;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOLockedLand extends WindowMain {
    private var _dataLand:Object;
    private var _land:LockedLand;
    private var _arrItems:Array;
    private var _btnOpen:CButton;
    private var _woBG:WindowBackground;
    private var _armature:Armature;
    private var _birka:Birka;
    private var _pl:HintBackground;
    private var _bgC:CartonBackground;

    public function WOLockedLand() {
        super();
        _windowType = WindowsManager.WO_LOCKED_LAND;
        _arrItems = [];
        _woWidth = 550;
        _woHeight = 540;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;
        _birka = new Birka('Новая территория', _source, _woWidth, _woHeight);

        _bgC = new CartonBackground(460, 320);
        _bgC.filter =  ManagerFilters.SHADOW;
        _bgC.x = -_woWidth/2 + 47;
        _bgC.y = -_woHeight/2 + 180;
        _source.addChild(_bgC);

        _btnOpen = new CButton();
        _btnOpen.addButtonTexture(158, 46, CButton.BLUE, true);
        var txt:TextField = new TextField(158,46,'Открыть участок',g.allData.fonts['BloggerMedium'],18,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _btnOpen.addChild(txt);
        _btnOpen.registerTextField(txt, ManagerFilters.TEXT_STROKE_BLUE);
        _btnOpen.x = 0;
        _btnOpen.y = -_woHeight/2 + 515;
        _source.addChild(_btnOpen);

        _pl = new HintBackground(310, 97, HintBackground.LONG_TRIANGLE, HintBackground.LEFT_CENTER);
        _pl.x = -_woWidth/2 + 179;
        _pl.y = -_woHeight/2 + 109;
        _pl.addShadow();
        _source.addChild(_pl);
        txt = new TextField(310,97,'Выполните следующие задания, чтобы открыть этот участок',g.allData.fonts['BloggerMedium'], 18, ManagerFilters.TEXT_BLUE_COLOR);
        _pl.inSprite.addChild(txt);
        addAnimation();
    }

    override public function showItParams(callback:Function, params:Array):void {
        _dataLand = params[0];
        _land = params[1];

        if (!_dataLand || !_land) {
            Cc.error('WOLockedLand showIt:: bad _dataLand or _land');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woLockedLand');
            return;
        }

        var item:LockedLandItem;
        if (_dataLand.friendsCount > 0) {
            item = new LockedLandItem();
            item.fillWithCurrency(_dataLand.currencyCount);
            item.source.y = -_woHeight/2 + 195;
            item.source.x = -_woWidth/2 + 64;
            _source.addChild(item.source);
            _arrItems.push(item);

            item = new LockedLandItem();
            item.fillWithResource(_dataLand.resourceId, _dataLand.resourceCount);
            item.source.y = -_woHeight/2 + 300;
            item.source.x = -_woWidth/2 + 64;
            _source.addChild(item.source);
            _arrItems.push(item);

            item = new LockedLandItem();
            item.fillWithFriends(_dataLand.friendsCount);
            item.source.y = -_woHeight/2 + 405;
            item.source.x = -_woWidth/2 + 64;
            _source.addChild(item.source);
            _arrItems.push(item);
        } else {
            item = new LockedLandItem();
            item.fillWithCurrency(_dataLand.currencyCount);
            item.source.y = -_woHeight/2 + 245;
            item.source.x = -_woWidth/2 + 64;
            _source.addChild(item.source);
            _arrItems.push(item);

            item = new LockedLandItem();
            item.fillWithResource(_dataLand.resourceId, _dataLand.resourceCount);
            item.source.y = -_woHeight/2 + 360;
            item.source.x = -_woWidth/2 + 64;
            _source.addChild(item.source);
            _arrItems.push(item);
        }
        checkBtn();
        WorldClock.clock.add(_armature);
        showAnimation();
        super.showIt();
    }

    private function checkBtn():void {
        var b:Boolean = true;
        for (var i:int=0; i<_arrItems.length; i++) {
            if (!_arrItems[i].isGood) {
                b = false;
                break;
            }
        }
        if (b) {
            _btnOpen.setEnabled = true;
            _btnOpen.clickCallback = onBtnOpen;
        } else {
            _btnOpen.clickCallback = null;
            _btnOpen.setEnabled = false;
        }
    }

    private function onBtnOpen():void {
        _land.showBoom();
        _land = null;
        hideIt();
    }

    private function addAnimation():void {
        _armature = g.allData.factory['plot_seller'].buildArmature("cat_customer");
        _armature.display.x = -150;
        _armature.display.y = -150;
        _armature.display.scaleX = -1;
        _source.addChild(_armature.display as Sprite);
    }

    private function showAnimation(e:AnimationEvent = null):void {
        if(!_armature) return;
        if (_armature.hasEventListener(AnimationEvent.COMPLETE)) _armature.removeEventListener(AnimationEvent.COMPLETE, showAnimation);
        if (_armature.hasEventListener(AnimationEvent.LOOP_COMPLETE)) _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, showAnimation);

        _armature.addEventListener(AnimationEvent.COMPLETE, showAnimation);
        _armature.addEventListener(AnimationEvent.LOOP_COMPLETE, showAnimation);
        var l:int = int(Math.random()*5);
        switch (l) {
            case 0: _armature.animation.gotoAndPlay('idle1'); break;
            case 1: _armature.animation.gotoAndPlay('idle1'); break;
            case 2: _armature.animation.gotoAndPlay('hi'); break;
            case 3: _armature.animation.gotoAndPlay('idle_2'); break;
            case 4: _armature.animation.gotoAndPlay('idle_3'); break;
        }
    }

    override protected function deleteIt():void {
        for (var i:int=0; i<_arrItems.length; i++) {
            _source.removeChild(_arrItems[i].source);
            _arrItems[i].deleteIt();
        }
        _arrItems.length = 0;
        WorldClock.clock.remove(_armature);
        if (_armature) if (_armature.hasEventListener(AnimationEvent.COMPLETE)) _armature.removeEventListener(AnimationEvent.COMPLETE, showAnimation);
        if (_armature) if (_armature.hasEventListener(AnimationEvent.LOOP_COMPLETE)) _armature.removeEventListener(AnimationEvent.LOOP_COMPLETE, showAnimation);
        if (_armature) _source.removeChild(_armature.display as Sprite);
        if (_armature) _armature.dispose();
        if (_armature) _armature = null;
        _source.removeChild(_btnOpen);
        _btnOpen.deleteIt();
        _btnOpen = null;
        _source.removeChild(_pl);
        _pl.deleteIt();
        _pl = null;
        _source.removeChild(_birka);
        _birka.deleteIt();
        _birka = null;
        _source.removeChild(_bgC);
        _bgC.deleteIt();
        _bgC = null;
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        super.deleteIt();
    }
}
}
