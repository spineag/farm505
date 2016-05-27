/**
 * Created by user on 5/26/16.
 */
package manager {
public class ManagerInviteFriend {
    private var g:Vars = Vars.getInstance();

    public function ManagerInviteFriend() {
    }

    public function create():void {
        g.socialNetwork.showInviteWindow();

    }

    public function openWindow(type:String,callback:Function=null, ...params):void {

//        switch (type) {
//            case NEW_LEVEL:
//                var wo:WALLNewLevel = new WALLNewLevel();
//                break;
//            case NEW_FABRIC:
////                wo = new WONoFreeCats();
//                break;
//            case NEW_LAND:
////                wo = new WOWaitFreeCats();
//                break;
//            case OPEN_TRAIN:
////                wo = new WOBuyCoupone();
//                break;
//            case OPEN_CAVE:
////                wo = new WOAmbarFilled();
//                break;
//            case DONE_TRAIN:
////                wo = new WOReloadGame();
//                break;
//            case DONE_ORDER:
////                wo = new WOServerError();
//                break;
//
//            default:
//                Cc.error('WindowsManager:: unknown window type: ' + type);
//                break;
//        }
//        wo.showItParams(callback,params);
    }
}
}
