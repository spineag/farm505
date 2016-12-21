/**
 * Created by user on 4/20/16.
 */
package user {
import manager.ManagerOrderItem;
import manager.Vars;

import windows.WindowsManager;

public class UserTimer {
    public var papperTimerAtMarket:int;
    public var timerAtPapper:int;
    public var timerAtNyashuk:int;
    public var _arrOrderItem:Array;
    private var _orderManagerItem:ManagerOrderItem;
    private var g:Vars = Vars.getInstance();

    public function UserTimer() {
        _arrOrderItem = [];
    }

    public function startUserMarketTimer(time:int):void {
        papperTimerAtMarket = time;
        g.gameDispatcher.addToTimer(onMarketTimer);
    }

    private function onMarketTimer():void {
        papperTimerAtMarket--;
        if (papperTimerAtMarket <= 0) {
            papperTimerAtMarket = 0;
            g.gameDispatcher.removeFromTimer(onMarketTimer);
        }
    }

    public function startUserPapperTimer(time:int):void {
        timerAtPapper = time;
        g.gameDispatcher.addToTimer(onPapperTimer);
    }

    private function onPapperTimer():void {
        timerAtPapper--;
        if (timerAtPapper <= 0) {
            timerAtPapper = 0;
            g.gameDispatcher.removeFromTimer(onPapperTimer);
        }
    }

    public function setOrder(manager:ManagerOrderItem):void {
        _arrOrderItem.push(manager);
    }

    public function buyerNyashuk(time:int):void {
        timerAtNyashuk = time;
        g.gameDispatcher.addToTimer(nyashukTimer);
    }

    private function nyashukTimer():void {
        timerAtNyashuk--;
        if (timerAtNyashuk <= 0) {
            timerAtNyashuk = 0;
            g.managerBuyerNyashuk.timeToNewNyashuk();
            g.gameDispatcher.removeFromTimer(nyashukTimer);
        }
    }

    public function newCatOrder():void {
        var i:int;
        var leftSecond:int;
        for (i = 0; i < _arrOrderItem.length; i++) {
            if (_arrOrderItem[i]) {
                leftSecond = _arrOrderItem[i].startTime - int(new Date().getTime()/1000);
                if (leftSecond <= 0){
                        break;
                }
            }
        }
      var pl:int = _arrOrderItem[i].placeNumber;
        _arrOrderItem[i] = null;
        var arr:Array = g.managerOrder.arrOrders.slice();
        for (i = 0; i < arr.length; i++) {
            if (arr[i].placeNumber == pl &&  arr[i].delOb) {
                arr[i].delOb = false;
               arr[i].cat = g.managerOrderCats.getNewCatForOrder(null,arr[i].catOb);
                break;
            }
        }
    }
}
}
