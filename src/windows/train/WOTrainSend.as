/**
 * Created by user on 1/26/16.
 */
package windows.train {
import build.train.Train;

import manager.ManagerFilters;
import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;
import utils.CButton;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOTrainSend extends WindowMain {
    private var _woBG:WindowBackground;
    private var _btnYes:CButton;
    private var _btnNo:CButton;
    private var _callback:Function;
    private var _build:Train;

    public function WOTrainSend() {
        super();
        _windowType = WindowsManager.WO_TRAIN_SEND;
        _woWidth = 460;
        _woHeight = 308;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        var txt:TextField;
        txt = new TextField(300,200,"ПОГРУЗКА НЕ ЗАВЕРШЕНА!");
        txt.format.setTo(g.allData.bFonts['BloggerBold24'],22,Color.WHITE);
        txt.x = -150;
        txt.y = -210;
        ManagerFilters.setStrokeStyle(txt, ManagerFilters.TEXT_BLUE_COLOR);
        _source.addChild(txt);
        txt = new TextField(350,50,"Отправить корзину не загрузив полностью?");
        txt.format.setTo(g.allData.bFonts['BloggerMedium18'],18,Color.WHITE);
        txt.x = -180;
        txt.y = -110;
        ManagerFilters.setStrokeStyle(txt, ManagerFilters.TEXT_BLUE_COLOR);
        _source.addChild(txt);
        _btnNo = new CButton();
        _btnNo.addButtonTexture(80, 40, CButton.YELLOW, true);
        _btnYes = new CButton();
        _btnYes.addButtonTexture(80, 40, CButton.GREEN, true);
        txt = new TextField(50,50,"Да");
        txt.format.setTo(g.allData.bFonts['BloggerBold18'],18,Color.WHITE);
        txt.x = 15;
        txt.y = -5;
        ManagerFilters.setStrokeStyle(txt, ManagerFilters.TEXT_GREEN_COLOR);
        _btnYes.addChild(txt);
        txt = new TextField(50,50,"Нет");
        txt.format.setTo(g.allData.bFonts['BloggerBold18'],18,Color.WHITE);
        txt.x = 15;
        txt.y = -5;
        ManagerFilters.setStrokeStyle(txt, ManagerFilters.TEXT_YELLOW_COLOR);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('basket_big'));
        im.y = -70;
        im.x = -65;
        _source.addChild(im);
        _btnYes.x = 100;
        _btnYes.y = 80;
        _btnNo.x = -100;
        _btnNo.y = 80;
        _btnNo.addChild(txt);
        _source.addChild(_btnYes);
        _source.addChild(_btnNo);
        _btnNo.clickCallback = onNo;
        _btnYes.clickCallback = onYes;
        _callbackClickBG = onNo;
    }

    override public function showItParams(f:Function, params:Array):void {
        _callback = f;
        _build = params[0];
        super.showIt();
    }

    private function onYes():void {
//        if (_callback != null) {
//            _callback.apply(null,[true]);
//            _callback = null;
//        }
        (_build as Train).fullTrain(true);
//        g.windowsManager.uncasheWindow();
        super.hideIt();
    }

    private function onNo():void {
//        g.windowsManager.uncasheWindow();
        super.hideIt();
    }

    override protected function deleteIt():void {
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        _callback = null;
        _source.removeChild(_btnNo);
        _btnNo.deleteIt();
        _btnNo = null;
        _source.removeChild(_btnYes);
        _btnYes.deleteIt();
        _btnYes = null;
        super.deleteIt();
    }
}
}
