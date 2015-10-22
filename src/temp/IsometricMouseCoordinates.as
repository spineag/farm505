/**
 * Created by user on 6/4/15.
 */
package temp {


import flash.geom.Point;

import manager.Vars;

import starling.display.Quad;

import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;


public class IsometricMouseCoordinates {

    public var source:Sprite;
    private var _textPosX:TextField;
    private var _textPosY:TextField;
    private var _mousePosX:TextField;
    private var _mousePosY:TextField;
    private var g:Vars = Vars.getInstance();

    public function IsometricMouseCoordinates() {
        source = new Sprite();
        _textPosX = new TextField(30, 20, "IsoX: ", "Arial", 10, Color.BLACK);
        _textPosY = new TextField(30, 20, "IsoY: ", "Arial", 10, Color.BLACK);
        _mousePosX = new TextField(30, 20, " ", "Arial", 10, Color.BLACK);
        _mousePosY = new TextField(30, 20, " ", "Arial", 10, Color.BLACK);
        var quad:Quad = new Quad(55, 35, Color.WHITE);
        source.addChild(quad);
        _textPosX.x = 3;
        _textPosX.y = 3;
        _textPosY.x = 3;
        _textPosY.y = 15;
        _mousePosX.x = 25;
        _mousePosX.y = 3;
        _mousePosY.x = 25;
        _mousePosY.y = 15;
        source.addChild(_textPosX);
        source.addChild(_textPosY);
        source.addChild(_mousePosX);
        source.addChild(_mousePosY);
    }

    private var _point:Point = new Point();
    private var _cont:Sprite = g.cont.gameCont;

    private function mapIndex():void {
        _point.x = g.ownMouse.mouseX - _cont.x;
        _point.y = g.ownMouse.mouseY - _cont.y;
        _point = g.matrixGrid.getStrongIndexFromXY(_point);
        _mousePosX.text = String(_point.x);
        _mousePosY.text = String(_point.y);
    }

    public function startIt():void {
        g.gameDispatcher.addEnterFrame(mapIndex);
    }

    public function stopIt():void {
        g.gameDispatcher.removeEnterFrame(mapIndex);
    }

    public function deleteIt():void {
        while (source.numChildren) source.removeChildAt(0);
        _textPosX.dispose();
        _textPosY.dispose();
        _mousePosX.dispose();
        _mousePosY.dispose();
        source = null;
        _point = null;
        _cont = null;
    }
}
}

