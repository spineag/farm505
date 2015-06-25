/**
 * Created by user on 6/19/15.
 */
package build.farm {
import flash.geom.Point;

import manager.Vars;

import resourceItem.CraftItem;
import resourceItem.RawItem;
import resourceItem.ResourceItem;

import starling.display.Image;
import starling.display.Sprite;
import starling.filters.BlurFilter;
import starling.utils.Color;

import utils.CSprite;

public class Animal {
    public static var EMPTY:int = 1;
    public static var WORKED:int = 2;
    public static var CRAFT:int = 3;

    public var source:CSprite;
    private var _image:Image;
    private var _data:Object;
    private var _craftSprite:Sprite;
    private var _timeToEnd:int;
    private var _state:int;
    private var _frameCounter:int;
    private var _isOnHover:Boolean;

    private var g:Vars = Vars.getInstance();

    public function Animal(data:Object) {
        source = new CSprite();
        _data = data;
        _isOnHover = false;

        _image = new Image(g.tempBuildAtlas.getTexture(_data.image));
        _image.pivotX = _image.width/2;
        _image.pivotY = _image.height;
        source.addChild(_image);

        _craftSprite = new Sprite();
        source.addChild(_craftSprite);

        _state = EMPTY;

        source.hoverCallback = onHover;
        source.outCallback = onOut;
        source.endClickCallback = onClick;
    }

    public function render():void {
        _timeToEnd--;
        if (_timeToEnd <=0) {
            g.gameDispatcher.removeFromTimer(render);
            craftResource();
            _state = CRAFT;
        }
    }

    private function craftResource():void {
        var rItem:ResourceItem = new ResourceItem();
        rItem.fillIt(g.dataResource.objectResources[_data.idResource]);
        var item:CraftItem = new CraftItem(0, 0, rItem, _craftSprite, 1, onCraft);
    }

    private function onCraft():void {
        _state = EMPTY;
    }

    private function onClick():void {
        if (_state == EMPTY) {
            // проверка есть ли хавка
            // анимация полета хавки для animal, и далее:
            _timeToEnd = _data.timeCraft;
            g.gameDispatcher.addToTimer(render);
            _state = WORKED;
            var p:Point = new Point(source.x, source.y);
            p = source.parent.localToGlobal(p);
            var rawItem:RawItem = new RawItem(p, g.resourceAtlas.getTexture(g.dataResource.objectResources[_data.idResourceRaw].imageShop), 1, 0);
        }
    }

    private function onHover():void {
        if (_state == EMPTY) {
            source.filter = BlurFilter.createGlow(Color.RED, 10, 2, 1);
        } else {
            source.filter = BlurFilter.createGlow(Color.WHITE, 10, 2, 1);
        }
        _isOnHover = true;
        if (_state == WORKED) {
            _frameCounter = 20;
            g.gameDispatcher.addEnterFrame(countEnterFrame);
        }
    }

    private function onOut():void {
        source.filter = null;
        _isOnHover = false;
        g.gameDispatcher.addEnterFrame(countEnterFrame);
    }

    private function countEnterFrame():void{
        _frameCounter--;
        if(_frameCounter <=0){
            g.gameDispatcher.removeEnterFrame(countEnterFrame);
            if (_isOnHover == true) {
                g.timerHint.showIt(g.cont.gameCont.x + source.parent.x + source.x, g.cont.gameCont.y + source.parent.y + source.y - source.height, _timeToEnd, _data.costForceCraft, _data.name);
            }
            if (_isOnHover == false) {
                source.filter = null;
                g.timerHint.hideIt();
            }
        }
    }
}
}
