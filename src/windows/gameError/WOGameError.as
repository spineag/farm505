/**
 * Created by user on 9/29/15.
 */
package windows.gameError {
import flash.events.Event;
import manager.ManagerFilters;

import media.SoundConst;

import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;
import utils.CButton;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOGameError extends WindowMain {
    private var _txtError:TextField;
    private var _b:CButton;
    private var _woBG:WindowBackground;

    public function WOGameError() {
        super();
        _windowType = WindowsManager.WO_GAME_ERROR;
        _woWidth = 460;
        _woHeight = 340;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        var txt:TextField = new TextField(420,80,'Произошла ошибка в игре. Если подобное происходит часто, обратитесь в службу поддержки.');
        txt.format.setTo(g.allData.bFonts['BloggerMedium18'],18,Color.WHITE);
        txt.autoScale = true;
        txt.x = -210;
        txt.y = -120;
        ManagerFilters.setStrokeStyle(txt, ManagerFilters.TEXT_BLUE_COLOR);
        txt.touchable = false;
        _source.addChild(txt);
        _txtError = new TextField(340,100,'Ошибка');
        _txtError.format.setTo(g.allData.bFonts['BloggerBold24'],22,Color.WHITE);
        _txtError.x = -170;
        _txtError.y = -170;
        ManagerFilters.setStrokeStyle(_txtError, ManagerFilters.TEXT_BLUE_COLOR);
        _source.addChild(_txtError);
        _txtError.touchable = false;
        _b = new CButton();
        _b.addButtonTexture(210, 34, CButton.GREEN, true);
        _b.y = 120;
        _source.addChild(_b);
        txt = new TextField(200, 34, "Перезагрузить");
        txt.format.setTo(g.allData.bFonts['BloggerMedium18'], 16, Color.WHITE);
        ManagerFilters.setStrokeStyle(txt, ManagerFilters.TEXT_GREEN_COLOR);
        _b.addChild(txt);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cat_blue'));
        im.x = -35;
        im.y = -50;
        _source.addChild(im);
        _b.clickCallback = onClick;
        SOUND_OPEN = SoundConst.WO_AHTUNG;
    }

    override public function showItParams(callback:Function, params:Array):void {
//        _txtError.text = params[0];
        showIt();
    }

    private function onClick():void {
        if (g.isDebug) hideIt();
        else g.socialNetwork.reloadGame();
    }

    override protected function deleteIt():void {
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
