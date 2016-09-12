/**
 * Created by user on 9/12/16.
 */
package windows.quest {
import flash.display.Bitmap;
import manager.ManagerFilters;
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
    private var _dataQuest:Object;
    private var _pl:HintBackground;
    private var _txtInfo:CTextField;
    private var _imageQuest:Image;
    private var _btnOk:CButton;
    private var _txtBtn:CTextField;
    private var _questItem:WOQuestItem;
    private var _award:WOQuestAward;

    public function WOQuest() {
        super();
        _windowType = WindowsManager.WO_QUEST;
        _woWidth = 550;
        _woHeight = 400;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;
        _birka = new Birka('Задание', _source, _woWidth, _woHeight);

        _bgC = new CartonBackground(460, 188);
        _bgC.filter =  ManagerFilters.SHADOW;
        _bgC.x = -_woWidth/2 + 46;
        _bgC.y = -_woHeight/2 + 181;
        _source.addChild(_bgC);

        _pl = new HintBackground(310, 97, HintBackground.LONG_TRIANGLE, HintBackground.LEFT_CENTER);
        _pl.x = -_woWidth/2 + 165;
        _pl.y = -_woHeight/2 + 110;
        _pl.addShadow();
        _source.addChild(_pl);
        _txtInfo = new CTextField(310,97,'Выполни следующее задание, чтобы получить награду');
        _txtInfo.setFormat(CTextField.MEDIUM18, 18, ManagerFilters.BLUE_COLOR);
        _pl.inSprite.addChild(_txtInfo);

        _btnOk = new CButton();
        _btnOk.addButtonTexture(158, 46, CButton.GREEN, true);
        _txtBtn = new CTextField(158,46,'OK');
        _txtBtn.setFormat(CTextField.MEDIUM24, 20, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _btnOk.addChild(_txtBtn);
        _btnOk.x = 0;
        _btnOk.y = -_woHeight/2 + 390;
        _source.addChild(_btnOk);
        _btnOk.clickCallback = hideIt;

        _award = new WOQuestAward(_source);
        _questItem = new WOQuestItem(_source);
    }

    override public function showItParams(callback:Function, params:Array):void {
        _dataQuest = params[0];
        _imageQuest = new Image(Texture.fromBitmap(g.pBitmaps[g.dataPath.getQuestIconPath() + _dataQuest.iconUrl].create() as Bitmap));
        _imageQuest.x = -_woWidth/2 + 65;
        _imageQuest.y = -_woHeight/2 + 50;
        _source.addChild(_imageQuest);

        _award.fillIt(_dataQuest.awardCount);
        _questItem.fillIt(_dataQuest);
        onWoShowCallback = onShow;
        super.showIt();
    }

    private function onShow():void {
        _birka.updateTextField();
        _txtBtn.updateIt();
        _txtInfo.updateIt();
        _award.updateTextField();
        _questItem.updateTextField();
    }

    override protected function deleteIt():void {
        _birka.deleteIt();
        _award.deleteIt();
        _questItem.deleteIt();
        _source.removeChild(_btnOk);
        _btnOk.deleteIt();
        _source.removeChild(_pl);
        _pl.deleteIt();
        _source.removeChild(_bgC);
        _bgC.deleteIt();
        super.deleteIt();
    }
}
}
