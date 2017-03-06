/**
 * Created by user on 6/26/15.
 */
package ui.craftPanel {
import data.BuildType;

import flash.geom.Point;

import manager.Vars;

import resourceItem.ResourceItem;

import starling.core.Starling;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;

import utils.MCScaler;

import windows.ambar.AmbarProgress;

public class CraftPanel {
    private var _source:Sprite;
    private var _progress:AmbarProgress;
    private var _isShow:Boolean;
    private var _resourceSprite:Sprite;
    private var _ambarImage:Image;
    private var _skladImage:Image;
    private var _counter:int;
    private var _countFlying:int;

    private var g:Vars = Vars.getInstance();

    public function CraftPanel() {
        _countFlying = 0;
        _isShow = false;
        _source = new Sprite();
        _source.touchable = false;
        _source.pivotX = _source.width/2;
        _source.pivotY = _source.height/2;
        _source.x = g.managerResize.stageWidth/2;
        _source.y = 70;

        _progress = new AmbarProgress(false, false);
        _progress.source.scaleX = _progress.source.scaleY = .75;
        _progress.source.x = _source.width/2;
        _progress.source.y = _source.height/2;
        _source.addChild(_progress.source);

        _resourceSprite = new Sprite();
        _source.addChild(_resourceSprite);

        _ambarImage = new Image(g.allData.atlas['iconAtlas'].getTexture('ambar_icon'));
        MCScaler.scale(_ambarImage, 70, 70);
        _ambarImage.pivotX = _ambarImage.width/2;
        _ambarImage.pivotY = _ambarImage.height/2;
        _ambarImage.x = 150;
        _ambarImage.y = -18;
        _source.addChild(_ambarImage);
        _ambarImage.visible = false;

        _skladImage = new Image(g.allData.atlas['iconAtlas'].getTexture('sklad_icon'));
        MCScaler.scale(_skladImage, 70, 70);
        _skladImage.pivotX = _skladImage.width/2;
        _skladImage.pivotY = _skladImage.height/2;
        _skladImage.x = 157;
        _skladImage.y = -12;
        _source.addChild(_skladImage);
        _skladImage.visible = false;
    }

    public function onResize():void {
        if (_source) _source.x = g.managerResize.stageWidth/2;
    }

    public function showIt(place:int):void {
        _countFlying++;
        if (!_isShow) {
            g.cont.windowsCont.addChild(_source);
            _isShow = true;
        }

        _skladImage.visible = false;
        _ambarImage.visible = false;

        if (place == BuildType.PLACE_AMBAR) {
            _ambarImage.visible = true;
            _progress.setProgress(g.userInventory.currentCountInAmbar/g.user.ambarMaxCount);
        } else {
            _skladImage.visible = true;
            _progress.setProgress(g.userInventory.currentCountInSklad/g.user.skladMaxCount);
        }
    }

    public function afterFly(item:ResourceItem):void {
        _countFlying--;
        _counter = 40;
        g.gameDispatcher.addEnterFrame(onEnterFrame);
        if (item.placeBuild == BuildType.PLACE_AMBAR) {
            _progress.setProgress(g.userInventory.currentCountInAmbar/g.user.ambarMaxCount);
        } else {
            _progress.setProgress(g.userInventory.currentCountInSklad/g.user.skladMaxCount);
        }
        while (_resourceSprite.numChildren) {
            _resourceSprite.removeChildAt(0);
        }
        var im:Image;
        if (item.buildType == BuildType.PLANT)
            im = new Image(g.allData.atlas['resourceAtlas'].getTexture(item.imageShop + '_icon'));
        else
            im = new Image(g.allData.atlas[item.url].getTexture(item.imageShop));
        MCScaler.scale(im, 50, 50);
        im.x = -im.width/2 - 170;
        im.y = -im.height/2;
        _resourceSprite.addChild(im);
    }

    public function afterFlyWithId(id:int):void {
        _countFlying--;
        _counter = 40;
        g.gameDispatcher.addEnterFrame(onEnterFrame);
        if (g.allData.getResourceById(id).placeBuild == BuildType.PLACE_AMBAR) {
            _progress.setProgress(g.userInventory.currentCountInAmbar/g.user.ambarMaxCount);
        } else {
            _progress.setProgress(g.userInventory.currentCountInSklad/g.user.skladMaxCount);
        }
        while (_resourceSprite.numChildren) {
            _resourceSprite.removeChildAt(0);
        }
        var im:Image;
        if (g.allData.getResourceById(id).buildType == BuildType.PLANT)
            im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(id).imageShop + '_icon'));
        else
            im = new Image(g.allData.atlas[g.allData.getResourceById(id).url].getTexture(g.allData.getResourceById(id).imageShop));
        MCScaler.scale(im, 50, 50);
        im.x = -im.width/2 - 170;
        im.y = -im.height/2;
        _resourceSprite.addChild(im);
    }

    private function onEnterFrame():void {
        _counter--;
        if (_counter <= 0) {
            if (_countFlying <= 0) {
                g.gameDispatcher.removeEnterFrame(onEnterFrame);
                hideIt();
            } else {
                _counter = 30;
            }
        }
    }

    private function hideIt():void {
        while (_resourceSprite.numChildren) {
            _resourceSprite.removeChildAt(0);
        }
        g.cont.windowsCont.removeChild(_source);
        _isShow = false;
    }

    public function pointXY():Point {
        var p:Point;
        if (g.windowsManager.currentWindow) {
            p = new Point(330,55);
            return p;
        }
        p = new Point(-165,-5);
        p = _source.localToGlobal(p);
        return p;
    }

}
}
