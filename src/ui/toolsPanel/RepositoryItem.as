/**
 * Created by user on 10/9/15.
 */
package ui.toolsPanel {
import build.WorldObject;
import build.decor.DecorFenceArka;
import build.decor.DecorFenceGate;
import build.decor.DecorPostFenceArka;

import com.junkbyte.console.Cc;
import data.BuildType;
import manager.ManagerFilters;
import manager.Vars;

import mouse.ToolsModifier;

import starling.display.Image;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;

import tutorial.managerCutScenes.ManagerCutScenes;

import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import windows.WindowsManager;

public class RepositoryItem {
    public var source:CSprite;
    private var _data:Object;
    private var _countDecor:int;
    private var _txtCount:CTextField;
    private var _box:RepositoryBox;
    private var _arrDbIds:Array;
    private var _position:int;
    private var g:Vars = Vars.getInstance();

    public function RepositoryItem() {
        _countDecor = 0;
        _position = 0;
        source = new CSprite();
        source.nameIt = 'repositoryItem';
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('decor_cell'));
        im.width = im.height = 60;
        source.addChild(im);
    }

    public function set position(countCell:int):void { _position = countCell; }
    public function get position():int { return _position; }
    public function get decorCount():int { return _countDecor; }
    public function get decorId():int { if (_data) return _data.id; else return 0; }

    public function fillIt(data:Object, count:int, arrIds:Array, box:RepositoryBox):void {
        if (!data) {
            Cc.error('RepoItem:: empty data');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'repoItem');
            return;
        }
        _data = data;
        _countDecor = count;
        _box = box;
        _arrDbIds = arrIds;
        
        var texture:Texture = g.allData.atlas['iconAtlas'].getTexture(_data.image + '_icon');
        if (!texture) {
            if (_data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR_FULL_FENСE || _data.buildType == BuildType.DECOR_POST_FENCE
                    || _data.buildType == BuildType.DECOR_TAIL || _data.buildType == BuildType.TREE || _data.buildType == BuildType.DECOR_FENCE_ARKA
                    || _data.buildType == BuildType.DECOR_FENCE_GATE || _data.buildType == BuildType.DECOR_POST_FENCE_ARKA)
                texture = g.allData.atlas[_data.url].getTexture(_data.image);
            else texture = g.allData.atlas['iconAtlas'].getTexture(_data.url + '_icon');
        }
        var im:Image = new Image(texture);
        MCScaler.scale(im, 55, 55);
        im.x = 30 - im.width/2;
        im.y = 30 - im.height/2;
        source.addChild(im);

        _txtCount = new CTextField(30,20,String(_countDecor));
        _txtCount.setFormat(CTextField.MEDIUM18, 14, ManagerFilters.BROWN_COLOR, Color.WHITE);
        _txtCount.x = 30;
        _txtCount.y = 40;
        source.addChild(_txtCount);
        source.endClickCallback = onClick;
    }

    public function clearIt():void {
        if (_txtCount) {
            source.removeChild(_txtCount);
            _txtCount.deleteIt();
            _txtCount = null;
        }
        _data = null;
        source.deleteIt();
    }

    private function onClick():void {
        if (g.selectedBuild) {
            g.toolsModifier.cancelMove();
        }
        g.toolsModifier.modifierType = ToolsModifier.MOVE;
        var build:WorldObject = g.townArea.createNewBuild(_data, _arrDbIds[0]);
        g.selectedBuild = build;
        if (_data.buildType == BuildType.DECOR_TAIL) {
            g.toolsModifier.startMoveTail(build, g.townArea.afterMoveFromInventory, true);
        } else {
            if (build is DecorFenceGate) (build as DecorFenceGate).showFullView();
            if (build is DecorFenceArka) (build as DecorFenceArka).showFullView();
            if (build is DecorPostFenceArka) (build as DecorPostFenceArka).showFullView();
            g.toolsModifier.startMove(build, g.townArea.afterMoveFromInventory, true);
        }
        _box.arrNumber(_position);
        if (g.managerCutScenes.isCutScene && g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_FROM_INVENTORY_DECOR)) g.managerCutScenes.checkCutSceneCallback();
    }

    public function updateCount():void {
        _countDecor --;
        if (_countDecor <= 0) _box.updateItems();
        else _txtCount.text = String(_countDecor);
    }

}
}
