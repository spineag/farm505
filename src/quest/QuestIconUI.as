/**
 * Created by andy on 12/29/16.
 */
package quest {
import manager.Vars;

import starling.display.Image;

import utils.CSprite;

public class QuestIconUI {
    private var g:Vars = Vars.getInstance();
    private var _source:CSprite;

    public function QuestIconUI() {
        _source = new CSprite();
        _source.x = 70;
        g.cont.interfaceCont.addChild(_source);
        checkContPosition();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_quest_icon'));
        im.x = -im.width/2;
        im.y = -im.height/2;
        _source.addChild(im);
    }

    public function checkContPosition():void {
        if (g.user.level > 16) {
            _source.y = 270;
        } else {
            _source.y = 180;
        }
    }

    public function hideIt(v:Boolean):void {
        _source.visible = !v;
    }
}
}
