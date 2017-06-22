/**
 * Created by user on 6/8/15.
 */
package build.decor {
import build.WorldObject;
import com.junkbyte.console.Cc;
import manager.ManagerFilters;
import manager.Vars;
import manager.hitArea.ManagerHitArea;
import mouse.ToolsModifier;
import starling.display.Image;
import starling.display.Sprite;

public class DecorPostFence extends WorldObject{ // zabor zi stovp4ukiv
    private var _rightLenta:Sprite;
    private var _leftLenta:Sprite;
    private var g:Vars = Vars.getInstance();

    public function DecorPostFence(_data:Object) {
        super(_data);
        createAtlasBuild(onCreateBuild);
        _source.releaseContDrag = true;
    }

    private function onCreateBuild():void {
        if (!g.isAway) {
            _source.endClickCallback = onClick;
            _source.hoverCallback = onHover;
            _source.outCallback = onOut;
            _hitArea = g.managerHitArea.getHitArea(_source, _dataBuild.image, ManagerHitArea.TYPE_FROM_ATLAS);
            _source.registerHitArea(_hitArea);
        }
    }

    public function addLeftLenta():void {
        if (_leftLenta) return;
        _leftLenta = new Sprite();
        try {
            var im:Image = new Image(g.allData.atlas[_dataBuild.url].getTexture(_dataBuild.image + '_1'));
        } catch (e:Error) {
          return;
        }
        switch (_dataBuild.id) {  // better to add its to DB as array
            case 21: im.x = -107 * g.scaleFactor;
                     im.y = -3 * g.scaleFactor;
                break;
            case 19: im.x = -105 * g.scaleFactor;
                     im.y = 12 * g.scaleFactor;
                break;
            case 20: im.x = -105 * g.scaleFactor;
                     im.y = 9 * g.scaleFactor;
                break;
            case 18: im.x = -105 * g.scaleFactor;
                     im.y = 9 * g.scaleFactor;
                break;
            case 204: im.x = -107 * g.scaleFactor;
                      im.y = -3 * g.scaleFactor;
                break;
        }
        _leftLenta.addChild(im);
        _source.addChild(_leftLenta);
    }

    public function addRightLenta():void {
        if (_rightLenta) return;
        _rightLenta = new Sprite();
        try {
            var im:Image = new Image(g.allData.atlas[_dataBuild.url].getTexture(_dataBuild.image + '_1'));
        } catch (e:Error) {
            return;
        }
        switch (_dataBuild.id) {  // better to add its to DB as array
            case 21: im.x = -107 * g.scaleFactor;
                im.y = -3 * g.scaleFactor;
                break;
            case 19: im.x = -105 * g.scaleFactor;
                im.y = 12 * g.scaleFactor;
                break;
            case 20: im.x = -105 * g.scaleFactor;
                im.y = 9 * g.scaleFactor;
                break;
            case 18: im.x = -105 * g.scaleFactor;
                im.y = 9 * g.scaleFactor;
                break;
            case 204: im.x = -107 * g.scaleFactor;
                im.y = -3 * g.scaleFactor;
                break;
        }
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
//            if (_dataBuild.id == 93 || _dataBuild.id == 95 || _dataBuild.id == 97
//                    || _dataBuild.id == 107 || _dataBuild.id == 108 || _dataBuild.id == 109 || _dataBuild.id == 110 || _dataBuild.id == 111 || _dataBuild.id == 112 || _dataBuild.id == 113
//                    || _dataBuild.id == 114 || _dataBuild.id == 115 || _dataBuild.id == 116 || _dataBuild.id == 117 || _dataBuild.id == 118) {
//                releaseFlip();
//                g.directServer.userBuildingFlip(_dbBuildingId, int(_flip), null);
//            }
            // ничего не делаем
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            if (!g.selectedBuild) {
                g.directServer.addToInventory(_dbBuildingId, null);
                g.userInventory.addToDecorInventory(_dataBuild.id, _dbBuildingId);
                g.townArea.deleteBuild(this);
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

    override public function onHover():void {
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE || g.toolsModifier.modifierType == ToolsModifier.FLIP || g.toolsModifier.modifierType == ToolsModifier.INVENTORY)
            _source.filter = ManagerFilters.BUILD_STROKE;
        super.onHover();
    }

    override public function onOut():void {
        super.onOut();
        if (_source.filter) _source.filter.dispose();
        _source.filter = null;
    }

    override public function clearIt():void {
        removeLeftLenta();
        removeRightLenta();
        _source.touchable = false;
        super.clearIt();
    }
}
}
