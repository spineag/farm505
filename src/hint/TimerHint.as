/**
 * Created by user on 6/9/15.
 */
package hint {

import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import manager.Vars;

import starling.core.Starling;


import starling.display.Image;
import starling.display.Quad;

import starling.text.TextField;

import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

public class TimerHint {
    public var source:CSprite;
    private var _contBtn:CSprite;
    private var _txtName:TextField;
    private var _txtTimer:TextField;
    private var _timer:int;
    private var _textureHint:Image;
    private var _imageBtn:Image;
    private var _txtCost:TextField;
    private var _isOnHover:Boolean;
    private var _isShow:Boolean;
    private var _needMoveCenter:Boolean = false;
    private var _callbackSkip:Function;
    private var g:Vars = Vars.getInstance();

    public function TimerHint() {
        source = new CSprite();
        _contBtn = new CSprite();
        _contBtn.x = 100;
        _contBtn.y = 20;
        _isOnHover = false;
        _isShow = false;
        _txtCost = new TextField(50,50,"","Arial",12,Color.BLACK);
        _txtTimer = new TextField(50,30,"","Arial",18,Color.BLACK);
        _txtName = new TextField(100,50,"","Arial",18,Color.WHITE);
        _txtName.x = 40;
        _txtName.y = -30;
        _textureHint = new Image(g.allData.atlas['interfaceAtlas'].getTexture("popup"));
        _imageBtn = new Image(g.allData.atlas['interfaceAtlas'].getTexture("btn4"));
        _contBtn.addChild(_imageBtn);
        _contBtn.addChild(_txtCost);
        MCScaler.scale(_imageBtn,60,60);
        source.addChild(_txtName);
        source.addChild(_textureHint);
        source.pivotX = source.width/2;
        source.pivotY = source.height;
        _txtTimer.x = 20;
        _txtTimer.y = 65;
        source.addChild(_txtTimer);
        var quad:Quad = new Quad(source.width, source.height,Color.WHITE ,false);
        quad.alpha = 0;
        source.addChildAt(quad,0);
        source.addChild(_contBtn);
        _contBtn.endClickCallback = onClickBtn;
        source.hoverCallback = onHover;
        source.outCallback = outHover;
    }

    public function set needMoveCenter(v:Boolean):void {
        _needMoveCenter = v;
    }

    public function showIt(x:int, y:int, timer:int, cost:int, name:String,f:Function):void {
//        var s:Number = g.cont.gameCont.scaleX;
//        var oY:Number = g.matrixGrid.offsetY*s;
        _callbackSkip = f;
        if(_isShow) return;
        _isShow = true;
        source.x = x;
        source.y = y;
        _timer = timer;
        _txtTimer.text = String(_timer);
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

    public function hideIt():void {
        _isShow = false;
        if (_isOnHover) return;
        g.gameDispatcher.removeFromTimer(onTimer);
        if (g.cont.hintContUnder.contains(source)) {
            g.cont.hintContUnder.removeChild(source);
        }
    }

    private function onTimer():void {
        _timer --;
        _txtTimer.text = String(_timer);
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
    }

    private function onClickBtn():void {
        if (g.user.hardCurrency < int(_txtCost.text))return;
        if (_callbackSkip != null) {
            _callbackSkip.apply(null);
        }
        g.userInventory.addMoney(1,-int(_txtCost.text));
        _isOnHover = false;
        hideIt();
    }
}
}
