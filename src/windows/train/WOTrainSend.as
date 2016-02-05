/**
 * Created by user on 1/26/16.
 */
package windows.train {
import manager.ManagerFilters;

import starling.display.Image;

import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;

import windows.WOComponents.WindowBackground;
import windows.Window;

public class WOTrainSend extends Window{
    private var _woBG:WindowBackground;
    private var _contYes:CButton;
    private var _contNo:CButton;
    private var _callback:Function;
    public function WOTrainSend() {
        _woWidth = 460;
        _woHeight = 308;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        var txt:TextField;
        txt = new TextField(300,200,"ПОГРУЗКА НЕ ЗАВЕРШЕНА!",g.allData.fonts['BloggerBold'],20,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        txt.x = -150;
        txt.y = -210;
        _source.addChild(txt);
        txt = new TextField(300,200,"Отправить корзину не загрузив полностью?",g.allData.fonts['BloggerBold'],14,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        txt.x = -150;
        txt.y = -185;
        _source.addChild(txt);
        _contNo = new CButton();
        _contNo.addButtonTexture(80, 40, CButton.YELLOW, true);
        _contYes = new CButton();
        _contYes.addButtonTexture(80, 40, CButton.YELLOW, true);
        txt = new TextField(50,50,"Да",g.allData.fonts['BloggerBold'],18,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_YELLOW;
        txt.x = 15;
        txt.y = -5;
        _contYes.addChild(txt);
        txt = new TextField(50,50,"Нет",g.allData.fonts['BloggerBold'],18,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_YELLOW;
        txt.x = 15;
        txt.y = -5;
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('basket_big'));
        im.y = -70;
        im.x = -65;
        _source.addChild(im);
        _contYes.x = 100;
        _contYes.y = 80;
        _contNo.x = -100;
        _contNo.y = 80;
        _contNo.addChild(txt);
        _source.addChild(_contYes);
        _source.addChild(_contNo);
        _contNo.clickCallback = onNo;
        _contYes.clickCallback = onYes;
        callbackClickBG = onClickExit;

    }

    public function showItTrain(f:Function):void {
        _callback = f;
        showIt();

    }
    private function onClickExit():void {
        hideIt();
    }

    private function onYes():void {
        if (_callback != null) {
            _callback.apply(null,[true]);
            _callback = null;
        }
        onClickExit();
    }

    private function onNo():void {
        onClickExit();
    }
}
}
