/**
 * Created by user on 6/11/15.
 */
package hint {

import flash.geom.Rectangle;

import manager.ManagerFilters;
import manager.Vars;
import starling.core.Starling;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import windows.WOComponents.HintBackground;

public class Hint {
    public var source:Sprite;
    private var _txtHint:TextField;
    private var _isShow:Boolean;

    private var g:Vars = Vars.getInstance();

    public function Hint() {
        source = new Sprite();
        _txtHint = new TextField(150,20,"", g.allData.fonts['BloggerBold'],14,Color.WHITE);
        _txtHint.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        source.touchable = false;
        _isShow = false;
    }

    public function showIt(st:String,big:Boolean = false):void {
        _txtHint.text = st;
        var rectangle:Rectangle = _txtHint.textBounds;
        if (!big )  {
            _txtHint.x = 0;
            _txtHint.width = rectangle.width + 20;
        } else {
            _txtHint.width = 150;
        }
        _txtHint.height = rectangle.height + 10;
        if (source.numChildren) {
            while (source.numChildren) source.removeChildAt(0);
        }
        var bg:HintBackground = new HintBackground(rectangle.width + 22, rectangle.height + 12);
        if (big) {
            _txtHint.x = bg.x + 7;
        }
        source.addChild(bg);
        source.addChild(_txtHint);
        if(_isShow) return;
        _isShow = true;
        g.cont.hintCont.addChild(source);
        g.gameDispatcher.addEnterFrame(onEnterFrame);
    }

    private function onEnterFrame():void {
        source.x = g.ownMouse.mouseX + 20;
        source.y = g.ownMouse.mouseY - 40;
        checkPosition();
    }

    private function checkPosition():void {  // check is hint source is in stage width|height
        if (source.x < 20) source.x = 20;
        if (source.x > Starling.current.nativeStage.stageWidth - source.width - 20) source.x = Starling.current.nativeStage.stageWidth - source.width - 20;
        if (source.y < 20) source.y = 20;
        if (source.y > Starling.current.nativeStage.stageHeight - source.height - 20) source.y = Starling.current.nativeStage.stageHeight - source.height - 20;
    }

    public function hideIt():void {
        _isShow = false;
        while (source.numChildren) source.removeChildAt(0);
        g.gameDispatcher.removeEnterFrame(onEnterFrame);
        g.cont.hintCont.removeChild(source);
    }
}
}
