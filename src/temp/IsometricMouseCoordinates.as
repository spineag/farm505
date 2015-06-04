/**
 * Created by user on 6/4/15.
 */
package temp {

import build.WorldObject;

import flash.geom.Point;

import manager.Vars;

import map.MatrixGrid;

import starling.display.Quad;

import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.Point3D;

public class IsometricMouseCoordinates {

    public var source:Sprite;
    private var _iconEditor:Sprite;
    private var _textPosX:TextField;
    private var _textPosY:TextField;
    private var _mousePosX:TextField;
    private var _mousePosY:TextField;
    private var _point:Point;
    private var posX:int;
    private var posY:int;

    private var g:Vars = Vars.getInstance();

    public function IsometricMouseCoordinates() {
        source = new Sprite();
        _iconEditor = new Sprite();
        _textPosX = new TextField(30,20,"IsoX: ","Arial",10,Color.BLACK);
        _textPosY = new TextField(30,20,"IsoY: ","Arial",10,Color.BLACK);
        _mousePosX = new TextField(30,10,"");
        _mousePosY = new TextField(30,10,"");
        var quad:Quad = new Quad(70, 50, Color.WHITE);
        source.addChild(quad);
        _textPosX.x = 3;
        _textPosX.y = 10;
        _textPosY.x = 3;
        _textPosY.y = 25;
        _mousePosX.x = 3;
        _mousePosX.y = 10;
        _mousePosY.x = 3;
        _mousePosY.y = 10;
        source.addChild(_textPosX);
        source.addChild(_textPosY);
        }
    private function mapIndex ():void{

        var pos:Point3D = new Point3D();
        pos.x = _point.x * MatrixGrid.FACTOR;
        pos.z = _point.y * MatrixGrid.FACTOR;
        posX = _point.x;
        posY = _point.y;
        _mousePosX.text = String(posX);
        _mousePosY.text = String(posY);
        source.addChild(_mousePosX);
        source.addChild(_mousePosY);

        }
    }
}

