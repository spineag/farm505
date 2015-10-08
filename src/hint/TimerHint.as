/**
 * Created by user on 6/9/15.
 */
package hint {

import manager.Vars;


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
        _textureHint = new Image(g.interfaceAtlas.getTexture("popup"));
        _imageBtn = new Image(g.interfaceAtlas.getTexture("btn4"));
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

    public function showIt(x:int,y:int,timer:int, cost:int, name:String):void {
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
        if (g.user.hardCurrency <= 0)return;
        g.userInventory.addMoney(1,-int(_txtCost.text));
        _isOnHover = false;
        hideIt();
    }
}
}
