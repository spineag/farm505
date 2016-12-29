/**
 * Created by andy on 12/29/16.
 */
package quest {
import manager.Vars;

import utils.CSprite;

public class QuestIconUI {
    private var g:Vars = Vars.getInstance();
    private var _source:CSprite;

    public function QuestIconUI() {
        _source = new CSprite();
        _source.x = 70;
        g.cont.interfaceCont.addChild(_source);
        checkContPosition();
    }

    public function checkContPosition():void {
        if (g.user.level > 16) {
            _source.y = 210;
        } else {
            _source.y = 120;
        }
    }

    public function hideIt(v:Boolean):void {
        _source.visible = !v;
    }
}
}
