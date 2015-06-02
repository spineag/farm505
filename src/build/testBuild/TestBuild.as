/**
 * Created by andy on 5/28/15.
 */
package build.testBuild {
import build.AreaObject;

import com.junkbyte.console.Cc;

import map.TownArea;

import mouse.ToolsModifier;

import starling.filters.BlurFilter;
import starling.utils.Color;

public class TestBuild extends AreaObject{
    private var _deleteBuild:TownArea;
    public function TestBuild(_data:Object) {
        super(_data);

        _source.hoverCallback = onHover;
        _source.endClickCallback = onClick;
        _source.outCallback = onOut;
        _dataBuild.isFlip = _flip;
    }

    private function onHover():void {
        _source.filter = BlurFilter.createGlow(Color.GREEN, 10, 2, 1);
    }

    private function onClick():void {
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) { // не сохраняется флип при муве
            g.townArea.moveBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            g.townArea.deleteBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {  // не работает поворот не для квадратных объектов
            releaseFlip();
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {

        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            // скидываем на дефолтный NONE
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {

        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }

    }

    private function onOut():void {
        _source.filter = null;
    }

    public function releaseFlip():void {
        if (_sizeX == _sizeY) {
            _flip = !_flip;
            _flip ? _source.scaleX = -_defaultScale : _source.scaleX = _defaultScale;
            _dataBuild.isFlip = _flip;
            return;
        }

        if (_flip) {
            g.townArea.unFillMatrix(posX, posY, _sizeY, _sizeX);
            if (g.toolsModifier.checkFreeGrids(posX, posY, _sizeX, _sizeY)) {
                _flip = false;
                _source.scaleX = _defaultScale;
                g.townArea.fillMatrix(posX, posY, _sizeX, _sizeY, this);
            } else {
                g.townArea.fillMatrix(posX, posY, _sizeY, _sizeX, this);
            }
        } else {
            g.townArea.unFillMatrix(posX, posY, _sizeX, _sizeY);
            if (g.toolsModifier.checkFreeGrids(posX, posY, _sizeY, _sizeX)) {
                _flip = true;
                _source.scaleX = -_defaultScale;
                g.townArea.fillMatrix(posX, posY, _sizeY, _sizeX, this);
            } else {
                g.townArea.fillMatrix(posX, posY, _sizeX, _sizeY, this);
            }
        }
        _dataBuild.isFlip = _flip;
    }
}
}
