/**
 * Created by user on 8/14/15.
 */
package ui.toolsPanel {
import manager.Vars;

import mouse.ToolsModifier;

import starling.core.Starling;

import starling.display.Image;

import starling.display.Sprite;
import starling.filters.BlurFilter;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

public class ToolsPanel {

    private var _source:Sprite;
    private var _contRepository:CSprite;
    private var _contMove:CSprite;
    private var _contFlip:CSprite;
    private var _contCancel:CSprite;
    private var _imageBg:Image;
    private var _imageTab:Image;
    private var _txt:TextField;
    private var g:Vars = Vars.getInstance();
    public function ToolsPanel() {
        _source = new Sprite();
        _imageBg = new Image(g.interfaceAtlas.getTexture("friends_plawka"));
        _imageBg.width = _imageBg.width/2;
        _imageTab = new Image(g.interfaceAtlas.getTexture("friends_tab"));
        _imageTab.x = 20;
        _imageTab.y = -20;
        _txt = new TextField(150,50,"Редактор карты","Arial",14,Color.BLACK);
        _txt.x = 10;
        _txt.y = -30;
        _source.addChild(_imageBg);
        _source.addChild(_imageTab);
        _source.addChild(_txt);
        _source.x = g.stageWidth - 550;
        _source.y = g.stageHeight - 120;
        g.cont.interfaceCont.addChild(_source);
        _source.visible = false;
        createList();
    }

    public function onResize():void {
        _source.x = Starling.current.nativeStage.stageWidth - 550;
        _source.y = Starling.current.nativeStage.stageHeight - 120;
    }

    public function showIt():void {
        _source.visible  = true;
    }

    public function hideIt():void {
        _source.visible = false;
    }

    public function get isShowed():Boolean {
        return _source.visible;
    }

    private function createList():void {
        var im:Image;
        var txt:TextField;

        _contRepository = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture('plus'));
        im.x = 30;
        im.y = 30;
        txt = new TextField(100,50,"На хранение","Arial",12,Color.BLACK);
        txt.x = -10;
        txt.y = 50;
        _contRepository.addChild(im);
        _contRepository.addChild(txt);
        _contRepository.x = 10;
        _contRepository.y = 10;
        _source.addChild(_contRepository);
        _contRepository.hoverCallback = function():void { _contRepository.filter = BlurFilter.createGlow(Color.WHITE, 10, 2, 1) };
        _contRepository.outCallback = function():void { _contRepository.filter = null };
        _contRepository.endClickCallback = function():void {onClick('repository')};

        _contMove = new CSprite();
        im = new Image(g.mapAtlas.getTexture('Move'));
        txt = new TextField(100,50,"Передвинуть","Arial",12,Color.BLACK);
        txt.x = -10;
        txt.y = 50;
        _contMove.addChild(im);
        _contMove.addChild(txt);
        _contMove.x = 100;
        _contMove.y = 10;
        _source.addChild(_contMove);
        _contMove.hoverCallback = function():void { _contMove.filter = BlurFilter.createGlow(Color.WHITE, 10, 2, 1) };
        _contMove.outCallback = function():void { _contMove.filter = null };
        _contMove.endClickCallback = function():void {onClick('move')};

        _contFlip = new CSprite();
        im = new Image(g.mapAtlas.getTexture('Rotate'));
        txt = new TextField(100,50,"Повернуть","Arial",12,Color.BLACK);
        txt.x = -10;
        txt.y = 50;
        _contFlip.addChild(im);
        _contFlip.addChild(txt);
        _contFlip.x = 190;
        _contFlip.y = 10;
        _source.addChild(_contFlip);
        _contFlip.hoverCallback = function():void { _contFlip.filter = BlurFilter.createGlow(Color.WHITE, 10, 2, 1) };
        _contFlip.outCallback = function():void { _contFlip.filter = null };
        _contFlip.endClickCallback = function():void {onClick('flip')};

        _contCancel = new CSprite();
        im = new Image(g.mapAtlas.getTexture('Cancel'));
        txt = new TextField(100,50,"Отменить","Arial",12,Color.BLACK);
        txt.x = -10;
        txt.y = 50;
        _contCancel.addChild(im);
        _contCancel.addChild(txt);
        _contCancel.x = 280;
        _contCancel.y = 10;
        _source.addChild(_contCancel);
        _contCancel.hoverCallback = function():void { _contCancel.filter = BlurFilter.createGlow(Color.WHITE, 10, 2, 1) };
        _contCancel.outCallback = function():void { _contCancel.filter = null };
        _contCancel.endClickCallback = function():void {onClick('cancel')};
    }

    private function onClick(reason:String):void {
        switch (reason) {
            case 'repository':
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
            case 'cancel':
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                break;
        }
    }
}
}
