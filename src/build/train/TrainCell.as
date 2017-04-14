/**
 * Created by user on 7/24/15.
 */
package build.train {
import com.junkbyte.console.Cc;

import data.BuildType;

import data.DataMoney;

import flash.geom.Point;

import manager.Vars;

import resourceItem.DropItem;
import resourceItem.DropPartyResource;

import starling.core.Starling;

import starling.display.Image;

import temp.DropResourceVariaty;

import ui.xpPanel.XPStar;

import windows.WindowsManager;

public class TrainCell {
    private var _dataResource:Object;
    private var _count:int;
    private var _isFull:Boolean;
    public var item_db_id:String;
    public var countXP:int;
    public var countMoney:int;
    public var needHelp:Boolean;
    public var helpId:String;

    private var g:Vars = Vars.getInstance();

    public function TrainCell(d:Object) {
        if (!d) {
            Cc.error('no data for TrainCell');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'no data for TrainCell');
            return;
        }
        _dataResource = g.allData.getResourceById(int(d.resource_id));
        if (!_dataResource) {
            Cc.error('TrainCell:: no _dataResource for id:' + d.resource_id);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'trainCell no _dataResource');
            return;
        }
        _count = int(d.count_resource);
        _isFull = d.is_full == '1';
        item_db_id = d.id;
        countXP = int(d.count_xp);
        countMoney = int(d.count_money);
        needHelp = Boolean(int(d.want_help));
        helpId = String(d.help_id)
    }

    public function canBeFull():Boolean { return g.userInventory.getCountResourceById(_dataResource.id) >= _count; }
    public function whoHelpId(s:String):void { helpId = s; }
    public function needHelpNow(b:Boolean):void { needHelp = b; }
    public function get count():int { return _count; }
    public function get id():int { return _dataResource.id; }
    public function get isFull():Boolean { return _isFull; }

    public function fullIt(im:Image):void {
        g.userInventory.addResource(_dataResource.id, -_count);
        var p:Point;
        if (!im) {
            p = new Point(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2);
        } else {
            p = new Point(im.x + im.width / 2, im.y + im.height / 2);
            p = im.parent.localToGlobal(p);
        }
        if (p.x < 0 || p.y < 0 ) {
            p.x = g.managerResize.stageWidth/2;
            p.y = g.managerResize.stageHeight/2;
        }
        if (g.managerParty.eventOn && g.managerParty.typeParty == 2 && g.managerParty.typeBuilding == BuildType.TRAIN) new XPStar(p.x, p.y, countXP * g.managerParty.coefficient);
        else new XPStar(p.x, p.y, countXP);
        var prise:Object = {};
        prise.id = DataMoney.SOFT_CURRENCY;
        prise.type = DropResourceVariaty.DROP_TYPE_MONEY;
        if (g.managerParty.eventOn && g.managerParty.typeParty == 1 && g.managerParty.typeBuilding == BuildType.TRAIN) prise.count = countMoney * g.managerParty.coefficient;
        else prise.count = countMoney;
        new DropItem(p.x, p.y, prise);
        if (g.managerParty.eventOn && g.managerParty.typeParty == 3 && g.managerParty.typeBuilding == BuildType.TRAIN) new DropPartyResource(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2);
        _isFull = true;
        g.managerAchievement.addAll(3,countMoney);
        g.directServer.updateUserTrainPackItems(item_db_id, null);
    }

    public function getImage():Image {
        var im:Image;
        if (_dataResource.buildType == BuildType.PLANT) {
            im = new Image(g.allData.atlas['resourceAtlas'].getTexture(_dataResource.imageShop + '_icon'));
        } else {
            im = new Image(g.allData.atlas[g.allData.getResourceById(_dataResource.id).url].getTexture(g.allData.getResourceById(_dataResource.id).imageShop));
        }
        return im;
    }
}
}
