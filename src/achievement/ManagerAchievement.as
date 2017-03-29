/**
 * Created by user on 3/20/17.
 */
package achievement {
import manager.Vars;

public class ManagerAchievement {

    public static const TAKE_PRODUCTS:int = 1; // +Собрать продукты
    public static const OTHER:int = 0; // +Купи декораций для фермы на n монет
    public var dataAchievement:Array;
    public var userAchievement:Array;
    private var g:Vars = Vars.getInstance();

    public function ManagerAchievement() {
        dataAchievement = [];
        userAchievement = [];
        g.directServer.getDataAchievement(null);
        g.directServer.getUserAchievement(null);
    }

    public function achievementCountFriend(count:int):void {
        var ob:Object;
        var b:Boolean = false;
        if (userAchievement.length > 0) {
            for (var i:int = 0; i < userAchievement.length; i++) {
                if (userAchievement[i].id == 22) {
                    if (count > userAchievement[i].resourceCount) {
                        b = true;
                        userAchievement[i].resourceCount = count;
                        break;
                    }
                }
            }
            if (!b) {
                ob = {};
                ob.id = 22;
                ob.resourceCount = int(count);
                ob.tookGift = [];
                ob.tookGift[0] = 0;
                ob.tookGift[1] = 0;
                ob.tookGift[2] = 0;
                userAchievement.push(ob);
                g.directServer.updateUserAchievement(ob.id, ob.resourceCount, '0&0&0', null);
            }
        } else {
            ob = {};
            ob.id = 22;
            ob.resourceCount = int(count);
            ob.tookGift = [];
            ob.tookGift[0] = 0;
            ob.tookGift[1] = 0;
            ob.tookGift[2] = 0;
            userAchievement.push(ob);
            g.directServer.updateUserAchievement(ob.id, ob.resourceCount, '0&0&0', null);
        }
    }

     public function achievementCountSoft(count:int):void {
            var ob:Object;
            var b:Boolean = false;
            if (userAchievement.length > 0) {
                for (var i:int = 0; i < userAchievement.length; i++) {
                    if (userAchievement[i].id == 23) {
                        if (count > userAchievement[i].resourceCount) {
                            b = true;
                            userAchievement[i].resourceCount = count;
                            break;
                        }
                    }
                }
                if (!b) {
                    ob = {};
                    ob.id = 23;
                    ob.resourceCount = int(count);
                    ob.tookGift = [];
                    ob.tookGift[0] = 0;
                    ob.tookGift[1] = 0;
                    ob.tookGift[2] = 0;
                    userAchievement.push(ob);
                    g.directServer.updateUserAchievement(ob.id, ob.resourceCount, '0&0&0', null);
                }
            } else {
                ob = {};
                ob.id = 23;
                ob.resourceCount = int(count);
                ob.tookGift = [];
                ob.tookGift[0] = 0;
                ob.tookGift[1] = 0;
                ob.tookGift[2] = 0;
                userAchievement.push(ob);
                g.directServer.updateUserAchievement(ob.id, ob.resourceCount, '0&0&0', null);
            }
        }

    public function addResource(idResource:int):void {
        var i:int = 0;
        var b:Boolean = false;
        var ob:Object = {};
        if (userAchievement.length > 0) {
            for (i = 0; i < dataAchievement.length; i++) {
                if (dataAchievement[i].idResource == idResource) {
                    for (var k:int = 0; k < userAchievement.length; k++) {
                        if (userAchievement[k].id == dataAchievement[i].id) {
                            b = true;
                            userAchievement[k].resourceCount += 1;
                            var st:String = String(userAchievement[k].tookGift[0]) + '&' + String(userAchievement[k].tookGift[1]) + '&' + String(userAchievement[k].tookGift[2]);
                            g.directServer.updateUserAchievement(userAchievement[k].id, userAchievement[k].resourceCount, st, null);
                            break;
                        }
                    }
                    break;
                }
            }
            if (!b) {
                for (i = 0; i < dataAchievement.length; i++) {
                    if (dataAchievement[i].idResource == idResource) {
                        ob = {};
                        ob.id = dataAchievement[i].id;
                        ob.resourceCount = int(1);
                        ob.tookGift = [];
                        ob.tookGift[0] = 0;
                        ob.tookGift[1] = 0;
                        ob.tookGift[2] = 0;
                        userAchievement.push(ob);
                        g.directServer.updateUserAchievement(ob.id, ob.resourceCount, '0&0&0', null);
                        break;
                    }
                }
            }
        } else {
            for (i = 0; i < dataAchievement.length; i++) {
                if (dataAchievement[i].idResource == idResource) {
                    ob = {};
                    ob.id = dataAchievement[i].id;
                    ob.resourceCount = int(1);
                    ob.tookGift = [];
                    ob.tookGift[0] = 0;
                    ob.tookGift[1] = 0;
                    ob.tookGift[2] = 0;
                    userAchievement.push(ob);
                    g.directServer.updateUserAchievement(ob.id, ob.resourceCount, '0&0&0', null);
                    break;
                }
            }
        }
    }

    public function addAll(achievementId:int, count:int = 1):void {
        var i:int = 0;
        var b:Boolean = false;
        var ob:Object = {};
        if (userAchievement.length > 0) {
            for (i = 0; i < userAchievement.length; i++) {
                if (userAchievement[i].id == achievementId) {
                    b = true;
                    userAchievement[i].resourceCount += count;
                    var st:String = String(userAchievement[i].tookGift[0]) + '&' + String(userAchievement[i].tookGift[1]) + '&' + String(userAchievement[i].tookGift[2]);
                    g.directServer.updateUserAchievement(userAchievement[i].id, userAchievement[i].resourceCount, st, null);
                    break;
                }
            }
            if (!b) {
                ob = {};
                ob.id = achievementId;
                ob.resourceCount = int(count);
                ob.tookGift = [];
                ob.tookGift[0] = 0;
                ob.tookGift[1] = 0;
                ob.tookGift[2] = 0;
                userAchievement.push(ob);
                g.directServer.updateUserAchievement(ob.id, ob.resourceCount, '0&0&0', null);
            }
        } else {
            ob = {};
            ob.id = achievementId;
            ob.resourceCount = int(count);
            ob.tookGift = [];
            ob.tookGift[0] = 0;
            ob.tookGift[1] = 0;
            ob.tookGift[2] = 0;
            userAchievement.push(ob);
            g.directServer.updateUserAchievement(ob.id, ob.resourceCount, '0&0&0', null);
        }
    }
}
}
