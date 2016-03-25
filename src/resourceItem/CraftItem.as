/**
 * Created by user on 6/12/15.
 */
package resourceItem {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;

import data.BuildType;
import flash.geom.Point;

import hint.FlyMessage;

import manager.ManagerFilters;

import manager.Vars;

import particle.CraftItemParticle;

import starling.display.Image;
import starling.display.Sprite;
import starling.filters.BlurFilter;
import starling.text.TextField;
import starling.utils.Color;

import tutorial.SimpleArrow;
import tutorial.TutorialAction;

import ui.xpPanel.XPStar;

import utils.CSprite;
import utils.MCScaler;

import windows.WindowsManager;

public class CraftItem {
    private var _source:CSprite;
    private var _resourceItem:ResourceItem;
    private var _image:Image;
    private var _callback:Function;
    public  var count:int;
    private var _txtNumber:TextField;
    private var _particle:CraftItemParticle;
    private var _arrow:SimpleArrow;
    private var _tutorialCallback:Function;

    private var g:Vars = Vars.getInstance();

    public function CraftItem(_x:int, _y:int, resourceItem:ResourceItem, parent:Sprite, _count:int = 1, f:Function = null, useHover:Boolean = false) {
        count = _count;
        _callback = f;
        _source = new CSprite();
        _resourceItem = resourceItem;
        if (!_resourceItem) {
            Cc.error('CraftItem:: resourceItem == null!');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'craftItem');
            return;
        }
        if (_resourceItem.buildType == BuildType.PLANT)
            _image = new Image(g.allData.atlas['resourceAtlas'].getTexture(_resourceItem.imageShop + '_icon'));
        else
            _image = new Image(g.allData.atlas[_resourceItem.url].getTexture(_resourceItem.imageShop));
        if (!_image) {
            Cc.error('CraftItem:: no such image: ' + _resourceItem.imageShop);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'craftItem');
            return;
        }
        MCScaler.scale(_image, 100*g.scaleFactor, 100*g.scaleFactor);
        _image.x = -_image.width/2;
        _image.y = -_image.height/2;
        _source.addChild(_image);
        _source.x = _x + int(Math.random()*30) - 15;
        _source.y = _y + int(Math.random()*30) - 15;
        parent.addChild(_source);
        _source.endClickCallback = flyIt;
        if (useHover){
            _source.hoverCallback = onHover;
            _source.outCallback = onOut;
        }
        _txtNumber = new TextField(50,50,'',g.allData.fonts['BloggerBold'],18, Color.WHITE);
        _txtNumber.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
//        _txtNumber.x = -5;
        _txtNumber.y = 10;
        _source.addChild(_txtNumber);
    }

    private function onHover():void {
        _image.filter = ManagerFilters.YELLOW_STROKE;
    }

    private function onOut():void {
        _image.filter = null;
    }

    public function removeDefaultCallbacks():void {
        _source.endClickCallback = null;
        _source.hoverCallback = null;
        _source.outCallback = null;
        _source.touchable = false;
    }

    public function set callback(f:Function):void {
        _callback = f;
    }

    public function get source():CSprite {
        return _source;
    }

    public function flyIt():void {
        if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction == TutorialAction.ANIMAL_CRAFT) {
            if (_tutorialCallback != null) {
                _tutorialCallback.apply();
                _tutorialCallback = null;
                removeArrow();
            }
        }
        _image.filter = null;
        if (_resourceItem.placeBuild == BuildType.PLACE_AMBAR && g.userInventory.currentCountInAmbar + count > g.user.ambarMaxCount) {
//            g.flyMessage.showIt(_source,"Амбар заполнен");
            g.windowsManager.openWindow(WindowsManager.WO_WAIT_FREE_CATS, null, true);
            while (_source.numChildren) {
                _source.removeChildAt(0);
            }
            _source = null;
            return;
        }

        if (_resourceItem.placeBuild == BuildType.PLACE_SKLAD && g.userInventory.currentCountInSklad + count > g.user.skladMaxCount) {
            var p:Point = new Point(_source.x, _source.y);
            p = _source.parent.localToGlobal(p);
            g.windowsManager.openWindow(WindowsManager.WO_WAIT_FREE_CATS, null, false);
//            new FlyMessage(p,"Склад заполнен");
            return;
        }
        deleteParticle();
        if (_resourceItem.placeBuild != BuildType.PLACE_NONE)
            g.craftPanel.showIt(_resourceItem.placeBuild);

        if (_callback != null) {
            _callback.apply(null, []);
        }
        _source.visible = true;
        _source.endClickCallback = null;
        _source.filter = null;
        for(var id:String in g.dataRecipe.objectRecipe) {
            if (g.dataRecipe.objectRecipe[id].idResource == _resourceItem.resourceID) {
                _txtNumber.text = String(g.dataRecipe.objectRecipe[id].numberCreate);
            }
        }
        var start:Point = new Point(int(_source.x), int(_source.y));
        start = _source.parent.localToGlobal(start);
        if (_source.parent.contains(_source)) _source.parent.removeChild(_source);

        _image.scaleY = _image.scaleX = 1;
        _source.scaleY = _source.scaleX = 1;
        MCScaler.scale(_image, 50, 50);
        var endPoint:Point = g.craftPanel.pointXY();
        _source.x = start.x;
        _source.y = start.y;
        g.cont.animationsResourceCont.addChild(_source);
        if (g.managerDropResources.checkDrop()) {
            g.managerDropResources.makeDrop(_source.x,_source.y);
        }
        g.userInventory.addResource(_resourceItem.resourceID, count);
        var f1:Function = function():void {
            g.cont.animationsResourceCont.removeChild(_source);
            removeDefaultCallbacks();
            while (_source.numChildren) {
                _source.removeChildAt(0);
            }
            _source = null;
            if (_resourceItem.placeBuild != BuildType.PLACE_NONE)
                g.craftPanel.afterFly(_resourceItem);
        };
        var tempX:int;
        _source.x < endPoint.x ? tempX = _source.x + 50 : tempX = _source.x - 50;
        var tempY:int = _source.y + 30 + int(Math.random()*20);
        var dist:int = int(Math.sqrt((_source.x - endPoint.x)*(_source.x - endPoint.x) + (_source.y - endPoint.y)*(_source.y - endPoint.y)));
        var v:Number = 250;
        new TweenMax(_source, dist/v, {bezier:[{x:tempX, y:tempY}, {x:endPoint.x, y:endPoint.y}], ease:Linear.easeOut ,onComplete: f1});
        new XPStar(_source.x,_source.y,_resourceItem.craftXP);
        if (count > 0) {
            _txtNumber.text = '+' + String(count);
        } else {
            _txtNumber.text = '';
        }
    }

    public function addParticle():void {
        if (_particle) return;
        _particle = new CraftItemParticle(_source);
    }

    public function deleteParticle():void {
        if (_particle) {
            _particle.deleteIt();
            _particle = null;
        }
    }

    public function addArrow(f:Function):void {
        removeArrow();
        _tutorialCallback = f;
        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, _source, 1);
        _arrow.animateAtPosition(0, -_image.height/2);
    }

    public function removeArrow():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
    }

}
}
