/**
 * Created by user on 6/9/15.
 */
package windows.fabricaWindow {
import manager.ResourceItem;
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

public class WOFabricaWorkListItem {
    public var source:Sprite;
    private var _bg:Image;
    private var _icon:Image;
    private var _resource:ResourceItem;
    private var _clickCallback:Function;
    private var _txtTimer:TextField;
    private var _timerFinishCallback:Function;

    private var g:Vars = Vars.getInstance();

    public function WOFabricaWorkListItem() {
        source = new CSprite();
        _bg = new Image(g.interfaceAtlas.getTexture('tempItemBG'));
        MCScaler.scale(_bg, 100, 100);
        source.addChild(_bg);
        source.pivotX = source.width/2;
        source.pivotY = source.height/2;
        source.alpha = .5;
    }

    public function fillData(resource:ResourceItem, f:Function):void {
        _resource = resource;
        _clickCallback = f;
        source.alpha = 1;
        fillIcon(_resource.imageShop);
    }

    private function fillIcon(s:String):void {
        if (_icon) {
            source.removeChild(_icon);
            _icon = null;
        }
        _icon = new Image(g.resourceAtlas.getTexture(s));
        MCScaler.scale(_icon, 100, 100);
        source.addChild(_icon);
    }

    public function unfillIt():void {
        if (_icon) {
            source.removeChild(_icon);
            _icon = null;
        }
        _resource = null;
        _clickCallback = null;
        source.alpha = .5;
    }

    public function destroyTimer():void {
        g.gameDispatcher.removeFromTimer(render);
        _txtTimer.text = '';
        _timerFinishCallback = null;
        source.removeChild(_txtTimer);
        _txtTimer = null;
    }

    public function activateTimer(f:Function):void {
        _txtTimer = new TextField(source.width, 40, "","Arial", 18,Color.BLACK);
        source.addChild(_txtTimer);
        _timerFinishCallback = f;
        g.gameDispatcher.addToTimer(render);
    }

    private function render():void {
        _txtTimer.text = String(_resource.leftTime);
        if (_resource.leftTime <= 0) {
            g.gameDispatcher.removeFromTimer(render);
            _txtTimer.text = '';
            if (_timerFinishCallback != null) {
                _timerFinishCallback.apply();
            }
        }
    }

}
}
