/**
 * Created by user on 9/12/16.
 */
package windows.quest {
import com.junkbyte.console.Cc;

import flash.display.Bitmap;

import manager.ManagerFilters;

import quest.ManagerQuest;
import quest.QuestStructure;
import starling.display.Image;
import starling.textures.Texture;
import starling.utils.Color;
import utils.CTextField;
import utils.MCScaler;

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
    private var _questIcon:Image;

    public function WOQuest() {
        super();
        _windowType = WindowsManager.WO_QUEST;
        _woWidth = 550;
        _woHeight = 570;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;
        _birka = new Birka(String(g.managerLanguage.allTexts[623]), _source, _woWidth, _woHeight);

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

        _txtDescription = new CTextField(260, 95, '');
        _txtDescription.setFormat(CTextField.MEDIUM24, 22, ManagerFilters.BLUE_COLOR);
        _txtDescription.x = -120;
        _txtDescription.y = -200;
        _txtDescription.touchable = false;
        _source.addChild(_txtDescription);
    }

    override public function showItParams(callback:Function, params:Array):void {
        _quest = params[0];
        if (!_quest.tasks.length) { Cc.error('WOQuest showItParams: no tasks for questId: ' + _quest.id); return; }
        if (!_quest.awards.length) { Cc.error('WOQuest showItParams: no awards for questId: ' + _quest.id); return; }
        if (g.allData.atlas['questAtlas']) {
            var im:Image;
            im = new Image(g.allData.atlas['questAtlas'].getTexture('quest_window_back'));
            if (im) {
                im.x = -im.width/2;
                im.y = -270;
                im.touchable = false;
                _source.addChild(im);
            } else {
                Cc.error('WOQuest showItParams:: no image for bg quest');
            }
        } else {
            Cc.error('WOQuest showItParams:: no questAtlas');
        }
        Cc.info("woQuest showItParams 1");
        _txtDescription.text = _quest.description;
        Cc.info("woQuest showItParams 2");
        if (g.user.isTester) _txtName.text = String(_quest.id) + ': ' + _quest.questName;
            else _txtName.text = _quest.questName;
        Cc.info("woQuest showItParams 3");
        _source.setChildIndex(_txtDescription, _source.numChildren-1);
        _source.setChildIndex(_txtName, _source.numChildren-1);
        _source.setChildIndex(_btnExit, _source.numChildren-1);

        Cc.info("woQuest showItParams 4");
        _award = new WOQuestAward(_source, _quest.awards);
        Cc.info("woQuest showItParams 5");
        _questItem = new WOQuestItem(_source, _quest.tasks);
        Cc.info("woQuest showItParams 6");
        super.showIt();

        var st:String = _quest.iconPath;
        if (st == '0') {
            st = _quest.getUrlFromTask();
            if (st == '0') {
                addIm(_quest.iconImageFromAtlas());
            } else {
                g.load.loadImage(ManagerQuest.ICON_PATH + st, onLoadIcon);
            }
        } else {
            g.load.loadImage(ManagerQuest.ICON_PATH + st, onLoadIcon);
        }
        Cc.info("woQuest showItParams 7");
    }

    private function onLoadIcon(bitmap:Bitmap):void { addIm(new Image(Texture.fromBitmap(bitmap))); }
    private function addIm(im:Image):void {
        _questIcon = im;
        if (_questIcon) {
            MCScaler.scale(_questIcon, 146, 146);
            _questIcon.alignPivot();
            _questIcon.x = -200;
            _questIcon.y = -190;
            _source.addChild(_questIcon);
        }
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
