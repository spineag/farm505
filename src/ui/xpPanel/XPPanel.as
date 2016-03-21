/**
 * Created by user on 6/19/15.
 */
package ui.xpPanel {

import flash.filters.GlowFilter;

import manager.ManagerFilters;

import manager.Vars;

import starling.animation.Tween;
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
    public var _imageStar:Image;
    private var _count:int;
    private var g:Vars = Vars.getInstance();

    public function XPPanel() {
        _source = new CSprite();
        g.cont.interfaceCont.addChild(_source);
        var pl:HorizontalPlawka = new HorizontalPlawka(null, g.allData.atlas['interfaceAtlas'].getTexture('xp_center'),
                g.allData.atlas['interfaceAtlas'].getTexture('xp_back_left'), 163);
        _source.addChild(pl);
        _bar = new ProgressBarComponent(g.allData.atlas['interfaceAtlas'].getTexture('progress_bar_left'), g.allData.atlas['interfaceAtlas'].getTexture('progress_bar_center'),
                g.allData.atlas['interfaceAtlas'].getTexture('progress_bar_right'), 145);
        _bar.x = 14;
        _bar.y = 3;
        _source.addChild(_bar);
        _imageStar = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star'));
        MCScaler.scale(_imageStar, 60, 60);
        _imageStar.x = -10;
        _imageStar.y = 5;
        _imageStar.pivotX = _imageStar.width/2;
        _imageStar.pivotY = _imageStar.height/2;
        _source.addChild(_imageStar);
        _txtLevel = new TextField(60, 60, '55', g.allData.fonts['BloggerBold'], 24, Color.WHITE);
        _txtLevel.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtLevel.x = -27;
        _txtLevel.y = -12;
        _source.addChild(_txtLevel);
        _txtXPCount = new TextField(123, 30, '6784/247289', g.allData.fonts['BloggerBold'], 16, Color.WHITE);
        _txtXPCount.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtXPCount.x = 35;
        _txtXPCount.y = 4;
        _source.addChild(_txtXPCount);
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
        _maxXP = g.dataLevel.objectLevels[g.user.level + 1].xp;
        checkXP();
        onResize();
    }

    public function onResize():void {
        _source.y = 17;
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
            g.friendPanel.checkLevel();
            _maxXP = g.dataLevel.objectLevels[g.user.level + 1].xp;
            g.directServer.updateUserLevel(onUpdateUserLevel);
            g.userInventory.addNewElementsAfterGettingNewLevel();
            g.managerCats.calculateMaxCountCats();
            g.managerOrder.checkOrders();
            if (g.user.level == g.dataBuilding.objectBuilding[45].blockByLevel)
                g.managerDailyBonus.generateDailyBonusItems();
        }
        checkXP();
    }

    private function onAddUserXP(b:Boolean = true):void {}
    private function onUpdateUserLevel(b:Boolean = true):void {}

    public function checkXP():void{
        _bar.progress = ((g.user.xp)/_maxXP)*.9 + .1; // get 10% for better view
        _txtXPCount.text = String(g.user.xp);
        _txtLevel.text = String(g.user.level);
    }

    private function onHover():void {
        g.hint.showIt(_maxXP - g.user.xp + ' XP до ' + (g.user.level+1) + ' уровня',false,false,false, _source.x);
    }

    private function onOut():void {
        g.hint.hideIt();
    }
    public function animationStar():void {
        var tween:Tween = new Tween(_imageStar, 0.3);
        tween.scaleTo(1.5);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
        };
        tween.scaleTo(0.6);
        g.starling.juggler.add(tween);
    }

}
}
