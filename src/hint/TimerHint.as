/**
 * Created by user on 6/9/15.
 */
package hint {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import manager.ManagerFilters;
import manager.Vars;
import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Quad;
import starling.text.TextField;
import starling.utils.Color;

import utils.CTextField;
import utils.SimpleArrow;
import utils.CButton;
import utils.CSprite;
import utils.MCScaler;
import utils.TimeUtils;
import windows.WOComponents.HintBackground;
import windows.WindowsManager;

public class TimerHint {
    private var _source:CSprite;
    private var _txtName:CTextField;
    private var _txtTimer:CTextField;
    private var _txtText:CTextField;
    private var _timer:int;
    private var _closeTime:Number;
    private var _imageClock:Image;
    private var _bg:HintBackground;
    private var _btn:CButton;
    private var _txtCost:CTextField;
    private var _isOnHover:Boolean;
    private var _isShow:Boolean;
    private var _needMoveCenter:Boolean = false;
    private var _callbackSkip:Function;
    private var _quad:Quad;
    private var _onOutCallback:Function;
    private var _canHide:Boolean;
    private var _arrow:SimpleArrow;
    private var g:Vars = Vars.getInstance();

    public function TimerHint() {
        _canHide = true;
        _source = new CSprite();
        _source.nameIt = 'timerHint';
        _isOnHover = false;
        _isShow = false;
        _bg = new HintBackground(176, 104, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
        _source.addChild(_bg);
        _btn = new CButton();
        _btn.addButtonTexture(78, 46, CButton.GREEN, true);
        _txtCost = new CTextField(50,50,"");
        _txtCost.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _txtCost.x = 3;
        _txtCost.y = 6;
        _txtTimer = new CTextField(80,30,"");
        _txtTimer.setFormat(CTextField.BOLD18, 14, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtTimer.cacheIt = false;
        _txtTimer.x = -85;
        _txtTimer.y = -58;
        _txtName = new CTextField(176,50,"");
        _txtName.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtName.x = -88;
        _txtName.y = -130;
        _txtText = new CTextField(78,50,'ускорить');
        _txtText.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _txtText.y = -17;
        _imageClock = new Image(g.allData.atlas['interfaceAtlas'].getTexture("order_window_del_clock"));
        _imageClock.y = -93;
        _imageClock.x = -63;
        _btn = new CButton();
        _btn.addButtonTexture(77, 45, CButton.GREEN, true);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
        im.x = 45;
        im.y = 19;
        MCScaler.scale(im,25,25);

        _btn.addChild(im);
        _btn.addChild(_txtCost);
        _btn.addDisplayObject(_txtText);
        _btn.y = -60;
        _btn.x = 36;
        _source.addChild(_btn);
        _source.addChild(_txtName);
        _source.addChild(_imageClock);
        _source.addChild(_txtTimer);

        _source.hoverCallback = onHover;
        _source.outCallback = outHover;
        _btn.clickCallback = onClickBtn;
    }

    public function set needMoveCenter(v:Boolean):void {
        _needMoveCenter = v;
    }

    public function get isShow():Boolean {
        return _isShow;
    }

    public function set canHide(v:Boolean):void {
        _canHide = v;
    }

    public function showIt(height:int,x:int, y:int, timeAll:int, timer:int, cost:int, name:String, f:Function, out:Function, ridge:Boolean = false, animal:Boolean = false):void {
        if(_isShow) return;
        if (timer <=0) return;
        _onOutCallback = out;
        _closeTime = 1;
        var quad:Quad;
        if (ridge) {
            _quad = new Quad(int(_bg.width), int(_bg.height), Color.WHITE);
            quad = new Quad(int(height * g.currentGameScale), int(height * g.currentGameScale), Color.GREEN);
            quad.pivotX = int(quad.width/2);
            _source.addChildAt(quad,0);
//            quad.alpha = 0;
        } else if (animal) {
            _quad = new Quad(int(_bg.width), int(_bg.height), Color.WHITE);
            quad = new Quad(int(height * g.currentGameScale), int(height * g.currentGameScale), Color.GREEN);
            quad.pivotX = int(quad.width/2);
            _source.addChildAt(quad,0);
//            quad.alpha = 0;
        } else _quad = new Quad(int(_bg.width), int(_bg.height + height/2 * g.currentGameScale), Color.WHITE);
//        _quad.alpha = 0;
        _quad.x = -int(_bg.width/2);
        _quad.y = -int(_bg.height);
        _source.addChildAt(_quad,0);
        _callbackSkip = f;
        _source.x = x;// + 115;
        _source.y = y;//+ 150;

        _source.scaleX = _source.scaleY = 0;
        var tween:Tween = new Tween(_source, 0.1);
        tween.scaleTo(1);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
            updateTextField();

        };
        g.starling.juggler.add(tween);

        _isShow = true;
        _isOnHover = true;
        _timer = timer;
        _txtTimer.text = TimeUtils.convertSecondsForHint(_timer);
        _txtCost.text = String(g.managerTimerSkip.newCount(timeAll,timer,cost));
        _txtName.text = name;
        g.cont.hintContUnder.addChild(_source);
        g.gameDispatcher.addToTimer(onTimer);

        if (_needMoveCenter) {
            if (_source.y < _source.height + 50 || _source.x < _source.width / 2 + 50 || _source.x > g.managerResize.stageWidth - _source.width / 2 - 50) {
                var dY:int = 0;
                if (_source.y < _source.height + 50)
                    dY = _source.height + 50 - _source.y;
                var dX:int = 0;
                if (_source.x < _source.width / 2 + 50) {
                    dX = _source.width / 2 + 50 - _source.x;
                } else if (_source.x > g.managerResize.stageWidth - _source.width / 2 - 50) {
                    dX = g.managerResize.stageWidth - _source.width / 2 - 50 - _source.x;
                }
                g.cont.deltaMoveGameCont(dX, dY, .5);
                new TweenMax(_source, .5, {x: int(_source.x + dX), y: int(_source.y + dY), ease: Linear.easeOut});
            }
            _needMoveCenter = false;
        }
    }

    private function updateTextField():void {
        _txtCost.updateIt();
        _txtName.updateIt();
        _txtText.updateIt();
        _txtTimer.updateIt();
    }

    public function hideIt(force:Boolean = false):void {
        if (!_canHide && !force) return;
        if (_isOnHover && !force) return;
        if (!_isShow) return;
        if (force) _closeTime = 0;
            else _closeTime = 1;
        g.gameDispatcher.addToTimer(closeTimer);
    }

    private function onTimer():void {
        _timer --;
        _txtTimer.text = TimeUtils.convertSecondsForHint(_timer);
        if(_timer <=0){
            _isOnHover = false;
            hideIt();
            managerHide();
            g.gameDispatcher.removeFromTimer(closeTimer);
            g.mouseHint.hideIt();
        }
    }

    private function closeTimer():void {
        _closeTime--;
        if (_closeTime <= 0) {
            if(!_isOnHover) {
                var tween:Tween = new Tween(_source, 0.1);
                tween.scaleTo(0);
                tween.onComplete = function ():void {
                    g.starling.juggler.remove(tween);
                    _isShow = false;
                    g.gameDispatcher.removeFromTimer(onTimer);
                    _source.removeChild(_quad);
                    if (g.cont.hintContUnder.contains(_source)) {
                        g.cont.hintContUnder.removeChild(_source);
                    }

                };
                g.starling.juggler.add(tween);
            }
            g.gameDispatcher.removeFromTimer(closeTimer);
        }
    }

    private function onHover():void {
        if (_isOnHover) return;
        _isOnHover = true;
    }

    private function outHover():void {
        _isOnHover = false;
        hideIt();
    }

    private function onClickBtn():void {
        if (g.managerTutorial.isTutorial) {
            _isOnHover = false;
            managerHide();
            if (_callbackSkip != null) {
                _callbackSkip.apply(null);
            }
            return;
        }
        if (g.user.hardCurrency < int(_txtCost.text)) {
            _isOnHover = false;
            hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        g.userInventory.addMoney(1,-int(_txtCost.text));
        _isOnHover = false;
//        managerHide();
        hideIt();
        if (_callbackSkip != null) {
            _callbackSkip.apply(null);
        }
    }

    public function managerHide(callback:Function = null):void {
        if (_isShow) {
            _closeTime = 1;
            var tween:Tween = new Tween(_source, 0.1);
            tween.scaleTo(0);
            tween.onComplete = function ():void {
                g.starling.juggler.remove(tween);
                _isShow = false;
                g.gameDispatcher.removeFromTimer(onTimer);
                _source.removeChild(_quad);
                if (g.cont.hintContUnder.contains(_source)) {
                    g.cont.hintContUnder.removeChild(_source);
                }
                if (callback != null) {
                    callback.apply();
                    callback = null;
                }
            };
            g.starling.juggler.add(tween);
            g.gameDispatcher.removeFromTimer(closeTimer);
            _isShow = false;
        }
    }

    public function addArrow():void {
        _canHide = false;
        if (_btn && !_arrow) {
            _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, _source);
            _arrow.animateAtPosition(_btn.x, _btn.y - _btn.height/2 - 2);
            _arrow.scaleIt(.7);
        }
    }

    public function hideArrow():void {
        _canHide = true;
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
    }
}
}
