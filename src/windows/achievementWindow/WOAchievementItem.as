/**
 * Created by user on 3/21/17.
 */
package windows.achievementWindow {
import data.BuildType;
import data.DataMoney;

import manager.ManagerFilters;
import manager.Vars;

import resourceItem.DropItem;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Align;
import starling.utils.Color;

import temp.DropResourceVariaty;

import ui.xpPanel.XPStar;

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
    private var _imStar1:Image;
    private var _imStar2:Image;
    private var _imStar3:Image;
    private var _numberUser:int;
    private var _quad:Quad;

    public function WOAchievementItem(number:int) {
        source = new Sprite();
        _number = number;
        _imPlashka = new Image(g.allData.atlas['achievementAtlas'].getTexture('plashka_big'));
        source.addChild(_imPlashka);
        _name = new CTextField(290, 60, String(g.managerAchievement.dataAchievement[_number].name));
        _name.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_COLOR);
        _name.alignH = Align.LEFT;
        _name.x = 250 - _name.textBounds.width/2;
        _name.y = -5;
        source.addChild(_name);
        _description = new CTextField(290, 60, String(g.managerAchievement.dataAchievement[_number].description));
        _description.setFormat(CTextField.BOLD18, 18, ManagerFilters.BLUE_COLOR);
        _description.alignH = Align.LEFT;
        _description.y = 30;
        source.addChild(_description);
        _imStar = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star_small'));
        _imStar.x = 290;
        _imStar.y = 90;
        source.addChild(_imStar);
        _imRubi = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
        _imRubi.x = 190;
        _imRubi.y = 90;
        source.addChild(_imRubi);
        _imKubok = new Image(g.allData.atlas['achievementAtlas'].getTexture('kubok_n_n'));
        _imKubok.x = 15;
        _imKubok.y = 20;
        source.addChild(_imKubok);
        var myPattern:RegExp = /count/;
        var str:String = g.managerAchievement.dataAchievement[_number].description;

        for (var i:int = 0; i < g.managerAchievement.userAchievement.length; i++) {
            if (g.managerAchievement.userAchievement[i].id == g.managerAchievement.dataAchievement[_number].id) {
                for (var k:int = 0 ; k < g.managerAchievement.dataAchievement[_number].countToGift.length; k++) {
                    if (g.managerAchievement.userAchievement[i].resourceCount >= g.managerAchievement.dataAchievement[_number].countToGift[k] && !g.managerAchievement.userAchievement[i].tookGift[k]) {
                        _btn = new CButton();
                        _btn.addButtonTexture(174, 30, CButton.GREEN, true);
                        _txtBtn = new CTextField(174, 30, String(g.managerLanguage.allTexts[923]));
                        _txtBtn.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
                        _btn.addChild(_txtBtn);
                        _btn.x = 516;
                        _btn.y = 110;
                        source.addChild(_btn);
                        _btn.clickCallback = onClick;
                        _txtRubi = new CTextField(120, 40, String(g.managerAchievement.dataAchievement[_number].countHard[k]));
                        _txtRubi.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
                        source.addChild(_txtRubi);
                        _txtStar = new CTextField(120, 40, String(g.managerAchievement.dataAchievement[_number].countXp[k]));
                        _txtStar.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
                        source.addChild(_txtStar);
                        break;
                    }
                    if (g.managerAchievement.userAchievement[i].resourceCount < g.managerAchievement.dataAchievement[_number].countToGift[k]) {
                        _txtCount = new CTextField(80, 50, String(g.managerAchievement.userAchievement[i].resourceCount) + '/' + String(g.managerAchievement.dataAchievement[_number].countToGift[k]));
                        _txtCount.setFormat(CTextField.BOLD18, 16,  Color.WHITE, ManagerFilters.BROWN_COLOR);
                        source.addChild(_txtCount);
                        _txtRubi = new CTextField(120, 40, String(g.managerAchievement.dataAchievement[_number].countHard[k]));
                        _txtRubi.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
                        source.addChild(_txtRubi);
                        _txtStar = new CTextField(120, 40, String(g.managerAchievement.dataAchievement[_number].countXp[k]));
                        _txtStar.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
                        source.addChild(_txtStar);
                        var count:int = 0;
                        var width:int = 0;
                        if (k == 1) {
                            count = g.managerAchievement.userAchievement[i].resourceCount - g.managerAchievement.dataAchievement[_number].countToGift[k];
                            width = (100 * count/ g.managerAchievement.dataAchievement[_number].countToGift[k]) * 1.68;
                        }
                        if (k == 2) {
                            count = g.managerAchievement.userAchievement[i].resourceCount - g.managerAchievement.dataAchievement[_number].countToGift[1] - g.managerAchievement.dataAchievement[_number].countToGift[2];
                            width = (100 * count/ g.managerAchievement.dataAchievement[_number].countToGift[k]) * 1.68;
                        }
                        if (k == 0) width = (100 * g.managerAchievement.userAchievement[i].resourceCount/ g.managerAchievement.dataAchievement[_number].countToGift[k]) * 1.68;
                        if (width > 168) width= 168;
                        if (width != 0) {
                            _quad = new Quad(width,35,0xffb900);
                            _quad.x = 435;
                            _quad.y = 94;
                            source.addChildAt(_quad,0);
                        }
                        break;
                    }
                }
                _description.text = str.replace(myPattern, String(g.managerAchievement.dataAchievement[_number].countToGift[k]));
                _numberUser = i;
                break;
            }
        }
        if (!_txtStar) {
            _numberUser = -1;
            _txtCount = new CTextField(80, 50, '0/' + String(g.managerAchievement.dataAchievement[_number].countToGift[0]));
            _txtCount.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BROWN_COLOR);
            source.addChild(_txtCount);
            _txtRubi = new CTextField(120, 40, String(g.managerAchievement.dataAchievement[_number].countHard[0]));
            _txtRubi.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
            source.addChild(_txtRubi);
            _txtStar = new CTextField(120, 40, String(g.managerAchievement.dataAchievement[_number].countXp[0]));
            _txtStar.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
            source.addChild(_txtStar);
            _description.text = str.replace(myPattern, String(g.managerAchievement.dataAchievement[_number].countToGift[0]));
        }
        _txtRubi.alignH = Align.LEFT;
        _txtRubi.x = 232;
        _txtRubi.y = 87;
        _txtStar.alignH = Align.LEFT;
        _txtStar.x = 331;
        _txtStar.y = 87;
        if (_txtCount) {
            _txtCount.alignH = Align.LEFT;
            _txtCount.x = 520 - _txtCount.textBounds.width/2;
            _txtCount.y = 86;
        }
        _imPlashkaDown = new Image(g.allData.atlas['achievementAtlas'].getTexture('plashka_dwn'));
        _imPlashkaDown.x = _imPlashka.width - _imPlashkaDown.width -13;
        _imPlashkaDown.y = _imPlashka.height - _imPlashkaDown.height -7;
        source.addChildAt(_imPlashkaDown,0);
        _description.x = 250 - _description.textBounds.width/2;
        starShow();
    }

    public function starShow():void {
        if (g.managerAchievement.userAchievement[_numberUser] && g.managerAchievement.dataAchievement[_number].countToGift[0] <= g.managerAchievement.userAchievement[_numberUser].resourceCount) {
            _imStar1 = new Image(g.allData.atlas['achievementAtlas'].getTexture('star'));
            source.addChild(_imStar1);
            if (g.managerAchievement.dataAchievement[_number].countToGift[1] <= g.managerAchievement.userAchievement[_numberUser].resourceCount) {
                _imStar2 = new Image(g.allData.atlas['achievementAtlas'].getTexture('star'));
                source.addChild(_imStar2);
            } else {
                _imStar2 = new Image(g.allData.atlas['achievementAtlas'].getTexture('star_off'));
                source.addChild(_imStar2);
                _imStar3 = new Image(g.allData.atlas['achievementAtlas'].getTexture('star_off'));
                source.addChild(_imStar3);
            }
            if (g.managerAchievement.dataAchievement[_number].countToGift[2] <= g.managerAchievement.userAchievement[_numberUser].resourceCount) {
                _imStar3 = new Image(g.allData.atlas['achievementAtlas'].getTexture('star'));
                source.addChild(_imStar3);
            } else if (!_imStar3){
                _imStar3 = new Image(g.allData.atlas['achievementAtlas'].getTexture('star_off'));
                source.addChild(_imStar3);
            }
        } else {
            _imStar1 = new Image(g.allData.atlas['achievementAtlas'].getTexture('star_off'));
            source.addChild(_imStar1);
            _imStar2 = new Image(g.allData.atlas['achievementAtlas'].getTexture('star_off'));
            source.addChild(_imStar2);
            _imStar3 = new Image(g.allData.atlas['achievementAtlas'].getTexture('star_off'));
            source.addChild(_imStar3);
        }
        _imStar1.x = 425;
        _imStar1.y = 10;
        _imStar2.x = 484;
        _imStar2.y = 10;
        if (_imStar3) _imStar3.x = 542;
        if (_imStar3) _imStar3.y = 10;
    }

    private function onClick():void {
        if (_txtBtn) {
            _btn.removeChild(_txtBtn);
            _txtBtn.deleteIt();
            _txtBtn = null;
        }
        if (_btn) {
            source.removeChild(_btn);
            _btn.deleteIt();
            _btn = null;
        }
        if (_quad) {
            _quad = null;
            source.removeChild(_quad);
        }

        for (var i:int = 0; i < g.managerAchievement.userAchievement[_numberUser].tookGift.length; i++) {
            if (!g.managerAchievement.userAchievement[_numberUser].tookGift[i]) {
                g.managerAchievement.userAchievement[_numberUser].tookGift[i] = 1;
                break;
            }
        }
        dropBonus(i);
        if (i >= 2) {
            if (_txtCount)_txtCount.text = ' ';
            _txtRubi.text = ' ';
            _txtStar.text = ' ';
        } else {
            var width:int;
            var count:int;
            i++;
            if (i == 1) {
                count = g.managerAchievement.userAchievement[_numberUser].resourceCount - g.managerAchievement.dataAchievement[_number].countToGift[0];
                width = (100 * count/ g.managerAchievement.dataAchievement[_number].countToGift[i]) * 1.68;
            }
            if (i == 2) {
                count = g.managerAchievement.userAchievement[_numberUser].resourceCount - g.managerAchievement.dataAchievement[_number].countToGift[1] - g.managerAchievement.dataAchievement[_number].countToGift[2];
                width = (100 * count/ g.managerAchievement.dataAchievement[_number].countToGift[i]) * 1.68;
            }
            if (width > 168) {
                width= 168;
                _btn = new CButton();
                _btn.addButtonTexture(174, 30, CButton.GREEN, true);
                _txtBtn = new CTextField(174, 30, String(g.managerLanguage.allTexts[923]));
                _txtBtn.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
                _btn.addChild(_txtBtn);
                _btn.x = 509;
                _btn.y = 115;
                source.addChild(_btn);
                _btn.clickCallback = onClick;
            } else {
                if (_txtCount) _txtCount.text = String(g.managerAchievement.userAchievement[_numberUser].resourceCount) + '/' + String(g.managerAchievement.dataAchievement[_number].countToGift[i]);
                else _txtCount = new CTextField(80, 50,  String(g.managerAchievement.userAchievement[_numberUser].resourceCount) + '/' + String(g.managerAchievement.dataAchievement[_number].countToGift[i]));
                _txtCount.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BROWN_COLOR);
                source.addChild(_txtCount);
            }

            if (_txtCount) {
                _txtCount.alignH = Align.LEFT;
                _txtCount.x = 520 - _txtCount.textBounds.width/2;
                _txtCount.y = 86;
            }
            _quad = new Quad(width,35,0xffb900);
            _quad.x = 327;
            _quad.y = 97;
            source.addChildAt(_quad,0);
            _txtRubi.text = String(g.managerAchievement.dataAchievement[_number].countHard[i]);
            _txtStar.text = String(g.managerAchievement.dataAchievement[_number].countXp[i]);
            var myPattern:RegExp = /count/;
            var str:String = g.managerAchievement.dataAchievement[_number].description;

            _description.text = str.replace(myPattern, String(g.managerAchievement.dataAchievement[_number].countToGift[i]));
            _imPlashkaDown.dispose();
            _imPlashkaDown = null;
            _imPlashkaDown = new Image(g.allData.atlas['achievementAtlas'].getTexture('plashka_dwn'));
            _imPlashkaDown.x = _imPlashka.width - _imPlashkaDown.width -13;
            _imPlashkaDown.y = _imPlashka.height - _imPlashkaDown.height -7;
            source.addChildAt(_imPlashkaDown,0);
        }
        if (!g.managerAchievement.checkAchievement()) {
            var arr:Array = g.townArea.getCityObjectsByType(BuildType.ACHIEVEMENT);
            arr[0].onTimer(false);
        }

    }

    private function dropBonus(number:int):void {
        var ob:Object = {};
        ob.id = DataMoney.HARD_CURRENCY;
        ob.type = DropResourceVariaty.DROP_TYPE_MONEY;
        ob.count =  g.managerAchievement.dataAchievement[_number].countHard[number];
        new DropItem(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2, ob);
        new XPStar(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2, g.managerAchievement.dataAchievement[_number].countXp[number]);
        var st:String = g.managerAchievement.userAchievement[_numberUser].tookGift[0] + '&' + g.managerAchievement.userAchievement[_numberUser].tookGift[1] + '&'
                + g.managerAchievement.userAchievement[_numberUser].tookGift[2];
        g.directServer.updateUserAchievement(g.managerAchievement.userAchievement[_numberUser].id, g.managerAchievement.userAchievement[_numberUser].resourceCount, st,0, null);
    }
}
}
