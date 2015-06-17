/**
 * Created by user on 6/12/15.
 */
package resourceItem {
import flash.geom.Point;

import resourceItem.ResourceItem;
import manager.Vars;

import starling.animation.Tween;

import starling.display.Image;

import starling.display.Sprite;

import utils.CSprite;
import utils.MCScaler;

public class CraftItem {
    private var _source:CSprite;
    private var _resourceItem:ResourceItem;
    private var _image:Image;
    private var _cont:Sprite;

    private var g:Vars = Vars.getInstance();

    public function CraftItem(_x:int, _y:int, resourceItem:ResourceItem, parent:Sprite) {
        _cont = g.cont.animationsResourceCont;
        _source = new CSprite();
        _resourceItem = resourceItem;
        if (_resourceItem.url == 'resourceAtlas') {
            _image = new Image(g.resourceAtlas.getTexture(_resourceItem.imageShop));
        } else if (_resourceItem.url == 'plantAtlas') {
            _image = new Image(g.plantAtlas.getTexture(_resourceItem.imageShop));
        }

        MCScaler.scale(_image, 50, 50);
        _source.addChild(_image);
        _source.pivotX = _source.width/2;
        _source.pivotY = _source.height/2;
        _source.x = _x + Math.random()*30 - 15;
        _source.y = _y + Math.random()*30 - 15;
        parent.addChild(_source);

        _source.endClickCallback = flyIt;
    }

    private function flyIt():void {
        _source.endClickCallback = null;

        var start:Point = new Point(int(_source.x), int(_source.y));
        start = _source.parent.localToGlobal(start);
        _source.parent.removeChild(_source);

        var endX:int = g.stageWidth/2;
        var endY:int = 50;
        _source.x = start.x;
        _source.y = start.y;
        _cont.addChild(_source);

        var tween:Tween = new Tween(_source, 1);
        tween.moveTo(endX, endY);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
            _cont.removeChild(_source);
            while (_source.numChildren) {
                _source.removeChildAt(0);
            }
            _source = null;
            g.userInventory.addResource(_resourceItem.id, 1);
        };
        g.starling.juggler.add(tween);
    }
}
}
