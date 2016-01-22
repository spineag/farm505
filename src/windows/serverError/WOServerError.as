/**
 * Created by user on 9/29/15.
 */
package windows.serverError {
import flash.events.Event;

import manager.ManagerFilters;

import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;

import windows.WOComponents.Birka;

import windows.WOComponents.WindowBackground;

import windows.Window;

public class WOServerError extends Window{
    private var _txtError:TextField;
    public function WOServerError() {
        super();
        _woWidth = 390;
        _woHeight = 280;
        var _woBG:WindowBackground = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        callbackClickBG = onClickExit;
        new Birka('Ошибка', _source, _woWidth, _woHeight);
        var txt:TextField = new TextField(340,100,'Произошла ошибка в игре. Если подобное происходит часто, сообщите в службу поддержки.',g.allData.fonts['BloggerMedium'],18,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        txt.x = -170;
        txt.y = -45;
        txt.touchable = false;
        _source.addChild(txt);
        _txtError = new TextField(340,100,'Ошибка',g.allData.fonts['BloggerMedium'],24,Color.WHITE);
        _txtError.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtError.x = -170;
        _txtError.y = -90;
        _source.addChild(_txtError);
        var b:CButton = new CButton();
        b.addButtonTexture(210, 34, CButton.GREEN, true);
        b.y = 85;
        _source.addChild(b);
        txt = new TextField(200, 34, "Перезагрузить", g.allData.fonts['BloggerMedium'], 16, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        b.addChild(txt);
    }

    public function showItParams(st:String):void {
        _txtError.text = st;
        showIt();
    }

    public function onClickExit(e:Event=null):void {
        hideIt();
    }
}
}
