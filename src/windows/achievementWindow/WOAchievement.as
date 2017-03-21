/**
 * Created by user on 3/21/17.
 */
package windows.achievementWindow {
import manager.ManagerFilters;

import starling.events.Event;
import starling.utils.Color;

import utils.CButton;
import utils.CTextField;

import windows.WOComponents.DefaultVerticalScrollSprite;

import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOAchievement extends WindowMain{
    private var _woBG:WindowBackground;
    private var _scrollSprite:DefaultVerticalScrollSprite;

    public function WOAchievement() {
        _windowType = WindowsManager.WO_ORDERS;
        _woWidth = 750;
        _woHeight = 660;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;
    }

    override public function showItParams(callback:Function, params:Array):void {
        _scrollSprite = new DefaultVerticalScrollSprite(700, 500, 599, 175);
        _scrollSprite.source.x = 55 - _woWidth/2;
        _scrollSprite.source.y = 107 - _woHeight/2;
        _source.addChild(_scrollSprite.source);
        _scrollSprite.createScoll(700, 0, 500, g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_line'), g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_c'));
        var item:WOAchievementItem;
        for (var i:int = 0; i < g.managerAchievement.dataAchievement.length; i++) {
            item = new WOAchievementItem(i);
            _scrollSprite.addNewCell(item.source)
        }
        super.showIt();
    }

    private function onClickExit(e:Event=null):void {
        if (g.managerTutorial.isTutorial) return;
        g.managerMiniScenes.onHideOrder();
        hideIt();
    }
}
}
