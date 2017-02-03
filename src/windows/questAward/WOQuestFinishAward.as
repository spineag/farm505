/**
 * Created by user on 1/20/17.
 */
package windows.questAward {
import com.junkbyte.console.Cc;
import manager.ManagerFilters;
import quest.QuestStructure;
import starling.display.Image;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
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

    public function WOQuestFinishAward() {
        super();
        _windowType = WindowsManager.WO_QUEST_AWARD;
        _woWidth = 550;
        _woHeight = 400;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        var im:Image = new Image(g.allData.atlas['questAtlas'].getTexture('quest_award_window'));
        im.x = -265;
        im.y = -195;
        im.touchable = false;
        _source.addChild(im);
        var txt:CTextField = new CTextField(400,100,"Задание выполнено!");
        txt.setFormat(CTextField.BOLD30, 30, ManagerFilters.ORANGE_COLOR, Color.WHITE);
        txt.x = -200;
        txt.y = -190;
        _source.addChild(txt);
        txt = new CTextField(200,100,"Ваша награда");
        txt.setFormat(CTextField.MEDIUM24, 20, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.x = -100;
        txt.y = 10;
        _source.addChild(txt);

        _btn = new CButton();
        _btn.addButtonTexture(130,40,CButton.GREEN, true);
        _btn.clickCallback = onClick;
        _btn.y = 160;
        _source.addChild(_btn);
        txt = new CTextField(130, 40, "Далее");
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
        for (var i:int=0; i<aw.length; i++) {
            it = new Item(aw[0]);
            it.y = -35;
            _source.addChild(it);
            _items.push(it);
        }
        switch (_items.length) {
            case 1: _items[0].x = 0; break;
            case 2: _items[0].x = -50; _items[1].x = 50; break;
            case 3: _items[0].x = -80; _items[1].x = 0; _items[2].x = 80; break;
        }
        super.showIt();
    }

    private function onClick():void {
        onClickExit();
    }

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

    override protected function deleteIt():void {
        super.deleteIt();
    }
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
import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.utils.Color;
import utils.CTextField;
import utils.MCScaler;

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
            im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.dataResource.objectResources[_aw.idResource].imageShop));
        } else if (_aw.typeResource == 'plant') {
            im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.dataResource.objectResources[_aw.idResource].imageShop + '_icon'));
        } else if (_aw.typeResource == 'decor') {
            im = new Image(g.allData.atlas['decorAtlas'].getTexture(g.dataBuilding.objectBuilding[_aw.idResource].image));
        } else if (_aw.typeResource) {
            im = new Image(g.allData.atlas['instrumentAtlas'].getTexture(g.dataResource.objectResources[_aw.idResource].imageShop));
        }

        if (im) {
            MCScaler.scale(im, 70, 70);
            im.alignPivot();
            addChild(im);
        }
    }

    private function deleteIt():void {
        if (_txt) {
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
        } else {
            flyItResource(i);
        }
    }

    private function flyItDecor(i:int):void {
        var f1:Function = function (dbId:int):void {
            g.userInventory.addToDecorInventory(_aw.idResource, dbId);
            deleteIt();
        };
        var f:Function = function ():void {
            g.cont.animationsResourceCont.removeChild(_source);
            g.directServer.buyAndAddToInventory(_aw.idResource, f1);
        };
        removeChild(im);
        _source.addChild(im);
        g.cont.animationsResourceCont.addChild(_source);
        new TweenMax(_source, .5, {scaleX:.2, scaleY:.2, ease:Back.easeIn, onComplete:f, delay:i * .2});
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
        if (g.dataResource.objectResources[_aw.idResource].placeBuild == BuildType.PLACE_SKLAD) {
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
