/**
 * Created by user on 6/8/15.
 */
package build.decor {
import build.AreaObject;

import com.junkbyte.console.Cc;

import manager.OwnEvent;

import manager.Vars;

import mouse.ToolsModifier;

import starling.display.Image;

import starling.display.Sprite;
import starling.events.Event;

public class DecorPostFence extends AreaObject{
    private var _rightLenta:Sprite;
    private var _leftLenta:Sprite;
    private var g:Vars = Vars.getInstance();

    public function DecorPostFence(_data:Object) {
        super(_data);
        createBuild();

        if (!g.isAway) {
            _source.endClickCallback = onClick;
        }
        _source.releaseContDrag = true;
    }

    public function addLeftLenta():void {
        if (_leftLenta) return;
        _leftLenta = new Sprite();
        var im:Image = new Image(g.allData.atlas[_dataBuild.url].getTexture(_dataBuild.image + '_1'));
        im.x = -107;
        im.y = -3;
        _leftLenta.addChild(im);
        _source.addChild(_leftLenta);
    }

    public function addRightLenta():void {
        if (_rightLenta) return;
        _rightLenta = new Sprite();
        var im:Image = new Image(g.allData.atlas[_dataBuild.url].getTexture(_dataBuild.image + '_1'));
        im.x = -107;
        im.y = -3;
        _rightLenta.addChild(im);
        _rightLenta.scaleX = -1;
        _source.addChild(_rightLenta);
    }

    public function removeLeftLenta():void {
        if (_leftLenta) {
            _source.removeChild(_leftLenta);
            _leftLenta = null;
        }
    }

    public function removeRightLenta():void {
        if (_rightLenta) {
            _source.removeChild(_rightLenta);
            _rightLenta = null;
        }
    }

    private function onClick():void {
        if (g.isActiveMapEditor) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            if (g.selectedBuild) {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                } else return;
            } else {
                g.townArea.moveBuild(this);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            g.townArea.deleteBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            // ничего не делаем
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            if (!g.selectedBuild) {
                g.directServer.addToInventory(_dbBuildingId, null);
                g.userInventory.addToDecorInventory(_dataBuild.id, _dbBuildingId);
                g.townArea.deleteBuild(this);
                g.event.dispatchEvent(new Event(OwnEvent.UPDATE_REPOSITORY));
            } else {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                }
            }
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

    override public function clearIt():void {
        removeLeftLenta();
        removeRightLenta();
        _source.touchable = false;
        super.clearIt();
    }
}
}
