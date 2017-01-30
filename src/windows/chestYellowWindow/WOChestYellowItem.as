/**
 * Created by user on 12/28/16.
 */
package windows.chestYellowWindow {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import data.BuildType;

import flash.geom.Point;

import manager.ManagerChest;
import manager.ManagerFilters;
import manager.Vars;

import starling.display.Image;

import starling.display.Sprite;
import starling.utils.Color;

import utils.CTextField;
import utils.MCScaler;

public class WOChestYellowItem {
    public  var source:Sprite;
    private var _data:Object;
    private var _parent:Sprite;
    private var _callback:Function;
    private var _particle:Sprite;
    private var _txt:CTextField;
    private var g:Vars = Vars.getInstance();

    public function WOChestYellowItem(obj:Object, parent:Sprite, f:Function) {
        _data = obj;
        _parent = parent;
        _callback = f;

        var im:Image;
        switch (_data.type) {
            case ManagerChest.RESOURCE:
                    if (g.dataResource.objectResources[_data.resource_id].buildType == BuildType.PLANT) {
                        im = new Image(g.allData.atlas[g.dataResource.objectResources[_data.resource_id].url].getTexture(g.dataResource.objectResources[_data.resource_id].imageShop + '_icon'));
                    } else {
                        im = new Image(g.allData.atlas[g.dataResource.objectResources[_data.resource_id].url].getTexture(g.dataResource.objectResources[_data.resource_id].imageShop));
                    }
                _txt = new CTextField(80, 60, '+' + String(_data.resource_count));
                _txt.setFormat(CTextField.MEDIUM30, 26, Color.WHITE, ManagerFilters.BROWN_COLOR);
                break;

            case ManagerChest.SOFT_MONEY:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
                _txt = new CTextField(80, 60, '+' + String(_data.money_count));
                _txt.setFormat(CTextField.MEDIUM30, 26, Color.WHITE, ManagerFilters.BROWN_COLOR);
                break;

            case ManagerChest.XP:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star'));
                _txt = new CTextField(80, 60, '+' + String(_data.xp_count));
                _txt.setFormat(CTextField.MEDIUM30, 26, Color.WHITE, ManagerFilters.BROWN_COLOR);
                break;
        }
        MCScaler.scale(im, 80, 80);
        im.x = -im.width / 2;
        im.y = -im.height / 2;
        source = new Sprite();
        source.addChild(im);
        _txt.x = -12;
        _txt.y = 15;
        source.addChild(_txt);
        _parent.addChild(source);
        showIt();
    }

    public function updateTextField():void {
        _txt.updateIt();
    }

    private function addParticle():void {
        _particle = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('product_particle'));
        im.scaleX = im.scaleY = g.scaleFactor;
        im.x = -im.width / 2;
        im.y = -im.height / 2;
        _particle.addChild(im);
        source.addChildAt(_particle, 0);
        _particle.touchable = false;
        new TweenMax(_particle, .3, {
            scaleX: g.scaleFactor * 4,
            scaleY: g.scaleFactor * 4,
            ease: Linear.easeIn,
            onComplete: makeTweenParticle
        });
    }

    private function makeTweenParticle():void {
        new TweenMax(_particle, 4, {rotation: -Math.PI * 4, ease: Linear.easeNone});
    }

    private function hideParticle(delay:Number):void {
        new TweenMax(_particle, .4, {
            scaleX: .1,
            scaleY: .1,
            onComplete: removeParticle,
            ease: Linear.easeNone,
            delay: delay
        });
    }

    private function removeParticle():void {
        if (_particle) {
            if (source.contains(_particle))source.removeChild(_particle);
            TweenMax.killTweensOf(_particle);
            _particle.dispose();
            _particle = null;
        }
    }

    private function showIt():void {
        source.scaleX = source.scaleY = .5;
        new TweenMax(source, .1, {scaleX: 1.5, scaleY: 1, ease: Linear.easeIn, onComplete: showIt1});
    }

    private function showIt1():void {
        addParticle();
        new TweenMax(source, .1, {scaleX: 1, scaleY: 1.5, ease: Linear.easeIn, onComplete: showIt2});
    }

    private function showIt2():void {
        new TweenMax(source, .1, {scaleX: 1.3, scaleY: 1.3, ease: Linear.easeIn, onComplete: delayBeforeFly});

    }

    private function delayBeforeFly():void {
        updateTextField();
        new TweenMax(source, .1, {scaleX: 1.3, scaleY: 1.3, onComplete: flyIt, delay: 1.5});
    }

    private function flyIt():void {
        hideParticle(0);
        switch (_data.type) {
            case ManagerChest.RESOURCE:
                flyItResource();
                break;

            case ManagerChest.SOFT_MONEY:
                flyItMoney(true);
                break;
            case ManagerChest.XP:
                flyItXp();
                break;
        }
    }

    private function flyItMoney(isSoft:Boolean):void {
        var endPoint:Point;

        var f1:Function = function ():void {
            if (isSoft) {
                g.userInventory.addMoney(2, _data.money_count);
            } else {
                g.userInventory.addMoney(1, _data.money_count);
            }
            deleteIt();
        };

        endPoint = new Point();
        endPoint.x = source.x;
        endPoint.y = source.y;
        endPoint = _parent.localToGlobal(endPoint);
        _parent.removeChild(source);
        _parent = g.cont.animationsResourceCont;
        source.x = endPoint.x;
        source.y = endPoint.y;
        _parent.addChild(source);
        if (isSoft) {
            endPoint = g.softHardCurrency.getSoftCurrencyPoint();
        } else {
            endPoint = g.softHardCurrency.getHardCurrencyPoint();
        }
        var tempX:int = source.x - 70;
        var tempY:int = source.y + 30 + int(Math.random() * 20);
        var dist:int = int(Math.sqrt((source.x - tempX) * (source.x - tempX) + (source.y - tempY) * (source.y - tempY)));
        dist += int(Math.sqrt((tempX - endPoint.x) * (tempX - endPoint.x) + (tempY - endPoint.y) * (tempY - endPoint.y)));
        var t:Number = dist / 1000 * 2;
        if (t > 2) t -= .6;
        if (t > 3) t -= 1;
        new TweenMax(source, t, {bezier: [{x: tempX, y: tempY}, {x: endPoint.x, y: endPoint.y}], scaleX:.5, scaleY:.5, ease: Linear.easeOut, onComplete: f1});
    }

    private function flyItResource():void {
        var endPoint:Point;

        var f1:Function = function ():void {
            g.craftPanel.afterFlyWithId(_data.resource_id);
            deleteIt();
        };
        g.userInventory.addResource(_data.resource_id, _data.resource_count);
        endPoint = new Point();
        endPoint.x = source.x;
        endPoint.y = source.y;
        endPoint = _parent.localToGlobal(endPoint);
        _parent.removeChild(source);
        _parent = g.cont.animationsResourceCont;
        source.x = endPoint.x;
        source.y = endPoint.y;
        _parent.addChild(source);
        if (g.dataResource.objectResources[_data.resource_id].placeBuild == BuildType.PLACE_SKLAD) {
            g.craftPanel.showIt(BuildType.PLACE_SKLAD);
        } else {
            g.craftPanel.showIt(BuildType.PLACE_AMBAR);
        }
        endPoint = g.craftPanel.pointXY();
        var tempX:int = source.x - 70;
        var tempY:int = source.y + 30 + int(Math.random() * 20);
        var dist:int = int(Math.sqrt((source.x - tempX) * (source.x - tempX) + (source.y - tempY) * (source.y - tempY)));
        dist += int(Math.sqrt((tempX - endPoint.x) * (tempX - endPoint.x) + (tempY - endPoint.y) * (tempY - endPoint.y)));
        var t:Number = dist / 1000 * 2;
        if (t > 2) t -= .6;
        if (t > 3) t -= 1;
        new TweenMax(source, t, {bezier: [{x: tempX, y: tempY}, {x: endPoint.x, y: endPoint.y}], scaleX:.5, scaleY:.5, ease: Linear.easeOut, onComplete: f1});
    }

    private function flyItXp():void {
        var endPoint:Point;

        var f1:Function = function ():void {
            g.xpPanel.serverAddXP(_data.xp_count);
            deleteIt();
        };

        endPoint = new Point();
        endPoint.x = source.x;
        endPoint.y = source.y;
        endPoint = _parent.localToGlobal(endPoint);
        _parent.removeChild(source);
        _parent = g.cont.animationsResourceCont;
        source.x = endPoint.x;
        source.y = endPoint.y;
        _parent.addChild(source);
        endPoint = g.xpPanel.getPanelPoints();
        var tempX:int = source.x - 70;
        var tempY:int = source.y + 30 + int(Math.random() * 20);
        var dist:int = int(Math.sqrt((source.x - tempX) * (source.x - tempX) + (source.y - tempY) * (source.y - tempY)));
        dist += int(Math.sqrt((tempX - endPoint.x) * (tempX - endPoint.x) + (tempY - endPoint.y) * (tempY - endPoint.y)));
        var t:Number = dist / 1000 * 2;
        if (t > 2) t -= .6;
        if (t > 3) t -= 1;
        new TweenMax(source, t, {bezier: [{x: tempX, y: tempY}, {x: endPoint.x, y: endPoint.y}], scaleX:.5, scaleY:.5, ease: Linear.easeOut, onComplete: f1
        });
    }

    private function deleteIt():void {
        TweenMax.killTweensOf(source);
        _parent.removeChild(source);
        if (_txt) {
            source.removeChild(_txt);
            _txt.deleteIt();
            _txt = null;
        }
        source.dispose();
        source = null;
        _parent = null;
        if (_data.resource_id) {
            if (_callback != null) {
                _callback.apply();
                _callback = null;
            }
        }
        _data = null;
    }
}
}