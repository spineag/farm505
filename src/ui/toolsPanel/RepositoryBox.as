/**
 * Created by user on 10/9/15.
 */
package ui.toolsPanel {
import com.greensock.TweenMax;
import com.greensock.easing.Back;
import com.greensock.easing.Linear;

import flash.geom.Rectangle;

import manager.OwnEvent;
import manager.Vars;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;

import utils.CButton;
import utils.MCScaler;

import windows.WOComponents.HorizontalPlawka;

public class RepositoryBox {
    public var source:Sprite;
    private var _contRect:Sprite;
    private var _cont:Sprite;
    private var _leftBtn:CButton;
    private var _rightBtn:CButton;
    private var _arrItems:Array;
    private var count:int;
    private var _shift:int;

    private var g:Vars = Vars.getInstance();

    public function RepositoryBox() {
        _arrItems = [];
        source = new Sprite();
        var pl:HorizontalPlawka = new HorizontalPlawka(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_back_l'), g.allData.atlas['interfaceAtlas'].getTexture('main_panel_back_c'),
                g.allData.atlas['interfaceAtlas'].getTexture('main_panel_back_r'), 256);
        source.addChild(pl);
        _contRect = new Sprite();
        source.addChild(_contRect);
        _contRect.clipRect = new Rectangle(0, 0, 188, 62);
        _contRect.y = 8;
        _contRect.x = 35;
        _cont = new Sprite();
        _contRect.addChild(_cont);
        source.visible = false;

        _leftBtn = new CButton();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friends_panel_ar'));
        _leftBtn.addDisplayObject(im);
        _leftBtn.setPivots();
        MCScaler.scale(_leftBtn, 60, 60);
        _leftBtn.x = 22;
        _leftBtn.y = 40;
        source.addChild(_leftBtn);
        _leftBtn.clickCallback = onLeft;

        _rightBtn = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friends_panel_ar'));
        im.scaleX = -1;
        im.x = im.width;
        _rightBtn.addDisplayObject(im);
        _rightBtn.setPivots();
        MCScaler.scale(_rightBtn, 60, 60);
        _rightBtn.x = 237;
        _rightBtn.y = 40;
        source.addChild(_rightBtn);
        _rightBtn.clickCallback = onRight;
    }

    public function showIt():void {
        g.event.addEventListener(OwnEvent.UPDATE_REPOSITORY, updateItems);
        _shift = 0;
        showItems();
        source.visible = true;
        TweenMax.killTweensOf(source);
        new TweenMax(source, .5, {y:Starling.current.nativeStage.stageHeight - 83, ease:Back.easeOut});
    }

    public function hideIt(needQuick:Boolean = false):void {
        g.event.removeEventListener(OwnEvent.UPDATE_REPOSITORY, updateItems);
        TweenMax.killTweensOf(source);
        new TweenMax(source, .5, {y:Starling.current.nativeStage.stageHeight + 10, ease:Back.easeOut, onComplete: function():void {source.visible = false; deleteItems()}});
    }

    private function showItems():void {
        var item:RepositoryItem;
        count = 0;
        var ob:Object = g.userInventory.decorInventory;
        for (var id:String in ob) {
            item = new RepositoryItem();
            item.fillIt(g.dataBuilding.objectBuilding[id], ob[id].count, ob[id].ids, this);
            item.source.x = count * 64;
            _cont.addChild(item.source);
            _arrItems.push(item);
            count++;
        }
        checkBtns();
    }

    public function updateItems():void { // not optimal
        deleteItems();
        showItems();
        if ((_shift + 1)*3 > count) {
            _cont.x = 0;
            _shift = 0;
            checkBtns();
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
//        _shift--;
//        var tween:Tween = new Tween(_cont, 0.5);
//        tween.moveTo(-192*_shift ,0);
//        tween.onComplete = function ():void {
//            g.starling.juggler.remove(tween);
//            checkBtns();
//        };
//        g.starling.juggler.add(tween);
        if (_shift > 0) {
            _shift -= 3;
            if (_shift<0) _shift = 0;
            new TweenMax(_cont, .5, {x:-_shift*60, ease:Linear.easeNone ,onComplete: function():void {}});
        }
        checkBtns();
    }

    private function onRight():void {
//        _shift++;
//        var tween:Tween = new Tween(_cont, 0.5);
//        tween.moveTo(-192*_shift ,0);
//        tween.onComplete = function ():void {
//            g.starling.juggler.remove(tween);
//            checkBtns();
//        };
//        g.starling.juggler.add(tween);
        var l:int = _arrItems.length;

        if (_shift +1 < l) {
            _shift += 3;
            if (_shift > l-3) _shift = l-3;
            new TweenMax(_cont, .5, {x:-_shift*60, ease:Linear.easeNone ,onComplete: function():void {}});
        }
        checkBtns();
    }

    private function checkBtns():void {
        if (_shift == 0) {
            _leftBtn.setEnabled = false;
        } else {
            _leftBtn.setEnabled = true;
        }
        if ((_shift + 1)*3 < count) {
            _rightBtn.setEnabled = true;
        } else {
            _rightBtn.setEnabled = false;
        }
    }
}
}
