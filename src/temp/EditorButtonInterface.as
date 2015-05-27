/**
 * Created by user on 5/25/15.
 */
package temp {


import flash.display.BitmapData;
import flash.display.Shape;

import manager.Vars;
import starling.display.Image;
import starling.display.Quad;
import starling.textures.Texture;
import starling.utils.Color;

import utils.CSprite;

import utils.MCScaler;

public class EditorButtonInterface {
    public static const WIDTH_CELL:uint = 30;
    public static const FACTOR:Number = WIDTH_CELL / Math.SQRT2;
    public static const DIAGONAL:Number = Math.sqrt(WIDTH_CELL * WIDTH_CELL + WIDTH_CELL * WIDTH_CELL);

    public var source:CSprite;
    private var _iconEditor:Image;
    private var g:Vars = Vars.getInstance();

    public function EditorButtonInterface() {
        source = new CSprite();
        source.y = - 10;
        var quad:Quad = new Quad(30, 50, Color.WHITE);
        source.addChild(quad);
    }

    public function setIconButton(s:String):void {
        if (s == "Active") {
            var sp:flash.display.Shape = new flash.display.Shape();
            sp.graphics.beginFill(0xFF0000);
            sp.graphics.moveTo(DIAGONAL/2, 0);
            sp.graphics.lineTo(0, FACTOR/2);
            sp.graphics.lineTo(DIAGONAL/2, FACTOR);
            sp.graphics.lineTo(DIAGONAL, FACTOR/2);
            sp.graphics.lineTo(DIAGONAL/2, 0);
            var BMP:BitmapData = new BitmapData(DIAGONAL, FACTOR, true, 0x00000000);
            BMP.draw(sp);
            _iconEditor = new Image(Texture.fromBitmapData(BMP,false, false));
            _iconEditor.y = 8;

        } else{
            _iconEditor = new Image(g.mapAtlas.getTexture(s));
        }

        MCScaler.scale(_iconEditor, 30, 30);
        source.addChild(_iconEditor);
    }
}
}
