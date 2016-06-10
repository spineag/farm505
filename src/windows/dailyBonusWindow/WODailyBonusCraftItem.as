/**
 * Created by andy on 1/19/16.
 */
package windows.dailyBonusWindow {

import com.greensock.TweenMax;
import com.greensock.easing.Back;
import com.greensock.easing.Linear;

import data.BuildType;

import flash.display.StageDisplayState;

import flash.geom.Point;
import manager.ManagerDailyBonus;
import manager.ManagerFilters;
import manager.Vars;

import resourceItem.CraftItem;

import starling.core.Starling;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.MCScaler;

public class WODailyBonusCraftItem {
    private var _source:Sprite;
    private var _data:Object;
    private var _parent:Sprite;
    private var _callback:Function;
    private var _particle:Sprite;
    private var g:Vars = Vars.getInstance();

    public function WODailyBonusCraftItem(obj:Object, parent:Sprite, f:Function) {
        _data = obj;
        _parent = parent;
        _callback = f;

        var im:Image;
        switch (_data.type) {
            case ManagerDailyBonus.RESOURCE:
                im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.dataResource.objectResources[obj.id].imageShop));
                break;
            case ManagerDailyBonus.PLANT:
                im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.dataResource.objectResources[obj.id].imageShop + '_icon'));
                break;
            case ManagerDailyBonus.SOFT_MONEY:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
                break;
            case ManagerDailyBonus.HARD_MONEY:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
                break;
            case ManagerDailyBonus.DECOR:
                im = new Image(g.allData.atlas['decorAtlas'].getTexture(g.dataBuilding.objectBuilding[obj.id].image));
                break;
            case ManagerDailyBonus.INSTRUMENT:
                im = new Image(g.allData.atlas['instrumentAtlas'].getTexture(g.dataResource.objectResources[obj.id].imageShop));
                break;
        }
        MCScaler.scale(im, 100, 100);
        im.x = -im.width/2;
        im.y = -im.height/2;
        _source = new Sprite();
        _source.addChild(im);
//        if (obj.type == ManagerDailyBonus.HARD_MONEY || obj.type == ManagerDailyBonus.SOFT_MONEY) {
            var txt:TextField = new TextField(80, 60, '+'+String(obj.count), g.allData.fonts['BloggerMedium'], 30, Color.WHITE);
            txt.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
            txt.x = 0;
            txt.y = 5;
            _source.addChild(txt);
