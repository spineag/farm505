/**
 * Created by user on 7/24/15.
 */
package windows.paperWindow {
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.utils.Color;

import user.Someone;

import utils.CSprite;

import windows.Window;

public class WOPaper extends Window{
    private var _data:Object;
    private var _contImage:Sprite;
    private var _arrItems:Array;
    private var _btnRefresh:CSprite;

    public function WOPaper() {
        createTempBG(570, 470, Color.GRAY);
        createExitButton(g.interfaceAtlas.getTexture('btn_exit'), '', g.interfaceAtlas.getTexture('btn_exit_click'), g.interfaceAtlas.getTexture('btn_exit_hover'));
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);
        _btnExit.x = 285;
        _btnExit.y = -235;
        _contImage = new Sprite();
        _source.addChild(_contImage);
        _btnRefresh = new CSprite();
        var ref:Image = new Image(g.interfaceAtlas.getTexture('refresh_icon'));
        _btnRefresh.addChild(ref);
        _btnRefresh.x = -285;
        _btnRefresh.y = 210;
        _source.addChild(_btnRefresh);
        createItem();
        _btnRefresh.endClickCallback = makeRefresh;
        callbackClickBG = onClickExit;
    }

    private function onClickExit():void {
        hideIt();
//        while (_contImage.numChildren) {
//            _contImage.removeChildAt(0);
//        }
        clearItems();
    }

    public function showItMenu():void {
        fillItems();
        showIt();
    }

    private function createItem():void {
        var item:WOPaperItem;
        _arrItems = [];
        for (var i:int=0; i<9; i++) {
            item = new WOPaperItem();
            item.source.x = 180*(i%3) - 265;
            item.source.y = int(i/3)*150 - 210;
            _contImage.addChild(item.source);
            _arrItems.push(item);
        }
    }

    public function updatePaperItems():void {
        clearItems();
        g.directServer.getPaperItems(fillItems);
    }

    private function clearItems():void {
        for (var i:int=0; i<_arrItems.length; i++) {
            _arrItems[i].clearIt();
        }
    }

    private function fillItems():void {
        var ar:Array = g.managerPaper.arr;
        for (var i:int=0; i<_arrItems.length; i++) {
            if (ar[i]) _arrItems[i].fillIt(ar[i]);
        }
    }

    private function makeRefresh():void {
        for (var i:int=0; i<_arrItems.length; i++) {
            _arrItems[i].unFillIt();
        }
        g.directServer.getPaperItems(fillItems);
    }
}
}
