/**
 * Created by user on 5/20/15.
 */
package temp {
import build.WorldObject;

import data.BuildType;

import manager.Vars;
import mouse.ToolsModifier;
import starling.display.Image;
import starling.display.Quad;
import starling.text.TextField;
import starling.text.TextFieldAutoSize;
import starling.utils.Color;

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
       _txt = new TextField(100, 10, _data.name);
        _txt.format.setTo("Arial", 12, 0xffffff);
        _txt.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
        _txt.x = 45 - _txt.width/2;
        _txt.y = 5;
        source.addChild(_txt);
        if (_data.buildType == BuildType.CHEST_YELLOW) {
            var quad:Quad = new Quad(50, 50, Color.YELLOW);
            quad.pivotX = quad.width / 2;
            quad.pivotY = quad.height / 2;
            quad.x = 45;
            quad.y = 50;
            source.addChild(quad);
        } else {
            _image = new Image(g.allData.atlas[_data.url].getTexture(_data.image));
            _image.pivotX = _image.width / 2;
            _image.pivotY = _image.height / 2;
            MCScaler.scale(_image, 50, 50);
            _image.x = 45;
            _image.y = 50;
            source.addChild(_image);
        }
        source.endClickCallback = onEndClick;
    }

    public function onEndClick():void {
        if(g.toolsModifier.modifierType !== ToolsModifier.NONE) return;
        // это условие только для включенного режима передвижения, нужно добавить и на остальные
        g.toolsModifier.modifierType = ToolsModifier.MOVE;
        var build:WorldObject = g.townArea.createNewBuild(_data);
        g.selectedBuild = build;
        g.toolsModifier.startMove(build, afterMove);
    }

    private function afterMove(build:WorldObject, _x:Number, _y:Number):void {
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
