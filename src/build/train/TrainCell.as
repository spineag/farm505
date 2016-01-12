/**
 * Created by user on 7/24/15.
 */
package build.train {
import com.junkbyte.console.Cc;

import data.DataMoney;

import flash.geom.Point;

import manager.Vars;

import resourceItem.DropItem;

import starling.display.Image;

import temp.DropResourceVariaty;

import ui.xpPanel.XPStar;

public class TrainCell {
    private var _dataResource:Object;
    private var _count:int;
    private var _isFull:Boolean;
    private var item_db_id:String;
    public var countXP:int;
    public var countMoney:int;

    private var g:Vars = Vars.getInstance();

    public function TrainCell(d:Object) {
        if (!d) {
            Cc.error('no data for TrainCell');
            g.woGameError.showIt();
            return;
        }
        _dataResource = g.dataResource.objectResources[int(d.resource_id)];
        if (!_dataResource) {
            Cc.error('TrainCell:: no _dataResource for id:' + d.resource_id);
            g.woGameError.showIt();
            return;
        }
        _count = int(d.count_resource);
        _isFull = d.is_full == '1';
        item_db_id = d.id;
        countXP = int(d.count_xp);
        countMoney = int(d.count_money);
    }

    public function canBeFull():Boolean {
        return g.userInventory.getCountResourceById(_dataResource.id) >= _count;
    }

    public function get count():int {
        return _count;
    }

    public function get id():int {
        return _dataResource.id;
    }

    public function get isFull():Boolean {
        return _isFull;
    }

    public function fullIt(im:Image):void {
        g.userInventory.addResource(_dataResource.id, -_count);
        var p:Point = new Point(im.x + im.width/2, im.y + im.height/2);
        p = im.parent.localToGlobal(p);
        new XPStar(p.x, p.y, countXP);
        var prise:Object = {};
        prise.id = DataMoney.SOFT_CURRENCY;
        prise.type = DropResourceVariaty.DROP_TYPE_MONEY;
        prise.count = countMoney;
        new DropItem(p.x, p.y, prise);
        _isFull = true;
        g.directServer.updateUserTrainPackItems(item_db_id, null);
    }
}
}
