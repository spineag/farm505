/**
 * Created by user on 9/12/16.
 */
package windows.quest {
import com.junkbyte.console.Cc;

import flash.display.Bitmap;
import manager.ManagerFilters;

import quest.QuestStructure;

import starling.display.Image;
import starling.textures.Texture;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import windows.WOComponents.Birka;
import windows.WOComponents.CartonBackground;
import windows.WOComponents.HintBackground;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOQuest extends WindowMain{
    private var _woBG:WindowBackground;
    private var _birka:Birka;
    private var _bgC:CartonBackground;
    private var _dataQuest:QuestStructure;
    private var _txtInfo:CTextField;
//    private var _questItem:WOQuestItem;
    private var _award:WOQuestAward;

    public function WOQuest() {
        super();
        _windowType = WindowsManager.WO_QUEST;
        _woWidth = 550;
        _woHeight = 600;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;
        _birka = new Birka('Задание', _source, _woWidth, _woHeight);

        _bgC = new CartonBackground(480, 240);
        _bgC.filter =  ManagerFilters.SHADOW;
        _bgC.x = -240;
        _bgC.y = 15;
        _source.addChild(_bgC);

        _txtInfo = new CTextField(300, 100, '');
        _txtInfo.setFormat(CTextField.MEDIUM30, 30, ManagerFilters.ORANGE_COLOR, Color.WHITE);
        _txtInfo.x = -150;
        _txtInfo.y = -310;
        _txtInfo.touchable = false;
        _source.addChild(_txtInfo);

//        _questItem = new WOQuestItem(_source);
    }

    override public function showItParams(callback:Function, params:Array):void {
        _dataQuest = params[0];
        if (g.allData.atlas['questAtlas']) {
            var im:Image;
            if (_dataQuest.id % 2) im = new Image(g.allData.atlas['questAtlas'].getTexture('quest_window_1'));
            else im = new Image(g.allData.atlas['questAtlas'].getTexture('quest_window_2'));
            if (im) {
                im.x = -im.width/2;
                im.y = -300;
                im.touchable = false;
                _source.addChild(im);
            } else {
                Cc.error('WOQuest showItParams:: no image for bg quest');
            }
        } else {
            Cc.error('WOQuest showItParams:: no questAtlas');
        }
        _txtInfo.text = _dataQuest.description;
        _source.setChildIndex(_txtInfo, _source.numChildren-1);

        _award = new WOQuestAward(_source, _dataQuest.awards);
//        _award.fillIt(_dataQuest);
//        _questItem.fillIt(_dataQuest);
        onWoShowCallback = onShow;
        updateInfo(false);
        super.showIt();
    }

    private function onShow():void {
        _birka.updateTextField();
        _txtInfo.updateIt();
//        _award.updateTextField();
//        _questItem.updateTextField();
    }

    private function onClick():void {
//        if (_dataQuest.isDone) {
//            _award.onGetAward();
//            g.managerQuest.onGetAwardFromQuest();
//        }
        super.hideIt();
    }

    public function updateInfo(needCheckItem:Boolean = true):void {
//        if (_dataQuest.isDone) {
//            _txtBtn.text = 'Забрать';
//        } else {
//            _txtBtn.text = 'ОК';
//        }
//        if (needCheckItem) _questItem.updateInfo();
    }

    override protected function deleteIt():void {
        g.managerQuest.onHideWO();
        _birka.deleteIt();
//        _award.deleteIt();
//        _questItem.deleteIt();
        if (_bgC) {
            _source.removeChild(_bgC);
            _bgC.deleteIt();
        }
        super.deleteIt();
    }
}
}
