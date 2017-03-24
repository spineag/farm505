/**
 * Created by user on 3/21/17.
 */
package windows.achievementWindow {
import manager.ManagerFilters;

import starling.events.Event;
import starling.utils.Align;
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
    private var _name:CTextField;

    public function WOAchievement() {
        _windowType = WindowsManager.WO_ACHIEVEMENT;
        _woWidth = 630;
        _woHeight = 590;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;
        _name = new CTextField(_woWidth, 120, String(g.managerLanguage.allTexts[924]));
        _name.setFormat(CTextField.BOLD30, 36, ManagerFilters.ORANGE_COLOR, Color.WHITE);
        _name.alignH = Align.LEFT;
        _name.x = -_name.textBounds.width/2;
        _name.y = -305;
        _source.addChild(_name);
    }

    override public function showItParams(callback:Function, params:Array):void {
        _scrollSprite = new DefaultVerticalScrollSprite(525, 465, 519, 154);
        _scrollSprite.createScoll(530, 0, 450, g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_line'), g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_c'));
        var item:WOAchievementItem;
        for (var i:int = 0; i < g.managerAchievement.dataAchievement.length; i++) {
            item = new WOAchievementItem(i);
            _scrollSprite.addNewCell(item.source)
        }
        _scrollSprite.source.x = -265;
        _scrollSprite.source.y = -210;
        _source.addChild(_scrollSprite.source);

        super.showIt();
    }

    private function onClickExit(e:Event=null):void {
        if (g.managerTutorial.isTutorial) return;
        g.managerMiniScenes.onHideOrder();
        hideIt();
    }
}
}
