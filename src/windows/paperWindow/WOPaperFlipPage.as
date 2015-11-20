/**
 * Created by user on 11/19/15.
 */
package windows.paperWindow {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import flash.display.Bitmap;
import flash.events.TimerEvent;
import flash.utils.Timer;

import starling.display.Image;
import starling.display.Sprite3D;
import starling.textures.Texture;

public class WOPaperFlipPage extends Sprite3D{
    private var _top:Image;
    private var _back:Image;

    public function WOPaperFlipPage(top:Bitmap, back:Bitmap, isNext:Boolean, callback:Function) {
        var tex:Texture = Texture.fromBitmap(top);
        _top = new Image(tex);
        tex = Texture.fromBitmap(back);
        _back = new Image(tex);
        _top.alignPivot();
        _back.alignPivot();
        if (isNext) {
            _back.scaleX = -1;
        } else {
            _top.scaleX = -1;
        }
        this.addChild(_top);
        this.addChild(_back);
        this.alignPivot();
        this.pivotX = -this.width/2;

        var f1:Function = function():void {
            _top.dispose();
            _back.dispose();
            removeChild(_top);
            removeChild(_back);
            tex.dispose();
            tex = null;
            _top = null;
            _back = null;
            if (callback != null) {
                callback.apply();
            }
        };
        _back.visible = false;
        var angle:Number;
        isNext ? angle = Math.PI : angle = 0;
        if (!isNext) this.rotationY = Math.PI;
        TweenMax.to(this, .8, {rotationY: angle, onComplete: f1, ease: Linear.ease});
        var t:Timer = new Timer(400, 1);
        var f2:Function = function():void {
            t.stop();
            t.removeEventListener(TimerEvent.TIMER, f2);
            t = null;
            _back.visible = true;
            _top.visible = false;
        };
        t.addEventListener(TimerEvent.TIMER, f2);
        t.start();
    }
}
}
