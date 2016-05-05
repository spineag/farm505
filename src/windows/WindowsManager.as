/**
 * Created by user on 3/24/16.
 */
package windows {
import com.junkbyte.console.Cc;
import windows.ambar.WOAmbars;
import windows.ambarFilled.WOAmbarFilled;
import windows.buyCoupone.WOBuyCoupone;
import windows.buyCurrency.WOBuyCurrency;
import windows.buyForHardCurrency.WOBuyForHardCurrency;
import windows.buyPlant.WOBuyPlant;
import windows.cave.WOBuyCave;
import windows.cave.WOCave;
import windows.chestWindow.WOChest;
import windows.dailyBonusWindow.WODailyBonus;
import windows.fabricaWindow.WOFabrica;
import windows.gameError.WOGameError;
import windows.lastResource.WOLastResource;
import windows.levelUp.WOLevelUp;
import windows.lockedLand.WOLockedLand;
import windows.market.WOMarket;
import windows.market.WOMarketChoose;
import windows.market.WOMarketDeleteItem;
import windows.noFreeCats.WONoFreeCats;
import windows.noFreeCats.WOWaitFreeCats;
import windows.noPlaces.WONoPlaces;
import windows.noResources.WONoResources;
import windows.orderWindow.WOOrder;
import windows.paperWindow.WOPapper;
import windows.reloadPage.WOReloadGame;
import windows.serverError.WOServerError;
import windows.shop.WOShop;
import windows.train.WOTrain;
import windows.train.WOTrainOrder;
import windows.train.WOTrainSend;

public class WindowsManager {
    public static const WO_AMBAR:String = 'ambar_and_sklad';
    public static const WO_AMBAR_FILLED:String = 'ambar_filled';
    public static const WO_BUY_COUPONE:String = 'buy_coupone'; 
    public static const WO_BUY_CURRENCY:String = 'buy_currency';
    public static const WO_BUY_FOR_HARD:String = 'buy_for_hard_currency';
    public static const WO_BUY_PLANT:String = 'buy_plant';
    public static const WO_CAVE:String = 'cave';
    public static const WO_BUY_CAVE:String = 'buy_cave';
    public static const WO_DAILY_BONUS:String = 'daily_bonus';
    public static const WO_FABRICA:String = 'fabrica_recipe';
    public static const WO_GAME_ERROR:String = 'game_error';
    public static const WO_LAST_RESOURCE:String = 'last_resource';
    public static const WO_LEVEL_UP:String = 'level_up';
    public static const WO_LOCKED_LAND:String = 'locked_land';
    public static const WO_MARKET:String = 'market';
    public static const WO_MARKET_CHOOSE:String = 'market_choose';
    public static const WO_MARKET_DELETE_ITEM:String = 'market_delete_item';
    public static const WO_NO_FREE_CATS:String = 'no_free_cats';
    public static const WO_WAIT_FREE_CATS:String = 'wait_free_cats';
    public static const WO_NO_PLACES:String = 'no_places';
    public static const WO_NO_RESOURCES:String = 'no_resources';
    public static const WO_ORDERS:String = 'orders';
    public static const WO_PAPPER:String = 'papper';
    public static const WO_RELOAD_GAME:String = 'reload_game';
    public static const WO_SERVER_ERROR:String = 'server_error';
    public static const WO_SHOP:String = 'shop';
    public static const WO_TRAIN:String = 'train';
    public static const WO_TRAIN_ORDER:String = 'train_order';
    public static const WO_TRAIN_SEND:String = 'train_send';
    public static const WO_CHEST:String = 'chest';

    private var _currentWindow:WindowMain;
    private var _cashWindow:WindowMain;
    private var _secondCashWindow:WindowMain;
    private var _nextWindow:Object;

    public function WindowsManager() {}

    public function get currentWindow():WindowMain {
        return _currentWindow;
    }

    public function openWindow(type:String, callback:Function=null, ...params):void {
        if (_currentWindow) {
            if (type == WO_GAME_ERROR || type == WO_RELOAD_GAME || type == WO_SERVER_ERROR) {
                closeAllWindows();
            } else {
                _nextWindow = {};
                _nextWindow.type = type;
                _nextWindow.callback = callback;
                _nextWindow.paramsArray = params;
                return;
            }
        }
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
            case WO_NO_RESOURCES:
                wo = new WONoResources();
                break;
            case WO_AMBAR:
                wo = new WOAmbars();
                break;
            case WO_BUY_PLANT:
                wo = new WOBuyPlant();
                break;
            case WO_CAVE:
                wo = new WOCave();
                break;
            case WO_FABRICA:
                wo = new WOFabrica();
                break;
            case WO_MARKET:
                wo = new WOMarket();
                break;
            case WO_MARKET_CHOOSE:
                wo = new WOMarketChoose();
                break;
            case WO_MARKET_DELETE_ITEM:
                wo = new WOMarketDeleteItem();
                break;
            case WO_PAPPER:
                wo = new WOPapper();
                break;
            case WO_ORDERS:
                wo = new WOOrder();
                break;
            case WO_TRAIN:
                wo = new WOTrain();
                break;
            case WO_TRAIN_ORDER:
                wo = new WOTrainOrder();
                break;
            case WO_TRAIN_SEND:
                wo = new WOTrainSend();
                break;
            case WO_SHOP:
                wo = new WOShop();
                break;
            case WO_CHEST:
                wo = new WOChest();
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
            _currentWindow.isCashed = false;
            _currentWindow.hideIt();
        }
    }

    public function onHideWindow(hiddenWindow:WindowMain):void {
        _currentWindow = null;
        if (_nextWindow) {
            openWindow.apply(null, [_nextWindow.type, _nextWindow.callback].concat(_nextWindow.paramsArray));
            _nextWindow = null;
            return;
        }
        if (_secondCashWindow && _secondCashWindow != hiddenWindow) {
            releaseSecondCashWindow();
            return;
        }
        if (_cashWindow && _cashWindow != hiddenWindow) {
            releaseCashWindow();
        }
    }

    public function uncasheWindow():void {
        if (_cashWindow) {
            _cashWindow.isCashed = false;
            _cashWindow.hideIt();
            _cashWindow = null;
        }
    }

    public function uncasheSecondWindow():void {
        if (_secondCashWindow) {
            _secondCashWindow.isCashed = false;
            _secondCashWindow.hideIt();
            _secondCashWindow = null;
        }
    }

    public function set cashWindow(wo:WindowMain):void {
        if (_cashWindow) uncasheWindow();
        _cashWindow = wo;
        wo.isCashed = true;
    }

    public function set secondCashWindow(wo:WindowMain):void {
        if (_secondCashWindow) {
            _secondCashWindow.isCashed = false;
            _secondCashWindow.hideIt();
            _secondCashWindow = null;
        }
        _secondCashWindow = wo;
        if (wo) wo.isCashed = true;
    }

    public function releaseCashWindow():void {
        if (_cashWindow) {
            _cashWindow.releaseFromCash();
            _currentWindow = _cashWindow;
            _currentWindow.isCashed = false;
            _cashWindow = null;
        }
    }

    public function releaseSecondCashWindow():void {
        if (_secondCashWindow) {
            _secondCashWindow.releaseFromCash();
            _currentWindow = _secondCashWindow;
            _currentWindow.isCashed = false;
            _secondCashWindow = null;
        }
    }

    public function onResize():void {
        if (_currentWindow) _currentWindow.onResize();
        if (_cashWindow) _cashWindow.onResize();
    }

    public function closeAllWindows():void {
        uncasheWindow();
        uncasheSecondWindow();
        _currentWindow.hideItQuick();
    }


}
}
