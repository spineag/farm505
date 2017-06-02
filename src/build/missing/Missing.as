/**
 * Created by user on 5/30/17.
 */
package build.missing {
import build.WorldObject;

import com.junkbyte.console.Cc;

import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;

import flash.display.Bitmap;

import loaders.PBitmap;

import manager.ManagerFilters;

import manager.hitArea.ManagerHitArea;

import mouse.ToolsModifier;

import starling.events.Event;

import starling.textures.Texture;
import starling.textures.TextureAtlas;

import user.Someone;

import windows.WindowsManager;

public class Missing extends WorldObject {
    private var _isHover:Boolean;
    private var _count:int;
    private var _person:Someone;

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
        super.showForOptimisation(false);
    }

    private function onCreateBuild():void {
        WorldClock.clock.add(_armature);
        _armature.animation.gotoAndPlayByFrame('idle_1');
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
            g.windowsManager.openWindow(WindowsManager.WO_MISS_YOU, null, _person);
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }
    }

    override public function onHover():void {
        if (_isHover) return;
        super.onHover();
        if (g.isAway) {
            g.hint.showIt(_dataBuild.name);
            return;
        }
        if (!_isHover) {
            _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
            var fEndOver:Function = function (e:Event = null):void {
                _armature.removeEventListener(EventObject.COMPLETE, fEndOver);
                _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEndOver);
                _armature.animation.gotoAndPlayByFrame('idle_1');
            };
            _armature.addEventListener(EventObject.COMPLETE, fEndOver);
            _armature.addEventListener(EventObject.LOOP_COMPLETE, fEndOver);
            _armature.animation.gotoAndPlayByFrame('over');
        }
        _isHover = true;
        g.hint.showIt(_dataBuild.name);
    }

    override public function onOut():void {
        super.onOut();
        if (g.isAway) {
            g.hint.hideIt();
            return;
        }
        if (_source.filter) _source.filter.dispose();
        _source.filter = null;
        _isHover = false;
        g.hint.hideIt();
    }

    public function visibleBuild(b:Boolean = false, person:Someone = null):void {
//        _source.visible = b;
        _person = person;
    }
}
}
