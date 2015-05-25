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
    private var button:Sprite;
//    private var _moveBack:Image;
//    private var _rotateBack:Image;
//    private var _cancelBack:Image;
    private var _moveTexture:Image;
    private var _rotateTexture:Image;
    private var _cancelTexture:Image;

    private var g:Vars = Vars.getInstance();

    public function EditorButtonInterface() {
        source = new Sprite();
        source.y = g.stageHeight - 100;
        g.cont.interfaceCont.addChild(source);
        button = new Sprite();
        source.addChild(button);



        _moveTexture = new Image(g.mapAtlas.getTexture("Move"));
        _moveTexture.pivotX = _moveTexture.width /2;
        _moveTexture.pivotY = _moveTexture.height /2;
        _moveTexture.x = 300;
        _moveTexture.y = -10;
        source.addChild(_moveTexture);

        _rotateTexture = new Image(g.mapAtlas.getTexture("Rotate"));
        _rotateTexture.pivotX = _rotateTexture.width /2;
        _rotateTexture.pivotY = _rotateTexture.height /2;
        _rotateTexture.x = 400;
        _rotateTexture.y = -10;
        source.addChild(_rotateTexture);

        _cancelTexture = new Image(g.mapAtlas.getTexture("Cancel"));
        _cancelTexture.pivotX = _cancelTexture.width /2;
        _cancelTexture.pivotY = _cancelTexture.height /2;
        _cancelTexture.x = 500;
        _cancelTexture.y = -10;
        source.addChild(_cancelTexture);

//        var shape:Shape = new Shape();
//        shape.graphics.beginFill(0xffffff);
//        shape.graphics.moveTo(0,0);
//        shape.graphics.lineTo(50,0);
//        shape.graphics.lineTo(50,50);
//        shape.graphics.lineTo(0,50);
//        shape.graphics.lineTo(0,0);
//        shape.graphics.endFill();
//        var BMP:BitmapData = new BitmapData(50, 50, true, 0x00000000);
//        BMP.draw(shape);
//        var Txr:Texture = Texture.fromBitmapData(BMP,false, false);
//        var _moveBack = new Image(Txr);
//        _moveBack.x = 300
//        _moveBack.y = g.stageHeight - 100;
//        button.addChild(_moveBack);

    }
}
}
