/**
 * Created by andy on 2/7/17.
 */
package windows.questList {
import flash.geom.Point;
import manager.ManagerFilters;
import manager.Vars;

import quest.QuestStructure;
import starling.display.Sprite;
import utils.CTextField;
import windows.WOComponents.HintBackground;

public class WOQuestListItemHint {
    private var g:Vars = Vars.getInstance();
    private var _source:Sprite;
    private var _txtName:CTextField;
    private var _bgTop:HintBackground;
    private var _bgBottom:HintBackground;
    private var _quest:QuestStructure;
    private var _items:Array;

    public function WOQuestListItemHint(q:QuestStructure, p:Point) {
        _source = new Sprite();
        _quest = q;
        _txtName = new CTextField(200, 30, _quest.questName);
        _txtName.setFormat(CTextField.BOLD18, 18, ManagerFilters.BLUE_COLOR);
        var w:int = _txtName.textBounds.width + 20;
        _bgTop = new HintBackground(w, 30, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
        _bgTop.y = -40;
        _txtName.y = -120;
        _txtName.x = -100;
        _source.addChild(_bgTop);
        _source.addChild(_txtName);

        _bgBottom = new HintBackground(100, 50, HintBackground.SMALL_TRIANGLE, HintBackground.TOP_CENTER);
        _bgBottom.y = 40;
        _source.addChild(_bgBottom);

        _source.x = p.x;
        _source.y = p.y;
        g.cont.hintCont.addChild(_source);

        var ar:Array = _quest.tasks;
        _items = [];
        var it:Item;
        for (var i:int=0; i<ar.length; i++) {
            it = new Item();
        }
    }

    public function hideIt():void {
        if (!_source) return;
        g.cont.hintCont.removeChild(_source);
        _source.removeChild(_bgTop);
        _source.removeChild(_bgBottom);
        _source.removeChild(_txtName);
        _bgTop.deleteIt();
        _bgBottom.deleteIt();
        _txtName.deleteIt();
        _source.dispose();
        _source = null;
    }
}
}

import starling.display.Sprite;
import utils.CTextField;

internal class Item {
    private var _source:Sprite;
    private var _txt:CTextField;

    public function Item() {
        
    }

}
