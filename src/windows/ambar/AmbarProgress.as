/**
 * Created by user on 6/26/15.
 */
package windows.ambar {
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;

public class AmbarProgress {
    public var source:Sprite;
    private var _bg:Image;
    private var _arrow:Image;
    private var _maxX:int = 380;
    private var _minX:int = 16;

    private var g:Vars = Vars.getInstance();

    public function AmbarProgress() {
        source = new Sprite();
        source.touchable = false;
        _bg = new Image(g.interfaceAtlas.getTexture('ambar_plawka'));
        _arrow = new Image(g.interfaceAtlas.getTexture('ambar_plawka_arrow'));
        source.addChild(_bg);
        source.addChild(_arrow);
        source.pivotX = source.width/2;
        source.pivotY = source.height/2;
    }

    public function setProgress(a:Number, isAmbar:Boolean):void {
        if (isAmbar) {
            if (g.userInventory.currentCountInAmbar >= g.user.ambarMaxCount){
                _arrow.x = _maxX - _minX;
                return;
            }
            _arrow.x = int(_minX + a*(_maxX - _minX));
        } else {
            if (g.userInventory.currentCountInSklad >= g.user.skladMaxCount){
                _arrow.x = _maxX - _minX;
                return;
            }
            _arrow.x = int(_minX + a*(_maxX - _minX));
        }
    }
}
}
