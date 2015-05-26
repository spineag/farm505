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
    public var spriteBtn;Sprite;
    public var iconEditor:Image;

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
        _buttonEditor.x = 400;
        source.addChild(_buttonEditor);

    }


        public function IconButton(s:String):void {


            spriteBtn = new Sprite();
            iconEditor = new Image(g.mapAtlas.getTexture(""));
            MCScaler.scale(iconEditor,50,50);
            iconEditor.pivotX = iconEditor.width / 2;
            iconEditor.pivotY = iconEditor.height / 2;
            iconEditor.x = 0;
            iconEditor.y = g.stageHeight - 100;
            spriteBtn.addChild(iconEditor)
            s = new String(spriteBtn);



        }
    }

}
