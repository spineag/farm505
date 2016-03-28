/**
 * Created by user on 3/24/16.
 */
package windows {
import com.junkbyte.console.Cc;

import windows.ambarFilled.WOAmbarFilled;
import windows.buyCoupone.WOBuyCoupone;
import windows.buyCurrency.WOBuyCurrency;
import windows.buyForHardCurrency.WOBuyForHardCurrency;
import windows.cave.WOBuyCave;
import windows.dailyBonusWindow.WODailyBonus;
import windows.gameError.WOGameError;
import windows.lastResource.WOLastResource;
import windows.levelUp.WOLevelUp;
import windows.lockedLand.WOLockedLand;
import windows.noFreeCats.WONoFreeCats;
import windows.noFreeCats.WOWaitFreeCats;
import windows.noPlaces.WONoPlaces;
import windows.reloadPage.WOReloadGame;
import windows.serverError.WOServerError;

public class WindowsManager {
    public static const WO_AMBAR:String = 'ambar_and_sklad'; // -
    public static const WO_AMBAR_FILLED:String = 'ambar_filled';
    public static const WO_BUY_COUPONE:String = 'buy_coupone'; 
    public static const WO_BUY_CURRENCY:String = 'buy_currency';
    public static const WO_BUY_FOR_HARD:String = 'buy_for_hard_currency';
    public static const WO_BUY_PLANT:String = 'buy_plant'; // -
    public static const WO_CAVE:String = 'cave'; // -
    public static const WO_BUY_CAVE:String = 'buy_cave';
    public static const WO_DAILY_BONUS:String = 'daily_bonus'; // -
    public static const WO_FABRICA:String = 'fabrica_recipe'; // -
    public static const WO_GAME_ERROR:String = 'game_error';
    public static const WO_LAST_RESOURCE:String = 'last_resource';
    public static const WO_LEVEL_UP:String = 'level_up'; // -
    public static const WO_LOCKED_LAND:String = 'locked_land'; // -
    public static const WO_MARKET:String = 'market'; // -
    public static const WO_NO_FREE_CATS:String = 'no_free_cats';
    public static const WO_WAIT_FREE_CATS:String = 'wait_free_cats';
    public static const WO_NO_PLACES:String = 'no_places'; // -
    public static const WO_NO_RESOURCES:String = 'no_resources'; // -
    public static const WO_ORDERS:String = 'orders'; // -
    public static const WO_PAPPER:String = 'papper'; // -
    public static const WO_RELOAD_GAME:String = 'reload_game';
    public static const WO_SERVER_ERROR:String = 'server_error';
    public static const WO_SHOP:String = 'shop'; // -
    public static const WO_TRAIN:String = 'train'; // -

    private var _currentWindow:WindowMain;

    public function WindowsManager() {
    }

    public function set currentWindow(wo:WindowMain):void {
        _currentWindow = wo;
    }

    public function get currentWindow():WindowMain {
        return _currentWindow;
    }

    public function openWindow(type:String, callback:Function=null, ...params):void {
        var wo:WindowMain;
        switch (type) {
            case WO_GAME_ERROR:
                wo = new WOGameError();
                break;
            case WO_NO_FREE_CATS:
                wo = new WONoFreeCats();
                break;
            case WO_WAIT_FREE_CATS:
                wo = new WOWaitFreeCats();
                break;
            case WO_BUY_COUPONE:
                wo = new WOBuyCoupone();
                break;
            case WO_AMBAR_FILLED:
                wo = new WOAmbarFilled();
                break;
            case WO_RELOAD_GAME:
                wo = new WOReloadGame();
                break;
            case WO_SERVER_ERROR:
                wo = new WOServerError();
                break;
            case WO_BUY_CURRENCY:
                wo = new WOBuyCurrency();
                break;
            case WO_BUY_CAVE:
                wo = new WOBuyCave();
                break;
            case WO_BUY_FOR_HARD:
                wo = new WOBuyForHardCurrency();
                break;
            case WO_DAILY_BONUS:
                wo = new WODailyBonus();
                break;
            case WO_LAST_RESOURCE:
                wo = new WOLastResource();
                break;
            case WO_LEVEL_UP:
                wo = new WOLevelUp();
                break;
            case WO_LOCKED_LAND:
                wo = new WOLockedLand();
                break;
            case WO_NO_PLACES:
                wo = new WONoPlaces();
                break;


            default:
                Cc.error('WindowsManager:: unknown window type: ' + type);
                break;
        }

        wo.showItParams(callback, params);
        _currentWindow = wo;
    }

    public function hideWindow(type:String):void {
        if (_currentWindow && _currentWindow.windowType == type) {
            _currentWindow.hideIt();
        }
    }

    public function onHideWindow():void {
        _currentWindow = null;
    }


}
}
