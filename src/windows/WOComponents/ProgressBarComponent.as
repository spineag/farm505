/**
 * Created by user on 11/24/15.
 */
package windows.WOComponents {
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

public class ProgressBarComponent extends Sprite {
    private var _left:Sprite;
    private var _center:Sprite;
    private var _right:Sprite;
    private var _maxWidth:int;
    private var _ct:Texture;

    public function ProgressBarComponent(lt:Texture, ct:Texture, rt:Texture, w:int) {
        _ct = ct;
        _maxWidth = w;
        _left = new Sprite();
        _center = new Sprite();
        _right = new Sprite();
        var im:Image = new Image(lt);
        _left.addChild(im);
        im = new Image(rt);
        _right.addChild(im);
        _center.x = _left.width;
        addChild(_left);
        addChild(_center);
        addChild(_right);
    }

    public function set progress(percent:Number):void {
        _left.visible = true;
        _center.visible = true;
        _right.visible = true;
        if (percent > 1) percent = 1;
        if (percent < 0) percent = 0;
        var w:Number = percent*_maxWidth;
        setCenterWidth(int(w - _left.width - _right.width));
        _right.x = w - _right.width;
        if (w == 0) {
            _left.visible = false;
            _center.visible = false;
            _right.visible = false;
        }
    }

    private function setCenterWidth(w:int):void {
        var im:Image;
        while (_center.numChildren) _center.removeChildAt(0);
        for (var i:int=0; i<=w+1; i++) {
            im = new Image(_ct);
            im.x = i-1;
            _center.addChild(im);
        }
    }

    public function deleteIt():void {
        _ct = null;
        dispose();
        _left = null;
        _center = null;
        _right = null;
    }
}
}
