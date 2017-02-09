/**
 * Created by user on 9/12/16.
 */
package windows.quest {
import com.junkbyte.console.Cc;
import manager.ManagerFilters;
import quest.QuestStructure;
import starling.display.Image;
import starling.utils.Color;
import utils.CTextField;
import windows.WOComponents.Birka;
import windows.WOComponents.CartonBackground;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOQuest extends WindowMain{
    private var _woBG:WindowBackground;
    private var _birka:Birka;
    private var _bgC:CartonBackground;
    private var _quest:QuestStructure;
    private var _txtName:CTextField;
    private var _questItem:WOQuestItem;
    private var _award:WOQuestAward;
    private var _txtDescription:CTextField;

    public function WOQuest() {
        super();
        _windowType = WindowsManager.WO_QUEST;
        _woWidth = 550;
        _woHeight = 570;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;
        _birka = new Birka('Задание', _source, _woWidth, _woHeight);

        _bgC = new CartonBackground(480, 240);
        _bgC.filter =  ManagerFilters.SHADOW;
        _bgC.x = -240;
        _bgC.y = 12;
        _source.addChild(_bgC);

        _txtName = new CTextField(300, 100, '');
        _txtName.setFormat(CTextField.MEDIUM30, 30, ManagerFilters.ORANGE_COLOR, Color.WHITE);
        _txtName.x = -150;
        _txtName.y = -295;
        _txtName.touchable = false;
        _source.addChild(_txtName);

        _txtDescription = new CTextField(270, 95, '');
        _txtDescription.setFormat(CTextField.MEDIUM24, 24, ManagerFilters.BLUE_COLOR);
        _txtDescription.x = -120;
        _txtDescription.y = -200;
        _txtDescription.touchable = false;
        _source.addChild(_txtDescription);
    }

    override public function showItParams(callback:Function, params:Array):void {
        _quest = params[0];
        if (g.allData.atlas['questAtlas']) {
            var im:Image;
            if (_quest.id % 2) im = new Image(g.allData.atlas['questAtlas'].getTexture('quest_window_1'));
                else im = new Image(g.allData.atlas['questAtlas'].getTexture('quest_window_2'));
            if (im) {
                im.x = -im.width/2;
                im.y = -295;
                im.touchable = false;
                _source.addChild(im);
            } else {
                Cc.error('WOQuest showItParams:: no image for bg quest');
            }
        } else {
            Cc.error('WOQuest showItParams:: no questAtlas');
        }
        _txtDescription.text = _quest.description;
        _txtName.text = _quest.questName;
        _source.setChildIndex(_txtDescription, _source.numChildren-1);
        _source.setChildIndex(_txtName, _source.numChildren-1);

        _award = new WOQuestAward(_source, _quest.awards);
        _questItem = new WOQuestItem(_source, _quest.tasks);
        super.showIt();
    }

    override protected function deleteIt():void {
        g.managerQuest.onHideWO();
        if (_txtName) {
            _source.removeChild(_txtName);
            _txtName.deleteIt();
            _txtName = null;
        }
        if (_txtDescription) {
            _source.removeChild(_txtDescription);
            _txtDescription.deleteIt();
            _txtDescription = null;
        }
        _birka.deleteIt();
        _award.deleteIt();
        _questItem.deleteIt();
        if (_bgC) {
            _source.removeChild(_bgC);
            _bgC.deleteIt();
        }
        super.deleteIt();
    }
}
}
