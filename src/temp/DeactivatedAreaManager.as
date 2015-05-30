/**
 * Created by andy on 5/30/15.
 */
package temp {
import flash.display.BitmapData;
import flash.display.Shape;
import flash.geom.Point;
import flash.utils.setTimeout;

import manager.Vars;

import map.MatrixGrid;

import mouse.ToolsModifier;

import starling.display.Sprite;
import starling.textures.Texture;

public class DeactivatedAreaManager {
    private var _texture:Texture;
    private var _matrixSize:int;
    private var _townMatrix:Array; // матрица строений города
    private var _rombsArray:Array;
    private var _cont:Sprite;

    private var g:Vars = Vars.getInstance();

    public function DeactivatedAreaManager() {
        _rombsArray = [];
        _matrixSize = g.matrixGrid.matrixSize;
        _townMatrix = g.townArea.townMatrix;
        _cont = g.cont.contentCont;
        createTexture();
    }

    private function createTexture():void {
        var sp:flash.display.Shape = new flash.display.Shape();
        sp.graphics.beginFill(0xFF0000);
        sp.graphics.moveTo(MatrixGrid.DIAGONAL/2, 0);
        sp.graphics.lineTo(0, MatrixGrid.FACTOR/2);
        sp.graphics.lineTo(MatrixGrid.DIAGONAL/2, MatrixGrid.FACTOR);
        sp.graphics.lineTo(MatrixGrid.DIAGONAL, MatrixGrid.FACTOR/2);
        sp.graphics.lineTo(MatrixGrid.DIAGONAL/2, 0);
        var BMP:BitmapData = new BitmapData(MatrixGrid.DIAGONAL, MatrixGrid.FACTOR, true, 0x00000000);
        BMP.draw(sp);
        _texture = Texture.fromBitmapData(BMP);
    }

    public function deactivatedTheArea(posX:int, posY:int):void { // add red romb
        var obj:Object = _townMatrix[posY][posX];

        if (!obj.inGame) return;
        if (obj.isFull) return;
        if (obj.isBlocked) return;

        obj.isBlocked = true;

        var area:DeactivatedArea = new DeactivatedArea(posX, posY, _texture, activateArea);
        var p:Point = new Point(posX, posY);
        p = g.matrixGrid.getXYFromIndex(p);
        area.source.x = p.x;
        area.source.y = p.y;
        _cont.addChild(area.source);
        g.townArea.fillMatrix(posX, posY, 1, 1, area);
    }

    private function activateArea(area:DeactivatedArea):void { // remove red romb
        if (g.toolsModifier.modifierType != ToolsModifier.GRID_DEACTIVATED) return;

        if (_cont.contains(area.source)) {
            _cont.removeChild(area.source);
        }
        var f:Function = function():void {
            _townMatrix[area.posY][area.posX].isBlocked = false;
            g.townArea.unFillMatrix(area.posX, area.posY, 1, 1);
            area = null;
        };
        setTimeout(f, 50);


    }
}
}
