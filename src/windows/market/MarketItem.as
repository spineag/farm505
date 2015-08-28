/**
 * Created by user on 6/24/15.
 */
package windows.market {

import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import data.DataMoney;

import flash.geom.Point;

import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;


public class MarketItem {
    public var source:CSprite;
    private var _bg:Image;
    private var _costTxt:TextField;
    private var _countTxt:TextField;
    private var isFill:int;   //0 - пустая, 1 - заполненная, 2 - купленная
    private var _callback:Function;
    private var _data:Object;
    private var _dataFromServer:Object;
    private var _countResource:int;
    private var _countMoney:int;
    private var _im:Image;
    private var _isUser:Boolean;

    private var g:Vars = Vars.getInstance();

    public function MarketItem() {
        source = new CSprite();
        _bg = new Image(g.interfaceAtlas.getTexture('shop_item'));
        _bg.scaleY = .5;
        source.addChild(_bg);

        _costTxt = new TextField(122, 30, '', "Arial", 16, Color.YELLOW);
        _costTxt.x = 22;
        _costTxt.y = 103;
        source.addChild(_costTxt);

        _countTxt = new TextField(30, 20, '', "Arial", 14, Color.BLACK);
        _countTxt.x = 120;
        _countTxt.y = 7;
        source.addChild(_countTxt);

        isFill = 0;
        source.endClickCallback = onClick;
    }

    private function fillIt(data:Object, count:int):void {
        isFill = 1;
        _data = data;
        if (_data) {
            if (_data.url == 'resourceAtlas') {
                _im = new Image(g.resourceAtlas.getTexture(_data.imageShop));
            } else if (_data.url == 'plantAtlas') {
                _im = new Image(g.plantAtlas.getTexture(_data.imageShop));
            } else if (_data.url == 'instrumentAtlas') {
                _im = new Image(g.instrumentAtlas.getTexture(_data.imageShop));
            }
            MCScaler.scale(_im, 80, 80);
            _im.x = 80 - _im.width/2;
            _im.y = 50 - _im.height/2;
            source.addChild(_im);
        }
        _countResource = count;
        g.userInventory.addResource(_data.id, -_countResource);
        _countTxt.text = String(_countResource);
        _countMoney = _countResource * _data.costMax;
        _costTxt.text = String(_countMoney);
    }

    public function clearIt():void {
        while (source.numChildren > 3) {
            source.removeChildAt(3);
        }
    }

    private function onClick():void {
        if (isFill == 1) {
            if (_isUser) {
                //тут нужно показать поп-ап про то что за 1 диамант забираем ресурсы с базара
                return;
            } else {

            }
        }
        if (isFill == 0) {
            g.woMarket.hideIt();
            g.woMarket.marketChoose.callback = onChoose;
            g.woMarket.marketChoose.showIt();
        } else {
            if (_im && source.contains(_im)) {
                source.removeChild(_im);
                _im.dispose();
                _im = null;
            }
            _costTxt.text = '';
            _countTxt.text = '';
            isFill = 0;

            animCoin();
        }
    }

    private var counter:int;
    private function onChoose(a:int, count:int = 0, cost:int = 0, inPapper:Boolean = false):void {
        g.woMarket.showIt();
        if (a > 0) {
            fillIt(g.dataResource.objectResources[a], count);
//            counter = 3;
//            g.gameDispatcher.addToTimer(timer);
            g.directServer.addUserMarketItem(a, count, inPapper, cost, onAddToServer);
        }
    }

    private function onAddToServer(ob:Object):void {
        var obj = {};
        obj.id = int(ob.id);
        obj.buyerId = ob.buyer_id;
        obj.cost = int(ob.cost);
        obj.inPapper = Boolean(ob.in_papper);
        obj.resourceCount = int(ob.resource_count);
        obj.resourceId = int(ob.resource_id);
        obj.timeSold = ob.time_sold;
        obj.timeStart = ob.time_start;
        _dataFromServer = obj;
        g.user.marketItems.push(obj);
    }

//    private function timer():void {
//        counter--;
//        if (counter <= 0) {
//            g.gameDispatcher.removeFromTimer(timer);
//            releaseBuy();
//        }
//    }

    private function releaseBuy():void {
        if (_im && source.contains(_im)) {
            source.removeChild(_im);
            _im.dispose();
            _im = null;
        }
        _im = new Image(g.interfaceAtlas.getTexture('coin'));
        _im.x = 80 - _im.width/2;
        _im.y = 50 - _im.height/2;
        source.addChild(_im);
        source.addChild(_im);
        isFill = 2;
    }

    public function set callbackFill(f:Function):void {
        _callback = f;
    }

    private function animCoin():void {
        var eP:Point = g.softHardCurrency.getSoftCurrencyPoint();
        var s:Sprite = new Sprite();
        s.addChild(new Image(g.interfaceAtlas.getTexture('coin')));
        MCScaler.scale(s, 50, 50);
        s.pivotX = s.width / 2;
        s.pivotY = s.height / 2;
        var sP:Point = new Point(80, 110);
        sP = source.localToGlobal(sP);
        s.x = sP.x;
        s.y = sP.y;
        g.cont.animationsResourceCont.addChild(s);

        var f1:Function = function():void {
            g.userInventory.addMoney(DataMoney.SOFT_CURRENCY, _countMoney);
            g.cont.animationsResourceCont.removeChild(s);
            s.dispose();
            s = null;
            _countMoney = 0;
            _countResource = 0;
        };
        new TweenMax(s, 1, {x:eP.x, y:eP.y, ease:Linear.easeOut ,onComplete: f1});
    }

    public function unFillIt():void {
        clearIt();
        isFill = 0;
        _countMoney = 0;
        _countResource = 0;
        _costTxt.text = '';
        _countTxt.text = '';
        _data = null;
    }

    public function fillFromServer(obj:Object, isUser:Boolean):void {
        _isUser = isUser;
        _dataFromServer = obj;
        fillIt(g.dataResource.objectResources[_dataFromServer.resourceId], _dataFromServer.resourceCount);
    }

    public function set isUser(value:Boolean):void {
        _isUser = value;
    }

}
}
