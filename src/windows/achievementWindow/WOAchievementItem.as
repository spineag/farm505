/**
 * Created by user on 3/21/17.
 */
package windows.achievementWindow {
import manager.ManagerFilters;
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.utils.Color;

import utils.CButton;

import utils.CTextField;

public class WOAchievementItem {
    public var source:Sprite;
    private var _imStar:Image;
    private var _imRubi:Image;
    private var _imPlashka:Image;
    private var _imPlashkaDown:Image;
    private var _name:CTextField;
    private var _description:CTextField;
    private var _imKubok:Image;
    private var _txtRubi:CTextField;
    private var _txtStar:CTextField;
    private var _txtCount:CTextField;
    private var g:Vars = Vars.getInstance();
    private var _number:int;
    private var _btn:CButton;
    private var _txtBtn:CTextField;

    public function WOAchievementItem(number:int) {
        _number = number;
        _imPlashka = new Image(g.allData.atlas['achievementAtlas'].getTexture('plashka'));
        source.addChild(_imPlashka);
        _imPlashkaDown = new Image(g.allData.atlas['achievementAtlas'].getTexture('plashka_dwn'));
        source.addChild(_imPlashkaDown);

        _name = new CTextField(90, 30, String(g.managerAchievement.dataAchievement[_number].name));
        _name.setFormat(CTextField.BOLD18, 18, ManagerFilters.BLUE_COLOR);
//        _name.x = 411;
//        _name.y = 418;
        source.addChild(_name);
        _description = new CTextField(90, 30, String(g.managerAchievement.dataAchievement[_number].description));
        _description.setFormat(CTextField.BOLD18, 16, ManagerFilters.BLUE_COLOR);
//        _name.x = 411;
//        _name.y = 418;
        source.addChild(_description);
        _imStar = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star_medium'));
        source.addChild(_imStar);
        _imRubi = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_medium'));
        source.addChild(_imRubi);
        _imKubok = new Image(g.allData.atlas['achievementAtlas'].getTexture('kubok'));
        source.addChild(_imKubok);



        for (var i:int = 0; i < g.managerAchievement.userAchievement.length; i++) {
            if (g.managerAchievement.userAchievement[i].id == g.managerAchievement.dataAchievement[_number].id) {
                for (var k:int = 0 ; k < g.managerAchievement.dataAchievement[_number].countToGift.length; k++) {
                    if (g.managerAchievement.userAchievement[i].countResource >= g.managerAchievement.dataAchievement[_number].countToGift[k] && !g.managerAchievement.dataAchievement[_number].tookGift[k]) {
                        _btn = new CButton();
                        _btn.addButtonTexture(120, 40, CButton.GREEN, true);
                        _txtBtn = new CTextField(120, 40, String(g.managerLanguage.allTexts[923]));
                        _txtBtn.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
                        _btn.addChild(_txtBtn);
//                        _btn.x = 493;
//                        _btn.y = 31;
                        source.addChild(_btn);
                        _txtRubi = new CTextField(120, 40, String(g.managerAchievement.dataAchievement[_number].countHard[k]));
                        _txtRubi.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
                        source.addChild(_txtRubi);
                        _txtStar = new CTextField(120, 40, String(g.managerAchievement.dataAchievement[_number].countXp[k]));
                        _txtStar.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
                        source.addChild(_txtStar);
                        break;
                    }
                    if (g.managerAchievement.userAchievement[i].countResource < g.managerAchievement.dataAchievement[_number].countToGift[k]) {
                        _txtCount = new CTextField(80, 50, String(g.managerAchievement.userAchievement[i].countResource) + '/' + String(g.managerAchievement.dataAchievement[_number].countToGift[k]));
                        _txtCount.setFormat(CTextField.BOLD18, 16, Color.WHITE);
                        source.addChild(_txtCount);
                        _txtRubi = new CTextField(120, 40, String(g.managerAchievement.dataAchievement[_number].countHard[k]));
                        _txtRubi.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
                        source.addChild(_txtRubi);
                        _txtStar = new CTextField(120, 40, String(g.managerAchievement.dataAchievement[_number].countXp[k]));
                        _txtStar.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
                        source.addChild(_txtStar);
                        break;
                    }
                }
            }
        }
    }

    public function starShow():void {
        var im:Image;
        if (g.managerAchievement.dataAchievement[_number].countToGift[0] >= g.managerAchievement.userAchievement) {
            im = new Image(g.allData.atlas['achievementAtlas'].getTexture('star'));
            source.addChild(im);
            if (g.managerAchievement.dataAchievement[_number].countToGift[1] >= g.managerAchievement.userAchievement) {
                im = new Image(g.allData.atlas['achievementAtlas'].getTexture('star'));
                source.addChild(im);
            } else {
                im = new Image(g.allData.atlas['achievementAtlas'].getTexture('star_off'));
                source.addChild(im);
                im = new Image(g.allData.atlas['achievementAtlas'].getTexture('star_off'));
                source.addChild(im);
            }
            if (g.managerAchievement.dataAchievement[_number].countToGift[2] >= g.managerAchievement.userAchievement) {
                im = new Image(g.allData.atlas['achievementAtlas'].getTexture('star'));
                source.addChild(im);
            }
        } else {
            im = new Image(g.allData.atlas['achievementAtlas'].getTexture('star_off'));
            source.addChild(im);
            im = new Image(g.allData.atlas['achievementAtlas'].getTexture('star_off'));
            source.addChild(im);
            im = new Image(g.allData.atlas['achievementAtlas'].getTexture('star_off'));
            source.addChild(im);
        }
    }
}
}
