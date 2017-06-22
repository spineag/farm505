/**
 * Created by user on 1/20/17.
 */
package windows.questAward {
import com.junkbyte.console.Cc;

import flash.display.Bitmap;

import manager.ManagerFilters;

import quest.ManagerQuest;
import quest.QuestStructure;
import starling.display.Image;
import starling.display.Quad;
import starling.textures.Texture;
import starling.utils.Align;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import utils.MCScaler;
import utils.Utils;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOQuestFinishAward extends WindowMain {
    private var _woBG:WindowBackground;
    private var _btn:CButton;
    private var _quest:QuestStructure;
    private var _items:Array;
    private var _callback:Function;
    private var _questIcon:Image;

    public function WOQuestFinishAward() {
        super();
        _windowType = WindowsManager.WO_QUEST_AWARD;
        _woWidth = 650;
        _woHeight = 300;
        var im:Image = new Image(g.allData.atlas['questAtlas'].getTexture('end_quest'));
        im.x = -210;
        im.y = -195;
        im.touchable = false;
        _source.addChild(im);
        var txt:CTextField = new CTextField(200, 100, g.managerLanguage.allTexts[626]);
        txt.setFormat(CTextField.MEDIUM24, 20, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.alignH = Align.LEFT;
        txt.x = 58 - txt.textBounds.width/2;
        txt.y = -155;
        _source.addChild(txt);

        _btn = new CButton();
        _btn.addButtonTexture(130, 40, CButton.GREEN, true);
        _btn.clickCallback = onClick;
        _btn.y = 72;
        _btn.x = 60;
        _source.addChild(_btn);
        txt = new CTextField(130, 40, g.managerLanguage.allTexts[328]);
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _btn.addChild(txt);

        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;
    }

    override public function showItParams(f:Function, params:Array):void {
        _callback = f;
        if (params.length && params[0] is QuestStructure) {
            _quest = params[0] as QuestStructure;
        } else {
            Cc.error('WOQuestFinishAward showItParams:: no quest in params');
        }
        _items = [];
        var it:Item;
        var aw:Array = _quest.awards;
        for (var i:int = 0; i < aw.length; i++) {
            it = new Item(aw[i]);
            it.y = -35;
            _source.addChild(it);
            _items.push(it);
        }
        switch (_items.length) {
            case 1:
                _items[0].x = 60;
                break;
            case 2:
                _items[0].x = 0;
                _items[1].x = 120;
                break;
            case 3:
                _items[0].x = -20;
                _items[1].x = 60;
                _items[2].x = 140;
                break;
        }
        var txt:CTextField = new CTextField(400, 100, String(_quest.questName));
        txt.setFormat(CTextField.BOLD30, 26, ManagerFilters.ORANGE_COLOR, Color.WHITE);
        txt.alignH = Align.LEFT;
        txt.x = 58 - txt.textBounds.width/2;
        txt.y = -210;
        _source.addChild(txt);
        super.showIt();
        var st:String = _quest.iconPath;
        if (st == '0') {
            st = _quest.getUrlFromTask();
            if (st == '0') {
                addIm(_quest.iconImageFromAtlas());
            } else {
                g.load.loadImage(ManagerQuest.ICON_PATH + st, onLoadIcon);
            }
        } else {
            g.load.loadImage(ManagerQuest.ICON_PATH + st, onLoadIcon);
        }
        Cc.info("woQuest showItParams 7");
    }


    private function onLoadIcon(bitmap:Bitmap):void { addIm(new Image(Texture.fromBitmap(bitmap))); }
    private function addIm(im:Image):void {
        _questIcon = im;
        if (_questIcon) {
            MCScaler.scale(_questIcon, 146, 146);
            _questIcon.alignPivot();
            _questIcon.x = -250;
            _questIcon.y = -60;
            _source.addChild(_questIcon);
        }
    }

    private function onClick():void { onClickExit(); }

    private function onClickExit():void {
        for (var i:int=0; i<_items.length; i++) {
            _items[i].flyIt(i);
        }
        _items.length = 0;
        if (_callback != null) {
            _callback.apply(null, [_quest]);
            _callback = null;
        }
        Utils.createDelay(.5, super.hideIt);
    }

    override protected function deleteIt():void { super.deleteIt(); }
}
}

import com.greensock.TweenMax;
import com.greensock.easing.Back;
import com.greensock.easing.Linear;
import data.BuildType;
import data.DataMoney;
import flash.display.StageDisplayState;
import flash.geom.Point;
import manager.ManagerFilters;
import manager.Vars;
import quest.QuestAwardStructure;

import resourceItem.DropDecor;

import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.utils.Color;

import ui.xpPanel.XPStar;

import utils.CTextField;
import utils.MCScaler;
import utils.Utils;

internal class Item extends Sprite {
    private var g:Vars = Vars.getInstance();
    private var _aw:QuestAwardStructure;
    private var im:Image;
    private var _txt:CTextField;
    private var _source:Sprite;

    public function Item(aw:QuestAwardStructure) {
        _source = new Sprite();
        _aw = aw;
        _txt = new CTextField(60, 30, String(_aw.countResource));
        _txt.setFormat(CTextField.MEDIUM24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txt.x = -30;
        _txt.y = 35;
        addChild(_txt);

        if (_aw.typeResource == 'money') {
            switch (_aw.idResource) {
                case DataMoney.SOFT_CURRENCY: im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins')); break;
                case DataMoney.HARD_CURRENCY: im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins')); break;
                case DataMoney.BLUE_COUPONE: im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('blue_coupone')); break;
                case DataMoney.RED_COUPONE: im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('red_coupone')); break;
                case DataMoney.GREEN_COUPONE: im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('green_coupone')); break;
                case DataMoney.YELLOW_COUPONE: im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('yellow_coupone')); break;
            }
        } else if (_aw.typeResource == 'resource') {
            im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(_aw.idResource).imageShop));
        } else if (_aw.typeResource == 'plant') {
            im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(_aw.idResource).imageShop + '_icon'));
        } else if (_aw.typeResource == 'decor') {
            im = new Image(g.allData.atlas['decorAtlas'].getTexture(g.allData.getResourceById(_aw.idResource).image));
        } else if (_aw.typeResource == 'instrument') {
            im = new Image(g.allData.atlas['instrumentAtlas'].getTexture(g.allData.getResourceById(_aw.idResource).imageShop));
        } else if (_aw.typeResource == 'xp') {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture("star"));
        }

        if (im) {
            MCScaler.scale(im, 70, 70);
            im.alignPivot();
            addChild(im);
        }
    }

    private function deleteIt():void {
        if (_txt) {
            removeChild(_txt);
            _txt.deleteIt();
            _txt = null;
        }
        if (_source) _source.dispose();
    }

    public function flyIt(i:int):void {
        _source = new Sprite();
        if (_aw.typeResource == 'money') {
            flyItMoney(i);
        } else if (_aw.typeResource == 'decor') {
            flyItDecor(i);
        } else if (_aw.typeResource == 'xp') {
            flyItXP();
        } else {
            flyItResource(i);
        }
    }

    private function flyItDecor(i:int):void {
        var p:Point = new Point(0, 0);
        p = _source.localToGlobal(p);
        new DropDecor(p.x, p.y, g.allData.getBuildingById(_aw.idResource), 70, 70, _aw.countResource, i*.2);
        deleteIt();
    }

    private function flyItXP():void {
        var endPoint:Point = new Point();
        endPoint.x = 0;
        endPoint.y = 0;
        endPoint = im.localToGlobal(endPoint);
        removeChild(im);
        new XPStar(endPoint.x, endPoint.y, _aw.countResource);
    }

    private function flyItMoney(i:int):void {
        var endPoint:Point = new Point();
        var f1:Function = function():void {
            g.cont.animationsResourceCont.removeChild(_source);
            g.userInventory.addMoney(_aw.idResource, _aw.countResource);
            deleteIt();
        };
        endPoint.x = 0;
        endPoint.y = 0;
        endPoint = im.localToGlobal(endPoint);
        removeChild(im);
        _source.addChild(im);
        _source.x = endPoint.x;
        _source.y = endPoint.y;
        g.cont.animationsResourceCont.addChild(_source);
        if (_aw.idResource == DataMoney.SOFT_CURRENCY) {
            endPoint = g.softHardCurrency.getSoftCurrencyPoint();
        } else if (_aw.idResource == DataMoney.HARD_CURRENCY) {
            endPoint = g.softHardCurrency.getHardCurrencyPoint();
        } else {
            endPoint = g.couponePanel.getPoint();
        }
        var tempX:int = _source.x - 70;
        var tempY:int = _source.y + 30 + int(Math.random()*20);
        var dist:int = int(Math.sqrt((_source.x - endPoint.x)*(_source.x - endPoint.x) + (_source.y - endPoint.y)*(_source.y - endPoint.y)));
        var v:int;
        if (Starling.current.nativeStage.displayState == StageDisplayState.NORMAL) v = 500;
        else v = 800;
        new TweenMax(_source, dist/v, {bezier:[{x:tempX, y:tempY}, {x:endPoint.x, y:endPoint.y}], scaleX:.5, scaleY:.5, ease:Linear.easeOut, onComplete: f1, delay:i * .2});
    }

    private function flyItResource(i:int):void {
        var endPoint:Point = new Point();
        var f1:Function = function():void {
            g.cont.animationsResourceCont.removeChild(_source);
            g.userInventory.addResource(_aw.idResource, _aw.countResource);
            g.craftPanel.afterFlyWithId(_aw.idResource);
            deleteIt();
        };
        endPoint.x = 0;
        endPoint.y = 0;
        endPoint = im.localToGlobal(endPoint);
        removeChild(im);
        _source.addChild(im);
        _source.x = endPoint.x;
        _source.y = endPoint.y;
        g.cont.animationsResourceCont.addChild(_source);
        if (g.allData.getResourceById(_aw.idResource).placeBuild == BuildType.PLACE_SKLAD) {
            g.craftPanel.showIt(BuildType.PLACE_SKLAD);
        } else {
            g.craftPanel.showIt(BuildType.PLACE_AMBAR);
        }
        endPoint = g.craftPanel.pointXY();
        var tempX:int = _source.x - 70;
        var tempY:int = _source.y + 30 + int(Math.random()*20);
        var dist:int = int(Math.sqrt((_source.x - endPoint.x)*(_source.x - endPoint.x) + (_source.y - endPoint.y)*(_source.y - endPoint.y)));
        var v:int;
        if (Starling.current.nativeStage.displayState == StageDisplayState.NORMAL) v = 300;
        else v = 380;
        new TweenMax(_source, dist/v, {bezier:[{x:tempX, y:tempY}, {x:endPoint.x, y:endPoint.y}], scaleX:.5, scaleY:.5, ease:Linear.easeOut, onComplete: f1, delay:i * .2});
    }
}
