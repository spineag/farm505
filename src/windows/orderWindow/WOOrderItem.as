/**
 * Created by user on 7/22/15.
 */
package windows.orderWindow {

import com.greensock.TweenMax;

import manager.ManagerFilters;
import manager.ManagerOrder;
import manager.ManagerOrderItem;
import manager.Vars;

import starling.animation.Tween;

import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;
import windows.WOComponents.CartonBackground;
import windows.WOComponents.CartonBackgroundIn;

public class WOOrderItem {
    public var source:CSprite;
    private var _bgCarton:CartonBackground;
    private var _bgCartonIn:CartonBackgroundIn;
    private var _txtName:TextField;
    private var _txtXP:TextField;
    private var _txtCoins:TextField;
    private var _order:ManagerOrderItem;
    private var _leftSeconds:int;
    private var _starImage:Image;
    private var _coinsImage:Image;
    private var _clockImage:Image;
    private var _delImage:Image;
    private var _position:int;
    private var _check:Image;
    private var _clickCallback:Function;
    private var _act:Boolean;
    private var _wo:WOOrder;
    private var _deleteOrSell:Boolean;
    private var _recheck:Boolean;

    private var g:Vars = Vars.getInstance();

    public function WOOrderItem(wo:WOOrder) {
        _wo = wo;
        source = new CSprite();
        _bgCarton = new CartonBackground(112, 90);
        _bgCarton.filter = ManagerFilters.SHADOW_LIGHT;
        source.addChild(_bgCarton);
        source.pivotX = source.width/2;
        source.pivotY = source.height/2;
        _bgCartonIn = new CartonBackgroundIn(102, 64);
        _bgCartonIn.x = 5;
        _bgCartonIn.y = 21;
        source.addChild(_bgCartonIn);
        _bgCarton.touchable = true;

        _clockImage = new Image(g.allData.atlas['interfaceAtlas'].getTexture('wait'));
        _clockImage.x = 20;
        _clockImage.y = 5;
        _clockImage.visible = false;
        source.addChild(_clockImage);

        _delImage = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_del_or'));
        _delImage.x = 25;
        _delImage.y = 10;
        source.addChild(_delImage);

        _txtName = new TextField(112, 20, "Васько", g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        _txtName.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        source.addChild(_txtName);

        _starImage = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star_small'));
        _starImage.x = 17;
        _starImage.y = 24;
//        MCScaler.scale(_starImage, 31, 31);
        _starImage.filter = ManagerFilters.SHADOW_TINY;
        source.addChild(_starImage);
        _txtXP = new TextField(52, 30, "8888", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _txtXP.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtXP.x = 48;
        _txtXP.y = 26;
        source.addChild(_txtXP);

        _coinsImage = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_small'));
        _coinsImage.x = 17;
        _coinsImage.y = 55;
//        MCScaler.scale(_coinsImage, 31, 31);
        _coinsImage.filter = ManagerFilters.SHADOW_TINY;
        source.addChild(_coinsImage);
        _txtCoins = new TextField(52, 30, "8888", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _txtCoins.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtCoins.x = 48;
        _txtCoins.y = 55;
        source.addChild(_txtCoins);
        _act = false;

        source.visible = false;
        _check = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
        _check.visible = false;
        source.addChild(_check);
        source.hoverCallback = onHover;
        source.outCallback = onOut;

    }

    public function activateIt(v:Boolean):void {
        if (v) {
            _bgCarton.filter = null;
            _bgCarton.filter = ManagerFilters.YELLOW_STROKE;
            _act = true;
        } else {
            _bgCarton.filter = null;
            _bgCarton.filter = ManagerFilters.SHADOW_LIGHT;
            _act = false;
        }
    }

    public function get position():int {
        return _position;
    }

    public function fillIt(order:ManagerOrderItem, position:int, f:Function, b:Boolean = false, afterSale:Boolean = false,rech:Boolean = false):void {
        _recheck = rech;
        _position = position;
        _order = order;
        _clickCallback = f;
        _txtName.text = _order.catOb.name;
        _txtXP.text = String(_order.xp);
        _txtCoins.text = String(_order.coins);
        source.visible = true;
        if (b) _check.visible = true;
        else _check.visible = false;
        source.endClickCallback = onClick;

        _deleteOrSell = afterSale;

        _leftSeconds = _order.startTime - int(new Date().getTime()/1000);

        if (_leftSeconds > 0) {
            if (order.delOb) {
                _txtName.visible = false;
                _txtXP.visible = false;
                _txtCoins.visible = false;
                _coinsImage.visible = false;
                _starImage.visible = false;
                _check.visible = false;
                g.userTimer.setOrder(_order);
                g.gameDispatcher.addToTimer(renderLeftTime);
                _clockImage.visible = false;
                _delImage.visible = true;
            } else {
                _txtName.visible = false;
                _txtXP.visible = false;
                _txtCoins.visible = false;
                _coinsImage.visible = false;
                _starImage.visible = false;
                _check.visible = false;
                g.userTimer.setOrder(_order);
                g.gameDispatcher.addToTimer(renderLeftTimeOrder);
                _delImage.visible = false;
                _clockImage.visible = true;
            }
        } else {
            if (order.delOb)  order.delOb = false;
            _leftSeconds = -1;
            _txtName.visible = true;
            _txtXP.visible = true;
            _txtCoins.visible = true;
            _coinsImage.visible = true;
            _starImage.visible = true;
            _clockImage.visible = false;
            _delImage.visible = false;
        }
//        if (afterSale) {
//            if (_leftSeconds > 0) {
//                _txtName.visible = false;
//                _txtXP.visible = false;
//                _txtCoins.visible = false;
//                _coinsImage.visible = false;
//                _starImage.visible = false;
//                _check.visible = false;
//                g.userTimer.setOrder(_order);
//                g.gameDispatcher.addToTimer(renderLeftTimeOrder);
//                _delImage.visible = false;
//                _clockImage.visible = true;
//            } else {
//                _leftSeconds = -1;
//                _txtName.visible = true;
//                _txtXP.visible = true;
//                _txtCoins.visible = true;
//                _coinsImage.visible = true;
//                _starImage.visible = true;
//                _clockImage.visible = false;
//                _delImage.visible = false;
//            }
//        } else {
//            if (_leftSeconds > 0) {
//                _txtName.visible = false;
//                _txtXP.visible = false;
//                _txtCoins.visible = false;
//                _coinsImage.visible = false;
//                _starImage.visible = false;
//                _check.visible = false;
//                g.userTimer.setOrder(_order);
//                g.gameDispatcher.addToTimer(renderLeftTime);
//                _clockImage.visible = false;
//                _delImage.visible = true;
//            } else {
//                _leftSeconds = -1;
//                _txtName.visible = true;
//                _txtXP.visible = true;
//                _txtCoins.visible = true;
//                _coinsImage.visible = true;
//                _starImage.visible = true;
//                _delImage.visible = false;
//                _clockImage.visible = false;
//            }
//        }
        if (rech)source.scaleX = source.scaleY = 0;
    }

    private function onClick():void {
        if (_clickCallback != null) {
            _clickCallback.apply(null, [this,false]);
        }
    }

    public function clearIt():void {
        source.filter = null;
        _order = null;
        source.endClickCallback = null;
        _txtCoins.text = '';
        _txtName.text = '';
        _txtCoins.text = '';
        source.visible = false;
        _check.visible = false;
        g.gameDispatcher.removeFromTimer(renderLeftTime);
        g.gameDispatcher.removeFromTimer(renderLeftTimeOrder);
    }

    private function renderLeftTime():void {
        _leftSeconds--;
        if (_leftSeconds <= 19 && !_recheck) {
            if (_txtName)_wo.timerSkip(_order);
            else g.userTimer.newCatOrder();
        }
        if (_leftSeconds <= 0) {
            _leftSeconds = -1;
            g.gameDispatcher.removeFromTimer(renderLeftTime);
            if(_txtName)_txtName.visible = true;
            if(_txtXP)_txtXP.visible = true;
            if(_txtCoins)_txtCoins.visible = true;
            if(_coinsImage)_coinsImage.visible = true;
            if(_starImage)_starImage.visible = true;
            if(_delImage)_delImage.visible = false;
            if (_clickCallback != null) {
                _clickCallback.apply(null, [this,false,1]);
            }
            if (_order.delOb) false;
//            if(_txtName)_wo.timerSkip(_order);
//            else g.userTimer.newCatOrder();
        }
    }

    private function renderLeftTimeOrder():void {
        _leftSeconds--;
        if (_leftSeconds <= 0) {
            _leftSeconds = -1;
            g.gameDispatcher.removeFromTimer(renderLeftTimeOrder);
            if(_txtName)_txtName.visible = true;
            if(_txtXP)_txtXP.visible = true;
            if(_txtCoins)_txtCoins.visible = true;
            if(_coinsImage)_coinsImage.visible = true;
            if(_starImage)_starImage.visible = true;
            if(_delImage)_delImage.visible = false;
            if(_clockImage)_clockImage.visible = false;
            if (_clickCallback != null) {
                _clickCallback.apply(null, [this,false,1]);
            }
//            if(_txtName)_wo.timerSkip(_order);
//            else g.userTimer.newCatOrder();
        }
    }

    public function get leftSeconds():int {
        return _leftSeconds;
    }

    public function onSkipTimer():void {
        g.gameDispatcher.removeFromTimer(renderLeftTime);
        _leftSeconds = 15;
        g.gameDispatcher.addToTimer(renderLeftTimeOrder);
        g.managerOrder.onSkipTimer(_order);
        _order.delOb = false;
        _check.visible = false;
        _delImage.visible = false;
        _clockImage.visible = true;
//        if (g.user.level <= 6) _order.startTime -= 2* ManagerOrder.TIME_FIRST_DELAY;
//        else if (g.user.level <= 9) _order.startTime -= 2*  ManagerOrder.TIME_SECOND_DELAY;
//        else if (g.user.level <= 15) _order.startTime -= 2* ManagerOrder.TIME_THIRD_DELAY;
//        else if (g.user.level <= 19) _order.startTime -= 2* ManagerOrder.TIME_FOURTH_DELAY;
//        else if (g.user.level >= 20) _order.startTime -= 2* ManagerOrder.TIME_FIFTH_DELAY;
        _order.startTime = int(new Date().getTime()/1000) + 19;
    }

    public function getOrder():ManagerOrderItem {
        return _order;
    }

    public function setOrder(ord:ManagerOrderItem):void {

    }

    private function onHover():void {
        _bgCarton.filter = null;
        _bgCarton.filter = ManagerFilters.BUTTON_HOVER_FILTER;
    }

    private function onOut():void {
        if (_act) {
            _bgCarton.filter = null;
            _bgCarton.filter = ManagerFilters.YELLOW_STROKE;
        } else {
            _bgCarton.filter = null;
            _bgCarton.filter = ManagerFilters.SHADOW_LIGHT;
        }
    }

    public function updateCheck(b:Boolean):void {
        _check.visible = b;
    }

    public function animation(delay:Number):void {
        TweenMax.to(source, .3, {scaleX:1, scaleY:1, alpha:1, y: source.y, delay:delay});
    }

    public function animationHide(delay:Number):void {
        TweenMax.to(source, .3, {scaleX:0, scaleY:0, alpha:1, y: source.y, delay:delay});
    }

    public function clearItem():void {
        _txtName.text = '';
        _txtXP.text = '';
        _txtCoins.text = '';
        _leftSeconds = 0;
    }

    public function deleteIt():void {
        _txtCoins.nativeFilters = [];
        _txtName.nativeFilters = [];
        _txtXP.nativeFilters = [];
        _starImage.filter = null;
        _coinsImage.filter = null;
        _order = null;
        source.filter = null;
        source.removeChild(_bgCarton);
        _bgCarton.filter = null;
        _bgCarton.deleteIt();
        _bgCarton = null;
        source.removeChild(_bgCartonIn);
        _bgCartonIn.filter = null;
        _bgCartonIn.deleteIt();
        _bgCarton = null;
        _clickCallback = null;
        _txtName = null;
        _txtXP = null;
        _txtCoins = null;
        _starImage = null;
        _coinsImage = null;
        _delImage = null;
        _check = null;
        source.deleteIt();
        source = null;
    }
}
}