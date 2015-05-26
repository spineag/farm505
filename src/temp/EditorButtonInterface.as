/**
 * Created by user on 5/25/15.
 */
package temp {


import manager.Vars;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;

import utils.MCScaler;

public class EditorButtonInterface {

    public var source:Sprite;
    private var _iconEditor:Image;
    private var g:Vars = Vars.getInstance();

    public function EditorButtonInterface() {
        source = new Sprite();
        source.y = - 10;
        var quad:Quad = new Quad(30, 50, Color.WHITE);
        source.addChild(quad);
    }

    public function setIconButton(s:String):void {
        _iconEditor = new Image(g.mapAtlas.getTexture(s));
        MCScaler.scale(_iconEditor, 30, 30);
        source.addChild(_iconEditor);
    }
}
}
