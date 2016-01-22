/**
 * Created by user on 7/22/15.
 */
package windows.orderWindow {

import manager.ManagerFilters;
import manager.ManagerOrder;
import manager.Vars;

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
    private var _order:Object;
    private var _leftSeconds:int;
    private var _starImage:Image;
    private var _coinsImage:Image;
    private var _delImage:Image;
    private var _position:int;
    private var _check:Image;
    private var _clickCallback:Function;

    private var g:Vars = Vars.getInstance();
    public function WOOrderItem() {
        source = new CSprite();
        _bgCarton = new CartonBackground(112, 90);
        _bgCarton.filter = ManagerFilters.SHADOW_LIGHT;
        source.addChild(_bgCarton);
        _bgCartonIn = new CartonBackgroundIn(102, 64);
        _bgCartonIn.x = 5;
        _bgCartonIn.y = 21;
        source.addChild(_bgCartonIn);
        _bgCarton.touchable = true;

        _delImage = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_del_or'));
        _delImage.x = 25;
        _delImage.y = 10;
        source.addChild(_delImage);

        _txtName = new TextField(112, 20, "Васько", g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        _txtName.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        source.addChild(_txtName);

        _starImage = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star'));
        _starImage.x = 17;
        _starImage.y = 24;
        MCScaler.scale(_starImage, 30, 30);
        _starImage.filter = ManagerFilters.SHADOW_TINY;
        source.addChild(_starImage);
        _txtXP = new TextField(52, 30, "8888", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _txtXP.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtXP.x = 48;
        _txtXP.y = 26;
        source.addChild(_txtXP);

        _coinsImage = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
        _coinsImage.x = 17;
        _coinsImage.y = 55;
        MCScaler.scale(_coinsImage, 30, 30);
        _coinsImage.filter = ManagerFilters.SHADOW_TINY;
        source.addChild(_coinsImage);
        _txtCoins = new TextField(52, 30, "8888", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _txtCoins.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtCoins.x = 48;
        _txtCoins.y = 55;
        source.addChild(_txtCoins);

        source.visible = false;
        _check = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
        _check.visible = false;
        source.addChild(_check);
    }

    public function activateIt(v:Boolean):void {
        if (v) {
            _bgCarton.filter = ManagerFilters.YELLOW_STROKE;
        } else {
            _bgCarton.filter = ManagerFilters.SHADOW_LIGHT;
        }
    }

    public function get position():int {
        return _position;
    }

    public function fillIt(order:Object, position:int, f:Function, b:Boolean = false):void {
        _position = position;
        _order = order;
        _clickCallback = f;
        _txtName.text = _order.catName;
        _txtXP.text = String(_order.xp);
        _txtCoins.text = String(_order.coins);
        source.visible = true;
        if (b) _check.visible = true;
            else _check.visible = false;
        source.endClickCallback = onClick;

        _leftSeconds = _order.startTime - int(new Date().getTime()/1000);
        if (_leftSeconds > 0) {
            _txtName.visible = false;
            _txtXP.visible = false;
            _txtCoins.visible = false;
            _coinsImage.visible = false;
            _starImage.visible = false;
            g.gameDispatcher.addToTimer(renderLeftTime);
            _delImage.visible = true;
        } else {
            _leftSeconds = -1;
            _txtName.visible = true;
            _txtXP.visible = true;
            _txtCoins.visible = true;
            _coinsImage.visible = true;
            _starImage.visible = true;
            _delImage.visible = false;
        }
    }

    private function onClick():void {
        if (_clickCallback != null) {
            _clickCallback.apply(null, [this]);
        }
    }

    public function clearIt():void {
        _order = null;
        source.endClickCallback = null;
        _txtCoins.text = '';
        _txtName.text = '';
        _txtCoins.text = '';
        source.visible = false;
        _check.visible = false;
        g.gameDispatcher.removeFromTimer(renderLeftTime);
    }

    private function renderLeftTime():void {
        _leftSeconds--;
        if (_leftSeconds <= 0) {
            _leftSeconds = -1;
            g.gameDispatcher.removeFromTimer(renderLeftTime);
            _txtName.visible = true;
            _txtXP.visible = true;
            _txtCoins.visible = true;
            _coinsImage.visible = true;
            _starImage.visible = true;
            _delImage.visible = false;
        }
    }

    public function get leftSeconds():int {
        return _leftSeconds;
    }

    public function onSkipTimer():void {
        _leftSeconds = 0;
        g.managerOrder.onSkipTimer(_order.dbId);
        _check.visible = false;
        _order.startTime -= 2*ManagerOrder.TIME_DELAY;
    }

    public function getOrder():Object {
        return _order;
    }

    public function setOrder(ord:Object):void {

    }
}
}
