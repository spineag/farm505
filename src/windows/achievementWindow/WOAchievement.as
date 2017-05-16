/**
 * Created by user on 3/21/17.
 */
package windows.achievementWindow {
import data.BuildType;

import manager.ManagerFilters;
import manager.ManagerLanguage;

import starling.display.Image;

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
    private var _imName:Image;

    public function WOAchievement() {
        _windowType = WindowsManager.WO_ACHIEVEMENT;
        _woWidth = 730;
        _woHeight = 590;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;
//        _name = new CTextField(_woWidth, 120, String(g.managerLanguage.allTexts[924]));
//        _name.setFormat(CTextField.BOLD30, 36, 0xea5802, Color.WHITE);
//        _name.alignH = Align.LEFT;
//        _name.x = -_name.textBounds.width/2;
//        _name.y = -305;
//        _source.addChild(_name);
        if (g.user.language == ManagerLanguage.ENGLISH) _imName = new Image(g.allData.atlas['achievementAtlas'].getTexture('achievements_1'));
        else _imName = new Image(g.allData.atlas['achievementAtlas'].getTexture('achievements_2'));
        _imName.x = -_imName.width/2;
        _imName.y = -272;
        _source.addChild(_imName);
    }

    override public function showItParams(callback:Function, params:Array):void {
        _scrollSprite = new DefaultVerticalScrollSprite(525, 460, 519, 154);
        _scrollSprite.createScoll(638, 0, 450, g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_line'), g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_c'));
        var item:WOAchievementItem;
        if (g.managerAchievement.userAchievement.length > 0) {
            for (var i:int = 0; i < g.managerAchievement.dataAchievement.length; i++) {
                for (var j:int = 0; j < g.managerAchievement.userAchievement.length; j++) {
                    if (g.managerAchievement.dataAchievement[i].id == g.managerAchievement.userAchievement[j].id) {
                        if (g.managerAchievement.dataAchievement[i].countToGift[0] <= g.managerAchievement.userAchievement[j].resourceCount && !g.managerAchievement.userAchievement[j].tookGift[0]) {
                            g.managerAchievement.dataAchievement[i].priority = 1;
                        } else if (g.managerAchievement.dataAchievement[i].countToGift[1] <= g.managerAchievement.userAchievement[j].resourceCount && !g.managerAchievement.userAchievement[j].tookGift[1]) {
                            g.managerAchievement.dataAchievement[i].priority = 1;
                        } else if (g.managerAchievement.dataAchievement[i].countToGift[2] <= g.managerAchievement.userAchievement[j].resourceCount && !g.managerAchievement.userAchievement[j].tookGift[2]) {
                            g.managerAchievement.dataAchievement[i].priority = 1;
                        } else g.managerAchievement.dataAchievement[i].priority = 1000;
                        break;
                    }
                }
            }
        }
        g.managerAchievement.dataAchievement.sortOn("priority",  Array.NUMERIC);
        for (i = 0; i < g.managerAchievement.dataAchievement.length; i++) {
            item = new WOAchievementItem(i);
            _scrollSprite.addNewCell(item.source)
        }
        _scrollSprite.source.x = -325;
        _scrollSprite.source.y = -195;
        _source.addChild(_scrollSprite.source);
        super.showIt();
    }

    private function onClickExit(e:Event=null):void {
        if (g.managerTutorial.isTutorial) return;
        g.managerMiniScenes.onHideOrder();
        hideIt();
    }

    override public function hideIt():void {
        var arr:Array;
        if (!g.managerAchievement.checkAchievement()) {
            arr = g.townArea.getCityObjectsByType(BuildType.ACHIEVEMENT);
            arr[0].onTimer(false);
        } else {
            arr = g.townArea.getCityObjectsByType(BuildType.ACHIEVEMENT);
            arr[0].onTimer();
        }
        super.hideIt();
    }
}
}
