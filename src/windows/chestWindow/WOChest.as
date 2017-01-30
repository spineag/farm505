/**
 * Created by user on 4/27/16.
 */
package windows.chestWindow {
import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingArmatureDisplay;

import manager.ManagerChest;
import manager.ManagerFilters;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import utils.MCScaler;
import windows.WindowMain;
import windows.WindowsManager;

public class WOChest  extends WindowMain{
    private var _armature:Armature;
    private var _woChestItem:WOChestItem;
    private var _woChestItemsTutorial:WOChestItemsTutorial;
    private var _btnOpen:CButton;
    private var _callback:Function;
    private var _txtBtn:CTextField;

    public function WOChest() {
        super();
        _windowType = WindowsManager.WO_CHEST;
        _woWidth = 400;
        _woHeight = 340;
        _armature = g.allData.factory['chest_interface'].buildArmature("box");
        _source.addChild(_armature.display as StarlingArmatureDisplay);
        WorldClock.clock.add(_armature);
        (_armature.display as Sprite).scale = .6;
    }

    private function onClickExit(e:Event=null):void {
        if (g.managerTutorial.isTutorial) return;
        hideIt();
    }

    override public function showItParams(callback:Function, params:Array):void {
        _callback = callback;
        if (g.managerChest.getCount + 1 <= 2) {
            var fEndOver:Function = function():void {
                _armature.removeEventListener(EventObject.COMPLETE, fEndOver);
                _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEndOver);
                _armature.animation.gotoAndStopByFrame('idle_2');
                if (g.managerTutorial.isTutorial) _woChestItemsTutorial = new WOChestItemsTutorial(_source, closeAnimation);
                else  _woChestItem = new WOChestItem(g.managerChest.dataPriseChest, _source, closeAnimation);
            };
            _armature.addEventListener(EventObject.COMPLETE, fEndOver);
            _armature.addEventListener(EventObject.LOOP_COMPLETE, fEndOver);
            _armature.animation.gotoAndPlayByFrame('idle_1');
        } else {
            _btnOpen = new CButton();
            _btnOpen.addButtonTexture(160, 40, CButton.GREEN, true);
            var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_medium'));
            MCScaler.scale(im, 35, 35);
            im.x = 120;
            im.y = 4;
            _btnOpen.addChild(im);
            _txtBtn = new CTextField(116,30,'Открыть за ' + String(ManagerChest.COST_OPEN));
            _txtBtn.setFormat(CTextField.BOLD18, 18 , Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
            _txtBtn.y = 5;
            _btnOpen.addChild(_txtBtn);
            _btnOpen.clickCallback = onClickOpen;
            _source.addChild(_btnOpen);
            _btnOpen.y = 190;
            _armature.animation.gotoAndPlayByFrame('idle_4');
            createExitButton(onClickExit);
        }
        onWoShowCallback = onShow;
        super.showIt();
    }

    private function onShow():void {
        if (_txtBtn) _txtBtn.updateIt();
    }

    private function closeAnimation():void {
        var fEndOver:Function = function(e:Event=null):void {
            if (_armature) {
                _armature.removeEventListener(EventObject.COMPLETE, fEndOver);
                _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEndOver);
            }
            if (g.managerTutorial.isTutorial) hideItTutorial();
            else hideIt();
        };
        if (_armature) {
            _armature.addEventListener(EventObject.COMPLETE, fEndOver);
            _armature.addEventListener(EventObject.LOOP_COMPLETE, fEndOver);
            _armature.animation.gotoAndPlayByFrame('idle_3');
        }
    }

    override public function hideIt():void {
        g.managerChest.setCount = 1;
        g.directServer.useChest(g.managerChest.getCount);
        super.hideIt();
        if (_callback != null) {
            _callback.apply(null,[]);
        }
    }

    private function hideItTutorial():void {
        g.managerTutorial.checkTutorialCallback();
        super.hideIt();
        if (_callback != null) {
            _callback.apply(null,[]);
        }
    }

    private function onClickOpen():void {
        if (g.user.hardCurrency < ManagerChest.COST_OPEN) {
            super.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        hideExitButton();
        var fEndOver:Function = function():void {
            _armature.removeEventListener(EventObject.COMPLETE, fEndOver);
            _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEndOver);
            _woChestItem = new WOChestItem(g.managerChest.dataPriseChest, _source, hideIt);
            if (_callback != null) {
                _callback.apply(null,[]);
            }
        };
        g.userInventory.addMoney(1,-ManagerChest.COST_OPEN);
        _armature.addEventListener(EventObject.COMPLETE, fEndOver);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, fEndOver);
        _armature.animation.gotoAndPlayByFrame('idle_5');
        _btnOpen.visible = false;

    }

    override protected function deleteIt():void {
        if (!_source) return;
        if (_armature) {
            _source.removeChild(_armature.display as Sprite);
            WorldClock.clock.remove(_armature);
            _armature.dispose();
        }
        if (_txtBtn) {
            _btnOpen.removeChild(_txtBtn);
            _txtBtn.deleteIt();
            _txtBtn = null;
        }
        _armature = null;
        _woChestItem = null;
        _btnOpen = null;
        _callback = null;
        super.deleteIt();
    }
}
}
