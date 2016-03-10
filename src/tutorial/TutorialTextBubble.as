/**
 * Created by andy on 3/3/16.
 */
package tutorial {
import manager.Vars;
import starling.display.Sprite;
import windows.WOComponents.HintBackground;

public class TutorialTextBubble {
    private var _bubble:HintBackground;
    private var _parent:Sprite;
    private var g:Vars = Vars.getInstance();
    private var _isFlip:Boolean;
    private var _st:String;

    public function TutorialTextBubble(p:Sprite) {
        _parent = p;
        _isFlip = false;
    }

    public function showBubble(st:String, isFlip:Boolean):void {
        _isFlip = isFlip;
        createBubble();
        _parent.addChild(_bubble);
        _bubble.addTextField(20);
        _bubble.setText(st);
        _st = st;
    }

    private function createBubble():void {
        hideBubble();
        if (_isFlip) {
            _bubble = new HintBackground(500 * g.scaleFactor, 300 * g.scaleFactor, HintBackground.SMALL_TRIANGLE, HintBackground.LEFT_BOTTOM);
            _bubble.x = 46 * g.scaleFactor;
            _bubble.y = -100 * g.scaleFactor;
        } else {
            _bubble = new HintBackground(500 * g.scaleFactor, 300 * g.scaleFactor, HintBackground.SMALL_TRIANGLE, HintBackground.RIGHT_TOP);
            _bubble.x = -46 * g.scaleFactor;
            _bubble.y = -100 * g.scaleFactor;
        }
    }

    public function hideBubble():void {
        if (_bubble) {
            if (_parent && _parent.contains(_bubble)) _parent.removeChild(_bubble);
            _bubble.clearIt();
            _bubble = null;
        }
    }

    public function deleteIt():void {
        hideBubble();
        _parent = null;
    }

}
}
