/**
 * Created by user on 5/23/16.
 */
package manager {
import com.junkbyte.console.Cc;

import flash.geom.Point;

import quest.QuestData;

import resourceItem.DropItem;

import starling.core.Starling;

import ui.xpPanel.XPStar;

import wallPost.WALLDoneOrder;

import wallPost.WALLDoneTrain;
import wallPost.WALLForQuest;
import wallPost.WALLNewFabric;

import wallPost.WALLNewLevel;
import wallPost.WALLOpenCave;
import wallPost.WALLOpenLand;
import wallPost.WALLOpenTrain;

public class ManagerWallPost {
    public static const NEW_LEVEL:String = 'new_level';
    public static const NEW_FABRIC:String = 'new_fabric';
    public static const NEW_LAND:String = 'new_land';
    public static const OPEN_TRAIN:String = 'open_train';
    public static const OPEN_CAVE:String = 'open_cave';
    public static const DONE_TRAIN:String = 'done_train';
    public static const DONE_ORDER:String = 'done_order';
    public static const POST_FOR_QUEST:String = 'done_order';

    private var _count:int;
    private var _type:int;
    private var _typePost:String;
    private var g:Vars = Vars.getInstance();

    public function ManagerWallPost() {

    }

    public function openWindow(type:String,callback:Function=null, ...params):void {
        _count = params[0];// количество подарка
        _type = params[1];//тип подарка
        _typePost = type;
        switch (type) {
            case NEW_LEVEL:
               var woLevel:WALLNewLevel = new WALLNewLevel();
                woLevel.showItParams(callback,params);
                break;
            case NEW_FABRIC:
                var woNewFabric:WALLNewFabric = new WALLNewFabric();
                woNewFabric.showItParams(callback,params[2]);
                break;
            case NEW_LAND:
                var woNewLand:WALLOpenLand = new WALLOpenLand();
                woNewLand.showItParams(callback,params);
                break;
            case OPEN_TRAIN:
                var woOpenTrain:WALLOpenTrain = new WALLOpenTrain();
                woOpenTrain.showItParams(callback,params);
                break;
            case OPEN_CAVE:
               var woCave:WALLOpenCave = new WALLOpenCave();
                woCave.showItParams(callback,params);
                break;
            case DONE_TRAIN:
                var woDoneTrain:WALLDoneTrain = new WALLDoneTrain();
                woDoneTrain.showItParams(callback,params);
                break;
            case DONE_ORDER:
                var woDoneOrder:WALLDoneOrder = new WALLDoneOrder();
                woDoneOrder.showItParams(callback,params);
                break;
            case POST_FOR_QUEST:
                var woForQuest:WALLForQuest = new WALLForQuest();
                woForQuest.showItParams(callback, params);

            default:
                Cc.error('WindowsManager:: unknown window type: ' + type);
                break;
        }

    }


    public function callbackAward():void {
        if (_typePost == POST_FOR_QUEST) {
            g.managerQuest.onFinishActionForQuestByType(QuestData.TYPE_POST);
        } else {
            if (_type == 9) {
                new XPStar(Starling.current.nativeStage.stageWidth / 2, Starling.current.nativeStage.stageHeight / 2, _count);
            } else {
                var obj:Object;
                obj = {};
                obj.count = _count;
                obj.id = _type;
                new DropItem(Starling.current.nativeStage.stageWidth / 2, Starling.current.nativeStage.stageHeight / 2, obj);
            }
        }
        _type = 0;
        _typePost = '';
    }
}
}
