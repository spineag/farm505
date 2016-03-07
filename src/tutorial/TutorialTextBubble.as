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

    public function TutorialTextBubble(p:Sprite) {
        _parent = p;
    }

    public function showBubble(st:String):void {
        createBubble();
        _parent.addChild(_bubble);
        _bubble.addTextField(20);
        _bubble.setText(st);
    }

    private function createBubble():void {
        hideBubble();
        _bubble = new HintBackground(300*g.scaleFactor, 200*g.scaleFactor, HintBackground.SMALL_TRIANGLE, HintBackground.LEFT_CENTER);
    }

    public function hideBubble():void {
        if (_parent && _parent.contains(_bubble)) _parent.removeChild(_bubble);
        _bubble.clearIt();
        _bubble = null;
    }

    public function deleteIt():void {
        hideBubble();
        _parent = null;
    }
}
}
