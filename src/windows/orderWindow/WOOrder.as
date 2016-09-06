/**
 * Created by user on 7/22/15.
 */
package windows.orderWindow {
import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;
import dragonBones.Armature;
import dragonBones.Bone;
import dragonBones.Slot;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingArmatureDisplay;
import dragonBones.starling.StarlingFactory;

import flash.geom.Point;

import heroes.OrderCat;
import heroes.OrderCat;

import manager.ManagerFabricaRecipe;
import manager.ManagerFilters;
import manager.ManagerOrder;
import manager.ManagerOrderItem;
import media.SoundConst;
import resourceItem.DropItem;

import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import temp.catCharacters.DataCat;

import utils.CTextField;

import utils.SimpleArrow;
import tutorial.TutorialAction;
import tutorial.TutorialTextBubble;
import ui.xpPanel.XPStar;
import utils.CButton;
import utils.MCScaler;
import utils.TimeUtils;
import windows.WOComponents.Birka;
import windows.WOComponents.CartonBackground;
import windows.WOComponents.CartonBackgroundIn;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOOrder extends WindowMain{
    private var _woBG:WindowBackground;
    private var _arrItems:Array;
    private var _arrResourceItems:Array;
    private var _btnSell:CButton;
    private var _btnDeleteOrder:CButton;
    private var _txtXP:CTextField;
    private var _txtCoins:CTextField;
    private var _txtName:CTextField;
    private var _arrOrders:Array;
    private var _rightBlock:Sprite;
    private var _rightBlockTimer:Sprite;
    private var _activeOrderItem:WOOrderItem;
    private var _txtTimer:CTextField;
    private var _waitForAnswer:Boolean;
    private var _btnSkipDelete:CButton;
    private var _armatureCustomer:Armature;
    private var _armatureSeller:Armature;
    private var _imCoup:Image;
    private var _txtCoupone:CTextField;
    private var _bubble:TutorialTextBubble;
    private var _birka:Birka;
    private var _txtOrder:CTextField;
    private var _arrowBtnCell:SimpleArrow;
    private var _rightBlockBG:CartonBackground;
    private var _rightBlockTimerBG:CartonBackground;
    private var _starSmall:Image;
    private var _coinSmall:Image;

    public function WOOrder() {
        super();
        _windowType = WindowsManager.WO_ORDERS;
        _woWidth = 764;
        _woHeight = 570;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;

        createRightBlock();
        createRightBlockTimer();
        createItems();
        createButtonSell();
        createButtonSkipDelete();
        _arrOrders = g.managerOrder.arrOrders.slice();
        createTopCats();
        _waitForAnswer = false;
        _rightBlock.visible = false;
        _birka = new Birka('ЛАВКА', _source, 764, 570);
    }

    override public function showItParams(callback:Function, params:Array):void {
        _arrOrders = g.managerOrder.arrOrders.slice();
        fillList();
        var num:int;
        var delay:int;
        for (var i:int = 0; i < _arrOrders.length; i++) {
            delay = 0;
            num = 0;
            for (var k:int = 0; k<_arrOrders[i].resourceIds.length; k++) {
                if (g.userInventory.getCountResourceById(_arrOrders[i].resourceIds[k]) >= _arrOrders[i].resourceCounts[k]) {
                   num++;
                }
            }
            if (num == _arrOrders[i].resourceIds.length) {
                break;
            } else {
                delay++;
            }
        }
        if (delay > 0) i = 0;
        onItemClick(_arrItems[i],false,-1,true);
        _waitForAnswer = false;
        changeCatTexture(i);
        startAnimationCats();
        if (g.user.level == 4 && !g.managerTutorial.isTutorial) {
            if (g.managerOrder.checkIsAnyFullOrder()) showBtnSellArrow();
        }
        super.showIt();
    }

    private function onClickExit(e:Event=null):void {
        if (g.managerTutorial.isTutorial) return;
        hideIt();
    }

    private function createRightBlock():void {
        _rightBlock = new Sprite();
        _rightBlock.x = -382;
        _rightBlock.y = -285;
        _source.addChild(_rightBlock);
        _rightBlockBG = new CartonBackground(317, 278);
        _rightBlockBG.x = 407;
        _rightBlockBG.y = 178;
        _rightBlockBG.filter = ManagerFilters.SHADOW_LIGHT;
        _rightBlock.addChild(_rightBlockBG);

        _txtName = new CTextField(320, 35, "Самбука заказывает");
        _txtName.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.TEXT_BROWN_COLOR);
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

        var txt:CTextField = new CTextField(90, 30, "Награда:");
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.TEXT_BROWN_COLOR);
        txt.x = 411;
        txt.y = 418;
        _rightBlock.addChild(txt);
        _starSmall = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star_small'));
        _starSmall.x = 501;
        _starSmall.y = 417;
        _starSmall.filter = ManagerFilters.SHADOW_TINY;
        _rightBlock.addChild(_starSmall);
        _txtXP = new CTextField(52, 30, "8888");
        _txtXP.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.TEXT_BLUE_COLOR);
        _txtXP.x = 523;
        _txtXP.y = 418;
        _rightBlock.addChild(_txtXP);
        _coinSmall = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_small'));
        _coinSmall.x = 570;
        _coinSmall.y = 419;
        _coinSmall.filter = ManagerFilters.SHADOW_TINY;
        _rightBlock.addChild(_coinSmall);
        _imCoup = new Image(g.allData.atlas['interfaceAtlas'].getTexture('a_tr_cup_ico'));
        _imCoup.x = 640;
        _imCoup.y = 422;
        _imCoup.visible = false;
        _rightBlock.addChild(_imCoup);
        _txtCoupone = new CTextField(30, 30, "1");
        _txtCoupone.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.TEXT_BLUE_COLOR);
        _txtCoupone.x = 650;
        _txtCoupone.y = 418;
        _txtCoupone.visible = false;
        _rightBlock.addChild(_txtCoupone);
        _txtCoins = new CTextField(52, 30, "8888");
        _txtCoins.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.TEXT_BLUE_COLOR);
        _txtCoins.x = 590;
        _txtCoins.y = 418;
        _rightBlock.addChild(_txtCoins);
        _btnDeleteOrder = new CButton();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_decline'));
        _btnDeleteOrder.addDisplayObject(im);
        _btnDeleteOrder.x = 670;
        _btnDeleteOrder.y = 414;
        _rightBlock.addChild(_btnDeleteOrder);
        _btnDeleteOrder.clickCallback = deleteOrder;

        _btnDeleteOrder.hoverCallback = function():void { g.hint.showIt('отменить заказ'); };
        _btnDeleteOrder.outCallback = function():void {g.hint.hideIt();};
    }

    private function createItems():void {
        var item:WOOrderItem;
        _arrItems = [];
        for (var i:int=0; i<9; i++) {
            item = new WOOrderItem(this);
            item.source.x = -330 + 40 + (i%3)*120;
            item.source.y = -246 + 185 + int(i/3)*94;
            _source.addChild(item.source);
            _arrItems.push(item);
        }
    }

    private function createButtonSell():void {
        _btnSell = new CButton();
        _btnSell.addButtonTexture(120, 40, CButton.GREEN, true);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_left'));
        MCScaler.scale(im, 66, 66);
        im.x = 98;
        im.y = -15;
        _btnSell.addDisplayObject(im);
        var txt:CTextField = new CTextField(110, 60, "Продать");
        txt.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.TEXT_GREEN_COLOR);
        txt.y = -10;
        _btnSell.addChild(txt);
        _btnSell.x = 547;
        _btnSell.y = 500;
        _rightBlock.addChild(_btnSell);
        _btnSell.clickCallback = sellOrder;
    }

    private function createButtonSkipDelete():void {
        _btnSkipDelete = new CButton();
        _btnSkipDelete.addButtonTexture(120, 50, CButton.GREEN, true);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
        MCScaler.scale(im, 20, 20);
        im.x = 98;
        im.y = 15;
        _btnSkipDelete.addDisplayObject(im);
        var txt:CTextField = new CTextField(80, 50, "Получить сейчас");
        txt.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.TEXT_GREEN_COLOR);
        _btnSkipDelete.addChild(txt);
        txt = new CTextField(20, 50, '');
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.TEXT_GREEN_COLOR);
        if (g.user.level <= 6) txt.text = String(ManagerOrder.COST_FIRST_SKIP_WAIT);
        else if (g.user.level <= 9) txt.text = String(ManagerOrder.COST_SECOND_SKIP_WAIT);
        else if (g.user.level <= 15) txt.text = String(ManagerOrder.COST_THIRD_SKIP_WAIT);
        else if (g.user.level <= 19) txt.text = String(ManagerOrder.COST_FOURTH_SKIP_WAIT);
        else if (g.user.level >= 20) txt.text = String(ManagerOrder.COST_FIFTH_SKIP_WAIT);
        txt.x = 80;
        _btnSkipDelete.addChild(txt);
        _btnSkipDelete.x = 160;
        _btnSkipDelete.y = 220;
        _rightBlockTimer.addChild(_btnSkipDelete);
        _btnSkipDelete.clickCallback = skipDelete;
    }

    private function sellOrder(b:Boolean = false, _order:ManagerOrderItem = null):void {
        if (_waitForAnswer) return;
        if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction != TutorialAction.ORDER) return;
        var i:int;
        if (!b) {
            for (i = 0; i < _activeOrderItem.getOrder().resourceIds.length; i++) {
                if (!_arrResourceItems[i].isChecked()) {
                    g.windowsManager.cashWindow = this;
                    super.hideIt();
//                    g.woNoResources.showItOrder(_activeOrderItem.getOrder(), sellOrder);
                    g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, sellOrder, 'order', _activeOrderItem.getOrder());
                    return;
                }
            }
            for (i = 0; i < _activeOrderItem.getOrder().resourceIds.length; i++) {
                if (_activeOrderItem.getOrder().resourceCounts[i] == g.userInventory.getCountResourceById(_activeOrderItem.getOrder().resourceIds[i])
                        && g.dataResource.objectResources[_activeOrderItem.getOrder().resourceIds[i]].buildType == BuildType.PLANT && !g.userInventory.checkLastResource(_activeOrderItem.getOrder().resourceIds[i])) {
                    g.windowsManager.cashWindow = this;
                    super.hideIt();
                    g.windowsManager.openWindow(WindowsManager.WO_LAST_RESOURCE, sellOrder, _activeOrderItem.getOrder(), 'order');
                    return;
                }
            }
        } else {
            if (!_isShowed) super.showIt();
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
            p.x = _btnSell.x + _btnSell.width * 4 / 5;
            p.y = _btnSell.y + _btnSell.height / 2;
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
        animateCatsOnSell();
        g.managerOrder.cancelAnimateSmallHero();
        g.soundManager.playSound(SoundConst.ORDER_DONE);
        if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction == TutorialAction.ORDER) {
            g.managerTutorial.checkTutorialCallback();
        }

    }

    private function afterSell(order:ManagerOrderItem, orderItem:WOOrderItem):void {
        _waitForAnswer = false;
        var k:int;
        if (_isShowed) {
            var b:Boolean = true;
            for (k=0; k<order.resourceIds.length; k++) {
                if (g.userInventory.getCountResourceById(order.resourceIds[k]) < order.resourceCounts[k]) {
                    b = false;
                    break;
                }
            }
            order.startTime = int(new Date().getTime()/1000) + 6;
            orderItem.fillIt(order, order.placeNumber, onItemClick, b);
            _arrOrders[order.placeNumber] = order;
            if (_activeOrderItem == orderItem) {
                onItemClick(_activeOrderItem, true);
            }
        }
        var i:int;
        for (k = 0; k < _arrItems.length; k++) {
            if (_arrOrders[k]) {
                for (i = 0; i < _arrOrders[k].resourceIds.length; i++) {
                    if (g.userInventory.getCountResourceById(_arrOrders[k].resourceIds[i]) < _arrOrders[k].resourceCounts[i]) {
                        _arrItems[k].updateCheck(false);
                        break;
                    }
                }
            } else break;
        }
//        g.bottomPanel.checkIsFullOrder();
//        newPlaceNumber();
    }

    private function fillList():void {
        var maxCount:int = g.managerOrder.maxCountOrders;
        var b:Boolean;
        var order:ManagerOrderItem;
        var k:int;
        var delay:Number = .1;
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
                _arrItems[i].fillIt(order, order.placeNumber, onItemClick, b,order.cat);
//                _arrItems[i].animation(delay);
//                delay += .1;
            } else {
                Cc.error('WOOrder fillList:: order.place == -1');
            }
        }
    }

    private function onItemClick(item:WOOrderItem, isAfterSell:Boolean = false, recheck:int = -1, open:Boolean = false):void {
        if (_waitForAnswer) return;
        if (_activeOrderItem) _activeOrderItem.activateIt(false);
        if (recheck > -1 && _activeOrderItem != item) return;
        clearResourceItems();

        _activeOrderItem = item;
        fillResourceItems(_activeOrderItem.getOrder());
        _activeOrderItem.activateIt(true);
        if (_activeOrderItem.leftSeconds <= 0 && !isAfterSell) {
            stopCatsAnimations();
            changeCatTexture(_activeOrderItem.position);
            animateCustomerCat();
            animateSellerCat();
            helloStart();
        }

        if (_activeOrderItem.leftSeconds > 0) {
            _rightBlock.visible = false;
            _rightBlockTimer.visible = true;
            _btnSkipDelete.visible = true;
            if (_activeOrderItem.leftSeconds <= 15) _btnSkipDelete.visible = false;
            if (!item.getOrder().delOb) {
                if (open) {
                    stopCatsAnimations();
                    emptyCarCustomer();
                }
                _txtOrder.text = 'ЗАКАЗ ОФОРМЛЕН';
                _btnSkipDelete.visible = false;
            } else {
                stopCatsAnimations();
            if (!g.managerTutorial.isTutorial) emptyCarCustomer();
                _txtOrder.text = 'ЗАКАЗ УДАЛЕН';
            }

            g.gameDispatcher.addToTimer(onTimer);
            setTimerText = _activeOrderItem.leftSeconds;
//
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
        _txtName.text = order.catOb.name + ' заказывает';
        _txtXP.text = String(_activeOrderItem.getOrder().xp);
        _txtCoins.text = String(_activeOrderItem.getOrder().coins);
        for (var i:int=0; i<_activeOrderItem.getOrder().resourceIds.length; i++) {
            _arrResourceItems[i].fillIt(_activeOrderItem.getOrder().resourceIds[i], _activeOrderItem.getOrder().resourceCounts[i]);
        }
    }

    private function deleteOrder():void {
        if (g.managerTutorial.isTutorial || g.managerCutScenes.isCutScene) return;
        if (_activeOrderItem) {
            g.hint.hideIt();
            _rightBlock.visible = false;
            _rightBlockTimer.visible = true;
//            g.userTimer.setOrder(_activeOrderItem.getOrder());
            if (g.user.level <= 6) setTimerText = ManagerOrder.TIME_FIRST_DELAY;
            else if (g.user.level <= 9) setTimerText = ManagerOrder.TIME_SECOND_DELAY;
            else if (g.user.level <= 15) setTimerText = ManagerOrder.TIME_THIRD_DELAY;
            else if (g.user.level <= 19) setTimerText = ManagerOrder.TIME_FOURTH_DELAY;
            else if (g.user.level >= 20) setTimerText = ManagerOrder.TIME_FIFTH_DELAY;
            _waitForAnswer = true;
            _arrOrders[_activeOrderItem.position] = null;
            var tOrderItem:WOOrderItem = _activeOrderItem;
            var f:Function = function (order:ManagerOrderItem):void {
                afterDeleteOrder(order, tOrderItem);
//                newPlaceNumber();
            };
            g.managerOrder.deleteOrder(_activeOrderItem.getOrder(), f);
        }
    }

    private function newPlaceNumber():void {
        _arrOrders = [];
        _arrOrders = g.managerOrder.arrOrders.slice();
        var delay:Number = .1;
        for (var i:int = 0; i < _arrOrders.length; i++) {
            _arrItems[i].animationHide(delay);
            delay += .1;
        }
        var order:ManagerOrderItem;
        var k:int;
        var b:Boolean;
        delay = .1;
        for (i = 0; i < _arrOrders.length; i++) {
            b = true;
            order = _arrOrders[i];
            for (k=0; k<order.resourceIds.length; k++) {
                if (g.userInventory.getCountResourceById(order.resourceIds[k]) < order.resourceCounts[k]) {
                    b = false;
                    break;
                }
            }
            if (order.placeNumber > -1) {
                _arrItems[i].fillIt(order, order.placeNumber, onItemClick, b,order.cat,true);
//                _arrItems[i].animation(delay);
                delay += .1;

            }
        }
        onItemClick(_arrItems[0]);
    }

    private function afterDeleteOrder(order:ManagerOrderItem, orderItem:WOOrderItem):void {
        if (_isShowed) {
            if (g.user.level <= 6) {
                order.startTime += ManagerOrder.TIME_FIRST_DELAY;
                _waitForAnswer = false;
                setTimerText = ManagerOrder.TIME_FIRST_DELAY;
            }
            else if (g.user.level <= 9) {
                order.startTime += ManagerOrder.TIME_SECOND_DELAY;
                _waitForAnswer = false;
                setTimerText = ManagerOrder.TIME_SECOND_DELAY;
            }
            else if (g.user.level <= 15) {
                order.startTime += ManagerOrder.TIME_THIRD_DELAY;
                _waitForAnswer = false;
                setTimerText = ManagerOrder.TIME_THIRD_DELAY;
            }
            else if (g.user.level <= 19) {
                order.startTime += ManagerOrder.TIME_FOURTH_DELAY;
                _waitForAnswer = false;
                setTimerText = ManagerOrder.TIME_FOURTH_DELAY;
            }
            else if (g.user.level >= 20) {
                order.startTime += ManagerOrder.TIME_FIFTH_DELAY;
                _waitForAnswer = false;
                setTimerText = ManagerOrder.TIME_FIFTH_DELAY;
            }
//            order.startTime += ManagerOrder.TIME_DELAY;
//            _waitForAnswer = false;
//            setTimerText = ManagerOrder.TIME_DELAY;
            var b:Boolean = true;
            for (var k:int=0; k<order.resourceIds.length; k++) {
                if (g.userInventory.getCountResourceById(order.resourceIds[k]) < order.resourceCounts[k]) {
                    b = false;
                    break;
                }
            }
            orderItem.fillIt(order, order.placeNumber, onItemClick);
            _arrOrders[order.placeNumber] = order;
            if (_activeOrderItem == orderItem) {
                onItemClick(_activeOrderItem);
            }
            g.gameDispatcher.addToTimer(onTimer);
        }
    }

    private function skipDelete():void {
        if (g.managerTutorial.isTutorial || g.managerCutScenes.isCutScene) return;
        var n:int;
        if (g.user.level <= 6) n = ManagerOrder.COST_FIRST_SKIP_WAIT;
        else if (g.user.level <= 9) n = ManagerOrder.COST_SECOND_SKIP_WAIT;
        else if (g.user.level <= 15) n = ManagerOrder.COST_THIRD_SKIP_WAIT;
        else if (g.user.level <= 19) n = ManagerOrder.COST_FOURTH_SKIP_WAIT;
        else if (g.user.level >= 20) n = ManagerOrder.COST_FIFTH_SKIP_WAIT;
        if (g.user.hardCurrency < n) {
            isCashed = false;
            super.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        _activeOrderItem.onSkipTimer();
        g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -n);
        _btnSkipDelete.visible = false;

    }

    private function createRightBlockTimer():void {
        _rightBlockTimer = new Sprite();
        _rightBlockTimer.x = -382 + 407;
        _rightBlockTimer.y = -285 + 178;
        _source.addChild(_rightBlockTimer);
        _rightBlockTimerBG = new CartonBackground(317, 278);
        _rightBlockTimerBG.filter = ManagerFilters.SHADOW_LIGHT;
        _rightBlockTimer.addChild(_rightBlockTimerBG);
        var bgIn:CartonBackgroundIn = new CartonBackgroundIn(280, 150);
        bgIn.x = 14;
        bgIn.y = 32;
        _rightBlockTimer.addChild(bgIn);

        _txtOrder = new CTextField(280, 30, "");
        _txtOrder.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.TEXT_BROWN_COLOR);
        _txtOrder.x = 14;
        _txtOrder.y = 40;
        _rightBlockTimer.addChild(_txtOrder);

        var t:CTextField = new CTextField(280, 30, "следующий поступит через:");
        t.setFormat(CTextField.MEDIUM18, 16, Color.WHITE, ManagerFilters.TEXT_BROWN_COLOR);
        t.x = 14;
        t.y = 65;
        _rightBlockTimer.addChild(t);

        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_del_clock'));
        im.x = 65;
        im.y = 110;
        _rightBlockTimer.addChild(im);

        _txtTimer = new CTextField(165, 50, "");
        _txtTimer.setFormat(CTextField.BOLD30, 30, ManagerFilters.TEXT_BROWN_COLOR);
        _txtTimer.x = 101;
        _txtTimer.y = 102;
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
            helloStart();
        }
    }

    public function timerSkip(order:ManagerOrderItem):void {
        var pl:int = order.placeNumber;
        for (var i:int = 0; i<_arrOrders.length; i++) {
            if (_arrOrders[i].placeNumber == pl &&  _arrOrders[i].delOb) {
                _arrOrders[i].delOb = false;
                _arrOrders[i].cat = g.managerOrderCats.getNewCatForOrder(null,_arrOrders[i].catOb);
                break;
            }
        }
    }

    private function set setTimerText(c:int):void {
        _txtTimer.text = TimeUtils.convertSecondsForOrders(c);
    }

    public function getSellBtnProperties():Object {
        var ob:Object = {};
        var p:Point = new Point(0, 0);
        p = _btnSell.localToGlobal(p);
        ob.x = p.x;
        ob.y = p.y;
        ob.width = _btnSell.width;
        ob.height = _btnSell.height;
        return ob;
    }

    override protected function deleteIt():void {
        if (!_source) return;
        _starSmall.filter = null;
        _coinSmall.filter = null;
        deleteBtnCellArrow();
        deleteCats();
        _activeOrderItem = null;
        g.gameDispatcher.removeFromTimer(onTimer);
        for (var i:int = 0; i < _arrItems.length; i++) {
            _source.removeChild(_arrItems[i].source);
            _arrItems[i].deleteIt();
        }
        _arrItems.length = 0;
        for (i=0; i<_arrResourceItems.length; i++) {
            _source.removeChild(_arrResourceItems[i].source);
            _arrResourceItems[i].deleteIt();
        }
        if (_rightBlockTimerBG) {
            _rightBlockTimer.removeChild(_rightBlockTimerBG);
            _rightBlockTimerBG.filter = null;
            _rightBlockTimerBG.deleteIt();
            _rightBlockTimerBG = null;
        }
        _arrResourceItems.length = 0;
        _txtName = null;
        _txtXP = null;
        if (_woBG) {
            _source.removeChild(_woBG);
            _woBG.deleteIt();
            _woBG = null;
        }
        if (_birka) {
            _source.removeChild(_birka);
            _birka.deleteIt();
            _birka = null;
        }
        if (_rightBlockBG) {
            _rightBlock.removeChild(_rightBlockBG);
            _rightBlockBG.filter = null;
            _rightBlockBG.deleteIt();
            _rightBlockBG = null;
        }
        if (_btnDeleteOrder) {
            _rightBlock.removeChild(_btnDeleteOrder);
            _btnDeleteOrder.deleteIt();
            _btnDeleteOrder = null;
        }
        if (_btnSell) {
            _rightBlock.removeChild(_btnSell);
            _btnSell.deleteIt();
            _btnSell = null;
        }
        if (_bubble) {
            _bubble.deleteIt();
            _bubble = null;
        }
        super.deleteIt();
    }

    public function showBtnSellArrow():void {
        _arrowBtnCell = new SimpleArrow(SimpleArrow.POSITION_LEFT, _rightBlock);
        _arrowBtnCell.animateAtPosition(_btnSell.x - 55, _btnSell.y);
        _arrowBtnCell.activateTimer(3, deleteBtnCellArrow);
    }
    
    private function deleteBtnCellArrow():void {
        if (_arrowBtnCell) {
            _arrowBtnCell.deleteIt();
            _arrowBtnCell = null;
        }
    }


    // ------------------ ANIMATIONS ---------------------

    private function createTopCats():void {
        _armatureCustomer = g.allData.factory['order_window'].buildArmature("cat_customer");
        _armatureSeller = g.allData.factory['order_window'].buildArmature("cat_seller");
        (_armatureCustomer.display as StarlingArmatureDisplay).x = 110;
        (_armatureCustomer.display as StarlingArmatureDisplay).y = -170;
        (_armatureSeller.display as StarlingArmatureDisplay).x = -110;
        (_armatureSeller.display as StarlingArmatureDisplay).y = -170;
        _source.addChild(_armatureCustomer.display as StarlingArmatureDisplay);
        _source.addChild(_armatureSeller.display as StarlingArmatureDisplay);
        var viyi:Slot = _armatureSeller.getSlot('viyi');
        if (viyi && viyi.display) {
            viyi.display.visible = false;
        }
        var bant:Slot = _armatureCustomer.getSlot('bant');
        if (bant && bant.display) bant.display.visible = false;

    }

    private function changeCatTexture(pos:int):void {
        if (g.managerTutorial.isTutorial) {
            if (g.managerTutorial.currentAction != TutorialAction.ORDER) return;
        }
        var st:String;
        if (!_arrOrders[pos] || !_arrOrders[pos].cat) return;
        switch (_arrOrders[pos].catOb.color){
            case OrderCat.BLACK:  st = '5'; break;
            case OrderCat.BLUE:   st = '4'; break;
            case OrderCat.GREEN:  st = '3'; break;
            case OrderCat.BROWN:  st = 'br'; break;
            case OrderCat.ORANGE: st = '1'; break;
            case OrderCat.PINK:   st = '2'; break;
            case OrderCat.WHITE:  st = '6'; break;
        }

        releaseFrontTexture(st);
        var b:Slot = _armatureCustomer.getSlot('bant');
        var viyi:Slot= _armatureCustomer.getSlot('viyi');
        if (!_arrOrders[pos].catOb.isWoman) {
            if (b.displayList.length) b.displayList[0].visible = false;
            if (viyi.displayList.length) viyi.displayList[0].visible = false;
        } else {
            changeBant(_arrOrders[pos].cat.bant, b);
            if (viyi.displayList.length) viyi.displayList[0].visible = true;
        }
        var okuli:Image;
        b = _armatureCustomer.getSlot('okuli') as Slot;
        if (b && b.displayList.length) {
            okuli = b.displayList[0] as Image;
        }
        var sharf:Image;
        b = _armatureCustomer.getSlot('sharf') as Slot;
        if (b && b.displayList.length) {
            sharf = b.displayList[0] as Image;
        }
        if (okuli) okuli.visible = false;
        if (sharf) sharf.visible = false;
        switch (_arrOrders[pos].catOb.type) {
            case DataCat.AKRIL:
                if (okuli) okuli.visible = false;
                if (sharf) sharf.visible = true;
                break;
            case DataCat.ASHUR:
                if (okuli) okuli.visible = false;
                if (sharf) sharf.visible = false;
                break;
            case DataCat.BULAVKA:
                if (okuli) okuli.visible = false;
                if (sharf) sharf.visible = false;
                break;
            case DataCat.BUSINKA:
                if (okuli) okuli.visible = false;
                if (sharf) sharf.visible = true;
                break;
            case DataCat.IGOLOCHKA:
                if (okuli) okuli.visible = false;
                if (sharf) sharf.visible = false;
                break;
            case DataCat.IRIS:
                if (okuli) okuli.visible = false;
                if (sharf) sharf.visible = false;
                break;
            case DataCat.KRUCHOK:
                if (okuli) okuli.visible = false;
                if (sharf) sharf.visible = true;
                break;
            case DataCat.LENTOCHKA:
                if (okuli) okuli.visible = false;
                if (sharf) sharf.visible = false;
                break;
            case DataCat.NAPERSTOK:
                if (okuli) okuli.visible = false;
                if (sharf) sharf.visible = false;
                break;
            case DataCat.PETELKA:
                if (okuli) okuli.visible = false;
                if (sharf) sharf.visible = false;
                break;
            case DataCat.PRYAGA:
                if (okuli) okuli.visible = false;
                if (sharf) sharf.visible = false;
                break;
            case DataCat.SINTETIKA:
                if (okuli) okuli.visible = true;
                if (sharf) sharf.visible = false;
                break;
            case DataCat.STESHOK:
                if (okuli) okuli.visible = false;
                if (sharf) sharf.visible = false;
                break;
            case DataCat.YZELOK:
                if (okuli) okuli.visible = false;
                if (sharf) sharf.visible = true;
                break;
        }
        b = _armatureCustomer.getSlot('sharf');
        if (_arrOrders[pos].catOb.png) {
//            var im:Image = (g.allData.factory['order_window'] as StarlingFactory).getTextureDisplay(_arrOrders[pos].catOb.png, "clothTextureTemp") as Image;
            var im:Image = new Image(g.allData.atlas['customisationInterfaceAtlas'].getTexture(_arrOrders[pos].catOb.png));
            var sp:Sprite = new Sprite();
            if (b.displayList.length) {
                var imOld:Image;
                if (b.displayList[0]) {
                    if (b.displayList[0] is Sprite) {
                        imOld = b.displayList[0].getChildAt(0) as Image;
                    } else {
                        imOld = b.displayList[0] as Image;
                    }
                    if (imOld) {
                        im.x = imOld.x + imOld.width/2 - im.width/2;
                    }
                }
            }
            sp.addChild(im);
            b.displayList = null;
            b.display = sp;
        } else {
            (b.displayList[0] as DisplayObject).visible = false;
        }
    }

    private function changeBant(n:int, b:Slot):void {
//        var im:Image = g.allData.factory['order_window'].getTextureDisplay('bants/' + str) as Image;
        var im:Image = new Image(g.allData.atlas['customisationInterfaceAtlas'].getTexture('bant_'+ String(n)));
        var sp:Sprite = new Sprite();
        if (b) {
            if (im) {
                if (b.displayList.length) {
                    var imOld:DisplayObject = b.displayList[0] as DisplayObject;
                    if (imOld) {
                        im.x = imOld.x + imOld.width/2 - im.width/2;
                    }
                }
                sp.addChild(im);
                b.displayList = null;
                b.display = sp;
            } else {
                Cc.error('WOOrder changeBant:: no bant image for: ' + n);
            }
        } else {
            Cc.error('WOOrder changeBant:: no bant bone');
        }
    }

    private function releaseFrontTexture(st:String):void {
        changeTexture("head", st + "_head_f", _armatureCustomer);
        changeTexture("body", st + "_body_f", _armatureCustomer);
        changeTexture("handLeft", st + "_lhand_f", _armatureCustomer);
        changeTexture("handRight", st + "_rhand_f", _armatureCustomer);
        changeTexture('handLeft copy', st + '_rhand_f', _armatureCustomer);
    }

    private function changeTexture(oldName:String, newName:String, arma:Armature):void {
//        var im:Image = g.allData.factory['order_window'].getTextureDisplay(newName, "clothTextureTemp") as Image;
        var im:Image = new Image(g.allData.atlas['customisationInterfaceAtlas'].getTexture(newName));
        var b:Slot = arma.getSlot(oldName);
        if (b) {
            if (im) {
                b.displayList = null;
                b.display = im;
            } else {
                Cc.error('WOOrder changeTexture:: no such image - ' + newName);
            }
        } else {
            Cc.error('WOOrder changeTexture:: no such slot - ' + oldName);
        }
    }
    private function startAnimationCats():void {
        WorldClock.clock.add(_armatureCustomer);
        WorldClock.clock.add(_armatureSeller);
//        animateCustomerCat();
//        animateSellerCat();
    }

    private function animateCustomerCat(e:Event=null):void {
        if (_armatureCustomer.hasEventListener(EventObject.COMPLETE)) _armatureCustomer.removeEventListener(EventObject.COMPLETE, animateCustomerCat);
        if (_armatureCustomer.hasEventListener(EventObject.LOOP_COMPLETE)) _armatureCustomer.removeEventListener(EventObject.LOOP_COMPLETE, animateCustomerCat);

        _armatureCustomer.addEventListener(EventObject.COMPLETE, animateCustomerCat);
        _armatureCustomer.addEventListener(EventObject.LOOP_COMPLETE, animateCustomerCat);
        var l:int = int(Math.random()*6);
        switch (l) {
            case 0: _armatureCustomer.animation.gotoAndPlayByFrame('idle1'); break;
            case 1: _armatureCustomer.animation.gotoAndPlayByFrame('idle_4'); break;
            case 2: _armatureCustomer.animation.gotoAndPlayByFrame('speak'); break;
            case 3: _armatureCustomer.animation.gotoAndPlayByFrame('idle_3'); break;
            case 4: _armatureCustomer.animation.gotoAndPlayByFrame('idle_2'); break;
            case 5: _armatureCustomer.animation.gotoAndPlayByFrame('speak_2'); break;
        }
    }

    private function animateSellerCat(e:Event=null):void {
        if (_armatureSeller.hasEventListener(EventObject.COMPLETE)) _armatureSeller.removeEventListener(EventObject.COMPLETE, animateSellerCat);
        if (_armatureSeller.hasEventListener(EventObject.LOOP_COMPLETE)) _armatureSeller.removeEventListener(EventObject.LOOP_COMPLETE, animateSellerCat);

        _armatureSeller.addEventListener(EventObject.COMPLETE, animateSellerCat);
        _armatureSeller.addEventListener(EventObject.LOOP_COMPLETE, animateSellerCat);
        var l:int = int(Math.random()*6);
        switch (l) {
            case 0: _armatureSeller.animation.gotoAndPlayByFrame('idle1'); break;
            case 1: _armatureSeller.animation.gotoAndPlayByFrame('speak_5'); break;
            case 2: _armatureSeller.animation.gotoAndPlayByFrame('speak_4'); break;
            case 3: _armatureSeller.animation.gotoAndPlayByFrame('speak'); break;
            case 4: _armatureSeller.animation.gotoAndPlayByFrame('speak_3'); break;
            case 5: _armatureSeller.animation.gotoAndPlayByFrame('speak_2'); break;
        }
    }

    private function killCatsAnimations():void {
        if (!_armatureCustomer) {
            return;
        }
        if (!_armatureSeller) {
            return;
        }
        stopCatsAnimations();
        WorldClock.clock.remove(_armatureCustomer);
        WorldClock.clock.remove(_armatureSeller);
    }

    private function stopCatsAnimations():void {
        if (!_armatureCustomer || !_armatureSeller) {
            return;
        }
        _armatureCustomer.animation.gotoAndStopByFrame('idle1');
        _armatureSeller.animation.gotoAndStopByFrame('idle1');
        if (_armatureSeller.hasEventListener(EventObject.COMPLETE)) _armatureSeller.removeEventListener(EventObject.COMPLETE, animateSellerCat);
        if (_armatureSeller.hasEventListener(EventObject.LOOP_COMPLETE)) _armatureSeller.removeEventListener(EventObject.LOOP_COMPLETE, animateSellerCat);
        if (_armatureCustomer.hasEventListener(EventObject.COMPLETE)) _armatureCustomer.removeEventListener(EventObject.COMPLETE, animateCustomerCat);
        if (_armatureCustomer.hasEventListener(EventObject.LOOP_COMPLETE)) _armatureCustomer.removeEventListener(EventObject.LOOP_COMPLETE, animateCustomerCat);
    }

    private function animateCatsOnSell():void {
        stopCatsAnimations();
        if (_armatureSeller) {
            _armatureSeller.addEventListener(EventObject.COMPLETE, animateSellerOnSell);
            _armatureSeller.addEventListener(EventObject.LOOP_COMPLETE, animateSellerOnSell);
            _armatureSeller.animation.gotoAndPlayByFrame('coin');
        }
        if (_armatureCustomer) {
            _armatureCustomer.addEventListener(EventObject.COMPLETE, animateCustomerOnSell);
            _armatureCustomer.addEventListener(EventObject.LOOP_COMPLETE, animateCustomerOnSell);
            _armatureCustomer.animation.gotoAndPlayByFrame('love');
        }
    }

    private function animateSellerOnSell(e:Event=null):void {
        _armatureSeller.removeEventListener(EventObject.COMPLETE, animateSellerOnSell);
        _armatureSeller.removeEventListener(EventObject.LOOP_COMPLETE, animateSellerOnSell);
        animateSellerCat();
    }

    private function animateCustomerOnSell(e:Event=null):void {
        _armatureCustomer.removeEventListener(EventObject.COMPLETE, animateCustomerOnSell);
        _armatureCustomer.removeEventListener(EventObject.LOOP_COMPLETE, animateCustomerOnSell);

        emptyCarCustomer();
//      changeCatTexture(_activeOrderItem.position);
//      animateCustomerCat();

        if (g.user.wallOrderItem && g.user.level >= 10) {
            hideIt();
            g.windowsManager.openWindow(WindowsManager.POST_DONE_ORDER);
            g.directServer.updateWallOrderItem(null);
            g.user.wallOrderItem = false;
        }

    }

    public function setTextForCustomer(st:String):void {
        if (_bubble) {
            _bubble.deleteIt();
        }

        if (st != '') {
            _bubble = new TutorialTextBubble(_source);
            _bubble.showBubble(st, true, TutorialTextBubble.SMALL);
            _bubble.setXY(120, -150);
        }
    }

    private function deleteCats():void {
        killCatsAnimations();
        if (!_armatureCustomer) return;
        _source.removeChild(_armatureCustomer.display as Sprite);
        _source.removeChild(_armatureSeller.display as Sprite);
        _armatureCustomer.dispose();
        _armatureCustomer = null;
        _armatureSeller.dispose();
        _armatureSeller = null;
    }

    private function helloStart():void {
        _armatureSeller.addEventListener(EventObject.COMPLETE, animateSellerCat);
        _armatureSeller.addEventListener(EventObject.LOOP_COMPLETE, animateSellerCat);
        var l:int = int(Math.random()*2);
        switch (l) {
            case 0: _armatureSeller.animation.gotoAndPlayByFrame('hi'); break;
            case 1: _armatureSeller.animation.gotoAndPlayByFrame('hi2'); break;
        }
        _armatureCustomer.addEventListener(EventObject.COMPLETE, animateCustomerCat);
        _armatureCustomer.addEventListener(EventObject.LOOP_COMPLETE, animateCustomerCat);
         l = int(Math.random()*2);
        switch (l) {
            case 0: _armatureCustomer.animation.gotoAndPlayByFrame('hi'); break;
            case 1: _armatureCustomer.animation.gotoAndPlayByFrame('hi2'); break;
        }
    }

    private function emptyCarCustomer():void {
        _armatureCustomer.animation.gotoAndPlayByFrame('empty');
    }
}
}