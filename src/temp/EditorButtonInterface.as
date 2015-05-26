/**
 * Created by user on 5/25/15.
 */
package temp {

import flash.display.BitmapData;
import flash.display.Shape;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

import utils.CButton;
import utils.MCScaler;

public class EditorButtonInterface {

    public var source:Sprite;

    private var _iconEditor:Image;

    private var _buttonEditor:CButton;
    private var g:Vars = Vars.getInstance();

    public function EditorButtonInterface() {
        source = new Sprite();
        source.y = g.stageHeight - 100;
        g.cont.interfaceCont.addChild(source);
        var shape:Shape = new Shape();
        shape.graphics.beginFill(0xffffff);
        shape.graphics.moveTo(0,0);
        shape.graphics.lineTo(50,0);
        shape.graphics.lineTo(50,20);
        shape.graphics.lineTo(0,20);
        shape.graphics.lineTo(0,0);
        shape.graphics.endFill();
        var BMP:BitmapData = new BitmapData(50, 20, true, 0x00000000);
        BMP.draw(shape);
        var Txr:Texture = Texture.fromBitmapData(BMP,false, false);
        _buttonEditor = new CButton(Txr);
        source.addChild(_buttonEditor);
    }

        public function IconButton(s:String):void {
            _iconEditor = new Image(g.mapAtlas.getTexture(s));
            MCScaler.scale(_iconEditor,50,50);
            _iconEditor.pivotX = _iconEditor.width / 2;
            _iconEditor.pivotY = _iconEditor.height / 2;
            _iconEditor.x = 0;
            _iconEditor.y = g.stageHeight - 100;
            source.addChild(_iconEditor);
        }
    }
}
