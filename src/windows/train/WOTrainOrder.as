/**
 * Created by user on 9/11/15.
 */
package windows.train {

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

import windows.Window;

public class WOTrainOrder extends Window{
    private var _contBtn:CSprite;
    private var _imageBtn:Image;
    private var _imageHard:Image;
    private var _txtBtn:TextField;
    private var _txtCostBtn:TextField;
    private var _txtInformation:TextField;
    private var _txtText:TextField;
    private var _txtTime:TextField;
    private var _txtTextTime:TextField;
    private var _arrItems:Array;
    private var _timer:int;


    public function WOTrainOrder() {
        super ();
        _arrItems = [];
        createTempBG(500, 320, Color.GRAY);
        createExitButton(g.interfaceAtlas.getTexture('btn_exit'), '', g.interfaceAtlas.getTexture('btn_exit_click'), g.interfaceAtlas.getTexture('btn_exit_hover'));
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);
        _btnExit.x = 250;
        _btnExit.y = -160;
        _contBtn = new CSprite();
        _imageBtn = new Image(g.interfaceAtlas.getTexture("btn2"));
        _imageBtn.width = 150;
        _imageBtn.height = 50;
        _imageHard = new Image(g.interfaceAtlas.getTexture("diamont"));
        _imageHard.y = 10;
        MCScaler.scale(_imageHard,25,25);
        _txtBtn = new TextField(100,50,"Вернуть корабль сейчас","Arial",12,Color.BLACK);
        _txtBtn.x = 40;
        _txtCostBtn = new TextField(50,50,"5","Arial",12,Color.BLACK);
        _txtCostBtn.x = 10;
        _source.addChild(_contBtn);
        _contBtn.addChild(_imageBtn);
        _contBtn.addChild(_imageHard);
        _contBtn.addChild(_txtBtn);
        _contBtn.addChild(_txtCostBtn);
        _contBtn.x = -80;
        _contBtn.y = 100;
        _contBtn.endClickCallback = onClickBtn;

        _txtInformation = new TextField(150,50,"Информация о заказе","Arial",12,Color.BLACK);
        _txtInformation.x = -50;
        _txtInformation.y = -140;
        _txtText = new TextField(300,50,"Пока корабль в пути вы можете начать подготовку товаров для следующего заказа!","Arial",12,Color.BLACK);
        _txtText.x = -120;
        _txtText.y = -100;
        _txtTextTime = new TextField(200,50,"Корабль вернется к пристани через:","Arial",12,Color.BLACK);
        _txtTextTime.x = -100;
        _txtTextTime.y = 20;
        _txtTime = new TextField(50,50,"","Arial",12,Color.BLACK);
        _txtTime.x = -20;
        _txtTime.y = 60;
        _source.addChild(_txtInformation);
        _source.addChild(_txtText);
        _source.addChild(_txtTextTime);
        _source.addChild(_txtTime);
    }

    public function onClickExit(e:Event=null):void {
        hideIt();
    }

    private function onClickBtn():void {
        if (g.user.hardCurrency < int(_txtCostBtn.text)) return;
        g.userInventory.addMoney(1,-int(_txtCostBtn.text));
        hideIt()
    }

    public function showItWO(list:Array,time:int):void {
        _timer = time;
        g.gameDispatcher.addToTimer(timerCheck);
        fillList(list);
        showIt();
    }

    private function fillList(list:Array):void {
        var item1:WOTrainOrderItem;
        var item2:WOTrainOrderItem;
        var item3:WOTrainOrderItem;
            item1 = new WOTrainOrderItem();
            item1.fillIt(list[1], 1);
            item1.source.x = -150;
            item1.source.y = -50;
            _source.addChild(item1.source);
            item2 = new WOTrainOrderItem();
            item2.fillIt(list[4], 4);
            item2.source.x = -50;
            item2.source.y = -50;
            _source.addChild(item2.source);
            item3 = new WOTrainOrderItem();
            item3.source.x = 50;
            item3.source.y = -50;
            item3.fillIt(list[6], 6);
            _source.addChild(item3.source);

//        for (var j:int = 0; j<list.length; j++) {
//            item = new WOTrainOrderItem();
//            item.fillIt(list[j], j);
//            item.source.x = j%3 * 110 - 240;
//            if (j >= 6) {
//                item.source.y = 60;
//            } else if (j >= 3) {
//                item.source.y = -40;
//            } else {
//                item.source.y = -140;
//            }
//            _source.addChild(item.source);
//            _arrItems.push(item);
//        }

    }

    private function timerCheck():void {
        --_timer;
        _txtTime.text = String(_timer);
    }
}
}
