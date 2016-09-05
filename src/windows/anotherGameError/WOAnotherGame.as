/**
 * Created by user on 9/29/15.
 */
package windows.anotherGameError {
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

public class WOAnotherGame extends WindowMain {
    private var _woBG:WindowBackground;

    public function WOAnotherGame() {
        super();
        _windowType = WindowsManager.WO_SERVER_ERROR;
        _woWidth = 460;
        _woHeight = 360;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        var txt:CTextField = new CTextField(420,130,'Игра уже запущена в другом окне');
        txt.setFormat(CTextField.MEDIUM24, 24, Color.WHITE, ManagerFilters.TEXT_BLUE_COLOR);
        txt.autoScale = true;
        txt.x = -210;
        txt.y = -130;
        txt.touchable = false;
        _source.addChild(txt);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cat_blue'));
        im.x = -35;
        im.y = -10;
        _source.addChild(im);
        SOUND_OPEN = SoundConst.WO_AHTUNG;
    }

    override public function showItParams(callback:Function, params:Array):void {
        showIt();
    }


    override protected function deleteIt():void {
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        super.deleteIt();
    }
}
}
