/**
 * Created by user on 6/9/15.
 */
package hint {

import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import flash.geom.Point;

import manager.ManagerFilters;

import manager.Vars;

import starling.animation.Tween;

import starling.core.Starling;

import flash.geom.Rectangle;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;

import starling.text.TextField;

import starling.utils.Color;

import utils.CButton;

import utils.CSprite;
import utils.MCScaler;
import utils.TimeUtils;

import windows.WOComponents.HintBackground;

import windows.WOComponents.WOButtonTexture;

public class TimerHint {
    public var source:CSprite;
    private var _txtName:TextField;
    private var _txtTimer:TextField;
    private var _txtText:TextField;
    private var _timer:int;
    private var _imageClock:Image;
    private var _bg:HintBackground;
    private var _btn:CButton;
    private var _txtCost:TextField;
    private var _isOnHover:Boolean;
    private var _isShow:Boolean;
    private var _needMoveCenter:Boolean = false;
    private var _callbackSkip:Function;
    private var _quad:Quad;
    private var _onOutCallback:Function;
    private var g:Vars = Vars.getInstance();

    public function TimerHint() {
        source = new CSprite();
        _isOnHover = false;
        _isShow = false;
        _bg = new HintBackground(176, 104, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
        source.addChild(_bg);
        _btn = new CButton();
        _btn.addButtonTexture(78, 46, CButton.GREEN, true);
        _txtCost = new TextField(50,50,"",g.allData.fonts['BloggerBold'],18,Color.WHITE);
        _txtCost.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        _txtCost.x = 10;
        _txtCost.y = -2;
        _txtTimer = new TextField(80,30,"",g.allData.fonts['BloggerBold'],14,Color.WHITE);
        _txtTimer.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtTimer.x = -85;
        _txtTimer.y = -58;
        _txtName = new TextField(176,50,"",g.allData.fonts['BloggerBold'],18,Color.WHITE);
        _txtName.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtName.x = -88;
        _txtName.y = -130;
        _txtText = new TextField(80,40,'УСКОРИТЬ',g.allData.fonts['BloggerBold]'],16,ManagerFilters.TEXT_BLUE);
        _imageClock = new Image(g.allData.atlas['interfaceAtlas'].getTexture("order_window_del_clock"));
        _imageClock.y = -93;
        _imageClock.x = -63;
        _btn = new CButton();
        _btn.addButtonTexture(77, 45, CButton.GREEN, true);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
        im.x = 50;
        im.y = 10;
        MCScaler.scale(im,25,25);
        _btn.addChild(im);
        _btn.addChild(_txtCost);
        _btn.y = -60;
        _btn.x = 36;
        source.addChild(_btn);
        source.addChild(_txtName);
        source.addChild(_imageClock);
        source.addChild(_txtText);
        source.addChild(_txtTimer);

        source.hoverCallback = onHover;
        source.outCallback = outHover;
        _btn.clickCallback = onClickBtn;
    }

    public function set needMoveCenter(v:Boolean):void {
        _needMoveCenter = v;
    }

    public function isShow():Boolean {
        return _isShow
    }

    public function showIt(height:int,x:int, y:int, timer:int, cost:int, name:String,f:Function, out:Function):void {
        if (timer <=0) return;
        _onOutCallback = out;
        _quad = new Quad(_bg.width, _bg.height + height * g.currentGameScale,Color.WHITE ,false);
        _quad.alpha = 0;
        _quad.x = -_bg.width/2;
        _quad.y = -_bg.height;
        source.addChildAt(_quad,0);
        _callbackSkip = f;
        if(_isShow) return;
        source.x = x;// + 115;
        source.y = y;//+ 150;

        source.scaleX = source.scaleY = 0;
        var tween:Tween = new Tween(source, 0.1);
        tween.scaleTo(1);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);

        };
        g.starling.juggler.add(tween);

        _isShow = true;
        _timer = timer;
        _txtTimer.text = TimeUtils.convertSecondsToStringClassic(_timer);
        _txtCost.text = String(cost);
        _txtName.text = name;
        g.cont.hintContUnder.addChild(source);
        g.gameDispatcher.addToTimer(onTimer);

        if (_needMoveCenter) {
            if (source.y < source.height + 50 || source.x < source.width / 2 + 50 || source.x > Starling.current.nativeStage.stageWidth - source.width / 2 - 50) {
                var dY:int = 0;
                if (source.y < source.height + 50)
                    dY = source.height + 50 - source.y;
                var dX:int = 0;
                if (source.x < source.width / 2 + 50) {
                    dX = source.width / 2 + 50 - source.x;
                } else if (source.x > Starling.current.nativeStage.stageWidth - source.width / 2 - 50) {
                    dX = Starling.current.nativeStage.stageWidth - source.width / 2 - 50 - source.x;
                }
                g.cont.deltaMoveGameCont(dX, dY, .5);
                new TweenMax(source, .5, {x: source.x + dX, y: source.y + dY, ease: Linear.easeOut});
            }
            _needMoveCenter = false;
        }
    }

    public function hideIt(force:Boolean = false):void {
        if (_isOnHover && !force) return;
        if (!_isShow) return;
        _isShow = false;
        g.gameDispatcher.removeFromTimer(onTimer);
        source.removeChild(_quad);
        if (g.cont.hintContUnder.contains(source)) {
            g.cont.hintContUnder.removeChild(source);
        }
    }

    private function onTimer():void {
        _timer --;
        _txtTimer.text = TimeUtils.convertSecondsToStringClassic(_timer);
        if(_timer <=0){
            hideIt();
        }
    }

    private function onHover():void {
        _isOnHover = true;
    }

    private function outHover():void {
        _isOnHover = false;
        hideIt();
        if (_onOutCallback != null) {
            _onOutCallback.apply();
            _onOutCallback = null;
        }
    }

    private function onClickBtn():void {
        if (g.user.hardCurrency < int(_txtCost.text)) {
            _isOnHover = false;
            hideIt();
            g.woBuyCurrency.showItMenu(true);
            return;
        }
        if (_callbackSkip != null) {
            _callbackSkip.apply(null);
        }
        g.userInventory.addMoney(1,-int(_txtCost.text));
        _isOnHover = false;
        hideIt();
    }
}
}
