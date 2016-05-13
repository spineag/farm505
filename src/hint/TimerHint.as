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
import tutorial.SimpleArrow;
import utils.CButton;
import utils.CSprite;
import utils.MCScaler;
import utils.TimeUtils;
import windows.WOComponents.HintBackground;
import windows.WindowsManager;

public class TimerHint {
    private var _source:CSprite;
    private var _txtName:TextField;
    private var _txtTimer:TextField;
    private var _txtText:TextField;
    private var _timer:int;
    private var _closeTime:Number;
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
    private var _canHide:Boolean;
    private var _arrow:SimpleArrow;
    private var g:Vars = Vars.getInstance();

    public function TimerHint() {
        _canHide = true;
        _source = new CSprite();
        _isOnHover = false;
        _isShow = false;
        _bg = new HintBackground(176, 104, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
        _source.addChild(_bg);
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
        _source.addChild(_btn);
        _source.addChild(_txtName);
        _source.addChild(_imageClock);
        _source.addChild(_txtText);
        _source.addChild(_txtTimer);

        _source.hoverCallback = onHover;
        _source.outCallback = outHover;
        _btn.clickCallback = onClickBtn;
    }

    public function set needMoveCenter(v:Boolean):void {
        _needMoveCenter = v;
    }

    public function isShow():Boolean {
        return _isShow;
    }

    public function set canHide(v:Boolean):void {
        _canHide = v;
    }

    public function showIt(height:int,x:int, y:int, timer:int, cost:int, name:String, f:Function, out:Function, ridge:Boolean = false):void {
        if(_isShow) return;
        if (timer <=0) return;
        _onOutCallback = out;
        if (ridge) {
            _quad = new Quad(_bg.width, _bg.height,Color.WHITE ,false);
            var quad:Quad = new Quad(height * g.currentGameScale,height * g.currentGameScale,Color.GREEN ,false);
            quad.pivotX = quad.width/2;
            _source.addChildAt(quad,0);
            quad.alpha = 0;
        } else _quad = new Quad(_bg.width, _bg.height + height * g.currentGameScale,Color.WHITE ,false);
        _quad.alpha = 0;
        _quad.x = -_bg.width/2;
        _quad.y = -_bg.height;
        _source.addChildAt(_quad,0);
        _callbackSkip = f;
        _source.x = x;// + 115;
        _source.y = y;//+ 150;

        _source.scaleX = _source.scaleY = 0;
        var tween:Tween = new Tween(_source, 0.1);
        tween.scaleTo(1);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);

        };
        g.starling.juggler.add(tween);

        _isShow = true;
        _timer = timer;
        _txtTimer.text = TimeUtils.convertSecondsForHint(_timer);
        _txtCost.text = String(cost);
        _txtName.text = name;
        g.cont.hintContUnder.addChild(_source);
        g.gameDispatcher.addToTimer(onTimer);

        if (_needMoveCenter) {
            if (_source.y < _source.height + 50 || _source.x < _source.width / 2 + 50 || _source.x > Starling.current.nativeStage.stageWidth - _source.width / 2 - 50) {
                var dY:int = 0;
                if (_source.y < _source.height + 50)
                    dY = _source.height + 50 - _source.y;
                var dX:int = 0;
                if (_source.x < _source.width / 2 + 50) {
                    dX = _source.width / 2 + 50 - _source.x;
                } else if (_source.x > Starling.current.nativeStage.stageWidth - _source.width / 2 - 50) {
                    dX = Starling.current.nativeStage.stageWidth - _source.width / 2 - 50 - _source.x;
                }
                g.cont.deltaMoveGameCont(dX, dY, .5);
                new TweenMax(_source, .5, {x: _source.x + dX, y: _source.y + dY, ease: Linear.easeOut});
            }
            _needMoveCenter = false;
        }
    }

    public function hideIt(force:Boolean = false):void {
        if (!_canHide) return;
        if (_isOnHover && !force) return;
        if (!_isShow) return;
        _closeTime = 1.5;
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
        _isOnHover = true;
    }

    private function outHover():void {
        _isOnHover = false;
        hideIt();
//        if (_onOutCallback != null) {
//            _onOutCallback.apply();
//            _onOutCallback = null;
//        }
    }

    private function onClickBtn():void {
        if (g.user.hardCurrency < int(_txtCost.text)) {
            _isOnHover = false;
            hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        g.userInventory.addMoney(1,-int(_txtCost.text));
        _isOnHover = false;
        managerHide();
        if (_callbackSkip != null) {
            _callbackSkip.apply(null);
        }
    }

    public function managerHide():void {
        if (_isShow) {
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
            g.gameDispatcher.removeFromTimer(closeTimer);
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
