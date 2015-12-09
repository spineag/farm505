/**
 * Created by user on 9/29/15.
 */
package windows.gameError {
import starling.text.TextField;
import starling.utils.Color;

import windows.Window;

public class WOGameError extends Window{
    public function WOGameError() {
        super();
        _woWidth = 200;
        _woHeight = 100;
        createTempBG();
        var txt:TextField = new TextField(200,100,"Ошибка!","Arial",30,Color.WHITE);
        txt.touchable = false;
        txt.x = -100;
        txt.y = -50;
        _source.addChild(txt);
        createExitButton(hideIt);
    }
}
}
