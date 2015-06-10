/**
 * Created by user on 6/9/15.
 */
package windows.fabricaWindow {
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.text.TextFieldAutoSize;
import starling.utils.Color;
import starling.utils.HAlign;
import starling.utils.VAlign;

import utils.CSprite;
import utils.MCScaler;

public class WOFabricaWorkListItem {
    public var source:Sprite;
    private var _bg:Image;
    private var _icon:Image;
    private var _dataRecipe:Object;
    private var _clickCallback:Function;
    private var _txtTimer:TextField;

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

    public function fillData(ob:Object, f:Function):void {
        _dataRecipe = ob;
        _clickCallback = f;
        source.alpha = 1;
        fillIcon(g.dataResource.objectResources[_dataRecipe.idResource].imageShop);
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
        _dataRecipe = null;
        _clickCallback = null;
        source.alpha = .5;
    }

//    private function onClick():void {
//        if (_clickCallback != null) {
//            _clickCallback.apply(null, [_dataRecipe]);
//        }
//    }

    public function activateTimer():void {
        _txtTimer = new TextField(source.width, 40, "","Arial", 18,Color.BLACK);
//        _txtTimer.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
//        _txtTimer.hAlign = HAlign.CENTER;
//        _txtTimer.vAlign = VAlign.CENTER;
        source.addChild(_txtTimer);
        g.gameDispatcher.addToTimer(render);
    }

    private function render():void {
        _txtTimer.text = String(_dataRecipe.leftTime);
        //необходимо проверять, если время <= 0, то переключаться на следующий рецепт, если он есть
    }

}
}
