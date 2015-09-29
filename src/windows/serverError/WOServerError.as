/**
 * Created by user on 9/29/15.
 */
package windows.serverError {
import starling.text.TextField;
import starling.utils.Color;

import windows.Window;

public class WOServerError extends Window{
    private var _txtError:TextField;
    public function WOServerError() {
        super();
        createTempBG(400, 400, Color.GRAY);
        var txt:TextField = new TextField(400,100,"Ошибка! Перегрузите игру","Arial",30,Color.WHITE);
        txt.x = -200;
        txt.y = -200;
        _source.addChild(txt);
        _txtError = new TextField(400,300,"","Arial",20,Color.WHITE);
        _txtError.x = -200;
        _txtError.y = -100;
        _source.addChild(_txtError);
    }

    public function showItParams(st:String):void {
        _txtError.text = st;
        showIt();
    }
}
}
