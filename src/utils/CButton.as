/**
 * Created by user on 5/21/15.
 */
package utils {
import flash.ui.Mouse;

import manager.Vars;

import mouse.OwnMouse;

import starling.display.Button;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.textures.Texture;

public class CButton extends Button{
    private var g:Vars = Vars.getInstance();

    public function CButton(upState:Texture,text:String = "",downState:Texture = null) {
        super (upState,text,downState);

        this.addEventListener(TouchEvent.TOUCH, onTouch);
    }

    private function onTouch(te:TouchEvent):void {
//        if (te.getTouch(this, TouchPhase.MOVED)) {
//        }

        if (te.getTouch(this, TouchPhase.BEGAN)) {
            Mouse.cursor = OwnMouse.CLICK_CURSOR;
        } else if (te.getTouch(this, TouchPhase.ENDED)) {
            Mouse.cursor = OwnMouse.USUAL_CURSOR;
        } else if (te.getTouch(this, TouchPhase.HOVER)) {
            Mouse.cursor = OwnMouse.HOVER_CURSOR;
        } else {
            Mouse.cursor = OwnMouse.USUAL_CURSOR;
        }
    }
}
}
