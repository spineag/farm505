/**
 * Created by user on 5/26/16.
 */
package manager {
import data.DataMoney;
import flash.geom.Point;
import resourceItem.DropItem;

import starling.textures.TextureAtlas;

import windows.WindowsManager;

public class ManagerInviteFriendViral {
    private var g:Vars = Vars.getInstance();
    private var _timer:int;
    private var _levelData:int;
    private var _countFriendsData:int;
    private var _countRubiesData:int;
    private var _timeCancelData:int;
    private var _timeCompleteData:int;

    public function ManagerInviteFriendViral(d:Object) {
        _levelData = int(d.user_level);
        _countFriendsData = int(d.count_friends);
        _countRubiesData = int(d.count_rubies);
        _timeCancelData = int(d.cancel_time);
        _timeCompleteData = int(d.complete_time);
        if (g.user.level >= _levelData) checkIt();
    }

    public function getCountFriends():int { return _countFriendsData; }
    public function getCountRubies():int { return _countRubiesData; }
    public function onUpdateLevel():void { if (g.user.level == _levelData) checkIt(); }

    private function checkIt():void {
        if (g.isDebug) return;
        if (g.user.nextTimeInvite == 0 || g.user.nextTimeInvite < int(new Date().getTime()/1000)) startTimer();
    }
    
    private function startTimer():void {
        _timer = 30 + int(Math.random()* 60);
        g.gameDispatcher.addToTimer(onTimer);
    }

    private function onTimer():void {
        _timer--;
        if (_timer < 0) {
            g.gameDispatcher.removeFromTimer(onTimer);
            g.load.loadAtlas('inviteAtlas', 'inviteAtlas', openWO);
        }
    }

    private function openWO():void {
        g.windowsManager.openWindow(WindowsManager.WO_INVITE_FRIENDS_VIRAL_INFO, onCloseWO);
    }

    private function onCloseWO(ar:Array):void {
        var countInvited:int = ar.length;
        if (countInvited > _countFriendsData) countInvited = _countFriendsData;
        var nextTime:int = int( new Date().getTime()/1000 );
        if (countInvited > 0) {
            nextTime += _timeCompleteData;
            var obj:Object = {};
            obj.count = _countRubiesData * countInvited;
            var p:Point = new Point(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2);
            obj.id = DataMoney.HARD_CURRENCY;
            new DropItem(p.x + 30, p.y + 30, obj);
        } else {
            nextTime += _timeCancelData;
        }
        g.directServer.updateUserViralInvite(nextTime, null);
        (g.allData.atlas['inviteAtlas'] as TextureAtlas).dispose();
        delete  g.allData.atlas['inviteAtlas'];
    }




}
}
