/**
 * Created by user on 5/20/15.
 */
package temp {

import build.AreaObject;
import build.AreaObject;

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
        _image = new Image(g.allData.atlas[_data.url].getTexture(_data.image));
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
        var build:AreaObject = g.townArea.createNewBuild(_data);
        g.toolsModifier.startMove(build, afterMove);
    }

    private function afterMove(build:AreaObject, _x:Number, _y:Number):void {
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        g.townArea.pasteBuild(build, _x, _y);
    }

    public function deleteIt():void {
        _data = null;
        source.endClickCallback = null;
        source.deleteIt();
        _txt.dispose();
        _image.dispose();
    }
}
}
