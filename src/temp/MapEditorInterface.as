/**
 * Created by user on 5/20/15.
 */
package temp {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Shape;

import manager.Vars;

import starling.display.Button;
import starling.display.Quad;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Color;

public class MapEditorInterface {
    private var _allTable:Sprite;
    private var _contBuildings:Sprite;
    private var _bg:Quad;
    private var _arrowBg:Quad;
    private var _leftArrow:Button;
    private var _rightArrow:Button;
    private var _house:Button;
    private var _tree:Button;
    private var _decor:Button;
    private var g:Vars = Vars.getInstance();

    public function MapEditorInterface() {
        _allTable = new Sprite();
        _allTable.y = 540;
        g.cont.interfaceCont.addChild(_allTable);
        _contBuildings = new Sprite();
        _bg = new Quad(1000, 80, Color.GRAY);
        _bg.y = 20;
        _allTable.addChild(_bg);

        _arrowBg = new Quad(50, 20, Color.BLUE);
        _arrowBg.x = 950;
        _arrowBg.y = 0;
        _allTable.addChild(_arrowBg);



        var shape:Shape = new Shape();

        shape.graphics.beginFill(0xffffff);
        shape.graphics.moveTo(0,10);
        shape.graphics.lineTo(10,2);
        shape.graphics.lineTo(10,18);
        shape.graphics.lineTo(0,10);

        shape.graphics.endFill();

        var BMP:BitmapData = new BitmapData(50, 50, true, 0x00000000);
        BMP.draw(shape);
        var Txr:Texture = Texture.fromBitmapData(BMP,false, false);

        _leftArrow = new Button(Txr);
        _leftArrow.x = 950;
        _leftArrow.y = 0;
        _allTable.addChild(_leftArrow);

        var shape:Shape = new Shape();

        shape.graphics.beginFill(0xffffff);
        shape.graphics.moveTo(0,10);
        shape.graphics.lineTo(10,2);
        shape.graphics.lineTo(10,18);
        shape.graphics.lineTo(0,10);

        shape.graphics.endFill();

        var BM:BitmapData = new BitmapData(50, 50, true, 0x00000000);
        BMP.draw(shape);
        var Tx:Texture = Texture.fromBitmapData(BMP,false, false);

        _rightArrow = new Button(Tx);
        _rightArrow.x = 980;
        _rightArrow.y = 0;
        _allTable.addChild(_rightArrow);
    }
}
}
