/**
 * Created by andy on 8/12/15.
 */
package windows.reloadPage {
import starling.text.TextField;
import starling.utils.Color;

import windows.Window;

public class WOReloadPage extends Window{
    public function WOReloadPage() {
        super();
        createTempBG(300, 200, Color.GRAY);
        var txt:TextField = new TextField(300,100,"Перегрузите игру","Arial",30,Color.WHITE);
        txt.x = -150;
        txt.y = -50;
        _source.addChild(txt);

        showIt();
    }
}
}
