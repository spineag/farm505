/**
 * Created by user on 5/21/15.
 */
package mouse {
import manager.Vars;

import starling.events.Touch;

import starling.events.TouchEvent;

public class OwnMouse {
    private var _mouseX:Number;
    private var _mouseY:Number;
    private var _touch:Touch;

    private var g:Vars = Vars.getInstance();

    public function OwnMouse() {
        g.mainStage.addEventListener(TouchEvent.TOUCH, onTouchEvent);
    }

    private function onTouchEvent(e:TouchEvent):void {
        _touch = e.getTouch(g.mainStage);
        if (_touch) {
            _mouseX = _touch.globalX;
            _mouseY = _touch.globalY;
        }
    }

    public function get mouseX():Number {
        return _mouseX;
    }

    public function get mouseY():Number {
        return _mouseY;
    }
}
}
