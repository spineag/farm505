/**
 * Created by user on 10/9/15.
 */
package ui.toolsPanel {
import flash.geom.Rectangle;

import manager.Vars;

import starling.animation.Tween;

import starling.display.Image;
import starling.display.Sprite;
import starling.filters.ColorMatrixFilter;

import utils.CSprite;

public class RepositoryBox {
    public var source:Sprite;
    private var _contRect:Sprite;
    private var _cont:Sprite;
    private var _leftBtn:CSprite;
    private var _rightBtn:CSprite;
    private var _arrItems:Array;
    private var filter:ColorMatrixFilter;
    private var count:int;
    private var _shift:int;

    private var g:Vars = Vars.getInstance();

    public function RepositoryBox() {
        filter = new ColorMatrixFilter();
        filter.adjustSaturation(-1);
        _arrItems = [];
        source = new Sprite();
        var im:Image = new Image(g.interfaceAtlas.getTexture("friends_plawka"));
        im.height = 100;
        im.width = 330;
        source.addChild(im);
        _contRect = new Sprite();
        source.addChild(_contRect);
        _contRect.clipRect = new Rectangle(0, 0, 270, 90);
        _contRect.y = 5;
        _contRect.x = 20;
        _cont = new Sprite();
        _contRect.addChild(_cont);

        _leftBtn = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture('shop_arrow'));
        im.scaleX = im.scaleY = .5;
        im.x = im.width;
        im.y = im.height;
        im.rotation = Math.PI;
        _leftBtn.addChild(im);
        _rightBtn = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture('shop_arrow'));
        im.scaleX = im.scaleY = .5;
        _rightBtn.addChild(im);

        _leftBtn.y = 90/2 - _leftBtn.height/2;
        _leftBtn.x = 2;
        _leftBtn.filter = filter;
        _rightBtn.y = 90/2 - _rightBtn.height/2;
        _rightBtn.x = 20 + 270 + 2;
        source.addChild(_leftBtn);
        source.addChild(_rightBtn);
        _leftBtn.endClickCallback = onLeft;
        _rightBtn.endClickCallback = onRight;
    }

    public function set visible(value:Boolean):void {
        source.visible = value;
        deleteItems();
        if (value) {
            showItems();
        }
    }

    private function showItems():void {
        var item:RepositoryItem;
        count = 0;
        var ob:Object = g.userInventory.decorInventory;
        for (var id:String in ob) {
            item = new RepositoryItem();
            item.fillIt(g.dataBuilding.objectBuilding[id], ob[id].count, this);
            item.source.x = count * 90;
            _cont.addChild(item.source);
            _arrItems.push(item);
            count++;
        }
        if (count < 4) {
//            for (count; count < 3; count++) {
//                item = new RepositoryItem();
//                item.source.x = count * 90;
//                _cont.addChild(item.source);
//                _arrItems.push(item);
//            }
            _rightBtn.filter = filter;
        } else {
            _rightBtn.filter = null;
        }
    }

    private function deleteItems():void {
        for (var i:int=0; i<_arrItems.length; i++) {
            _arrItems[i].clearIt();
        }
        while (_cont.numChildren) _cont.removeChildAt(0);
        _arrItems.length = 0;
    }

    private function onLeft():void {
        if (_leftBtn.filter == filter) return;
        _rightBtn.filter = null;
        var tween:Tween = new Tween(_cont, 0.5);
        tween.moveTo(count,0);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
            _leftBtn.filter = filter;
            _rightBtn.filter = null;
        };
        g.starling.juggler.add(tween);

    }

    private function onRight():void {
        if (_rightBtn.filter == filter) return;
        _leftBtn.filter = null;
        var tween:Tween = new Tween(_cont, 0.5);
        tween.moveTo((count - 3)* - 90 ,0);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
            _rightBtn.filter = filter;
            _leftBtn.filter = null;
        };
        g.starling.juggler.add(tween);
//        if (_cont.x/2 == _cont.x/2) _leftBtn.filter = filter;
    }
}
}
