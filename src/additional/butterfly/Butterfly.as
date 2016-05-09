/**
 * Created by andy on 5/9/16.
 */
package additional.butterfly {
import starling.display.Sprite;

public class Butterfly {
    public static const TYPE_PINK:int = 1;
    public static const TYPE_YELLOW:int = 2;
    public static const TYPE_BLUE:int = 3;

    private var _source:Sprite;
    private var _curType:int;
    private var _animation:ButterflyAnimation;

    public function Butterfly(type:int) {
        _source = new Sprite();
        _curType = type;
        _animation = new ButterflyAnimation(_curType);
    }

    public function flipIt(v:Boolean):void {
        if (v) _source.scaleX = -1;
            else _source.scaleX = 1;
    }

    // play Direct label
    public function playDirectLabel(label:String, playOnce:Boolean, callback:Function):void {
        _animation.playIt(label, playOnce, callback);
    }
}
}
