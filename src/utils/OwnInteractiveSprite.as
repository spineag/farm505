/**
 * Created by ndy on 15.04.2015.
 */
package utils {
import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class OwnInteractiveSprite extends Sprite{
    private var _onOverCallback:Function;
    private var _onOutCallback:Function;
    private var _onClickCallback:Function;
    private var _scaleOnOver:Boolean;
    private var _scaleOnClick:Boolean;

    public function OwnInteractiveSprite() {
        _onOverCallback = null;
        _onOutCallback = null;
        _onClickCallback = null;
        _scaleOnOver = false;
        _scaleOnClick = false;

        this.addEventListener(TouchEvent.TOUCH, onTouch);
    }

    public function set onOverCallback(f:Function):void {
        _onOverCallback = f;
    }

    public function set onOutCallback(f:Function):void {
        _onOutCallback = f;
    }

    public function set onClickCallback(f:Function):void {
        _onClickCallback = f;
    }

    public function set scaleOnOver(value:Boolean):void {
        _scaleOnOver = value;
    }

    public function set scaleOnClick(value:Boolean):void {
        _scaleOnClick = value;
    }

    private function onTouch(te:TouchEvent):void {
        if (te.getTouch(this, TouchPhase.ENDED)) {
            // click code goes here
            if (_onClickCallback != null) {
                _onClickCallback.apply();
            }
        }

        if (te.getTouch(this, TouchPhase.HOVER)) {
            // rollover code goes here
            if (_scaleOnOver) {
                this.scaleX = this.scaleY = 1.05;
            }
            if (_onOverCallback != null) {
                _onOverCallback.apply();
            }
        } else {
            // rollout code goes here
            if (_scaleOnOver) {
                this.scaleX = this.scaleY = 1;
            }
            if (_onOutCallback != null) {
                _onOutCallback.apply();
            }
        }
    }
}
}
