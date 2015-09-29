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
        createTempBG(300, 400, Color.GRAY);
        var txt:TextField = new TextField(300,100,"Ошибка! Перегрузите игру","Arial",30,Color.WHITE);
        txt.x = -150;
        txt.y = -200;
        _source.addChild(txt);
        _txtError = new TextField(300,300,"Ошибка! Перегрузите игру","Arial",20,Color.WHITE);
        txt.x = -150;
        txt.y = 50;
        _source.addChild(_txtError);
    }

    public function showItParams(st:String):void {
        _txtError.text = st;
        showIt();
    }
}
}
