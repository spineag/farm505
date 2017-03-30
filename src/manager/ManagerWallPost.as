/**
 * Created by user on 5/23/16.
 */
package manager {
import com.junkbyte.console.Cc;

import flash.display.StageDisplayState;

import quest.ManagerQuest;
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
    public static const POST_FOR_QUEST:String = 'quest_post';

    private var _count:int;
    private var _type:int;
    private var _typePost:String;
    private var g:Vars = Vars.getInstance();

    public function ManagerWallPost() {}

    public function postWallpost(type:String, callback:Function=null, ...params):void {
        if (Starling.current.nativeStage.displayState != StageDisplayState.NORMAL) {
            Starling.current.nativeStage.displayState = StageDisplayState.NORMAL;
        }
        _count = params[0];// количество подарка
        _type = params[1];//тип подарка
        _typePost = type;
        switch (type) {
            case NEW_LEVEL: new WALLNewLevel(callback,params); break;
            case NEW_FABRIC: new WALLNewFabric(callback,params[2]); break;
            case NEW_LAND: new WALLOpenLand(callback,params); break;
            case OPEN_TRAIN: new WALLOpenTrain(callback,params); break;
            case OPEN_CAVE: new WALLOpenCave(callback,params); break;
            case DONE_TRAIN: new WALLDoneTrain(callback,params); break;
            case DONE_ORDER: new WALLDoneOrder(callback,params); break;
            case POST_FOR_QUEST: new WALLForQuest(callback, params); break;
            default: Cc.error('WindowsManager:: unknown window type: ' + type); break;
        }
    }

    public function callbackAward():void {
        if (_typePost == POST_FOR_QUEST) {
            g.managerQuest.onActionForTaskType(ManagerQuest.POST);
        } else {
            if (_type == 9) new XPStar(g.managerResize.stageWidth / 2, g.managerResize.stageHeight / 2, _count);
            else {
                var obj:Object;
                obj = {};
                obj.count = _count;
                obj.id = _type;
                new DropItem(g.managerResize.stageWidth / 2, g.managerResize.stageHeight / 2, obj);
            }
        }
        _type = 0;
        _typePost = '';
    }
}
}
