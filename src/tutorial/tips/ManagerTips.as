/**
 * Created by andy on 8/8/16.
 */
package tutorial.tips {
import build.WorldObject;
import build.farm.Animal;
import build.wild.Wild;

import com.junkbyte.console.Cc;

import data.BuildType;
import flash.display.Bitmap;
import flash.events.TimerEvent;
import flash.utils.Timer;

import manager.Vars;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import ui.tips.TipsPanel;

import utils.SimpleArrow;

import windows.WindowsManager;
import windows.shop.WOShop;

public class ManagerTips {
    public static const TIP_RAW_RIDGE:String = 'raw_ridge';        // 8 - priority
    public static const TIP_CRAFT_RIDGE:String = 'craft_ridge';    // 7
    public static const TIP_RAW_FABRICA:String = 'raw_fabrica';    // 6
    public static const TIP_CRAFT_FABRICA:String = 'craft_fabrica';// 4
    public static const TIP_MARKET:String = 'market';              // 3
    public static const TIP_PAPPER:String = 'papper';              // 2
    public static const TIP_ORDER:String = 'order';                // 11
    public static const TIP_DAILY_BONUS:String = 'daily_bonus';    // 10
    public static const TIP_WILD:String = 'wild';                  // 1
    public static const TIP_BUY_HERO:String = 'buy_hero';          // 9
    public static const TIP_RAW_ANIMAL:String = 'raw_animal';      // 5

    private var _arrTips:Array;
    private var _tipsPanel:TipsPanel;
    private var _arrowShow:Boolean;
    private var g:Vars = Vars.getInstance();

    public function ManagerTips(show:Boolean = false) {
        _arrowShow = show;
        if (g.allData.atlas['tipsAtlas']) showTips();
            else loadTips();
    }

    private function loadTips():void {
        var st:String = g.dataPath.getGraphicsPath() + 'x1/';
        g.load.loadImage(st + 'tipsAtlas.png' + g.getVersion('tipsAtlas'), onLoadImage, st);
        g.load.loadXML(st + 'tipsAtlas.xml' + g.getVersion('tipsAtlas'), onLoad, st);
    }

    private function onLoadImage(b:Bitmap, st:String):void {
        onLoad(st);
    }

    private function onLoad(st:String):void {
        if (g.pBitmaps[st + 'tipsAtlas.png' + g.getVersion('tipsAtlas')] && g.pXMLs[st + 'tipsAtlas.xml' + g.getVersion('tipsAtlas')]) {
            g.allData.atlas['tipsAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[st + 'tipsAtlas.png' + g.getVersion('tipsAtlas')].create() as Bitmap), g.pXMLs[st + 'tipsAtlas.xml' + g.getVersion('tipsAtlas')]);
            delete  g.pBitmaps[st + 'tipsAtlas.png' + g.getVersion('tipsAtlas')];
            delete  g.pXMLs[st + 'tipsAtlas.xml' + g.getVersion('tipsAtlas')];
            showTips();
        }
    }

    private function showTips():void {
        _tipsPanel = new TipsPanel();
        if (_arrowShow) _tipsPanel.showArrow();
        _arrowShow = false;
    }
    
    public function onHideWOTips():void {
        _tipsPanel.onHideWO();
    }

    public function deleteTips():void {
        _tipsPanel.hideIt();
        _tipsPanel = null;
        _arrTips.length = 0;
        _arrTips = null;
        (g.allData.atlas['tipsAtlas'] as TextureAtlas).dispose();
        g.allData.atlas['tipsAtlas'] = null;
    }

    public function setUnvisible(v:Boolean):void {
        if (_tipsPanel) {
            _tipsPanel.setUnvisible(v);
        }
    }

    public function getArrTips():Array {
        _arrTips.sortOn('priority', Array.NUMERIC);
        _arrTips.reverse();
        return _arrTips;
    }

    public function calculateAvailableTips():void {
        _arrTips = [];
        var count:int = 0;
        var ob:Object;

        ob = getRawRidge();
        count += ob.count;
        _arrTips.push(ob);

        ob = getCraftRidge();
        count += ob.count;
        _arrTips.push(ob);

        ob = getRawFabrica();
        count += ob.count;
        _arrTips.push(ob);

        ob = getCraftFabrica();
        count += ob.count;
        _arrTips.push(ob);

        ob = getMarket();
        count += ob.count;
        _arrTips.push(ob);

        ob = getPapper();
        count += ob.count;
        _arrTips.push(ob);

        ob = getOrder();
        count += ob.count;
        _arrTips.push(ob);

        ob = getDailyBonus();
        count += ob.count;
        _arrTips.push(ob);

        ob = getWild();
        count += ob.count;
        _arrTips.push(ob);

        ob = getHero();
        count += ob.count;
        _arrTips.push(ob);

        ob = getRawAnimal();
        count += ob.count;
        _arrTips.push(ob);

        _tipsPanel.updateAvailableActionCount(count);
    }

    private function getRawRidge():Object {
        var ob:Object = {};
        ob.type = TIP_RAW_RIDGE;
        ob.array = g.managerPlantRidge.getEmptyRidges();
        if (ob.array.length) {
            ob.priority = 8 + 100;
            ob.count = 1;
        } else {
            ob.priority = 8;
            ob.count = 0;
        }
        return ob;
    }

    private function getCraftRidge():Object {
        var ob:Object = {};
        ob.type = TIP_CRAFT_RIDGE;
        ob.array = g.managerPlantRidge.getRidgesForCraft();
        if (ob.array.length) {
            ob.priority = 7 + 100;
            ob.count = 1;
        } else {
            ob.priority = 7;
            ob.count = 0;
        }
        return ob;
    }

    private function getRawFabrica():Object {
        var ob:Object = {};
        ob.type = TIP_RAW_FABRICA;
        ob.array = g.managerFabricaRecipe.getAllFabricasWithPossibleRecipe();
        if (ob.array.length) {
            ob.priority = 6 + 100;
            ob.count = 1;
        } else {
            ob.priority = 6;
            ob.count = 0;
        }
        return ob;
    }

    private function getCraftFabrica():Object {
        var ob:Object = {};
        ob.type = TIP_CRAFT_FABRICA;
        ob.array = g.managerFabricaRecipe.getAllFabricaWithCraft();
        if (ob.array.length) {
            ob.priority = 4 + 100;
            ob.count = 1;
        } else {
            ob.priority = 4;
            ob.count = 0;
        }
        return ob;
    }

    private function getMarket():Object {
        var ob:Object = {};
        ob.type = TIP_MARKET;
        ob.array = g.townArea.getCityObjectsByType(BuildType.MARKET);
        if (g.user.level < 5) {
            ob.priority = 3;
            ob.count = 0;
        } else {
            ob.priority = 100 + 3;
            ob.count = 1;
        }
        return ob;
    }

    private function getPapper():Object {
        var ob:Object = {};
        ob.type = TIP_PAPPER;
        ob.array = g.townArea.getCityObjectsByType(BuildType.PAPER);
        if (g.user.level < 5) {
            ob.priority = 2;
            ob.count = 0;
        } else {
            ob.priority = 100 + 2;
            ob.count = 1;
        }
        return ob;
    }

    private function getOrder():Object {
        var ob:Object = {};
        ob.type = TIP_ORDER;
        ob.array = g.townArea.getCityObjectsByType(BuildType.ORDER);
        if (g.managerOrder.checkIsAnyFullOrder()) {
            ob.priority = 11 + 100;
            ob.count = 1;
        } else {
            ob.priority = 11;
            ob.count = 0;
        }
        return ob;
    }

    private function getDailyBonus():Object {
        var ob:Object = {};
        ob.type = TIP_DAILY_BONUS;
        ob.array = g.townArea.getCityObjectsByType(BuildType.DAILY_BONUS);
        if (g.managerDailyBonus.count <= 0 && g.user.level >= 8) {
            ob.priority = 10 + 100;
            ob.count = 1;
        } else {
            ob.priority = 10;
            ob.count = 0;
        }
        return ob;
    }

    private function getWild():Object {
        var arr:Array = [];
        var arrWilds:Array = g.townArea.getCityObjectsByType(BuildType.WILD);
        for (var i:int=0; i<arrWilds.length; i++) {
            if (!(arrWilds[i] as Wild).isAtLockedLand && g.userInventory.getCountResourceById((arrWilds[i] as Wild).dataBuild.removeByResourceId) > 0) {
                arr.push(arrWilds[i]);
            }
        }
        var ob:Object = {};
        ob.type = TIP_WILD;
        ob.array = arr;
        if (arr.length) {
            ob.priority = 1 + 100;
            ob.count = 1;
        } else {
            ob.priority = 1;
            ob.count = 0;
        }
        return ob;
    }

    private function getHero():Object {
        var ob:Object = {};
        ob.type = TIP_BUY_HERO;
        if (g.managerCats.curCountCats < g.managerCats.maxCountCats) {
            ob.priority = 9 + 100;
            ob.count = 1;
        } else {
            ob.priority = 9;
            ob.count = 0;
        }
        return ob;
    }

    private function getRawAnimal():Object {
        var ob:Object = {};
        ob.type = TIP_RAW_ANIMAL;
        ob.array = g.managerAnimal.getAllHungryAnimalsForTipsWithPossibleForRaw();
        if (ob.array.length) {
            ob.priority = 5 + 100;
            ob.count = 1;
        } else {
            ob.priority = 5;
            ob.count = 0;
        }
        return ob;
    }
    
    public function onChooseTip(ob:Object):void {
        try {
            if (ob.type == TIP_BUY_HERO) {
                g.windowsManager.openWindow(WindowsManager.WO_SHOP, null, WOShop.VILLAGE);
                createDelay(.7, atBuyCat);
            } else if (ob.type == TIP_RAW_ANIMAL) {
                for (var i:int = 0; i < ob.array.length; i++) {
                    (ob.array[i] as Animal).addArrow(5);
                    if (i==0) {
                        g.cont.moveCenterToXY((ob.array[0] as Animal).farm.source.x, (ob.array[0] as Animal).farm.source.y);
                    }
                }
            } else {
                for (var k:int = 0; k < ob.array.length; k++) {
                    (ob.array[k] as WorldObject).showArrow(5);
                }
                if (ob.array[0]) {
                    g.cont.moveCenterToXY((ob.array[0] as WorldObject).source.x, (ob.array[0] as WorldObject).source.y);
                }
            }
        } catch (e:Error) {
            Cc.error('ManagerTips onChooseTip for type==' + ob.type + ' error: ' + e.message);
        }
    }
    
    private function atBuyCat():void {
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_SHOP) {
            (g.windowsManager.currentWindow as WOShop).addArrowAtPos(0, 3);
        }
    }

    private function createDelay(delay:Number, f:Function):void {
        var func:Function = function():void {
            timer.removeEventListener(TimerEvent.TIMER, func);
            timer = null;
            if (f != null) {
                f.apply();
            }
        };
        var timer:Timer = new Timer(delay*1000, 1);
        timer.addEventListener(TimerEvent.TIMER, func);
        timer.start();
    }

}
}
