/**
 * Created by andy on 3/3/16.
 */
package tutorial {
import manager.ManagerFilters;
import manager.Vars;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;

import windows.WOComponents.HintBackground;

public class CutSceneTextBubble {
    private var _source:Sprite;
    private var _bubble:HintBackground;
    private var _parent:Sprite;
    private var _btn:CButton;
    private var g:Vars = Vars.getInstance();

    public function CutSceneTextBubble(p:Sprite) {
        _parent = p;
        _source = new Sprite();
        _source.y = -130;
        _source.x = 65;
        _parent.addChild(_source);
    }

    public function showBubble(st:String, btnSt:String, callback:Function):void {
        createBubble();
        _source.addChild(_bubble);
        _bubble.addTextField(18);
        _bubble.setText(st);
        if (callback != null) {
            _btn = new CButton();
            _btn.addButtonTexture(200, 30, CButton.BLUE, true);
            _btn.x = 170;
            _btn.y = 40;
            _source.addChild(_btn);
            _btn.clickCallback = callback;
            var txt:TextField = new TextField(200, 30, btnSt, g.allData.fonts['BloggerBold'], 18, Color.WHITE);
//            txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
            _btn.addChild(txt);
        }
    }

    private function createBubble():void {
        hideBubble();
        _bubble = new HintBackground(300, 150, HintBackground.SMALL_TRIANGLE, HintBackground.LEFT_BOTTOM);
    }

    public function hideBubble():void {
        if (_bubble) {
            if (_source.contains(_bubble)) _source.removeChild(_bubble);
            _bubble.clearIt();
            _bubble = null;
        }
    }

    public function deleteIt():void {
        hideBubble();
        if (_parent.contains(_source)) _parent.removeChild(_source);
        _source.dispose();
        _source = null;
        _parent = null;
    }
}
}
