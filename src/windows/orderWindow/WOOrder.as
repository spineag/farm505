/**
 * Created by user on 7/22/15.
 */
package windows.orderWindow {
import data.DataMoney;

import flash.filters.GlowFilter;
import flash.geom.Point;

import manager.Vars;

import resourceItem.DropItem;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.filters.BlurFilter;
import starling.text.TextField;
import starling.utils.Color;

import ui.xpPanel.XPStar;

import utils.CSprite;
import utils.MCScaler;

import windows.Birka;

import windows.CartonBackground;

import windows.Window;
import windows.WindowBackground;

public class WOOrder extends Window{
    private var _woBG:WindowBackground;
    private var _arrItems:Array;
    private var _arrResourceItems:Array;
    private var _btnCell:CSprite;
    private var _btnDeleteOrder:CSprite;
    private var _txtXP:TextField;
    private var _txtCoins:TextField;
    private var _txtName:TextField;
    private var _arrOrders:Array;
    private var _curOrder:Object;
    private var position:int;

    public function WOOrder() {
        super ();
        _woBG = new WindowBackground(764, 570);
        _source.addChild(_woBG);
        createExitButton(g.allData.atlas['interfaceAtlas'].getTexture('bt_close'), '');
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);
        _btnExit.x += 382;
        _btnExit.y -= 285;
        callbackClickBG = onClickExit;

        createRightBlock();
        createItems();
        createButtonCell();
        createTopCats();

        new Birka('ЛАВКА', _source, 764, 570);
    }

    override public function showIt():void {
        _arrOrders = g.managerOrder.arrOrders;
        fillList();
        _arrItems[0].activateIt(true);
        fillResourceItems(_arrOrders[0]);
        super.showIt();
    }


    private function onClickExit(e:Event=null):void {
        for (var i:int=0; i<_arrItems.length; i++) {
            _arrItems[i].activateIt(false);
        }
        clearResourceItems();
        for (var i:int=0; i<_arrOrders.length; i++) {
            _arrItems[i].clearIt();
        }
        hideIt();
    }

    private function createRightBlock():void {
        var bg:CartonBackground = new CartonBackground(317, 278);
        bg.x = -382 + 407;
        bg.y = -285 + 178;
        bg.filter = BlurFilter.createDropShadow(0, 0.785, 0, 1, .5, 0.5);
        _source.addChild(bg);

        _txtName = new TextField(320, 35, "Самбука заказывает", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _txtName.nativeFilters = [new GlowFilter(0x674b0e, 1, 3, 3, 5.0)];
        _txtName.x = -382 + 407;
        _txtName.y = -285 + 175;
        _source.addChild(_txtName);

        var item:WOOrderResourceItem;
        _arrResourceItems = [];
        for (var i:int=0; i<6; i++) {
            item = new WOOrderResourceItem();
            item.source.x = bg.x + 9 + (i%3)*103;
            item.source.y = bg.y + 33 + int(i/3)*104;
            _source.addChild(item.source);
            _arrResourceItems.push(item);
        }

        var txt:TextField = new TextField(90, 30, "Награда:", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        txt.nativeFilters = [new GlowFilter(0x674b0e, 1, 3, 3, 5.0)];
        txt.x = -382 + 411;
        txt.y = -285 + 418;
        _source.addChild(txt);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star'));
        im.x = -382 + 501;
        im.y = -285 + 417;
        MCScaler.scale(im, 30, 30);
        _source.addChild(im);
        _txtXP = new TextField(52, 30, "8888", g.allData.fonts['BloggerBold'], 18, 0xc2f3ff);
        _txtXP.nativeFilters = [new GlowFilter(0x0874a7, 1, 3, 3, 5.0)];
        _txtXP.x = -382 + 528;
        _txtXP.y = -285 + 418;
        _source.addChild(_txtXP);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
        im.x = -382 + 580;
        im.y = -285 + 419;
        MCScaler.scale(im, 30, 30);
        _source.addChild(im);
        _txtCoins = new TextField(52, 30, "8888", g.allData.fonts['BloggerBold'], 18, 0xc2f3ff);
        _txtCoins.nativeFilters = [new GlowFilter(0x0874a7, 1, 3, 3, 5.0)];
        _txtCoins.x = -382 + 610;
        _txtCoins.y = -285 + 418;
        _source.addChild(_txtCoins);
        _btnDeleteOrder = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_decline'));
        _btnDeleteOrder.addChild(im);
        _btnDeleteOrder.x = -382 + 670;
        _btnDeleteOrder.y = -285 + 414;
        _source.addChild(_btnDeleteOrder);
        _btnDeleteOrder.endClickCallback = deleteOrder;
    }

    private function createItems():void {
        var item:WOOrderItem;
        _arrItems = [];
        for (var i:int=0; i<9; i++) {
            item = new WOOrderItem();
            item.source.x = -382 + 40 + (i%3)*120;
            item.source.y = -285 + 178 + int(i/3)*94;
            _source.addChild(item.source);
            _arrItems.push(item);
        }
    }

    private function createButtonCell():void {
        _btnCell = new CSprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('bt_green'));
        _btnCell.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_left'));
        MCScaler.scale(im, 66, 65);
        im.x = 98;
        im.y = -15;
        _btnCell.addChild(im);
        var txt:TextField = new TextField(110, 60, "Оформить заказ", g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        txt.y = -9;
        txt.nativeFilters = [new GlowFilter(0x325d16, 1, 3, 3, 5.0)];
        _btnCell.addChild(txt);
        _btnCell.x = -382 + 487;
        _btnCell.y = -285 + 480;
        _btnCell.flatten();
        _source.addChild(_btnCell);
        _btnCell.endClickCallback = sellOrder;
    }

    private function sellOrder():void {
        if (_curOrder) {
            for (var i:int=0; i<_curOrder.resourceIds.length; i++) {
                if (!_arrResourceItems[i].isChecked()) return;
            }
            for (i=0; i<_curOrder.resourceIds.length; i++) {
                g.userInventory.addResource(_curOrder.resourceIds[i], -_curOrder.resourceCounts[i]);
            }
            var p:Point = new Point(134, 147);
            p = _source.localToGlobal(p);
            new XPStar(p.x, p.y,_curOrder.xp);
            p = new Point(186, 147);
            var prise:Object = {};
            prise.id = DataMoney.SOFT_CURRENCY;
            prise.count = _curOrder.coins;
            new DropItem(p.x, p.y, prise);
            if (_curOrder.addCoupone) {
                p.x = _btnCell.x + _btnCell.width*4/5;
                p.y = _btnCell.y + _btnCell.height/2;
                prise.id = int(Math.random()*4) + 3;
                prise.count = 1;
                new DropItem(p.x, p.y, prise);
            }
            g.managerOrder.sellOrder(_curOrder);
            _curOrder = null;
            updateIt();
        }
    }

    private function createTopCats():void {
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_left'));
        im.x = -382 + 220;
        im.y = -285 + 21;
        _source.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_right'));
        im.x = -382 + 445;
        im.y = -285 + 31;
        _source.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_paket'));
        im.x = -382 + 373;
        im.y = -285 + 65;
        _source.addChild(im);
    }

    private function fillList():void {
        for (var i:int=0; i<_arrOrders.length; i++) {
            _arrItems[i].fillIt(_arrOrders[i], i, onItemClick);
        }
    }

    private function onItemClick(pos:int):void {
        for (var i:int=0; i<_arrItems.length; i++) {
            _arrItems[i].activateIt(false);
        }
        position = pos;
        _arrItems[pos].activateIt(true);
        clearResourceItems();
        fillResourceItems(_arrOrders[pos]);
    }

    private function clearResourceItems():void {
        for (var i:int=0; i<_arrResourceItems.length; i++) {
            _arrResourceItems[i].clearIt();
        }
        _txtName.text = '';
        _txtXP.text = '';
        _txtCoins.text = '';
    }

    private function fillResourceItems(order:Object):void {
        _curOrder = order;
        _txtName.text = _curOrder.catName + ' заказывает';
        _txtXP.text = String(_curOrder.xp);
        _txtCoins.text = String(_curOrder.coins);
        for (var i:int=0; i<_curOrder.resourceIds.length; i++) {
            _arrResourceItems[i].fillIt(_curOrder.resourceIds[i], _curOrder.resourceCounts[i]);
        }
    }

    private function deleteOrder():void {
        if (_curOrder) {
            g.managerOrder.deleteOrder(_curOrder);
            _arrItems[position].activateIt(false);
            _curOrder = null;
            updateIt();
        }
    }

    private function updateIt():void {
        clearResourceItems();
        for (var i:int=0; i<_arrOrders.length; i++) {
            _arrItems[i].clearIt();
        }
        fillList();
        _arrItems[0].activateIt(true);
        fillResourceItems(_arrOrders[0]);
    }

}
}
