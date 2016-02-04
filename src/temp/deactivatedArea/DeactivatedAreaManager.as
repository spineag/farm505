/**
 * Created by andy on 5/30/15.
 */
package temp.deactivatedArea {
import com.junkbyte.console.Cc;

import flash.geom.Point;
import manager.Vars;
import mouse.ToolsModifier;
import starling.display.Sprite;

public class DeactivatedAreaManager {
    private var _matrixSize:int;
    private var _townMatrix:Array; // матрица строений города
    private var _rombsArray:Array;
    private var _cont:Sprite;
    private var _arrDeactivatedAreas:Array;

    private var g:Vars = Vars.getInstance();

    public function DeactivatedAreaManager() {
        _rombsArray = [];
        _matrixSize = g.matrixGrid.matrixSize;
        _townMatrix = g.townArea.townMatrix.slice();
        _cont = g.cont.tailCont;
        _arrDeactivatedAreas = [];
        var area:DeactivatedArea;
        var p:Point = new Point();
        for (var i:int = 0; i < _matrixSize; i++) {
            for (var j:int = 0; j < _matrixSize; j++) {
                if (!_townMatrix[i][j].inGame) {
                    area = new DeactivatedArea(j, i);
                    p.x = j;
                    p.y = i;
                    p = g.matrixGrid.getXYFromIndex(p);
                    area.source.x = p.x;
                    area.source.y = p.y;
                    _cont.addChild(area.source);
                    _arrDeactivatedAreas.push(area);
                }
            }
        }
    }

    public function clearIt():void {
         for (var i:int=0; i<_arrDeactivatedAreas.length; i++) {
             if (_cont.contains(_arrDeactivatedAreas[i].source)) {
                 _cont.removeChild(_arrDeactivatedAreas[i].source);
                 _arrDeactivatedAreas[i].clearIt();
             }
         }
        _townMatrix.length = 0;
        _arrDeactivatedAreas.length = 0;
    }

    public function deactivateArea(posX:int, posY:int):void { // add red romb
        if (!_townMatrix[posY][posX].inGame) {
            activateArea(posX, posY);
            return;
        }
        var area:DeactivatedArea = new DeactivatedArea(posX, posY);
        _townMatrix[posY][posX].inGame = false;
        g.townArea.addDeactivatedArea(posX, posY, true);
        var p:Point = new Point(posX, posY);
        p = g.matrixGrid.getXYFromIndex(p);
        area.source.x = p.x;
        area.source.y = p.y;
        _cont.addChild(area.source);
        _arrDeactivatedAreas.push(area);
        g.directServer.ME_addOutGameTile(posX, posY, null);
    }

    private function activateArea(posX:int, posY:int):void { // remove red romb
        var area:DeactivatedArea;
        for (var i:int=0; i<_arrDeactivatedAreas.length; i++) {
            if (_arrDeactivatedAreas[i].posX == posX && _arrDeactivatedAreas[i].posY == posY) {
                area = _arrDeactivatedAreas[i];
                break;
            }
        }
        if (!area) {
            Cc.error('No deactivated area at this point');
            return;
        }
        if (_cont.contains(area.source)) {
            _cont.removeChild(area.source);
        }
        if (_arrDeactivatedAreas.indexOf(area) > -1) _arrDeactivatedAreas.splice(_arrDeactivatedAreas.indexOf(area), 1);
        g.townArea.addDeactivatedArea(area.posX, area.posY, false);
        g.directServer.ME_deleteOutGameTile(area.posX, area.posY, null);
        area.clearIt();
        area = null;

    }
}
}
