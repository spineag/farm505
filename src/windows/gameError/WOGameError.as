/**
 * Created by user on 9/29/15.
 */
package windows.gameError {
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import windows.Window;

public class WOGameError extends Window{
    public function WOGameError() {
        super();
        createTempBG(200, 100, Color.GRAY);
        var txt:TextField = new TextField(200,100,"Ошибка!","Arial",30,Color.WHITE);
        txt.touchable = false;
        txt.x = -100;
        txt.y = -50;
        _source.addChild(txt);
        createExitButton(g.interfaceAtlas.getTexture('btn_exit'), '', g.interfaceAtlas.getTexture('btn_exit_click'), g.interfaceAtlas.getTexture('btn_exit_hover'));
        _btnExit.x = 100;
        _btnExit.y = -50;
        _btnExit.addEventListener(Event.TRIGGERED, hideIt);
    }
}
}
