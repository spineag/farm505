/**
 * Created by user on 7/21/15.
 */
package hint {

import flash.geom.Point;
import manager.ManagerFilters;
import manager.Vars;
import starling.animation.Tween;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

public class FlyMessage {
    private var _source:Sprite;
    private var _txtMessage:TextField;
    private var g:Vars = Vars.getInstance();

    public function FlyMessage(p:Point, text:String) {
        _source = new Sprite();
        _txtMessage = new TextField(300,30,text,g.allData.bFonts['BloggerBold18'], 18, Color.WHITE);
        _txtMessage.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtMessage.x = -150;
        _source.x = p.x;
        _source.y = p.y;
        _source.addChild(_txtMessage);
        g.cont.hintCont.addChild(_source);
        var tween:Tween = new Tween(_source, 2);
        tween.moveTo(_source.x,_source.y - 40);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
            while (_source.numChildren) {
                _source.removeChildAt(0);
            }
            _source=null;
        };
        g.starling.juggler.add(tween);

    }
}
}
