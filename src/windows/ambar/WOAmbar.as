/**
 * Created by user on 6/17/15.
 */
package windows.ambar {

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

import ui.scrolled.DefaultVerticalScrollSprite;

import windows.Window;

public class WOAmbar extends Window {
    private var _scrollSprite:DefaultVerticalScrollSprite;
    private var _arrCells:Array;
    private var _titleTxt:TextField;

    public function WOAmbar() {
        super();
        _woHeight = 500;
        _woWidth = 534;
        _bg = new Image(g.interfaceAtlas.getTexture('wo_ambar'));
        _bg.pivotX = _bg.width/2;
        _bg.pivotY = _bg.height/2;
        _source.addChild(_bg);
        createExitButton(g.interfaceAtlas.getTexture('btn_exit'), '', g.interfaceAtlas.getTexture('btn_exit_click'), g.interfaceAtlas.getTexture('btn_exit_hover'));
        _btnExit.x -= 28;
        _btnExit.y += 40;
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);

        _arrCells = [];
        _scrollSprite = new DefaultVerticalScrollSprite(395, 297, 99, 99);
        _scrollSprite.source.x = 40 - _woWidth/2;
        _scrollSprite.source.y = 79 - _woHeight/2;
        _source.addChild(_scrollSprite.source);
        _scrollSprite.createScoll(440, 0, 300, g.interfaceAtlas.getTexture('scroll_line'), g.interfaceAtlas.getTexture('scroll_box'));

        _titleTxt = new TextField(150, 40, 'Амбар', "Arial", 30, Color.BLACK);
        _titleTxt.x = 189 - _woWidth/2;
        _titleTxt.y = 5 - _woHeight/2;
        _source.addChild(_titleTxt);
    }

    private function onClickExit(e:Event):void {
        unfillItems();
        _scrollSprite.resetAll();
        hideIt();
    }

    override public function showIt():void {
        fillItems();
        super.showIt();
    }

    private function fillItems():void {
        var cell:AmbarCell;
        var arr:Array = g.userInventory.getResourcesForAmbar();
        arr.sortOn("count", Array.DESCENDING | Array.NUMERIC);
        for (var i:int = 0; i < arr.length; i++) {
            cell = new AmbarCell(arr[i]);
            _arrCells.push(cell);
            _scrollSprite.addNewCell(cell.source);
        }
    }

    private function unfillItems():void {
        for (var i:int = 0; i < _arrCells.length; i++) {
            _arrCells[i].clearIt();
        }
        _arrCells.length = 0;
    }
}
}
