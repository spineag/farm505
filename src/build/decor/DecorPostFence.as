/**
 * Created by user on 6/8/15.
 */
package build.decor {
import build.AreaObject;

import com.junkbyte.console.Cc;

import manager.Vars;

import mouse.ToolsModifier;

import starling.display.Image;

import starling.display.Sprite;

public class DecorPostFence extends AreaObject{
    private var _rightLenta:Sprite;
    private var _leftLenta:Sprite;
    private var g:Vars = Vars.getInstance();

    public function DecorPostFence(_data:Object) {
        super(_data);
        createBuild();

//        _source.hoverCallback = onHover;
        _source.endClickCallback = onClick;
//        _source.outCallback = onOut;
    }

    public function addLeftLenta():void {
        if (_leftLenta) return;
        _leftLenta = new Sprite();
        var im:Image = new Image(g.tempBuildAtlas.getTexture(_dataBuild.imageLenta));
        im.x = -22;
        im.y = -17;
        _leftLenta.addChild(im);
        _source.addChild(_leftLenta);
    }

    public function addRightLenta():void {
        if (_rightLenta) return;
        _rightLenta = new Sprite();
        var im:Image = new Image(g.tempBuildAtlas.getTexture(_dataBuild.imageLenta));
        im.x = -22;
        im.y = -17;
        _rightLenta.addChild(im);
        _rightLenta.scaleX *= -1;
        _source.addChild(_rightLenta);
    }

    public function removeLeftLenta():void {
        _source.removeChild(_leftLenta);
        _leftLenta = null;
    }

    public function removeRightLenta():void {
        _source.removeChild(_rightLenta);
        _rightLenta = null;
    }

    private function onClick():void {
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            g.townArea.moveBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            g.townArea.deleteBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            // ничего не делаем
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {

        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.PLANT_TREES;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            // ничего не делаем
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }
    }
}
}
