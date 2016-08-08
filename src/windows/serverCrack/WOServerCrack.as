/**
 * Created by user on 7/14/16.
 */
package windows.serverCrack {
import com.junkbyte.console.Cc;

import manager.ManagerFilters;

import media.SoundConst;

import starling.display.Image;

import starling.text.TextField;
import starling.utils.Color;
import utils.CButton;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOServerCrack  extends WindowMain {
    private var _txtError:TextField;
    private var _woBG:WindowBackground;
    private var _b:CButton;

    public function WOServerCrack() {
        super();
        _windowType = WindowsManager.WO_SERVER_CRACK;
        _woWidth = 460;
        _woHeight = 340;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        var txt:TextField = new TextField(420,80,'Не правильные данные',g.allData.fonts['BloggerMedium'],18,Color.WHITE);
        txt.autoScale = true;
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        txt.x = -210;
        txt.y = -130;
        txt.touchable = false;
        _source.addChild(txt);
        _txtError = new TextField(340,100,'Ошибка данных',g.allData.fonts['BloggerBold'],22,Color.WHITE);
        _txtError.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtError.x = -170;
        _txtError.y = -170;
        _source.addChild(_txtError);
        _txtError.touchable = false;
        _b = new CButton();
        _b.addButtonTexture(210, 34, CButton.GREEN, true);
        _b.y = 120;
        _source.addChild(_b);
        txt = new TextField(200, 34, "Перезагрузить", g.allData.fonts['BloggerMedium'], 16, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        _b.addChild(txt);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cat_blue'));
        im.x = -35;
        im.y = -65;
        _source.addChild(im);
        _b.clickCallback = onClick;
        SOUND_OPEN = SoundConst.WO_AHTUNG;
    }

    override public function showItParams(callback:Function, params:Array):void {
        showIt();

        if (params[0]) {
            _txtError.text = 'Ошибка данных ' + String(params[0]);
            Cc.error('WOServerCrack: status=' + params[0]);
        }
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
