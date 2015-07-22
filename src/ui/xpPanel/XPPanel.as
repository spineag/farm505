/**
 * Created by user on 6/19/15.
 */
package ui.xpPanel {

import build.WorldObject;

import manager.Vars;

import starling.display.Image;

import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;


import utils.CSprite;

public class XPPanel {
    private var _source:CSprite;
//    private var _contXPProgres:Sprite;
    private var _XPProgres:Image;
    private var _XPProgresEnd:Image;
    private var _XPPanel:Image;
    private var _maxXP:int;
    private var _maxWidth:int = 162;
    private var _txtLevel:TextField;
    private var _txtXP:TextField;

    private var g:Vars = Vars.getInstance();
    public function XPPanel() {
        _source = new CSprite();
        g.cont.interfaceCont.addChild(_source);
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
//        _contXPProgres = new Sprite();
        _txtLevel = new TextField(50,50,"","Arial",18,Color.WHITE);
        _txtXP = new TextField(100,100,"","Arial",18,Color.WHITE);
        _XPProgres = new Image(g.interfaceAtlas.getTexture("xp_progres_part"));
        _XPProgresEnd = new Image(g.interfaceAtlas.getTexture("xp_progres_part_end"));
        _XPPanel = new Image(g.interfaceAtlas.getTexture("xp_progres"));

        _XPPanel.x = g.stageWidth - _XPPanel.width -10;
        _XPPanel.y = 5;
        _XPProgres.x = g.stageWidth - 175;
        _XPProgres.y = _XPPanel.height - _XPProgres.height - 10;
        _XPProgresEnd.x = _XPProgres.x +_XPProgres.width - 4;
        _XPProgresEnd.y = _XPPanel.height - _XPProgresEnd.height - 10;
        _txtLevel.text = String(g.user.level);
        _txtLevel.x = g.stageWidth - 207;
        _txtLevel.y = 23;
        _txtXP.x = g.stageWidth - 150;
        _txtXP.y = -15;
        _source.addChild(_XPProgres);
        _source.addChild(_XPProgresEnd);
        _source.addChild(_XPPanel);
        _source.addChild(_txtLevel);
        _maxXP = g.dataLevel.objectLevels[g.user.level + 1].xp;
    }

    public function addXP(count:int):void{
        g.user.xp += count;
        g.user.globalXP += count;
        if (g.user.xp >= _maxXP){
            g.user.xp -= _maxXP;
            g.user.level++;
            _txtLevel.text = String(g.user.level);
            g.woLevelUp.showLevelUp();
            _maxXP = g.dataLevel.objectLevels[g.user.level + 1].xp;
        }
        checkXP();
        if (count)
            g.directServer.addUserXP(count, onAddUserXP);
    }

    private function onAddUserXP(b:Boolean = true):void {

    }

    private function checkXP():void{
        _XPProgres.width = (g.user.xp * _maxWidth) / _maxXP;
        _XPProgresEnd.x = _XPProgres.x +_XPProgres.width - 4;
    }

    private function onHover():void {
        _txtXP.text = String(g.user.xp + "/" + _maxXP);
        _source.addChild(_txtXP);
    }

    private function onOut():void {
        _source.removeChild(_txtXP);
    }

}
}
