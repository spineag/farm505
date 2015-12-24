/**
 * Created by user on 10/9/15.
 */
package ui.toolsPanel {
import com.greensock.TweenMax;
import com.greensock.easing.Back;

import flash.geom.Rectangle;
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
        _contRect.clipRect = new Rectangle(0, 0, 186, 62);
        _contRect.y = 8;
        _contRect.x = 36;
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
        showItems();
        source.visible = true;
        TweenMax.killTweensOf(source);
        new TweenMax(source, .5, {y:Starling.current.nativeStage.stageHeight - 83, ease:Back.easeOut});
    }

    public function hideIt(needQuick:Boolean = false):void {
        TweenMax.killTweensOf(source);
        new TweenMax(source, .5, {y:Starling.current.nativeStage.stageHeight + 10, ease:Back.easeOut, onComplete: function():void {source.visible = false}});
    }

    private function showItems():void {
        var item:RepositoryItem;
        count = 0;
        var ob:Object = g.userInventory.decorInventory;
        for (var id:String in ob) {
            item = new RepositoryItem();
            item.fillIt(g.dataBuilding.objectBuilding[id], ob[id].count, ob[id].ids, this);
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
        } else {
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
//        if (_leftBtn.filter == filter) return;
        _rightBtn.filter = null;
        var tween:Tween = new Tween(_cont, 0.5);
        tween.moveTo(count,0);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
//            _leftBtn.filter = filter;
            _rightBtn.filter = null;
        };
        g.starling.juggler.add(tween);

    }

    private function onRight():void {
//        if (_rightBtn.filter == filter) return;
        _leftBtn.filter = null;
        var tween:Tween = new Tween(_cont, 0.5);
        tween.moveTo((count - 3)* - 90 ,0);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
//            _rightBtn.filter = filter;
            _leftBtn.filter = null;
        };
        g.starling.juggler.add(tween);
//        if (_cont.x/2 == _cont.x/2) _leftBtn.filter = filter;
    }
}
}
