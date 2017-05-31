/**
 * Created by user on 5/30/17.
 */
package build.missing {
import build.WorldObject;

import com.junkbyte.console.Cc;

import dragonBones.animation.WorldClock;

import flash.display.Bitmap;

import loaders.PBitmap;

import manager.hitArea.ManagerHitArea;

import mouse.ToolsModifier;

import starling.textures.Texture;
import starling.textures.TextureAtlas;

import windows.WindowsManager;

public class Missing extends WorldObject {
    private var _isHover:Boolean;
    private var _count:int;

    public function Missing(_data:Object) {
        super(_data);
        if (!_data) {
            Cc.error('no data for Missing');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'no data for Missing');
            return;
        }
        _count = 0;
        g.load.loadImage(g.dataPath.getGraphicsPath() + 'missAtlas.png' + g.getVersion('missAtlas'), onLoad);
        g.load.loadXML(g.dataPath.getGraphicsPath() + 'missAtlas.xml' + g.getVersion('missAtlas'), onLoad);
        createAnimatedBuild(onCreateBuild);
        _isHover = false;
        _source.releaseContDrag = true;
    }

    private function onCreateBuild():void {
        WorldClock.clock.add(_armature);
        _armature.animation.gotoAndStopByFrame('idle');
        if (!g.isAway) {
            _source.endClickCallback = onClick;
            _hitArea = g.managerHitArea.getHitArea(_source, 'missing', ManagerHitArea.TYPE_LOADED);
            _source.registerHitArea(_hitArea);
        }
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
    }

    private function onLoad(smth:*=null):void {
        _count++;
        if (_count >=2) createAtlases();
    }

    private function createAtlases():void {
        g.allData.atlas['missAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[g.dataPath.getGraphicsPath() + 'missAtlas.png' + g.getVersion('missAtlas')].create() as Bitmap), g.pXMLs[g.dataPath.getGraphicsPath() + 'missAtlas.xml' + g.getVersion('missAtlas')]);
        (g.pBitmaps[g.dataPath.getGraphicsPath() + 'missAtlas.png' + g.getVersion('missAtlas')] as PBitmap).deleteIt();
        delete  g.pBitmaps[g.dataPath.getGraphicsPath() + 'missAtlas.png' + g.getVersion('missAtlas')];
        delete  g.pXMLs[g.dataPath.getGraphicsPath() + 'missAtlas.xml' + g.getVersion('missAtlas')];
        g.load.removeByUrl(g.dataPath.getGraphicsPath() + 'missAtlas.png' + g.getVersion('missAtlas'));
        g.load.removeByUrl(g.dataPath.getGraphicsPath() + 'missAtlas.xml' + g.getVersion('missAtlas'));
    }

    private function onClick():void {
        if (g.managerTutorial.isTutorial) return;
        if (g.managerCutScenes.isCutScene) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            if (g.selectedBuild) {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                    onOut();
                }
            } else {
                if (g.isActiveMapEditor)
                    g.townArea.moveBuild(this);
            }
            return;
        }

        if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            g.townArea.deleteBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            g.windowsManager.openWindow(WindowsManager.WO_ACHIEVEMENT, null);
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }
    }
}
}
