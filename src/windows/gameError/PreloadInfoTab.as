/**
 * Created by andy on 10/6/16.
 */
package windows.gameError {
import manager.Vars;

import starling.core.Starling;
import starling.display.Quad;
import starling.text.TextField;
import starling.text.TextFormat;
import starling.utils.Color;

public class PreloadInfoTab {
    private var g:Vars = Vars.getInstance();

    public function PreloadInfoTab(st:String) {
        var q:Quad = new Quad(500, 200, Color.BLACK);
        g.cont.popupCont.addChild(q);
        q.x = g.managerResize.stageWidth/2 - 250;
        q.y = g.managerResize.stageHeight/2 - 100;
        q.alpha = .9;
        var txt:TextField = new TextField(500, 200, st+' ' + String(g.managerLanguage.allTexts[284]));
        var format:TextFormat = new TextFormat();
        format.size = 36;
        format.color = Color.WHITE;
        txt.format = format;
        txt.x = g.managerResize.stageWidth/2 - 250;
        txt.y = g.managerResize.stageHeight/2 - 100;
        g.cont.popupCont.addChild(txt);
    }
}
}
