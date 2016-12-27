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

import resourceItem.DropItem;

import starling.events.Event;

import temp.DropResourceVariaty;

import ui.xpPanel.XPStar;

import windows.WindowMain;

public class WOChestYellow extends WindowMain {
    private var _armature:Armature;
    private var _data:Object;
    private var _callback:Function;

    public function WOChestYellow() {
        _armature = g.allData.factory['chest_interface_yellow'].buildArmature('cat');
        _source.addChild(_armature.display as StarlingArmatureDisplay);
        WorldClock.clock.add(_armature);
    }

    override public function showItParams(callback:Function, params:Array):void {
        _callback = callback;
        _data = params[0];
        super.showIt();
        var fEndOver:Function = function(e:Event=null):void {
            _armature.removeEventListener(EventObject.COMPLETE, fEndOver);
            _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEndOver);
            _armature.animation.gotoAndPlayByFrame('idle_3');
            openChest();
        };
        _armature.addEventListener(EventObject.COMPLETE, fEndOver);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, fEndOver);
        _armature.animation.gotoAndPlayByFrame('idle2');
    }

    private function openChest():void {
        var obj:Object;
        var p:Point = new Point(0, 0);
        p = _source.localToGlobal(p);
        if (_data.resource_id > 0) {
            obj = {};
            obj.count = _data.resource_count;
            obj.id =  _data.resource_id;
            obj.type = DropResourceVariaty.DROP_TYPE_RESOURSE;
            new DropItem(p.x, p.y, obj);
        }

        if (_data.xp_count > 0) new XPStar(p.x, p.y, _data.xp_count);
        if (_data.money_count) {

        }
        if (_callback != null) {
            _callback.apply(null,[]);
        }
    }
}
}
