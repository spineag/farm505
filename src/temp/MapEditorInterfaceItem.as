/**
 * Created by user on 5/20/15.
 */
package temp {

import manager.Vars;

import mouse.ToolsModifier;

import starling.display.Image;
import starling.text.TextField;
import starling.text.TextFieldAutoSize;
import starling.utils.HAlign;
import starling.utils.VAlign;

import utils.CSprite;
import utils.MCScaler;

public class MapEditorInterfaceItem {
    public var source:CSprite;
    private var _txt:TextField;
    private var _image:Image;
    private var _data:Object;

    private var g:Vars = Vars.getInstance();

    public function MapEditorInterfaceItem(ob:Object, type:String) {
        _data = ob;
        _data.type = type;
        source = new CSprite();
       _txt = new TextField(100, 10, _data.name, "Arial", 12, 0xffffff);
        _txt.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
        _txt.hAlign = HAlign.CENTER;
        _txt.vAlign = VAlign.CENTER;
        _txt.x = 45 - _txt.width/2;
        _txt.y = 5;
        source.addChild(_txt);
        if (_data.url == "buildAtlas") {
            _image = new Image(g.tempBuildAtlas.getTexture(_data.image));
        } else if (_data.url == "treeAtlas") {
            _image = new Image(g.treeAtlas.getTexture(_data.image));
        } else {
            _image = new Image(g.mapAtlas.getTexture(_data.image));
        }
        _image.pivotX = _image.width /2;
        _image.pivotY = _image.height /2;
        MCScaler.scale(_image, 50, 50);
        _image.x = 45;
        _image.y = 50;
        source.addChild(_image);
        source.flatten();

        source.endClickCallback = onEndClick;
    }

    public function onEndClick():void {
        if(g.toolsModifier.modifierType !== ToolsModifier.NONE) return;
        // это условие только для включенного режима передвижения, нужно добавить и на остальные
        g.toolsModifier.modifierType = ToolsModifier.MOVE;
        g.toolsModifier.startMove(_data, afterMove);

    }

    private function afterMove(_x:Number, _y:Number):void {
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        g.townArea.createNewBuild(_data, _x, _y);
    }
}
}
