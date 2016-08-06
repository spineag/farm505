/**
 * Created by user on 9/11/15.
 */
package windows.train {
import analytic.AnalyticManager;

import build.train.Train;
import manager.ManagerFilters;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;
import utils.CButton;
import utils.MCScaler;
import utils.TimeUtils;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOTrainOrder extends WindowMain{
    private var _btn:CButton;
    private var _contItem:Sprite;
    private var _txtTime:TextField;
    private var _timer:int;
    private var _woBG:WindowBackground;
    private var _callback:Function;
    private var item1:WOTrainOrderItem;
    private var item2:WOTrainOrderItem;
    private var item3:WOTrainOrderItem;
    private var _train:Train;

    public function WOTrainOrder() {
        super ();
        _windowType = WindowsManager.WO_TRAIN_ORDER;
        var txt:TextField;
        var im:Image;
        _contItem = new Sprite();
        _woWidth = 500;
        _woHeight = 337;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;
        _btn = new CButton();
        _btn.addButtonTexture(172, 50, CButton.GREEN, true);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("rubins_small"));
        im.y = 10;
        im.x = 35;
        _btn.addDisplayObject(im);
        txt = new TextField(100,50,"привезти сейчас",g.allData.fonts['BloggerBold'],16,Color.WHITE);
        txt.x = 60;
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _btn.addChild(txt);
        txt = new TextField(50,50,"30",g.allData.fonts['BloggerBold'],16,Color.WHITE);
        txt.x = -5;
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _btn.addChild(txt);
        _btn.y = 110;
        _btn.clickCallback = onClickBtn;
        _source.addChild(_btn);

        txt = new TextField(300,50,"ПРИБЫТИЕ КОРЗИНКИ ",g.allData.fonts['BloggerBold'],24,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        txt.x = -150;
        txt.y = -145;
        _source.addChild(txt);

        txt = new TextField(150,50,"Следующий заказ:","Arial",14,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        txt.x = -80;
        txt.y = -60;
        _source.addChild(txt);

        txt = new TextField(300,50,"Корзина прибудет к станции через:",g.allData.fonts['BloggerBold'],14,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        txt.x = -150;
        txt.y = -120;
        _source.addChild(txt);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_del_clock'));
        im.x = -55;
        im.y = -80;
        _source.addChild(im);
        _txtTime = new TextField(80,50,"",g.allData.fonts['BloggerBold'],18,Color.WHITE);
        _txtTime.x = -20;
        _txtTime.y = -85;
        _txtTime.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _source.addChild(_txtTime);
    }

    public function onClickExit(e:Event=null):void {
        hideIt();
    }

    private function onClickBtn():void {
        if (g.user.hardCurrency < 30) {
            g.windowsManager.cashWindow = this;
            hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }

        g.userInventory.addMoney(1,-30);
        g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.SKIP_TIMER, {id: AnalyticManager.SKIP_TIMER_AERIAL_TRAM_ID});
//        g.woTrain.clearItems();
        if (_callback != null) {
            _callback.apply(null);
            _callback = null;
        }
//        g.windowsManager.cashWindow = this;
        hideIt();
    }

    override public function showItParams(callback:Function, params:Array):void {
        _callback = callback;
        _timer = params[2];
        _train = params[1];
        _txtTime.text = TimeUtils.convertSecondsForHint(_timer);
        g.gameDispatcher.addToTimer(timerCheck);
        fillList(params[0]);
        super.showIt();
    }

    private function fillList(list:Array):void {
        item1 = new WOTrainOrderItem();
        item1.fillIt(list[0], 1);
        item1.source.x = -150;
        item1.source.y = -20;
        _contItem.addChild(item1.source);
        item2 = new WOTrainOrderItem();
        item2.fillIt(list[4], 4);
        item2.source.x = -50;
        item2.source.y = -20;
        _contItem.addChild(item2.source);
        item3 = new WOTrainOrderItem();
        item3.source.x = 50;
        item3.source.y = -20;
        if (list.length <= 9) item3.fillIt(list[8], 8);
            else item3.fillIt(list[9], 9);
        _contItem.addChild(item3.source);
        _source.addChild(_contItem);
    }

    private function timerCheck():void {
        --_timer;
        _txtTime.text = TimeUtils.convertSecondsForHint(_timer);
    }

    override protected function deleteIt():void {
        _train = null;
        g.gameDispatcher.removeFromTimer(timerCheck);
        _contItem.removeChild(item1.source);
        _contItem.removeChild(item2.source);
        _contItem.removeChild(item3.source);
        item1.clearIt();
        item2.clearIt();
        item3.clearIt();
        item1 = null;
        item2 = null;
        item3 = null;
        super.deleteIt();
    }
}
}
