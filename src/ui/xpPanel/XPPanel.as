/**
 * Created by user on 6/19/15.
 */
package ui.xpPanel {

import flash.filters.GlowFilter;

import manager.Vars;
import starling.core.Starling;
import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

import windows.WOComponents.HorizontalPlawka;
import windows.WOComponents.ProgressBarComponent;

public class XPPanel {
    private var _source:CSprite;
    private var _maxXP:int;
    private var _bar:ProgressBarComponent;
    private var _txtLevel:TextField;
    private var _txtXPCount:TextField;

    private var g:Vars = Vars.getInstance();

    public function XPPanel() {
        _source = new CSprite();
        g.cont.interfaceCont.addChild(_source);
        var pl:HorizontalPlawka = new HorizontalPlawka(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_l'), g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_c'),
                g.allData.atlas['interfaceAtlas'].getTexture('shop_window_line_r'), 163);
        _source.addChild(pl);
        _bar = new ProgressBarComponent(g.allData.atlas['interfaceAtlas'].getTexture('progress_bar_left'), g.allData.atlas['interfaceAtlas'].getTexture('progress_bar_center'),
                g.allData.atlas['interfaceAtlas'].getTexture('progress_bar_right'), 145);
        _bar.x = 14;
        _bar.y = 3;
        _source.addChild(_bar);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star'));
        MCScaler.scale(im, 60, 60);
        im.x = -27;
        im.y = -12;
        _source.addChild(im);
        _txtLevel = new TextField(60, 60, '55', g.allData.fonts['BloggerBold'], 24, Color.WHITE);
        _txtLevel.nativeFilters = [new GlowFilter(0x036ea1, 1, 4, 4, 5)];
        _txtLevel.x = -27;
        _txtLevel.y = -12;
        _source.addChild(_txtLevel);
        _txtXPCount = new TextField(123, 30, '6784/247289', g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _txtXPCount.nativeFilters = [new GlowFilter(0x036ea1, 1, 4, 4, 5)];
        _txtXPCount.x = 37;
        _txtXPCount.y = 2;
        _source.addChild(_txtXPCount);

        _maxXP = g.dataLevel.objectLevels[g.user.level + 1].xp;
        checkXP();
        onResize();
    }

    public function onResize():void {
        _source.y = 20;
        _source.x = Starling.current.nativeStage.stageWidth - 170;
    }

    public function addXP(count:int):void{
        g.user.xp += count;
        g.user.globalXP += count;
        if (count && g.useDataFromServer)
            g.directServer.addUserXP(count, onAddUserXP);
        if (g.user.xp >= _maxXP){
            g.user.xp -= _maxXP;
            g.user.level++;
            _txtLevel.text = String(g.user.level);
            g.woLevelUp.showLevelUp();
            _maxXP = g.dataLevel.objectLevels[g.user.level + 1].xp;
            if (g.useDataFromServer) g.directServer.updateUserLevel(onUpdateUserLevel);
            g.managerCats.calculateMaxCountCats();
            g.managerOrder.checkOrders();
        }
        checkXP();
    }

    private function onAddUserXP(b:Boolean = true):void {}
    private function onUpdateUserLevel(b:Boolean = true):void {}

    private function checkXP():void{
        _bar.progress = ((g.user.xp)/_maxXP)*.9 + .1; // get 10% for better view
        _txtXPCount.text = String(g.user.xp) + ' / ' + String(_maxXP);
    }
}
}
