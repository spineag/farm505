/**
 * Created by user on 9/29/15.
 */
package windows.serverError {
import manager.ManagerFilters;

import media.SoundConst;

import starling.display.Image;

import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;
import utils.CButton;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOServerError extends WindowMain {
    private var _txtError:TextField;
    private var _txtErrorNew:TextField;
    private var _woBG:WindowBackground;
    private var _b:CButton;

    public function WOServerError() {
        super();
        _windowType = WindowsManager.WO_SERVER_ERROR;
        _woWidth = 460;
        _woHeight = 320;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        var txt:TextField = new TextField(420,80,'Произошла ошибка в игре. Если подобное происходит часто, обратитесь в службу поддержки.');
        txt.format.setTo(g.allData.bFonts['BloggerMedium18'],18,Color.WHITE);
        txt.autoScale = true;
        txt.filter = ManagerFilters.TEXT_STROKE_BLUE;
        txt.x = -210;
        txt.y = -120;
        txt.touchable = false;
        _source.addChild(txt);
        _txtError = new TextField(340,100,'Ошибка Сервера');
        _txtError.format.setTo(g.allData.bFonts['BloggerBold24'],22,Color.WHITE);
        _txtError.filter = ManagerFilters.TEXT_STROKE_BLUE;
        _txtError.x = -170;
        _txtError.y = -170;
        _source.addChild(_txtError);
        _txtErrorNew = new TextField(420,100,'');
        _txtErrorNew.format.setTo(g.allData.bFonts['BloggerBold24'],22,Color.WHITE);
        _txtErrorNew.filter = ManagerFilters.TEXT_STROKE_BLUE;
        _txtErrorNew.x = -165;
        _txtErrorNew.y = -170;
        _source.addChild(_txtErrorNew);

        _txtError.touchable = false;
        _b = new CButton();
        _b.addButtonTexture(210, 34, CButton.GREEN, true);
        _b.y = 120;
        _source.addChild(_b);
        txt = new TextField(200, 34, "Перезагрузить");
        txt.format.setTo(g.allData.bFonts['BloggerMedium18'], 16, Color.WHITE);
        txt.filter = ManagerFilters.TEXT_STROKE_GREEN;
        _b.addChild(txt);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cat_blue'));
        im.x = -35;
        im.y = -50;
        _source.addChild(im);
        _b.clickCallback = onClick;
        SOUND_OPEN = SoundConst.WO_AHTUNG;
    }

    override public function showItParams(callback:Function, params:Array):void {
        _txtError.text = "Ошибка сервера " + params[0];
        showIt();
    }

    private function onClick():void {
        g.socialNetwork.reloadGame();
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
