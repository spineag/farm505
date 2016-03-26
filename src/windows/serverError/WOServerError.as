/**
 * Created by user on 9/29/15.
 */
package windows.serverError {
import manager.ManagerFilters;
import starling.text.TextField;
import starling.utils.Color;
import utils.CButton;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOServerError extends WindowMain {
    private var _txtError:TextField;
    private var _woBG:WindowBackground;
    private var _btn:CButton;

    public function WOServerError() {
        super();
        _windowType = WindowsManager.WO_SERVER_ERROR;
        _woWidth = 390;
        _woHeight = 280;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(hideIt);
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
        _btn = new CButton();
        _btn.addButtonTexture(210, 34, CButton.GREEN, true);
        _btn.y = 85;
        _source.addChild(_btn);
        txt = new TextField(200, 34, "Перезагрузить", g.allData.fonts['BloggerMedium'], 16, Color.WHITE);
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        _btn.addChild(txt);
    }

    override public function showItParams(callback:Function, params:Array):void {
        _txtError.text = params[0];
        showIt();
    }

    override protected function deleteIt():void {
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        _source.removeChild(_btn);
        _btn.deleteIt();
        _btn = null;
        super.deleteIt();
    }
}
}
