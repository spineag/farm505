/**
 * Created by user on 7/24/15.
 */
package windows.paperWindow {
import starling.display.Sprite;
import starling.events.Event;
import starling.utils.Color;

import utils.CSprite;

import windows.Window;

public class WOPaper extends Window{
    private var _data:Object;
    private var _contImage:Sprite;
    public function WOPaper() {
        createTempBG(550, 150, Color.GRAY);
        createExitButton(g.interfaceAtlas.getTexture('btn_exit'), '', g.interfaceAtlas.getTexture('btn_exit_click'), g.interfaceAtlas.getTexture('btn_exit_hover'));
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);
        _btnExit.x = 275;
        _btnExit.y = -75;
        _contImage = new Sprite();
        _source.addChild(_contImage);
    }

    private function onClickExit():void {
        hideIt();
        while (_contImage.numChildren) {
            _contImage.removeChildAt(0);
        }
    }

    public function showItMenu():void {
        showIt();
        createItem();
    }

    private function createItem():void {
        var id:String;
        var r:int;
        var arr:Array;
        arr = [];
        _data = g.dataResource.objectResources;
        for (id in _data) {
            if (g.user.level >= _data[id].blockByLevel) {
                arr.push(_data[id]);
            }
        }
        r = int(1+Math.random()*arr.length);
        var item1:WOPaperItem;
        var item2:WOPaperItem;
        var item3:WOPaperItem;
        var item4:WOPaperItem;
        var item5:WOPaperItem;
        var item6:WOPaperItem;

        item1 = new WOPaperItem(_data[r]);
        item1.source.x = 10 - 275;
        item1.source.y = -65;
        _contImage.addChild(item1.source);
        r = int(1+Math.random()*arr.length);
        item2 = new WOPaperItem(_data[r]);
        item2.source.x = 190 - 275;
        item2.source.y = -65;
        _contImage.addChild(item2.source);
        r = int(1+Math.random()*arr.length);
        item3 = new WOPaperItem(_data[r]);
        item3.source.x = 370 - 275;
        item3.source.y = -65;
        _contImage.addChild(item3.source);
//        item4 = new WOPaperItem(obj[r]);
//        _source.addChild(item4.source);
//
//        item5 = new WOPaperItem(obj[r]);
//        _source.addChild(item5.source);
//
//        item6 = new WOPaperItem(obj[r]);
//        _source.addChild(item6.source);

    }
}
}
