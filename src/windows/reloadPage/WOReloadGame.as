/**
 * Created by andy on 8/12/15.
 */
package windows.reloadPage {
import manager.ManagerFilters;

import media.SoundConst;

import starling.text.TextField;
import starling.utils.Color;

import utils.CTextField;

import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOReloadGame extends WindowMain{
    private var _woBG:WindowBackground;

    public function WOReloadGame() {
        super();
        _windowType = WindowsManager.WO_RELOAD_GAME;
        _woWidth = 400;
        _woHeight = 300;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        var txt:CTextField = new CTextField(400,300,"Перегрузите игру");
        txt.setFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.x = -200;
        txt.y = -150;
        _source.addChild(txt);
        SOUND_OPEN = SoundConst.WO_AHTUNG;
    }

    override public function showItParams(f:Function, params:Array):void {
        super.showIt();
    }
}
}
