/**
 * Created by andy on 2/7/17.
 */
package windows.questList {
import flash.geom.Point;
import manager.ManagerFilters;
import quest.QuestStructure;
import starling.display.Sprite;
import utils.CTextField;
import windows.WOComponents.HintBackground;

public class WOQuestListItemHint {
    private var _source:Sprite;
    private var _txtName:CTextField;
    private var _bgTop:HintBackground;
    private var _bgBottom:HintBackground;
    private var _quest:QuestStructure;

    public function WOQuestListItemHint(q:QuestStructure, p:Point) {
        _source = new Sprite();
        _quest = q;
        _txtName = new CTextField(200, 30, _quest.questName);
        _txtName.setFormat(CTextField.BOLD18, 18, ManagerFilters.BLUE_COLOR);
        var w:int = _txtName.textBounds.width + 20;
        _bgTop = new HintBackground(w, 70, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
    }
}
}
