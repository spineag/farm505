/**
 * Created by user on 7/21/15.
 */
package hint {

import flash.geom.Point;

import manager.Vars;

import starling.animation.Tween;

import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

public class FlyMessage {
    private var _source:Sprite;
    private var _txtMessage:TextField;
    private var g:Vars = Vars.getInstance();

    public function FlyMessage() {
        _source = new Sprite();
    }

    public function showIt(spr:Sprite, text:String):void {
        _txtMessage = new TextField(200,30,"","Arial",18,Color.BLACK);
        _txtMessage.x = -100;
        _txtMessage.text = text;
        var start:Point = new Point(int(spr.x), int(spr.y));
        start = spr.parent.localToGlobal(start);
        _source.x = start.x;
        _source.y = start.y;
        _source.addChild(_txtMessage);
        g.cont.hintCont.addChild(_source);
        var tween:Tween = new Tween(_source, 1);
        tween.moveTo(_source.x,_source.y - 50);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
            while (_source.numChildren) {
                _source.removeChildAt(0);
            }
        };
        g.starling.juggler.add(tween);

    }
}
}
