/**
 * Created by user on 9/29/15.
 */
package windows.gameError {
import flash.events.Event;

import manager.ManagerFilters;

import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;

import windows.WOComponents.Birka;

import windows.WOComponents.WindowBackground;

import windows.WindowMain;
import windows.WindowsManager;

public class WOGameError extends WindowMain {
    private var _txtError:TextField;
    private var _b:CButton;
    private var _birka:Birka;

    public function WOGameError() {
        super();
        _windowType = WindowsManager.WO_GAME_ERROR;
        _woWidth = 390;
        _woHeight = 280;
        var _woBG:WindowBackground = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;
        _birka = new Birka('Ошибка', _source, _woWidth, _woHeight);
        var txt:TextField = new TextField(340,100,'Произошла ошибка в игре. Если подобное происходит часто, сообщите в службу поддержки.',g.allData.fonts['BloggerMedium'],20,Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        txt.x = -170;
        txt.y = -45;
        txt.touchable = false;
        _source.addChild(txt);
        _txtError = new TextField(340,100,'Ошибка',g.allData.fonts['BloggerMedium'],24,Color.WHITE);
        _txtError.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtError.x = -170;
        _txtError.y = -110;
        _source.addChild(_txtError);
        _txtError.touchable = false;
        _b = new CButton();
        _b.addButtonTexture(210, 34, CButton.GREEN, true);
        _b.y = 85;
        _source.addChild(_b);
        txt = new TextField(200, 34, "Перезагрузить", g.allData.fonts['BloggerMedium'], 16, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        _b.addChild(txt);
    }

    private function onClickExit(e:Event=null):void {
        hideIt();
    }

    override public function showItParams(callback:Function, params:Array):void {
        _txtError.text = params[0];
        showIt();
    }

    override public function hideIt():void {
        deleteIt();
        super.hideIt();
    }

    override protected function deleteIt():void {
        _source.removeChild(_b);
        _b.deleteIt();
        _b = null;
        super.deleteIt();
    }


}
}
