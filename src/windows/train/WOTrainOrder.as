/**
 * Created by user on 9/11/15.
 */
package windows.train {

import manager.ManagerFilters;

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;

import utils.CSprite;
import utils.MCScaler;
import utils.TimeUtils;

import windows.WOComponents.WOButtonTexture;
import windows.WOComponents.WindowBackground;

import windows.Window;

public class WOTrainOrder extends Window{
    private var _btn:CButton;
    private var _txtTime:TextField;
    private var _arrItems:Array;
    private var _timer:int;
    private var _woBG:WindowBackground;

    public function WOTrainOrder() {
        super ();
        var txt:TextField;
        var im:Image;
        _arrItems = [];
        _woWidth = 500;
        _woHeight = 337;
//        createTempBG();
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _btn = new CButton();
        _btn.addButtonTexture(172, 50, CButton.GREEN, true);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("rubins"));
        im.y = 10;
        im.x = 30;
        MCScaler.scale(im,30,30);
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
        if (g.user.hardCurrency < 30) return;
        g.userInventory.addMoney(1,-30);
        hideIt()
    }

    public function showItWO(list:Array,time:int):void {
        _timer = time;
        _txtTime.text = TimeUtils.convertSecondsForOrders(_timer);
        g.gameDispatcher.addToTimer(timerCheck);
        fillList(list);
        showIt();
    }

    private function fillList(list:Array):void {
        var item1:WOTrainOrderItem;
        var item2:WOTrainOrderItem;
        var item3:WOTrainOrderItem;
            item1 = new WOTrainOrderItem();
            item1.fillIt(list[0], 1);
            item1.source.x = -150;
            item1.source.y = -20;
            _source.addChild(item1.source);
            item2 = new WOTrainOrderItem();
            item2.fillIt(list[4], 4);
            item2.source.x = -50;
            item2.source.y = -20;
            _source.addChild(item2.source);
            item3 = new WOTrainOrderItem();
            item3.source.x = 50;
            item3.source.y = -20;
            item3.fillIt(list[9], 9);
            _source.addChild(item3.source);
    }

    private function timerCheck():void {
        --_timer;
        _txtTime.text = TimeUtils.convertSecondsForOrders(_timer);
    }
}
}
