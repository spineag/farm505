/**
 * Created by user on 7/22/15.
 */
package windows.orderWindow {
import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;
import dragonBones.Armature;
import dragonBones.Bone;
import dragonBones.animation.WorldClock;
import dragonBones.events.AnimationEvent;
import flash.geom.Point;
import heroes.HeroEyesAnimation;
import heroes.OrderCat;
import manager.ManagerFilters;
import manager.ManagerOrder;
import manager.ManagerOrderItem;

import resourceItem.DropItem;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import tutorial.TutorialTextBubble;

import ui.xpPanel.XPStar;
import utils.CButton;
import utils.CSprite;
import utils.MCScaler;
import utils.TimeUtils;
import windows.WOComponents.Birka;
import windows.WOComponents.CartonBackground;
import windows.WOComponents.CartonBackgroundIn;
import windows.Window;
import windows.WOComponents.WindowBackground;
import windows.WindowsManager;

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
    private var _rightBlock:Sprite;
    private var _rightBlockTimer:Sprite;
    private var _activeOrderItem:WOOrderItem;
    private var _txtTimer:TextField;
    private var _waitForAnswer:Boolean;
    private var _btnSkipDelete:CButton;
    private var _armatureCustomer:Armature;
    private var _armatureSeller:Armature;
    private var _imCoup:Image;
    private var _txtCoupone:TextField;
    private var _bubble:TutorialTextBubble;
    private var heroEyes:HeroEyesAnimation;

    public function WOOrder() {
        super ();
        _woWidth = 764;
        _woHeight = 570;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;

        createRightBlock();
        createRightBlockTimer();
        createItems();
        createButtonCell();
        createButtonSkipDelete();
        _arrOrders = g.managerOrder.arrOrders.slice();
        createTopCats();
        _waitForAnswer = false;
        _rightBlock.visible = false;

        new Birka('ЛАВКА', _source, 764, 570);
    }

    override public function showIt():void {
        _arrOrders = g.managerOrder.arrOrders.slice();
        fillList();
        onItemClick(_arrItems[0]);
        super.showIt();
        _waitForAnswer = false;
        changeCatTexture(0);
        startAnimationCats();
    }

    private function onClickExit(e:Event=null):void {
        if (g.managerTutorial.isTutorial) return;
        hideIt();
    }

    override public function hideIt():void {
        g.gameDispatcher.removeFromTimer(onTimer);
        try {
            for (var i:int = 0; i < _arrItems.length; i++) {
                _arrItems[i].activateIt(false);
            }
        } catch (e:Error) {
            Cc.error('WOOrder onClickExit error1:: ' + e.message);
        }
        try {
            clearResourceItems();
        } catch (e:Error) {
            Cc.error('WOOrder onClickExit error2:: ' + e.message);
        }
        try {
            for (i = 0; i < _arrOrders.length; i++) {
                _arrItems[i].clearIt();
            }
        } catch (e:Error) {
            Cc.error('WOOrder onClickExit error3:: ' + e.message);
        }
        _activeOrderItem = null;
        super.hideIt();
        killCatsAnimations();
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
        _txtXP.x = 523;
        _txtXP.y = 418;
        _rightBlock.addChild(_txtXP);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
        im.x = 570;
        im.y = 419;
        MCScaler.scale(im, 30, 30);
        im.filter = ManagerFilters.SHADOW_TINY;
        _rightBlock.addChild(im);
        _imCoup = new Image(g.allData.atlas['interfaceAtlas'].getTexture('a_tr_cup_ico'));
        _imCoup.x = 640;
        _imCoup.y = 422;
        _imCoup.visible = false;
        _rightBlock.addChild(_imCoup);
        _txtCoupone = new TextField(30, 30, "1", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _txtCoupone.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtCoupone.x = 650;
        _txtCoupone.y = 418;
        _txtCoupone.visible = false;
        _rightBlock.addChild(_txtCoupone);
        _txtCoins = new TextField(52, 30, "8888", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _txtCoins.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtCoins.x = 590;
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
        _btnDeleteOrder.hoverCallback = function():void { _btnDeleteOrder.filter = ManagerFilters.BUTTON_HOVER_FILTER; };
        _btnDeleteOrder.outCallback = function():void { _btnDeleteOrder.filter = null; };
    }

    private function createItems():void {
        var item:WOOrderItem;
        _arrItems = [];
        for (var i:int=0; i<9; i++) {
            item = new WOOrderItem();
            item.source.x = -382 + 40 + (i%3)*120;
            item.source.y = -285 + 185 + int(i/3)*94;
            _source.addChild(item.source);
            _arrItems.push(item);
        }
    }

    private function createButtonCell():void {
        _btnCell = new CButton();
        _btnCell.addButtonTexture(120, 40, CButton.GREEN, true);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_left'));
        MCScaler.scale(im, 66, 66);
        im.x = 98;
        im.y = -15;
        _btnCell.addDisplayObject(im);
        var txt:TextField = new TextField(110, 60, "Оформить заказ", g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        txt.y = -9;
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        _btnCell.addChild(txt);
        _btnCell.registerTextField(txt, ManagerFilters.TEXT_STROKE_GREEN);
        _btnCell.x = 547;
        _btnCell.y = 500;
        _rightBlock.addChild(_btnCell);
        _btnCell.clickCallback = sellOrder;
    }

    private function createButtonSkipDelete():void {
        _btnSkipDelete = new CButton();
        _btnSkipDelete.addButtonTexture(120, 50, CButton.GREEN, true);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
        MCScaler.scale(im, 20, 20);
        im.x = 98;
        im.y = 15;
        _btnSkipDelete.addDisplayObject(im);
        var txt:TextField = new TextField(80, 50, "Получить сейчас", g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        _btnSkipDelete.addChild(txt);
        txt = new TextField(20, 50, String(ManagerOrder.COST_SKIP_WAIT), g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        txt.x = 80;
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        _btnSkipDelete.addChild(txt);
        _btnSkipDelete.x = 160;
        _btnSkipDelete.y = 220;
        _rightBlockTimer.addChild(_btnSkipDelete);
        _btnSkipDelete.clickCallback = skipDelete;
    }

    private function sellOrder(b:Boolean = false, _order:ManagerOrderItem = null):void {
        if (_waitForAnswer) return;
        var i:int;
        if (!b) {
            for (i = 0; i < _activeOrderItem.getOrder().resourceIds.length; i++) {
                if (!_arrResourceItems[i].isChecked()) {
//                    g.woNoResources.showItOrder(_activeOrderItem.getOrder(), sellOrder);
                    g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, sellOrder, 'order', _activeOrderItem.getOrder());
                    return;
                }
            }
            for (i = 0; i < _activeOrderItem.getOrder().resourceIds.length; i++) {
                if (_activeOrderItem.getOrder().resourceCounts[i] == g.userInventory.getCountResourceById(_activeOrderItem.getOrder().resourceIds[i])
                        && g.dataResource.objectResources[_activeOrderItem.getOrder().resourceIds[i]].buildType == BuildType.PLANT) {
                    g.windowsManager.openWindow(WindowsManager.WO_BUY_FOR_HARD, sellOrder, _activeOrderItem.getOrder(), 'order');
                    return;
                }
            }
        } else {
            showIt();
            for (i=0; i< _arrItems.length; i++) {
                if (_arrItems[i].getOrder().dbId == _order.dbId) {
                    onItemClick(_arrItems[i]);
                    break;
                }
            }
        }
        for (i=0; i<_activeOrderItem.getOrder().resourceIds.length; i++) {
            g.userInventory.addResource(_activeOrderItem.getOrder().resourceIds[i], -_activeOrderItem.getOrder().resourceCounts[i]);
        }
        var prise:Object = {};
        var p:Point = new Point(134, 147);
        p = _source.localToGlobal(p);
        new XPStar(p.x, p.y, _activeOrderItem.getOrder().xp);
        p = new Point(186, 147);
        prise.id = DataMoney.SOFT_CURRENCY;
        prise.count = _activeOrderItem.getOrder().coins;
        new DropItem(p.x, p.y, prise);
        if (_activeOrderItem.getOrder().addCoupone) {
            p.x = _btnCell.x + _btnCell.width * 4 / 5;
            p.y = _btnCell.y + _btnCell.height / 2;
            prise.id = int(Math.random() * 4) + 3;
            prise.count = 1;
            new DropItem(p.x, p.y, prise);
        }
        _waitForAnswer = true;
        var tOrderItem:WOOrderItem = _activeOrderItem;
        var f:Function = function (order:ManagerOrderItem):void {
            afterSell(order, tOrderItem);
        };
        _arrOrders[_activeOrderItem.position] = null;
        g.managerOrder.sellOrder(_activeOrderItem.getOrder(), f);
        g.bottomPanel.checkIsFullOrder();
        animateCatsOnSell();
    }

    private function afterSell(order:ManagerOrderItem, orderItem:WOOrderItem):void {
        _waitForAnswer = false;
        if (g.currentOpenedWindow && g.currentOpenedWindow == this) {
            var b:Boolean = true;
            for (var k:int=0; k<order.resourceIds.length; k++) {
                if (g.userInventory.getCountResourceById(order.resourceIds[k]) < order.resourceCounts[k]) {
                    b = false;
                    break;
                }
            }
            orderItem.fillIt(order, order.placeNumber, onItemClick, b);
            _arrOrders[order.placeNumber] = order;
            if (_activeOrderItem == orderItem) {
                onItemClick(_activeOrderItem);
            }
        }
        g.bottomPanel.checkIsFullOrder();
    }

    private function fillList():void {
        var maxCount:int = g.managerOrder.maxCountOrders;
        var b:Boolean;
        var order:ManagerOrderItem;
        var k:int;
        for (var i:int=0; i<_arrOrders.length; i++) {
            if (i >= maxCount) return;
            b = true;
            order = _arrOrders[i];
            for (k=0; k<order.resourceIds.length; k++) {
                if (g.userInventory.getCountResourceById(order.resourceIds[k]) < order.resourceCounts[k]) {
                    b = false;
                    break;
                }
            }
            if (order.placeNumber > -1) {
                _arrItems[i].fillIt(order, order.placeNumber, onItemClick, b);
            } else {
                Cc.error('WOOrder fillList:: order.place == -1');
            }
        }
    }

    private function onItemClick(item:WOOrderItem):void {
        if (_waitForAnswer) return;
        if (_activeOrderItem) _activeOrderItem.activateIt(false);
        clearResourceItems();
        _activeOrderItem = item;
        fillResourceItems(item.getOrder());
        _activeOrderItem.activateIt(true);
        stopCatsAnimations();
        changeCatTexture(item.position);
        animateCustomerCat();
        animateSellerCat();
        if (_activeOrderItem.leftSeconds > 0) {
            _rightBlock.visible = false;
            _rightBlockTimer.visible = true;
            g.gameDispatcher.addToTimer(onTimer);
            setTimerText = _activeOrderItem.leftSeconds;
        } else {
            _rightBlock.visible = true;
            if (item.getOrder().addCoupone) {
                _imCoup.visible = true;
                _txtCoupone.visible = true;
            }
            else {
                _imCoup.visible = false;
                _txtCoupone.visible = false;
            }
            _rightBlockTimer.visible = false;
            g.gameDispatcher.removeFromTimer(onTimer);
        }
    }

    private function clearResourceItems():void {
        for (var i:int=0; i<_arrResourceItems.length; i++) {
            _arrResourceItems[i].clearIt();
        }
        _txtName.text = '';
        _txtXP.text = '';
        _txtCoins.text = '';
    }

    private function fillResourceItems(order:ManagerOrderItem):void {
        _txtName.text = _activeOrderItem.getOrder().catName + ' заказывает';
        _txtXP.text = String(_activeOrderItem.getOrder().xp);
        _txtCoins.text = String(_activeOrderItem.getOrder().coins);
        for (var i:int=0; i<_activeOrderItem.getOrder().resourceIds.length; i++) {
            _arrResourceItems[i].fillIt(_activeOrderItem.getOrder().resourceIds[i], _activeOrderItem.getOrder().resourceCounts[i]);
        }
    }

    private function deleteOrder():void {
        if (_activeOrderItem) {
            _rightBlock.visible = false;
            _rightBlockTimer.visible = true;
            setTimerText = ManagerOrder.TIME_DELAY;
            _waitForAnswer = true;
            _arrOrders[_activeOrderItem.position] = null;
            var tOrderItem:WOOrderItem = _activeOrderItem;
            var f:Function = function (order:ManagerOrderItem):void {
                afterDeleteOrder(order, tOrderItem);
            };
            g.managerOrder.deleteOrder(_activeOrderItem.getOrder(), f);
        }
    }

    private function afterDeleteOrder(order:ManagerOrderItem, orderItem:WOOrderItem):void {
        if (g.currentOpenedWindow && g.currentOpenedWindow == this) {
            order.startTime += ManagerOrder.TIME_DELAY;
            _waitForAnswer = false;
            setTimerText = ManagerOrder.TIME_DELAY;
            var b:Boolean = true;
            for (var k:int=0; k<order.resourceIds.length; k++) {
                if (g.userInventory.getCountResourceById(order.resourceIds[k]) < order.resourceCounts[k]) {
                    b = false;
                    break;
                }
            }
            orderItem.fillIt(order, order.placeNumber, onItemClick, b);
            _arrOrders[order.placeNumber] = order;
            if (_activeOrderItem == orderItem) {
                onItemClick(_activeOrderItem);
            }
            g.gameDispatcher.addToTimer(onTimer);
        }
    }

    private function skipDelete():void {
        if (g.user.hardCurrency < ManagerOrder.COST_SKIP_WAIT) {
            hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        _activeOrderItem.onSkipTimer();
        g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -ManagerOrder.COST_SKIP_WAIT);
    }

    private function createRightBlockTimer():void {
        _rightBlockTimer = new Sprite();
        _rightBlockTimer.x = -382 + 407;
        _rightBlockTimer.y = -285 + 178;
        _source.addChild(_rightBlockTimer);
        var bg:CartonBackground = new CartonBackground(317, 278);
        bg.filter = ManagerFilters.SHADOW_LIGHT;
        _rightBlockTimer.addChild(bg);
        var bgIn:CartonBackgroundIn = new CartonBackgroundIn(280, 150);
        bgIn.x = 14;
        bgIn.y = 32;
        _rightBlockTimer.addChild(bgIn);

        var t:TextField = new TextField(280, 30, "ЗАКАЗ УДАЛЕН", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        t.x = 14;
        t.y = 40;
        t.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _rightBlockTimer.addChild(t);
        t = new TextField(280, 30, "следующий поступит через:", g.allData.fonts['BloggerMedium'], 16, Color.WHITE);
        t.x = 14;
        t.y = 65;
        t.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _rightBlockTimer.addChild(t);

        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_del_clock'));
        im.x = 65;
        im.y = 110;
        _rightBlockTimer.addChild(im);
        _txtTimer = new TextField(165, 50, "", g.allData.fonts['BloggerBold'], 30, Color.WHITE);
        _txtTimer.x = 101;
        _txtTimer.y = 102;
        _txtTimer.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _rightBlockTimer.addChild(_txtTimer);
    }

    private function onTimer():void {
        if (_activeOrderItem.leftSeconds > 0) {
            setTimerText = _activeOrderItem.leftSeconds;
        } else {
            _rightBlock.visible = true;
            _rightBlockTimer.visible = false;
            g.gameDispatcher.removeFromTimer(onTimer);
            setTimerText = 0;
        }
    }

    private function set setTimerText(c:int):void {
        _txtTimer.text = TimeUtils.convertSecondsForOrders(c);
    }

    public function getSellBtnProperties():Object {
        var ob:Object = {};
        ob.x = _btnCell.x;
        ob.y = _btnCell.y;
        var p:Point = new Point(ob.x, ob.y);
        p = _source.localToGlobal(p);
        ob.x = p.x;
        ob.y = p.y;
        ob.width = _btnCell.width;
        ob.height = _btnCell.height;
        return ob;
    }


    // ------------------ ANIMATIONS ---------------------

    private function createTopCats():void {
        _armatureCustomer = g.allData.factory['orderWindow'].buildArmature("cat_customer");
        _armatureSeller = g.allData.factory['orderWindow'].buildArmature("cat_seller");
        _armatureCustomer.display.x = 110;
        _armatureCustomer.display.y = -170;
        _armatureSeller.display.x = -110;
        _armatureSeller.display.y = -170;
        _source.addChild(_armatureCustomer.display as Sprite);
        _source.addChild(_armatureSeller.display as Sprite);
        var viyi:Bone = _armatureSeller.getBone('viyi');
        if (viyi) viyi.visible = false;
        viyi = _armatureCustomer.getBone('viyi');
        if (viyi) viyi.visible = false;
    }

    private function changeCatTexture(pos:int):void {
        var st:String;
        var isWoman:Boolean;
        if (!_arrOrders[pos] || !_arrOrders[pos].cat) return;
        switch (_arrOrders[pos].cat.typeCat){
            case OrderCat.BLUE:   st = '_bl';  isWoman = false; break;
            case OrderCat.GREEN:  st = '_gr'; isWoman = false; break;
            case OrderCat.ORANGE: st = '_or'; isWoman = true;  break;
            case OrderCat.PINK:   st = '_pk'; isWoman = true;  break;
            case OrderCat.WHITE:  st = '_wh'; isWoman = true;  break;
            case OrderCat.BLACK:  st = '';    isWoman = false; break;
        }
        releaseFrontTexture(st);
//        heroEyes = new HeroEyesAnimation(g.allData.factory['cat_queue'], _armatureCustomer, 'heads/head' + st ,isWoman);
    }

    private function releaseFrontTexture(st:String):void {
        changeTexture("head", "heads/head" + st, _armatureCustomer);
        changeTexture("body", "bodys/body" + st, _armatureCustomer);
        changeTexture("handLeft", "left_hand/handLeft" + st, _armatureCustomer);
        changeTexture("handRight", "right_hand/handRight" + st, _armatureCustomer);
    }

    private function changeTexture(oldName:String, newName:String, arma:Armature):void {
        var im:Image = g.allData.factory['orderWindow'].getTextureDisplay(newName) as Image;
        var b:Bone = arma.getBone(oldName);
        b.display.dispose();
        b.display = im;
    }
    private function startAnimationCats():void {
        WorldClock.clock.add(_armatureCustomer);
        WorldClock.clock.add(_armatureSeller);
        animateCustomerCat();
        animateSellerCat();
    }

    private function animateCustomerCat(e:AnimationEvent=null):void {
        if (_armatureCustomer.hasEventListener(AnimationEvent.COMPLETE)) _armatureCustomer.removeEventListener(AnimationEvent.COMPLETE, animateCustomerCat);
        if (_armatureCustomer.hasEventListener(AnimationEvent.LOOP_COMPLETE)) _armatureCustomer.removeEventListener(AnimationEvent.LOOP_COMPLETE, animateCustomerCat);

        _armatureCustomer.addEventListener(AnimationEvent.COMPLETE, animateCustomerCat);
        _armatureCustomer.addEventListener(AnimationEvent.LOOP_COMPLETE, animateCustomerCat);
        var l:int = int(Math.random()*6);
        switch (l) {
            case 0: _armatureCustomer.animation.gotoAndPlay('idle1'); break;
            case 1: _armatureCustomer.animation.gotoAndPlay('idle1'); break;
            case 2: _armatureCustomer.animation.gotoAndPlay('idle1'); break;
            case 3: _armatureCustomer.animation.gotoAndPlay('hi1'); break;
            case 4: _armatureCustomer.animation.gotoAndPlay('hi2'); break;
            case 5: _armatureCustomer.animation.gotoAndPlay('idle1'); break;
        }
    }

    private function animateSellerCat(e:AnimationEvent=null):void {
        if (_armatureSeller.hasEventListener(AnimationEvent.COMPLETE)) _armatureSeller.removeEventListener(AnimationEvent.COMPLETE, animateSellerCat);
        if (_armatureSeller.hasEventListener(AnimationEvent.LOOP_COMPLETE)) _armatureSeller.removeEventListener(AnimationEvent.LOOP_COMPLETE, animateSellerCat);

        _armatureSeller.addEventListener(AnimationEvent.COMPLETE, animateSellerCat);
        _armatureSeller.addEventListener(AnimationEvent.LOOP_COMPLETE, animateSellerCat);
        var l:int = int(Math.random()*6);
        switch (l) {
            case 0: _armatureSeller.animation.gotoAndPlay('idle1'); break;
            case 1: _armatureSeller.animation.gotoAndPlay('idle1'); break;
            case 2: _armatureSeller.animation.gotoAndPlay('idle1'); break;
            case 3: _armatureSeller.animation.gotoAndPlay('hi1'); break;
            case 4: _armatureSeller.animation.gotoAndPlay('hi2'); break;
            case 5: _armatureSeller.animation.gotoAndPlay('idle1'); break;
        }
    }

    private function killCatsAnimations():void {
        stopCatsAnimations();
        WorldClock.clock.remove(_armatureCustomer);
        WorldClock.clock.remove(_armatureSeller);
    }

    private function stopCatsAnimations():void {
        _armatureCustomer.animation.gotoAndStop('idle1', 0);
        _armatureSeller.animation.gotoAndStop('idle1', 0);
        if (_armatureSeller.hasEventListener(AnimationEvent.COMPLETE)) _armatureSeller.removeEventListener(AnimationEvent.COMPLETE, animateSellerCat);
        if (_armatureSeller.hasEventListener(AnimationEvent.LOOP_COMPLETE)) _armatureSeller.removeEventListener(AnimationEvent.LOOP_COMPLETE, animateSellerCat);
        if (_armatureCustomer.hasEventListener(AnimationEvent.COMPLETE)) _armatureCustomer.removeEventListener(AnimationEvent.COMPLETE, animateCustomerCat);
        if (_armatureCustomer.hasEventListener(AnimationEvent.LOOP_COMPLETE)) _armatureCustomer.removeEventListener(AnimationEvent.LOOP_COMPLETE, animateCustomerCat);
    }

    private function animateCatsOnSell():void {
        stopCatsAnimations();
        _armatureSeller.addEventListener(AnimationEvent.COMPLETE, animateSellerOnSell);
        _armatureSeller.addEventListener(AnimationEvent.LOOP_COMPLETE, animateSellerOnSell);
        _armatureSeller.animation.gotoAndPlay('coin');
        _armatureCustomer.addEventListener(AnimationEvent.COMPLETE, animateCustomerOnSell);
        _armatureCustomer.addEventListener(AnimationEvent.LOOP_COMPLETE, animateCustomerOnSell);
        _armatureCustomer.animation.gotoAndPlay('love');
    }

    private function animateSellerOnSell(e:AnimationEvent):void {
        _armatureSeller.removeEventListener(AnimationEvent.COMPLETE, animateSellerOnSell);
        _armatureSeller.removeEventListener(AnimationEvent.LOOP_COMPLETE, animateSellerOnSell);
        animateSellerCat();
    }

    private function animateCustomerOnSell(e:AnimationEvent):void {
        _armatureCustomer.removeEventListener(AnimationEvent.COMPLETE, animateCustomerOnSell);
        _armatureCustomer.removeEventListener(AnimationEvent.LOOP_COMPLETE, animateCustomerOnSell);
        animateCustomerCat();
    }

    public function setTextForCustomer(st:String):void {
        if (_bubble) {
            _bubble.hideBubble();
            _bubble.deleteIt();
        }

        if (st != '') {
            _bubble = new TutorialTextBubble(_source);
            _bubble.showBubble(st, true);
            _bubble.setXY(120, -150);
        }
    }

}
}
