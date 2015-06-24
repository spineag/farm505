/**
 * Created by user on 6/19/15.
 */
package ui.xpPanel {
import manager.Vars;

import starling.display.Image;

import starling.display.Sprite;

public class XPPanel {

    private var _contXP:Sprite;
    private var _contXPProgres:Sprite;
    private var _XPProgres:Image;
    private var _XPProgresEnd:Image;
    private var _XPPanel:Image;
    private var _maxXP:int;
    private var _maxWidth:int = 162;
    private var curentXP:int;

    private var g:Vars = Vars.getInstance();
    public function XPPanel() {

        _contXP = new Sprite();
        g.cont.xpCont.addChild(_contXP);
        _contXPProgres = new Sprite();
        _XPProgres = new Image(g.interfaceAtlas.getTexture("xp_progres_part"));
        _XPProgresEnd = new Image(g.interfaceAtlas.getTexture("xp_progres_part_end"));
        _XPPanel = new Image(g.interfaceAtlas.getTexture("xp_progres"));
        _XPPanel.x = g.stageWidth - _XPPanel.width -10;
        _XPPanel.y = 5;
        _XPProgres.x = g.stageWidth - 175;
        _XPProgres.y = _XPPanel.height - _XPProgres.height - 10;
        //_XPProgresEnd.x = g.stageWidth - 160 ;
        _XPProgresEnd.y = _XPPanel.height - _XPProgresEnd.height - 10;
        _contXP.addChild(_XPProgres);
        _contXP.addChild(_XPProgresEnd);
        _contXP.addChild(_XPPanel);
    }

    private function addXP(number:int):void{
        g.user.xp += number;
        if (g.user.xp >= _maxXP){
            g.user.xp -= _maxXP;
            g.user.level++;
            _maxXP = g.dataLevel.objectLevels[g.user.level].xp;
        }
        checkXP();
    }

    private function checkXP():void{
        _XPProgres.width = (g.user.xp * _maxWidth) / _maxXP;
        _XPProgresEnd.x = _XPProgres.x +_XPProgres.width - 4;
    }

}
}
