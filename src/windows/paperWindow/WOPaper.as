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
    private var _btnRefresh:CSprite;
    private var _arrPaper:Array;
    private var _leftPage:WOPaperPage;
    private var _rightPage:WOPaperPage;
    private var _shiftPages:int;
    private var _maxPages:int;

    public function WOPaper() {
        _woWidth = 842;
        _woHeight = 526;
        _shiftPages = 1;

        _btnRefresh = new CSprite();
        var ref:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('refresh_icon'));
        _btnRefresh.addChild(ref);
        _btnRefresh.x = -285;
        _btnRefresh.y = 210;
        _source.addChild(_btnRefresh);
        _btnRefresh.endClickCallback = makeRefresh;

        callbackClickBG = onClickExit;
    }

    private function onClickExit():void {
        hideIt();
    }

    public function showItMenu():void {
        _arrPaper = g.managerPaper.arr;
        //temporary
//            _arrPaper = _arrPaper.concat(_arrPaper);
//            _arrPaper = _arrPaper.concat(_arrPaper);
//            _arrPaper = _arrPaper.concat(_arrPaper);
//            _arrPaper = _arrPaper.concat(_arrPaper);
//            _arrPaper = _arrPaper.concat(_arrPaper);
        // end fo temporary block
        if (_arrPaper.length > 60) _arrPaper.length = 60;
        _maxPages = Math.ceil(_arrPaper.length/6);
        if (_maxPages <2) _maxPages = 2;

        createPages();
        showIt();
    }

    private function createPages():void {
        _leftPage = new WOPaperPage(_shiftPages, _maxPages, WOPaperPage.LEFT_SIDE);
        _rightPage = new WOPaperPage(_shiftPages + 1, _maxPages, WOPaperPage.RIGHT_SIDE);
        _leftPage.source.x = -_woWidth/2;
        _leftPage.source.y = -_woHeight/2;
        _rightPage.source.x = 0;
        _rightPage.source.y = -_woHeight/2;
        _source.addChild(_leftPage.source);
        _source.addChild(_rightPage.source);

        var arr:Array = _arrPaper.slice((_shiftPages - 1)*6, (_shiftPages - 1)*6 + 6);
        _leftPage.fillItems(arr);
        arr = _arrPaper.slice(_shiftPages*6, _shiftPages*6 + 6);
        _rightPage.fillItems(arr);
    }

    private function makeRefresh():void {
//        g.directServer.getPaperItems(fillItems);
    }
}
}
