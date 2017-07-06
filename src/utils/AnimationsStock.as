/**
 * Created by andy on 7/4/17.
 */
package utils {
import com.greensock.TweenMax;
import starling.display.DisplayObject;

public class AnimationsStock {

    public static function joggleItBaby(sp:DisplayObject, count:int=3, f:Function=null, firstLeft:Boolean = true, time:Number = .18):void {
        var defaultRotation:Number = sp.rotation;
        var deltaRotation:Number = .2;
        var finishF:Function = function():void { 
            sp.rotation = defaultRotation;
            if (f!=null) f.apply(); 
        };
        try {
            var onEnd:Function = function ():void {
                if (!sp) return;
                count--;
                if (count <= 0) TweenMax.to(sp, time, {rotation: defaultRotation, onComplete: finishF});
                else {
                    deltaRotation *= .5;
                    f1();
                }
            };
            var f2:Function = function ():void {
                if (!sp) return;
                if (firstLeft) TweenMax.to(sp, time, {rotation: defaultRotation + deltaRotation, onComplete: onEnd});
                else TweenMax.to(sp, time, {rotation: defaultRotation - deltaRotation, onComplete: onEnd});
            };
            var f1:Function = function ():void {
                if (!sp) return;
                if (firstLeft) TweenMax.to(sp, time, {rotation: defaultRotation - deltaRotation, onComplete: f2});
                else TweenMax.to(sp, time, {rotation: defaultRotation + deltaRotation, onComplete: f2});
            };
            f1();
        } catch(e:Error) {
            finishF();
        }
    }

    public static function jumpSimple(sp:DisplayObject, count:int=3, f:Function=null, height:Number = 10, time:Number = .2):void {
        var defaultY:int = sp.y;
        var onFinish:Function = function():void {
            sp.y = defaultY;
            if (f!=null) f.apply();
        };
        
        try {
            var onEnd:Function = function ():void {
                count--;
                if (count <= 0) onFinish();
                else {
                    height *= .6;
                    time *= .7;
                    jumpUp();
                }
            };
            var jumpDown:Function = function ():void {
                TweenMax.to(sp, time, {y: defaultY, onComplete: onEnd});
            };
            var jumpUp:Function = function ():void {
                if (!sp) return;
                TweenMax.to(sp, time, {y: defaultY - height, onComplete: jumpDown});
            };
            jumpUp();
        } catch(e:Error) {
            onFinish();
        }
    }

}
}
