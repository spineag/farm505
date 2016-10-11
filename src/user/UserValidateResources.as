/**
 * Created by andy on 10/6/16.
 */
package user {
import com.junkbyte.console.Cc;
import manager.Vars;
import windows.WindowsManager;

public class UserValidateResources {
    private var K1:int = 1;
    private var K2:int = 11;

    private var xp:int;
    private var level:int;
    private var resources:Object;
    private var softCount:int;
    private var hardCount:int;
    private var greenCount:int;
    private var redCount:int;
    private var blueCount:int;
    private var yellowCount:int;
    private var ambarLevel:int;
    private var ambarMax:int;
    private var skladMax:int;
    private var skladLevel:int;
    private var countCats:int;
    private var g:Vars = Vars.getInstance();

    public function UserValidateResources() {
        resources = {};
        K1 = int(Math.random()*3) + K1;
        K2 = int(Math.random()*43) + K2;
    }

    public function updateInfo(reason:String, count:int):void {
        switch (reason) {
            case 'xp': xp = count*K1 + K2; break;
            case 'level': level = count*K1 + K2; break;
            case 'softCount': softCount = count*K1 + K2; break;
            case 'hardCount': hardCount = count*K1 + K2; break;
            case 'greenCount': greenCount = count*K1 + K2; break;
            case 'redCount': redCount = count*K1 + K2; break;
            case 'blueCount': blueCount = count*K1 + K2; break;
            case 'yellowCount': yellowCount = count*K1 + K2; break;
            case 'ambarLevel': ambarLevel = count*K1 + K2; break;
            case 'ambarMax': ambarMax = count*K1 + K2; break;
            case 'skladLevel': skladLevel = count*K1 + K2; break;
            case 'skladMax': skladMax = count*K1 + K2; break;
            case 'countCats': countCats = count*K1 + K2; break;
            default:  Cc.error('UserValidResources initInfo:: unknown reason: ' + reason); break;
        }
    }

    public function updateResources(id:int, count:int):void {
        if (!resources[id]) resources[id] = 0;
        resources[id] = count*K1 + K2;
    }

    public function checkResources(id:int, count:int):Boolean {
        return true;

        if (g.isDebug || g.user.isTester || g.user.isMegaTester) {
            if (!resources[id]) resources[id] = K2;
            var c:int = count * K1 + K2;
            if (c == resources[id]) {
                return true;
            } else {
                if (g.windowsManager) g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, 'resource mismatch');
                Cc.error('UserValidateResources checkInfo:: wrong for resource id: ' + id);
                return false;
            }
        } else return true;
    }

    public function checkInfo(reason:String, count:int):Boolean {
        return true;
        
        if (g.isDebug || g.user.isTester || g.user.isMegaTester) {
            var isGood:Boolean = false;
            switch (reason) {
                case 'xp': isGood = xp == count*K1 + K2; break;
                case 'level': isGood = level == count*K1 + K2; break;
                case 'softCount': isGood = softCount == count*K1 + K2; break;
                case 'hardCount': isGood = hardCount == count*K1 + K2; break;
                case 'greenCount': isGood = greenCount == count*K1 + K2; break;
                case 'redCount': isGood = redCount == count*K1 + K2; break;
                case 'blueCount': isGood = blueCount == count*K1 + K2; break;
                case 'yellowCount': isGood = yellowCount == count*K1 + K2; break;
                case 'ambarLevel': isGood = ambarLevel == count*K1 + K2; break;
                case 'ambarMax': isGood = ambarMax == count*K1 + K2; break;
                case 'skladLevel': isGood = skladLevel == count*K1 + K2; break;
                case 'skladMax': isGood = skladMax == count*K1 + K2; break;
                case 'countCats': isGood = countCats == count*K1 + K2; break;
                default:  Cc.error('UserValidResources initInfo:: unknown reason: ' + reason); break;
            }
            if (!isGood) {
                if (g.windowsManager) g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, 'info mismatch');
                Cc.error('UserValidateResources checkInfo:: wrong for reason: ' + reason);
            }
            return isGood;
        } else {
            return true;
        }    
    }
}
}
