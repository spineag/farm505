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
    private var _XP:int;
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
        _XPProgres.x = g.stageWidth - 205;
        _XPProgres.y = _XPPanel.height - _XPProgres.height - 5;
        _XPProgres.width = 190;
        _XPProgresEnd.x = g.stageWidth - _XPPanel.width/2 - 5;
        _XPProgresEnd.y = _XPPanel.height - _XPProgresEnd.height - 10;
        _contXP.addChild(_XPProgres);
        _contXP.addChild(_XPProgresEnd);
        _contXP.addChild(_XPPanel);
    }

    private function xpLevel():void{
        if(_XP == g.dataLevel.objectLevels.xp){
            _XPProgres.width = _XPProgres.width;
            _XPProgresEnd.x = 0;//начальная позиция
        }
    }
}
}
