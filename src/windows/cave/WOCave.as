
package windows.cave {

import com.junkbyte.console.Cc;

import starling.display.Image;
import starling.display.Sprite;

import windows.WOComponents.Birka;
import windows.Window;

public class WOCave extends Window {
    private var _arrItems:Array;
    private var _topBG:Sprite;
    private var _birka:Birka;

    public function WOCave() {
        super();
        _woWidth = 380;
        _woHeight = 134;
        createBG();
        createCaveItems();
        callbackClickBG = onClickExit;
        _birka = new Birka('Пещера', _source, 455, 580);
        _birka.flipIt();
        _birka.source.rotation = Math.PI/2;
        _birka.source.x = 0;
        _birka.source.y = 150;
    }

    private function createBG():void {
        _topBG = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_line_l'));
        _topBG.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_line_r'));
        im.x = _woWidth - im.width;
        _topBG.addChild(im);
        for (var i:int=0; i<6; i++) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_line_c'));
            im.x = 50*(i+1);
            _topBG.addChildAt(im, 0);
        }
        _topBG.flatten();
        _topBG.x = -_woWidth/2;
        _topBG.y = -_woHeight/2 + 80;
        _source.addChild(_topBG);
    }

    private function createCaveItems():void {
        var item:CaveItem;
        _arrItems = [];
        for (var i:int = 0; i < 3; i++) {
            item = new CaveItem();
            item.source.x = -_woWidth/2 + 77 + i*107;
            item.source.y = -_woHeight/2 + 115;
            _source.addChild(item.source);
            _arrItems.push(item);
        }
    }

     public function onClickExit():void {
        clearItems();
        super.hideIt();
    }

    public function fillIt(arrIds:Array, f:Function):void {
        try {
            var f1:Function = function (id:int):void {
                if (f != null) {
                    f.apply(null, [id]);
                }
                onClickExit();
            };
            for (var i:int = 0; i < arrIds.length; i++) {
                _arrItems[i].fillData(g.dataResource.objectResources[arrIds[i]], f1);
            }
        } catch(e:Error) {
            Cc.error('WOCave fillIt error: ' + e.errorID + ' - ' + e.message);
            g.woGameError.showIt();
        }
    }

    private function clearItems():void {
        for (var i:int = 0; i < _arrItems.length; i++) {
            _arrItems[i].clearIt();
        }
    }
}
}
