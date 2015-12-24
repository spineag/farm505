/**
 * Created by user on 8/14/15.
 */
package ui.toolsPanel {

import com.greensock.TweenMax;
import com.greensock.easing.Back;
import com.greensock.easing.Linear;

import manager.ManagerFilters;
import manager.Vars;
import mouse.ToolsModifier;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;

import utils.CButton;
import utils.CSprite;
import windows.WOComponents.HorizontalPlawka;

public class ToolsPanel {

    private var _source:Sprite;
    private var _repositoryBtn:CButton;
    private var _flipBtn:CButton;
    private var _moveBtn:CButton;
    private var _repositoryBox:RepositoryBox;
    private var g:Vars = Vars.getInstance();

    public function ToolsPanel() {
        _source = new Sprite();
        _source = new Sprite();
        g.cont.interfaceCont.addChildAt(_source, 0);
        var pl:HorizontalPlawka = new HorizontalPlawka(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_back_l'), g.allData.atlas['interfaceAtlas'].getTexture('main_panel_back_c'),
                g.allData.atlas['interfaceAtlas'].getTexture('main_panel_back_r'), 204);
        _source.addChild(pl);

        _repositoryBox = new RepositoryBox();
        g.cont.interfaceCont.addChildAt(_repositoryBox.source, 0);
        createBtns();
        _source.visible = false;
        onResize();
    }

    private function createBtns():void {
        var im:Image;

        _repositoryBtn = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_bt'));
        _repositoryBtn.addDisplayObject(im);
        _repositoryBtn.setPivots();
        _repositoryBtn.x = 3 + _repositoryBtn.width/2;
        _repositoryBtn.y = 8 + _repositoryBtn.height/2;
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('tools_panel_bt_inv'));
        im.x = 4;
        im.y = 2;
        _repositoryBtn.addDisplayObject(im);
        _source.addChild(_repositoryBtn);
        _repositoryBtn.hoverCallback = function():void { g.hint.showIt("Инвентарь"); };
        _repositoryBtn.outCallback = function():void { g.hint.hideIt(); };
        _repositoryBtn.clickCallback = function():void {onClick('repository')};

        _flipBtn = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_bt'));
        _flipBtn.addDisplayObject(im);
        _flipBtn.setPivots();
        _flipBtn.x = 66 + _flipBtn.width/2;
        _flipBtn.y = 8 + _flipBtn.height/2;
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('tools_panel_bt_rotate'));
        im.x = 4;
        im.y = 4;
        _flipBtn.addDisplayObject(im);
        _source.addChild(_flipBtn);
        _flipBtn.hoverCallback = function():void { g.hint.showIt("Повернуть"); };
        _flipBtn.outCallback = function():void { g.hint.hideIt(); };
        _flipBtn.clickCallback = function():void {onClick('flip')};

        _moveBtn = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_bt'));
        _moveBtn.addDisplayObject(im);
        _moveBtn.setPivots();
        _moveBtn.x = 129 + _moveBtn.width/2;
        _moveBtn.y = 8 + _moveBtn.height/2;
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('tools_panel_bt_move'));
        im.x = 5;
        im.y = 3;
        _moveBtn.addDisplayObject(im);
        _source.addChild(_moveBtn);
        _moveBtn.hoverCallback = function():void { g.hint.showIt("Переместить"); };
        _moveBtn.outCallback = function():void { g.hint.hideIt(); };
        _moveBtn.clickCallback = function():void {onClick('move')};
    }

    public function get isShowed():Boolean {
        return _source.visible;
    }

    public function onResize():void {
        if (_source.visible) {
            _source.x = Starling.current.nativeStage.stageWidth - 480;
        } else {
            _source.x = Starling.current.nativeStage.stageWidth - 271;
        }
        if (_repositoryBox.source.visible) {
            _repositoryBox.source.y = Starling.current.nativeStage.stageHeight - 83;
        } else {
            _repositoryBox.source.y = Starling.current.nativeStage.stageHeight + 10;
        }

        _repositoryBox.source.x = Starling.current.nativeStage.stageWidth - 740;
        _source.y = Starling.current.nativeStage.stageHeight - 83;
    }

    public function showIt():void {
        _source.visible  = true;
        TweenMax.killTweensOf(_source);
        new TweenMax(_source, .5, {x:Starling.current.nativeStage.stageWidth - 480, ease:Back.easeOut, delay:.2});
    }

    public function hideRepository():void {
        _repositoryBox.hideIt();
    }

    public function hideIt():void {
        TweenMax.killTweensOf(_source);
        new TweenMax(_source, .5, {x:Starling.current.nativeStage.stageWidth - 271, ease:Back.easeOut, onComplete: function():void {_source.visible = false}});
    }

    private function onClick(reason:String):void {
        switch (reason) {
            case 'repository':
                if(g.toolsModifier.modifierType != ToolsModifier.GRID_DEACTIVATED){
                    if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
                        g.toolsModifier.modifierType = ToolsModifier.NONE;
                        hideRepository();
                    } else {
                        g.toolsModifier.modifierType = ToolsModifier.INVENTORY;
                        _repositoryBox.showIt();
                    }
                }
                break;
            case 'move':
                    if(g.toolsModifier.modifierType != ToolsModifier.GRID_DEACTIVATED){
                        g.toolsModifier.modifierType == ToolsModifier.MOVE
                          ? g.toolsModifier.modifierType = ToolsModifier.NONE : g.toolsModifier.modifierType = ToolsModifier.MOVE;
                    }
                break;
            case 'flip':
                if(g.toolsModifier.modifierType != ToolsModifier.GRID_DEACTIVATED){
                    g.toolsModifier.modifierType == ToolsModifier.FLIP
                      ? g.toolsModifier.modifierType = ToolsModifier.NONE : g.toolsModifier.modifierType = ToolsModifier.FLIP;
                }
                break;
        }
    }

    public function get repositoryBoxVisible():Boolean {
        return _repositoryBox.source.visible;
    }
}
}
