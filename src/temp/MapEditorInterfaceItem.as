/**
 * Created by user on 5/20/15.
 */
package temp {
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.text.TextFieldAutoSize;
import starling.utils.HAlign;
import starling.utils.VAlign;

import utils.MCScaler;

public class MapEditorInterfaceItem {
    public var source:Sprite;
    private var _txt:TextField;
    private var _image:Image;
    private var _data:Object;
    private var g:Vars = Vars.getInstance();
    public function MapEditorInterfaceItem(ob:Object) {
        _data = ob;
        source = new Sprite();
       _txt = new TextField(100, 10, _data.name, "Arial", 12, 0xffffff);
        _txt.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
        _txt.hAlign = HAlign.CENTER;
        _txt.vAlign = VAlign.CENTER;
        _txt.x = 45;
        _txt.y = 5;
        source.addChild(_txt);

        switch (_data.image) {
            case "tile 3x3":
                _image = new Image(g.mapAtlas.getTexture("tile3x3"));
                break;
            case "tile 4x4":
                _image = new Image(g.mapAtlas.getTexture("tile4x4"));
                break;
        }
        _image.pivotX = _image.width /2;
        _image.pivotY = _image.height /2;
        MCScaler.scale(_image,70, 70);
        _image.x = 45;
        _image.y = 50;
        source.addChild(_image);
        source.flatten();
    }
}
}
