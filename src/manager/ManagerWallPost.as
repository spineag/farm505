/**
 * Created by user on 5/23/16.
 */
package manager {
import com.junkbyte.console.Cc;

import flash.display.StageDisplayState;

import quest.ManagerQuest;
import resourceItem.DropItem;

import social.SocialNetwork;
import social.SocialNetworkSwitch;

import starling.core.Starling;

import ui.xpPanel.XPStar;

import wallPost.WALLAnnouncement;
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
    public static const POST_ANNOUNCEMENT:String = 'announcement_post';

    private var _count:int;
    private var _type:int;
    private var _typePost:String;
    private var _isPost:Boolean;
    private var _postQueue:Array;
    private var g:Vars = Vars.getInstance();

    public function ManagerWallPost() {
        _isPost = false;
        _postQueue = [];
    }

    public function postWallpost(type:String, callback:Function=null, ...params):void {
        if (_isPost && g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) {
            var ob:Object = {type: type, callback: callback, params: params};
            _postQueue.push(ob);
            return;
        }
        if (Starling.current.nativeStage.displayState != StageDisplayState.NORMAL) {
            Starling.current.nativeStage.displayState = StageDisplayState.NORMAL;
        }
        _count = params[0];// количество подарка
        _type = params[1];//тип подарка
        _typePost = type;
        switch (type) {
            case NEW_LEVEL: _isPost = true; new WALLNewLevel(callback,params); break;
            case NEW_FABRIC: _isPost = true; new WALLNewFabric(callback,params[2]); break;
            case NEW_LAND: _isPost = true; new WALLOpenLand(callback,params); break;
            case OPEN_TRAIN: _isPost = true; new WALLOpenTrain(callback,params); break;
            case OPEN_CAVE: _isPost = true; new WALLOpenCave(callback,params); break;
            case DONE_TRAIN: _isPost = true; new WALLDoneTrain(callback,params); break;
            case DONE_ORDER: _isPost = true; new WALLDoneOrder(callback,params); break;
            case POST_FOR_QUEST: _isPost = true; new WALLForQuest(callback, params); break;
            case POST_ANNOUNCEMENT: _isPost = true; new WALLAnnouncement(callback, params); break;
            default: Cc.error('WindowsManager:: unknown window type: ' + type); break;
        }
        checkPostQueue();
    }

    public function callbackAward():void {
        if (_typePost == POST_FOR_QUEST) {
            g.managerQuest.onActionForTaskType(ManagerQuest.POST);
        } else {
            if (_type == 0 || _count == 0) return;
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
        _isPost = false;
        checkPostQueue();
    }

    public function cancelWallPost():void {
        _isPost = false;
        checkPostQueue();
    }

    private function  checkPostQueue(): void {
        if (g.socialNetworkID != SocialNetworkSwitch.SN_VK_ID) return;
        if (_isPost) return;
        if (_postQueue.length) {
            var ob:Object = _postQueue.shift();
            if (ob) {
//                postWallpost(ob.type, ob.callback)
                postWallpost.apply(null, [ob.type, ob.callback].concat(ob.params));
            }
        }
    }

}
}
