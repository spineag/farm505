/**
 * Created by user on 12/26/16.
 */
package windows.chestYellowWindow {
import data.DataMoney;

import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingArmatureDisplay;

import flash.geom.Point;

import manager.ManagerChest;

import resourceItem.DropItem;

import starling.display.Sprite;

import starling.events.Event;

import temp.DropResourceVariaty;

import ui.xpPanel.XPStar;

import windows.WindowMain;

public class WOChestYellow extends WindowMain {
    private var _armature:Armature;
    private var _data:Object;
    private var _callback:Function;
    private var _woChestItem:WOChestYellowItem;

    public function WOChestYellow() {
        _armature = g.allData.factory['chest_interface_yellow'].buildArmature('cat');
        _source.addChild(_armature.display as StarlingArmatureDisplay);
        WorldClock.clock.add(_armature);
    }

    override public function showItParams(callback:Function, params:Array):void {
        _callback = callback;
        _data = params[0];
        var arr:Array = [];
        if (_data.resource_id > 0) {
            var ob:Object = {};
            ob.resource_id = _data.resource_id;
            ob.resource_count = _data.resource_count;
            ob.type = ManagerChest.RESOURCE;
            arr.push(ob);
        }
        if (_data.money_count > 0) {
            ob = {};
            ob.money_count = _data.money_count;
            ob.type = ManagerChest.SOFT_MONEY;
            arr.push(ob);
        }
        if (_data.xp_count > 0) {
            ob ={};
            ob.xp_count = _data.xp_count;
            ob.type = ManagerChest.XP;
            arr.push(ob);
        }
            var fEndOver:Function = function():void {
                _armature.removeEventListener(EventObject.COMPLETE, fEndOver);
                _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEndOver);
                _armature.animation.gotoAndStopByFrame('idle_2');
                for (var i:int = 0; i< arr.length; i++) {
                    _woChestItem = new WOChestYellowItem(arr[i], _source, closeAnimation);
                    _woChestItem.source.x = -115 + (i*110);
                }
            };
            _armature.addEventListener(EventObject.COMPLETE, fEndOver);
            _armature.addEventListener(EventObject.LOOP_COMPLETE, fEndOver);
            _armature.animation.gotoAndPlayByFrame('idle_1');
        super.showIt();
    }

    private function closeAnimation():void {
        var fEndOver:Function = function(e:Event=null):void {
            if (_armature) {
                _armature.removeEventListener(EventObject.COMPLETE, fEndOver);
                _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEndOver);
            }
            hideIt();
        };
        if (_armature) {
            _armature.addEventListener(EventObject.COMPLETE, fEndOver);
            _armature.addEventListener(EventObject.LOOP_COMPLETE, fEndOver);
            _armature.animation.gotoAndPlayByFrame('idle_3');
        }
    }

    override public function hideIt():void {
        super.hideIt();
        if (_callback != null) {
            _callback.apply(null,[]);
        }
    }

    override protected function deleteIt():void {
        if (!_source) return;
        if (_armature) {
            _source.removeChild(_armature.display as Sprite);
            WorldClock.clock.remove(_armature);
            _armature.dispose();
        }
        _armature = null;
        _woChestItem = null;
        _callback = null;
        super.deleteIt();
    }
}
}
