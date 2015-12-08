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
        _source.x = g.stageWidth/2;
        _source.y = 70;

        _progress = new AmbarProgress();
        _progress.source.scaleX = _progress.source.scaleY = .75;
        _progress.source.x = _source.width/2;
        _progress.source.y = _source.height/2;
        _source.addChild(_progress.source);

        _resourceSprite = new Sprite();
        _source.addChild(_resourceSprite);

        _ambarImage = new Image(g.allData.atlas['buildAtlas'].getTexture('ambar'));
        MCScaler.scale(_ambarImage, 70, 70);
        _ambarImage.pivotX = _ambarImage.width/2;
        _ambarImage.pivotY = _ambarImage.height/2;
        _ambarImage.x = 300;
        _source.addChild(_ambarImage);
        _ambarImage.visible = false;

        _skladImage = new Image(g.allData.atlas['buildAtlas'].getTexture('sklad'));
        MCScaler.scale(_skladImage, 70, 70);
        _skladImage.pivotX = _skladImage.width/2;
        _skladImage.pivotY = _skladImage.height/2;
        _skladImage.x = 300;
        _source.addChild(_skladImage);
        _skladImage.visible = false;
    }

    public function onResize():void {
        _source.x = Starling.current.nativeStage.stageWidth/2;
    }

    public function showIt(place:int):void {
        _countFlying++;
        if (!_isShow) {
            g.cont.interfaceCont.addChild(_source);
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
        im = new Image(g.allData.atlas[item.url].getTexture(item.imageShop));
        MCScaler.scale(im, 50, 50);
        im.x = -im.width/2 - 140;
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
        g.cont.interfaceCont.removeChild(_source);
        _isShow = false;
    }

    public function pointXY():Point {
        return _source.localToGlobal(new Point(-170,-5));
    }

}
}
