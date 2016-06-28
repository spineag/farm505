/**
 * Created by andy on 6/28/16.
 */
package tutorial.helpers {
import manager.ManagerFilters;
import manager.Vars;

import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import utils.CSprite;

public class GameHelper {
    private var _source:CSprite;
    private var _bg:Image;
    private var _txt:TextField;
    private var _catHead:Sprite;
    private var g:Vars = Vars.getInstance();

    public function GameHelper() {
        _source = new CSprite();
        _bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('baloon_3'));
        _bg.scaleX = -1;
        _bg.x = _bg.width;
        _source.addChild(_bg);
        _txt = new TextField(260, 90, "", g.allData.fonts['BloggerBold'], 20, ManagerFilters.TEXT_BLUE_COLOR);
        _txt.x = 36;
        _txt.y = 27;
        _txt.autoScale = true;
        _source.addChild(_txt);
        createCatHead();
    }
    public function showIt(st:String, callback:Function = null):void {
        _txt.text = st;
        _source.x = Starling.current.nativeStage.stageWidth/2 - 200;
        _source.y = Starling.current.nativeStage.stageHeight/2 - 80;
        _source.endClickCallback = callback;
        g.cont.hintGameCont.addChild(_source);
    }

    private function createCatHead():void {
        _catHead = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_right'));
        im.scaleX = im.scaleY = .7;
        _catHead.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cat_icon'));
        im.scaleX = -1.3;
        im.scaleY = 1.3;
        im.x = 75;
        im.y = 16;
        _catHead.addChild(im);
        _catHead.x = 295;
        _catHead.y = 45;
        _source.addChild(_catHead);
    }

    public function hideIt():void {
        g.cont.hintGameCont.removeChild(_source);
        while (_source.numChildren) _source.removeChildAt(0);
        _catHead.dispose();
        _catHead = null;
        _txt.dispose();
        _bg = null;
        _source = null;
    }
}
}
