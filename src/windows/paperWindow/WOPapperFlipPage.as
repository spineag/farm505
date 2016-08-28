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

public class WOPapperFlipPage extends Sprite3D{
    private var _top:Image;
    private var _back:Image;

    public function WOPapperFlipPage(top:Texture, back:Texture, isNext:Boolean, callback:Function) {
        _top = new Image(top);
        _back = new Image(back);
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
        this.y = 5;

        var f1:Function = function():void {
            _top.dispose();
            _back.dispose();
            removeChild(_top);
            removeChild(_back);
            _top = null;
            _back = null;
            if (callback != null) {
                callback.apply();
            }
        };
        var f2:Function = function():void {
            _back.visible = true;
            _top.visible = false;
        };
        _back.visible = false;
        var angle:Number;
        isNext ? angle = Math.PI : angle = 0;
        if (!isNext) this.rotationY = Math.PI;
        TweenMax.to(this, .4, {x:this.x, onComplete:f2});
        TweenMax.to(this, .8, {rotationY: angle, onComplete: f1, ease: Linear.ease});
    }

    public function deleteIt():void {
        dispose();
    }
}
}