//        }

        _parent.addChild(_source);
        showIt();
    }

    private function addParticle():void {
        _particle = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('product_particle'));
        im.scaleX = im.scaleY = g.scaleFactor;
        im.x = -im.width/2;
        im.y = -im.height/2;
        _particle.addChild(im);
        _source.addChildAt(_particle, 0);
        _particle.flatten();
        _particle.touchable = false;
        new TweenMax(_particle, .3, {scaleX:g.scaleFactor*4, scaleY:g.scaleFactor*4, ease:Linear.easeIn, onComplete: makeTweenParticle});
    }

    private function makeTweenParticle():void {
        new TweenMax(_particle, 4, {rotation:-Math.PI*4, ease:Linear.easeNone});
    }

    private function hideParticle(delay:Number):void {
        new TweenMax(_particle, .4, {scaleX:.1, scaleY:.1, onComplete: removeParticle, ease:Linear.easeNone, delay:delay});
    }

    private function removeParticle():void {
        if (_particle) {
            if (_source.contains(_particle)) _source.removeChild(_particle);
            TweenMax.killTweensOf(_particle);
            _particle.dispose();
            _particle = null;
        }
    }

    private function showIt():void {
        _source.scaleX = _source.scaleY = .5;
        new TweenMax(_source, .1, {scaleX:1.5, scaleY:1, ease:Linear.easeIn, onComplete:showIt1});
    }

    private function showIt1():void {
        addParticle();
        new TweenMax(_source, .1, {scaleX:1, scaleY:1.5, ease:Linear.easeIn, onComplete:showIt2});
    }

    private function showIt2():void {
        new TweenMax(_source, .1, {scaleX:1.3, scaleY:1.3, ease:Linear.easeIn, onComplete:delayBeforeFly});

    }

    private function delayBeforeFly():void {
        new TweenMax(_source, .1, {scaleX:1.3, scaleY:1.3, onComplete:flyIt, delay:1.5});
    }

    private function flyIt():void {
        hideParticle(0);
        switch (_data.type) {
            case ManagerDailyBonus.RESOURCE:
                flyItResource();
                break;
            case ManagerDailyBonus.PLANT:
                flyItResource();
                break;
            case ManagerDailyBonus.SOFT_MONEY:
                flyItMoney(true);
                break;
            case ManagerDailyBonus.HARD_MONEY:
                flyItMoney(false);
                break;
            case ManagerDailyBonus.DECOR:
                flyItDecor();
                break;
            case ManagerDailyBonus.INSTRUMENT:
                flyItResource();
                break;
        }
    }

    private function flyItDecor():void {
        var f1:Function = function (dbId:int):void {
            g.userInventory.addToDecorInventory(_data.id, dbId);
            deleteIt();
        };
        var f:Function = function ():void {
            g.directServer.buyAndAddToInventory(_data.id, f1);
        };
        var v:Number;
        if (Starling.current.nativeStage.displayState == StageDisplayState.NORMAL) v = .5;
        else v = .2;
        new TweenMax(_source, v, {scaleX:.3, scaleY:.3, ease:Back.easeIn, onComplete:f});
    }

    private function flyItMoney(isSoft:Boolean):void {
        var endPoint:Point;

        var f1:Function = function():void {
            if (isSoft) {
                g.userInventory.addMoney(2, _data.count);
            } else {
                g.userInventory.addMoney(1, _data.count);
            }
            deleteIt();
        };

        endPoint = new Point();
        endPoint.x = _source.x;
        endPoint.y = _source.y;
        endPoint = _parent.localToGlobal(endPoint);
        _parent.removeChild(_source);
        _parent = g.cont.animationsResourceCont;
        _source.x = endPoint.x;
        _source.y = endPoint.y;
        _parent.addChild(_source);
        if (isSoft) {
            endPoint = g.softHardCurrency.getSoftCurrencyPoint();
        } else {
            endPoint = g.softHardCurrency.getHardCurrencyPoint();
        }
        var tempX:int = _source.x - 70;
        var tempY:int = _source.y + 30 + int(Math.random()*20);
        var dist:int = int(Math.sqrt((_source.x - endPoint.x)*(_source.x - endPoint.x) + (_source.y - endPoint.y)*(_source.y - endPoint.y)));
        var v:int;
        if (Starling.current.nativeStage.displayState == StageDisplayState.NORMAL) v = 300;
        else v = 460;
        new TweenMax(_source, dist/v, {bezier:[{x:tempX, y:tempY}, {x:endPoint.x, y:endPoint.y}], scaleX:.5, scaleY:.5, ease:Linear.easeOut ,onComplete: f1});
    }

    private function flyItResource():void {
        var endPoint:Point;

        var f1:Function = function():void {
            g.userInventory.addResource(_data.id, _data.count);
            g.craftPanel.afterFlyWithId(_data.id);
            deleteIt();
        };

        endPoint = new Point();
        endPoint.x = _source.x;
        endPoint.y = _source.y;
        endPoint = _parent.localToGlobal(endPoint);
        _parent.removeChild(_source);
        _parent = g.cont.animationsResourceCont;
        _source.x = endPoint.x;
        _source.y = endPoint.y;
        _parent.addChild(_source);
        if (g.dataResource.objectResources[_data.id].placeBuild == BuildType.PLACE_SKLAD) {
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
        new TweenMax(_source, dist/v, {bezier:[{x:tempX, y:tempY}, {x:endPoint.x, y:endPoint.y}], scaleX:.5, scaleY:.5, ease:Linear.easeOut ,onComplete: f1});
    }

    private function deleteIt():void {
        TweenMax.killTweensOf(_source);
        _parent.removeChild(_source);
        _source.dispose();
        _source = null;
        _parent = null;
        if (_callback != null) {
            _callback.apply();
            _callback = null;
        }
        _data = null;
    }

}
}
