/**
 * Created by user on 6/24/15.
 */
package windows.market {

import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import data.BuildType;
import data.DataMoney;

import flash.geom.Point;
import manager.Vars;
import resourceItem.ResourceItem;

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
    private var _inPapper:Image;
    private var _plawkaSold:Image;
    private var _isUser:Boolean;
    private var _imageCont:Sprite;

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

        _imageCont = new Sprite();
        source.addChild(_imageCont);

        _inPapper = new Image(g.interfaceAtlas.getTexture('in_papper'));
        _inPapper.x = -5;
        _inPapper.y = -5;
        source.addChild(_inPapper);
        _inPapper.visible = false;

        _plawkaSold = new Image(g.interfaceAtlas.getTexture('plawka_sold'));
        _plawkaSold.x = _bg.width/2 - _plawkaSold.width/2;
        source.addChild(_plawkaSold);
        _plawkaSold.visible = false;

        isFill = 0;
        source.endClickCallback = onClick;
    }

    private function fillIt(data:Object, count:int, isFromServer:Boolean = false):void {
        var im:Image;
        isFill = 1;
        _data = data;
        if (_data) {
            if (_data.url == 'resourceAtlas') {
                im = new Image(g.resourceAtlas.getTexture(_data.imageShop));
            } else if (_data.url == 'plantAtlas') {
                im = new Image(g.plantAtlas.getTexture(_data.imageShop));
            } else if (_data.url == 'instrumentAtlas') {
                im = new Image(g.instrumentAtlas.getTexture(_data.imageShop));
            }
            MCScaler.scale(im, 80, 80);
            im.x = 80 - im.width/2;
            im.y = 50 - im.height/2;
            _imageCont.addChild(im);
        }
        _countResource = count;
        if (!isFromServer) g.userInventory.addResource(_data.id, -_countResource);
        _countTxt.text = String(_countResource);
        _countMoney = _countResource * _data.costMax;
        _costTxt.text = String(_countMoney);
    }

    public function clearImageCont():void {
        while (_imageCont.numChildren) {
            _imageCont.removeChildAt(0);
        }
    }

    private function onClick():void {
        var i:int;
        if (isFill == 1) {
            if (_isUser) {
                //тут нужно показать поп-ап про то что за 1 диамант забираем ресурсы с базара

            } else {
                if (g.user.softCurrencyCount < _dataFromServer.cost) {
                    g.flyMessage.showIt(source, "Недостаточно денег");
                    return;
                }
                var d:Object = g.dataResource.objectResources[_dataFromServer.resourceId];
                if (d.placeBuild == BuildType.PLACE_AMBAR) {
                    if (g.userInventory.currentCountInAmbar + _dataFromServer.resourceCount >= g.user.ambarMaxCount) {
                        g.flyMessage.showIt(source, "Амбар заполнен");
                        return;
                    }
                } else if (d.placeBuild == BuildType.PLACE_SKLAD) {
                    if (g.userInventory.currentCountInSklad + _dataFromServer.resourceCount >= g.user.skladMaxCount) {
                        g.flyMessage.showIt(source, "Склад заполнен");
                        return;
                    }
                }
                clearImageCont();
                g.userInventory.addMoney(DataMoney.SOFT_CURRENCY, -_dataFromServer.cost);
                showFlyResource(d, _dataFromServer.resourceCount);
                _inPapper.visible = false;
                showCoinImage();
                _plawkaSold.visible = true;
                g.directServer.buyFromMarket(_dataFromServer.id, null);
                isFill = 2;
                var arr:Array = g.user.arrFriends.concat(g.user.arrTempUsers);
                for (var j:int; j< arr.length; j++) {
                    if (!arr[j].marketItems) continue;
                    for (i = 0; i < arr[j].marketItems.length; i++) {
                        if (g.user.arrFriends[j].marketItems[i].id == _dataFromServer.id) {
                            g.user.arrFriends[j].marketItems[i].buyerId = g.user.userId;
                            g.user.arrFriends[j].marketItems[i].inPapper = false;
                            g.user.arrFriends[j].marketItems[i].buyerSocialId = g.user.userSocialId;
                            return;
                        }
                    }
                }
            }
        } else if (isFill == 0) {
            if (_isUser) {
                g.woMarket.hideIt();
                g.woMarket.marketChoose.callback = onChoose;
                g.woMarket.marketChoose.showIt();
            }
        } else {
            if (_isUser) {
                g.userInventory.addMoney(2,_dataFromServer.cost);
                g.directServer.deleteUserMarketItem(_dataFromServer.id, null);
                for (i=0; i<g.user.marketItems.length; i++) {
                    if (g.user.marketItems[i].id == _dataFromServer.id) {
                        g.user.marketItems.splice(i, 1);
                        break;
                    }
                }
                animCoin();
                unFillIt();
            }
        }
    }

    private var counter:int;
    private function onChoose(a:int, count:int = 0, cost:int = 0, inPapper:Boolean = false):void {
        g.woMarket.showIt();
        if (a > 0) {
            fillIt(g.dataResource.objectResources[a], count);
            _inPapper.visible = inPapper;
            g.directServer.addUserMarketItem(a, count, inPapper, cost, onAddToServer);
        }
    }

    private function onAddToServer(ob:Object):void {
        var obj:Object = {};
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

//    private function showCoin():void {
//        if (_im && source.contains(_im)) {
//            source.removeChild(_im);
//            _im.dispose();
//            _im = null;
//        }
//        _im = new Image(g.interfaceAtlas.getTexture('coin'));
//        _im.x = 80 - _im.width/2;
//        _im.y = 50 - _im.height/2;
//        source.addChild(_im);
//        source.addChild(_im);
//        isFill = 2;
//    }

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
            g.cont.animationsResourceCont.removeChild(s);
            s.dispose();
            s = null;
            _countMoney = 0;
            _countResource = 0;
        };
        new TweenMax(s, 1, {x:eP.x, y:eP.y, ease:Linear.easeOut ,onComplete: f1});
    }

    public function unFillIt():void {
        clearImageCont();
        isFill = 0;
        _countMoney = 0;
        _countResource = 0;
        _costTxt.text = '';
        _countTxt.text = '';
        _data = null;
        _inPapper.visible = false;
        _plawkaSold.visible = false;
    }

    public function fillFromServer(obj:Object, isUser:Boolean):void {
        _isUser = isUser;
        _dataFromServer = obj;
        _inPapper.visible = _dataFromServer.inPapper;
        if (_dataFromServer.buyerId != '0') {
            _plawkaSold.visible = true;
            isFill = 2;
            showCoinImage();
        } else {
            isFill = 1;
            fillIt(g.dataResource.objectResources[_dataFromServer.resourceId], _dataFromServer.resourceCount, true);
        }
    }

    public function set isUser(value:Boolean):void {
        _isUser = value;
    }

    private function showFlyResource(d:Object, count:int):void {
        var im:Image;
        if (d.url == 'plantAtlas') {
            im = new Image(g.plantAtlas.getTexture(d.imageShop));
        } else if (d.utr == 'instrumentAtlas') {
            im = new Image(g.instrumentAtlas.getTexture(d.imageShop));
        } else {
            im = new Image(g.resourceAtlas.getTexture(d.imageShop));
        }
        MCScaler.scale(im, 50, 50);
        var p:Point = new Point(_bg.width/2, _bg.height/2);
        p = source.localToGlobal(p);
        im.pivotX = im.width/2;
        im.pivotY = im.height/2;
        im.x = p.x;
        im.y = p.y;
        g.cont.animationsResourceCont.addChild(im);
        g.craftPanel.showIt(d.placeBuild);
        p = g.craftPanel.pointXY();
        var f1:Function = function():void {
            g.cont.animationsResourceCont.removeChild(im);
            im.dispose();
            g.userInventory.addResource(d.id, count);
            var item:ResourceItem = new ResourceItem();
            item.fillIt(d);
            g.craftPanel.afterFly(item);
        };
        new TweenMax(im, .5, {x:p.x, y:p.y, ease:Linear.easeOut ,onComplete: f1});
    }

    private function showCoinImage():void {
        var im:Image = new Image(g.interfaceAtlas.getTexture('coin'));
        MCScaler.scale(im, 80, 80);
        im.pivotX = im.width/2;
        im.pivotY = im.height/2;
        im.x = _bg.width/2;
        im.y = _bg.height/2;
        _imageCont.addChild(im);
    }
}
}
