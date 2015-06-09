/**
 * Created by user on 6/9/15.
 */
package hint {

import manager.Vars;

import map.TownArea;

import starling.display.Image;

import starling.display.Sprite;
import starling.text.TextField;

import starling.textures.Texture;
import starling.utils.Color;


public class TimerHint {

    public var source:Sprite;
    private var _txtTimer:TextField;
    private var _timer:int;
    private var _textureHint:Image;
    private var g:Vars = Vars.getInstance();

    public function TimerHint() {
        source = new Sprite();
        _txtTimer = new TextField(50,30," ","Arial",18,Color.BLACK);
        _textureHint = new Image(g.interfaceAtlas.getTexture("popup"));
        source.addChild(_textureHint);
        source.pivotX = source.width/2;
        source.pivotY = source.height;
        _txtTimer.x = 20;
        _txtTimer.y = 65;
        source.addChild(_txtTimer);
    }
    public function showIt(x:int,y:int,timer:int, cost:int, name:String):void {
        source.x = x;
        source.y = y;
        _timer = timer;
        g.cont.hintCont.addChild(source);
        g.gameDispatcher.addToTimer(onTimer);
    }
    public function hideIt():void{
        if (g.cont.hintCont.contains(source)) {
            g.cont.hintCont.removeChild(source);
        }
        g.gameDispatcher.removeFromTimer(onTimer);
    }
    private function onTimer():void{
        _timer --;
        _txtTimer.text = String(_timer);
        if(_timer <=0){
            hideIt();
        }
    }
}
}
