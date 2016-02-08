/**
 * Created by user on 2/5/16.
 */
package hint {
import manager.ManagerFilters;
import manager.Vars;
import flash.geom.Rectangle;

import starling.core.Starling;
import starling.display.Image;

import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.MCScaler;

import windows.WOComponents.HintBackground;

public class BuyHint {
    public var _source:Sprite;
    private var _imCoins:Image;
    private var _txtHint:TextField;
    private var g:Vars = Vars.getInstance();

    public function BuyHint() {
        _source = new Sprite();
        _txtHint = new TextField(100,50,"", g.allData.fonts['BloggerBold'],14,Color.WHITE);
        _txtHint.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _source.touchable = false;
    }

    public function showIt(st:int):void {
        _txtHint.text = String(st);
        var rectangle:Rectangle = _txtHint.textBounds;
        _imCoins = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
        MCScaler.scale(_imCoins,20,20);
        _imCoins.y = 5;
        _txtHint.width = rectangle.width + 20;
        _txtHint.height = rectangle.height + 10;
//        _txtHint.x = -10;
        _imCoins.x =  _txtHint.width - 5;
        hideIt();
        var bg:HintBackground = new HintBackground(rectangle.width + 42, rectangle.height + 12);
        _source.addChild(bg);
        _source.addChild(_txtHint);
        _source.addChild(_imCoins);
        g.cont.hintCont.addChild(_source);
        g.gameDispatcher.addEnterFrame(onEnterFrame);

    }

    private function onEnterFrame():void {
        _source.x = g.ownMouse.mouseX + 20;
        _source.y = g.ownMouse.mouseY - 40;
        checkPosition();
    }

    private function checkPosition():void {  // check is hint source is in stage width|height
        if (_source.x < 20) _source.x = 20;
        if (_source.x > Starling.current.nativeStage.stageWidth - _source.width - 20) _source.x = Starling.current.nativeStage.stageWidth - _source.width - 20;
        if (_source.y < 20) _source.y = 20;
        if (_source.y > Starling.current.nativeStage.stageHeight - _source.height - 20) _source.y = Starling.current.nativeStage.stageHeight - _source.height - 20;
    }

    public function hideIt():void {
        while (_source.numChildren) _source.removeChildAt(0);
        g.gameDispatcher.removeEnterFrame(onEnterFrame);
        g.cont.hintCont.removeChild(_source);
    }

//    public function checkText(st:int):void {
//        _txtHint.text = String(st);
//        var rectangle:Rectangle = _txtHint.textBounds;
//    }
}
}
