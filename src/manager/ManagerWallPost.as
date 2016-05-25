/**
 * Created by user on 5/23/16.
 */
package manager {
import com.junkbyte.console.Cc;

import wallPost.WALLNewLevel;

public class ManagerWallPost {
    public static const NEW_LEVEL:String = 'new_level';
    public static const NEW_FABRIC:String = 'new_fabric';
    public static const NEW_LAND:String = 'new_land';
    public static const OPEN_TRAIN:String = 'open_train';
    public static const OPEN_CAVE:String = 'open_cave';
    public static const DONE_TRAIN:String = 'done_train';
    public static const DONE_ORDER:String = 'done_order';

    public function ManagerWallPost() {

    }

    public function openWindow(type:String,callback:Function=null, ...params):void {
        switch (type) {
            case NEW_LEVEL:
               var wo:WALLNewLevel = new WALLNewLevel();
                    wo.showItParams(callback,params);
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
//
    }
}
}
