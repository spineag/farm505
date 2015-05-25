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

    private var _buttonEditor:CButton;

    private var g:Vars = Vars.getInstance();

    public function EditorButtonInterface() {
//        source = new Sprite();
//        source.y = g.stageHeight - 100;
//        g.cont.interfaceCont.addChild(source);
//
//        var shape:Shape = new Shape();
//        shape.graphics.beginFill(0xffffff);
//        shape.graphics.moveTo(0,10);
//        shape.graphics.lineTo(10,2);
//        shape.graphics.lineTo(10,18);
//        shape.graphics.lineTo(0,10);
//        shape.graphics.endFill();
//        var BMP:BitmapData = new BitmapData(10, 20, true, 0x00000000);
//        BMP.draw(shape);
//        var Txr:Texture = Texture.fromBitmapData(BMP,false, false);
//        _buttonEditor = new CButton(Txr);
//        _buttonEditor.x = g.stageWidth - 45;
//        _buttonEditor.y = 0;
//        source.addChild(_buttonEditor);

    }

//        public function IconButton(s:String):void {
//            s:String = new Image(g.mapAtlas.getTexture("Move"));
//            _moveTexture.pivotX = _moveTexture.width / 2;
//            _moveTexture.pivotY = _moveTexture.height / 2;
//            _moveTexture.x = 300;
//            _moveTexture.y = -10;
//            source.addChild(_moveTexture);
//
//
//        }
    }

}
