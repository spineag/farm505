/**
 * Created by user on 5/23/16.
 */
package manager {
import com.junkbyte.console.Cc;

import flash.geom.Point;

import resourceItem.DropItem;

import starling.core.Starling;

import ui.xpPanel.XPStar;

import wallPost.WALLNewLevel;

public class ManagerWallPost {
    public static const NEW_LEVEL:String = 'new_level';
    public static const NEW_FABRIC:String = 'new_fabric';
    public static const NEW_LAND:String = 'new_land';
    public static const OPEN_TRAIN:String = 'open_train';
    public static const OPEN_CAVE:String = 'open_cave';
    public static const DONE_TRAIN:String = 'done_train';
    public static const DONE_ORDER:String = 'done_order';

    private var _count:int;
    private var _type:int;
    private var g:Vars = Vars.getInstance();

    public function ManagerWallPost() {

    }

    public function openWindow(type:String,callback:Function=null, ...params):void {
        _count = params[1];
        _type = params[2];
        switch (type) {
            case NEW_LEVEL:
               var wo:WALLNewLevel = new WALLNewLevel();
                break;
            case NEW_FABRIC:
//                wo = new WONoFreeCats();
                break;
            case NEW_LAND:
//                wo = new WOWaitFreeCats();
                break;
            case OPEN_TRAIN:
//                wo = new WOBuyCoupone();
                break;
            case OPEN_CAVE:
//                wo = new WOAmbarFilled();
                break;
            case DONE_TRAIN:
//                wo = new WOReloadGame();
                break;
            case DONE_ORDER:
//                wo = new WOServerError();
                break;

            default:
                Cc.error('WindowsManager:: unknown window type: ' + type);
                break;
        }
        wo.showItParams(callback,params);
    }


    public function callbackAward():void {
        if (_type == 9) new XPStar(Starling.current.nativeStage.stageWidth/2, Starling.current.nativeStage.stageHeight/2, _count);
        else {
            var obj:Object;
            obj = {};
            obj.count = _count;
            obj.id = _type;
            new DropItem(Starling.current.nativeStage.stageWidth/2, Starling.current.nativeStage.stageHeight/2,obj);
        }
    }
}
}
