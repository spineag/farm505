/**
 * Created by user on 7/22/15.
 */
package windows.orderWindow {
import data.DataMoney;

import flash.filters.GlowFilter;
import flash.geom.Point;

import manager.ManagerFilters;

import manager.Vars;

import resourceItem.DropItem;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.filters.BlurFilter;
import starling.text.TextField;
import starling.utils.Color;

import ui.xpPanel.XPStar;

import utils.CButton;

import utils.CSprite;
import utils.MCScaler;

import windows.WOComponents.Birka;

import windows.WOComponents.CartonBackground;
import windows.WOComponents.CartonBackgroundIn;

import windows.Window;
import windows.WOComponents.WindowBackground;

public class WOOrder extends Window{
    private var _woBG:WindowBackground;
    private var _arrItems:Array;
    private var _arrResourceItems:Array;
    private var _btnCell:CButton;
    private var _btnDeleteOrder:CSprite;
    private var _txtXP:TextField;
    private var _txtCoins:TextField;
    private var _txtName:TextField;
    private var _arrOrders:Array;
    private var _curOrder:Object;
    private var position:int;
    private var _rightBlock:Sprite;
    private var _rightBlockTimer:Sprite;

    public function WOOrder() {
        super ();
        _woWidth = 764;
        _woHeight = 570;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        callbackClickBG = onClickExit;

        createRightBlock();
        createRightBlockTimer();
        createItems();
        createButtonCell();
        createTopCats();

        _rightBlock.visible = false;

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
        for (i=0; i<_arrOrders.length; i++) {
            _arrItems[i].clearIt();
        }
        hideIt();
    }

    private function createRightBlock():void {
        _rightBlock = new Sprite();
        _rightBlock.x = -382;
        _rightBlock.y = -285;
        _source.addChild(_rightBlock);
        var bg:CartonBackground = new CartonBackground(317, 278);
        bg.x = 407;
        bg.y = 178;
        bg.filter = ManagerFilters.SHADOW_LIGHT;
        _rightBlock.addChild(bg);

        _txtName = new TextField(320, 35, "Самбука заказывает", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _txtName.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtName.x = 407;
        _txtName.y = 175;
        _rightBlock.addChild(_txtName);

        var item:WOOrderResourceItem;
        _arrResourceItems = [];
        for (var i:int=0; i<6; i++) {
            item = new WOOrderResourceItem();
            item.source.x = 418 + (i%3)*103;
            item.source.y = 211 + int(i/3)*104;
            _rightBlock.addChild(item.source);
            _arrResourceItems.push(item);
        }

        var txt:TextField = new TextField(90, 30, "Награда:", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txt.x = 411;
        txt.y = 418;
        _rightBlock.addChild(txt);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star'));
        im.x = 501;
        im.y = 417;
        MCScaler.scale(im, 30, 30);
        im.filter = ManagerFilters.SHADOW_TINY;
        _rightBlock.addChild(im);
        _txtXP = new TextField(52, 30, "8888", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _txtXP.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtXP.x = 528;
        _txtXP.y = 418;
        _rightBlock.addChild(_txtXP);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
        im.x = 580;
        im.y = 419;
        MCScaler.scale(im, 30, 30);
        im.filter = ManagerFilters.SHADOW_TINY;
        _rightBlock.addChild(im);
        _txtCoins = new TextField(52, 30, "8888", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _txtCoins.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtCoins.x = 610;
        _txtCoins.y = 418;
        _rightBlock.addChild(_txtCoins);
        _btnDeleteOrder = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_decline'));
        _btnDeleteOrder.addChild(im);
        im.filter = ManagerFilters.SHADOW_TINY;
        _btnDeleteOrder.x = 670;
        _btnDeleteOrder.y = 414;
        _rightBlock.addChild(_btnDeleteOrder);
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
        _btnCell = new CButton();
        _btnCell.addButtonTexture(120, 40, CButton.GREEN, true);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_left'));
        MCScaler.scale(im, 66, 65);
        im.x = 98;
        im.y = -15;
        _btnCell.addDisplayObject(im);
        var txt:TextField = new TextField(110, 60, "Оформить заказ", g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        txt.y = -9;
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        _btnCell.addChild(txt);
        _btnCell.registerTextField(txt, ManagerFilters.TEXT_STROKE_GREEN);
        _btnCell.x = -_woWidth/2 + 547;
        _btnCell.y = -_woHeight/2 + 500;
        _rightBlock.addChild(_btnCell);
        _btnCell.clickCallback = sellOrder;
    }

    private function sellOrder():void {
        for (var i:int=0; i<_curOrder.resourceIds.length; i++) {
            if (!_arrResourceItems[i].isChecked()) {
                g.woNoResources.showItOrder(_curOrder.resourceIds[i],sellOrder);
            }
        }
            return;
        if (_curOrder) {
            for (var i:int=0; i<_curOrder.resourceIds.length; i++) {
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
        checkSellBtn();
    }

    private function checkSellBtn():void {
        var b:Boolean = true;
        for (var i:int=0; i<_curOrder.resourceIds.length; i++) {
            if (!_arrResourceItems[i].isChecked()) {
                b = false;
                break;
            }
        }
//        _btnCell.setEnabled = b;
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

    private var _txtTimer:TextField;
    private function createRightBlockTimer():void {
        _rightBlockTimer = new Sprite();
        _rightBlockTimer.x = -382 + 407;
        _rightBlockTimer.y = -285 + 178;
        _source.addChild(_rightBlockTimer);
        var bg:CartonBackground = new CartonBackground(317, 278);
        bg.filter = ManagerFilters.SHADOW_LIGHT;
        _rightBlockTimer.addChild(bg);
//        var bgIn:CartonBackgroundIn = new CartonBackgroundIn(280, 150);
//        bgIn.x = 14;
//        bgIn.y = 32;
//        _rightBlockTimer.addChild(bgIn);

        var t:TextField = new TextField(280, 30, "ЗАКАЗ УДАЛЕН", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        t.x = 12;
        t.y = 26;
        t.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _rightBlockTimer.addChild(t);
        t = new TextField(280, 30, "следующий поступит через:", g.allData.fonts['BloggerMedium'], 16, Color.WHITE);
        t.x = 12;
        t.y = 60;
        t.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _rightBlockTimer.addChild(t);

        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_del_clock'));
        im.x = 66;
        im.y = 104;
        _rightBlockTimer.addChild(im);
        _txtTimer = new TextField(165, 50, "00:13:14", g.allData.fonts['BloggerBold'], 20, Color.WHITE);
        t.x = 101;
        t.y = 99;
        t.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _rightBlockTimer.addChild(t);
    }

}
}
