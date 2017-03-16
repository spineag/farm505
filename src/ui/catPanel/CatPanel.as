/**
 * Created by user on 10/27/15.
 */
package ui.catPanel {
import data.BuildType;

import manager.ManagerFilters;
import manager.Vars;

import social.SocialNetworkSwitch;

import starling.display.Image;
import utils.CSprite;
import utils.CTextField;
import windows.WOComponents.HorizontalPlawka;
import windows.WindowsManager;

public class CatPanel {
    private var _source:CSprite;
    private var _txtCount:CTextField;
    private var _txtZero:CTextField;
    public var catBuing:Boolean;

    private var g:Vars = Vars.getInstance();

    public function CatPanel() {
        _source = new CSprite();
        _source.nameIt = 'catPanel';
        var pl:HorizontalPlawka = new HorizontalPlawka(null, g.allData.atlas['interfaceAtlas'].getTexture('xp_center'),
                g.allData.atlas['interfaceAtlas'].getTexture('xp_back_left'), 100);
        _source.addChild(pl);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('circle'));
        im.x = -im.width/2;
        im.y = -10;
        _source.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cat_icon'));
        im.x = -19;
        im.y = -5;
        _source.addChild(im);
        _txtCount = new CTextField(77, 40, '55');
        _txtCount.setFormat(CTextField.BOLD24, 22, ManagerFilters.BROWN_COLOR);
        _txtZero = new CTextField(40, 40, '23');
        _txtZero.setFormat(CTextField.BOLD24, 22, ManagerFilters.ORANGE_COLOR);
        _source.addChild(_txtCount);
        _source.addChild(_txtZero);

        onResize();
        g.cont.interfaceCont.addChild(_source);
        checkCat();
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
        _source.endClickCallback = onClick;
    }

    public function checkCat():void {
        if (g.managerCats.countFreeCats <= 0) {
            _txtZero.text = '0';
            _txtCount.text = String("/" + g.managerCats.curCountCats);
            _txtCount.x = 28;
            _txtZero.x = 55 - _txtCount.textBounds.width;
            _txtZero.visible = true;
        } else {
            _txtCount.text = String(g.managerCats.countFreeCats + "/" + g.managerCats.curCountCats);
            _txtZero.visible = false;
            _txtCount.x = 20;
        }
    }

    public function onResize():void {
        if (!_source) return;
        _source.y = 77;
        _source.x = g.managerResize.stageWidth - 108;
    }

    private function onHover():void {
        g.hint.showIt(String(g.managerLanguage.allTexts[482]) + g.managerCats.countFreeCats + String(g.managerLanguage.allTexts[483]) + g.managerCats.curCountCats,'xp',_source.x);
    }

    private function onOut():void {
        g.hint.hideIt();
    }

    public function visibleCatPanel(b:Boolean):void {
        if (b) _source.visible = true;
        else _source.visible = false;
    }

    private function onClick():void {
        if ((g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID)) {
            if (g.user.userSocialId == '252433337505') {
                g.user.level++;
                g.windowsManager.openWindow(WindowsManager.WO_LEVEL_UP, null);
            }
        } else {
            if (g.user.userSocialId == '14663166' || g.user.userSocialId == '201166703' || g.user.userSocialId == '168207096' || g.user.userSocialId == '202427318' || g.user.userSocialId == '191561520') {
                g.user.level++;
                g.windowsManager.openWindow(WindowsManager.WO_LEVEL_UP, null);
            }
        }
//        g.directServer.addUserXP(1,null);
//        var _dataBuild:Object = g.dataBuilding.objectBuilding[9];
//        g.windowsManager.openWindow(WindowsManager.POST_OPEN_FABRIC,null,_dataBuild);
//        g.windowsManager.openWindow(WindowsManager.POST_OPEN_CAVE,null);
    }
}
}
