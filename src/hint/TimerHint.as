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


public class TimerHint {
    public var source:CSprite;
    private var _txtTimer:TextField;
    private var _timer:int;
    private var _textureHint:Image;
    private var _isOnHover:Boolean;
    private var _isShow:Boolean;
    private var g:Vars = Vars.getInstance();

    public function TimerHint() {
        source = new CSprite();
        _isOnHover = false;
        _isShow = false;
        _txtTimer = new TextField(50,30," ","Arial",18,Color.BLACK);
        _textureHint = new Image(g.interfaceAtlas.getTexture("popup"));
        source.addChild(_textureHint);
        source.pivotX = source.width/2;
        source.pivotY = source.height;
        _txtTimer.x = 20;
        _txtTimer.y = 65;
        source.addChild(_txtTimer);
        var quad:Quad = new Quad(source.width, source.height,Color.WHITE ,false);
        quad.alpha = 0;
        source.addChildAt(quad,0);
        source.hoverCallback = onHover;
        source.outCallback = outHover;
    }

    public function showIt(x:int,y:int,timer:int, cost:int, name:String):void {
        if(_isShow) return;
        _isShow = true;
        source.x = x;
        source.y = y;
        _timer = timer;
        g.cont.hintCont.addChild(source);
        g.gameDispatcher.addToTimer(onTimer);
    }

    public function hideIt():void {
        _isShow = false;
        if (_isOnHover) return;
        if (g.cont.hintCont.contains(source)) {
            g.cont.hintCont.removeChild(source);
        }
        g.gameDispatcher.removeFromTimer(onTimer);
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
}
}
