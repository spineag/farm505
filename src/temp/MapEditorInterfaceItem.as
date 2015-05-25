/**
 * Created by user on 5/20/15.
 */
package temp {
import flash.geom.Point;

import manager.Vars;

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.text.TextFieldAutoSize;
import starling.utils.HAlign;
import starling.utils.VAlign;

import utils.CSprite;

import utils.MCScaler;

public class MapEditorInterfaceItem {
    public var type:String;
    public var source:CSprite;
    private var _txt:TextField;
    private var _image:Image;
    private var _data:Object;

    private var g:Vars = Vars.getInstance();

    public function MapEditorInterfaceItem(ob:Object) {
        _data = ob;
        source = new CSprite();
       _txt = new TextField(100, 10, _data.name, "Arial", 12, 0xffffff);
        _txt.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
        _txt.hAlign = HAlign.CENTER;
        _txt.vAlign = VAlign.CENTER;
        _txt.x = 45 - _txt.width/2;
        _txt.y = 5;
        source.addChild(_txt);
        _image = new Image(g.mapAtlas.getTexture(_data.image));
        _image.pivotX = _image.width /2;
        _image.pivotY = _image.height /2;
        MCScaler.scale(_image,70, 70);
        _image.x = 45;
        _image.y = 50;
        source.addChild(_image);
        source.flatten();

        source.endClickCallback = onEndClick;
    }

    private function onEndClick():void {
        g.toolsModifier.startMove(_data.id, type, afterMove);
    }

    private function afterMove(p:Point):void {
        trace('point: ' + p);
    }
}
}
