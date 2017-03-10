/**
 * Created by user on 7/14/16.
 */
package windows.serverNoWork {
import manager.ManagerFilters;

import media.SoundConst;

import starling.display.Image;

import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;

import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOSeverNoWork  extends WindowMain {
    private var _txtError:CTextField;
    private var _txtInfo:CTextField;
    private var _txtBtn:CTextField;
    private var _woBG:WindowBackground;
    private var _b:CButton;

    public function WOSeverNoWork() {
        super();
        _windowType = WindowsManager.WO_SERVER_ERROR;
        _woWidth = 460;
        _woHeight = 340;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        _txtInfo = new CTextField(420,80,String(g.managerLanguage.allTexts[286]));
        _txtInfo.setFormat(CTextField.MEDIUM18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtInfo.x = -210;
        _txtInfo.y = -130;
        _source.addChild(_txtInfo);
        _txtError = new CTextField(340,100,String(g.managerLanguage.allTexts[287]));
        _txtError.setFormat(CTextField.BOLD24, 22, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtError.x = -170;
        _txtError.y = -170;
        _source.addChild(_txtError);
        _txtError.touchable = false;
        _b = new CButton();
        _b.addButtonTexture(210, 34, CButton.GREEN, true);
        _b.y = 120;
        _source.addChild(_b);
        _txtBtn = new CTextField(200, 34, String(g.managerLanguage.allTexts[281]));
        _txtBtn.setFormat(CTextField.MEDIUM18, 16, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _b.addChild(_txtBtn);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cat_blue'));
        im.x = -35;
        im.y = -65;
        _source.addChild(im);
        _b.clickCallback = onClick;
        SOUND_OPEN = SoundConst.WO_AHTUNG;
    }

    override public function showItParams(callback:Function, params:Array):void {
        super.showIt();
    }

    private function onClick():void {
        g.socialNetwork.reloadGame();
    }

    override protected function deleteIt():void {
        if (_txtBtn) {
            _b.removeChild(_txtBtn);
            _txtBtn.deleteIt();
            _txtBtn = null;
        }
        if (_txtError) {
            _source.removeChild(_txtError);
            _txtError.deleteIt();
            _txtError = null;
        }
        if (_txtInfo) {
            _txtInfo.removeChild(_txtInfo);
            _txtInfo.deleteIt();
            _txtInfo = null;
        }
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        _source.removeChild(_b);
        _b.deleteIt();
        _b = null;
        super.deleteIt();
    }
}
}
