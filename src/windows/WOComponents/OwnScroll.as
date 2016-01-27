/**
 * Created by user on 6/15/15.
 */
package windows.WOComponents {
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

import utils.CButton;

import utils.CSprite;

public class OwnScroll {
    public var source:Sprite;
    private var _size:int;  //height - для вертикального, width - для горизонтального
    private var _lineImage:Image;
    private var _box:CButton;
    private var _startDragSourcePoint:int;
    private var _startDragPoint:int;
    private var _dragCallback:Function;
    private var _isVertical:Boolean;

    private var g:Vars = Vars.getInstance();

    public function OwnScroll(h:int, lineTexture:Texture, boxTexture:Texture, callback:Function, isVertical:Boolean = true) {
        _isVertical = isVertical;
        source = new Sprite;
        _dragCallback = callback;
        _size = h;
        _lineImage = new Image(lineTexture);
        _isVertical ? _lineImage.height = _size : _lineImage.width = _size;
        _lineImage.pivotX = _lineImage.width/2;

        _box = new CButton();
        _box.addDisplayObject(new Image(boxTexture));
        _box.setPivots();
        _box.y = _box.height/2;

        source.addChild(_lineImage);
        source.addChild(_box);

        _box.onMovedCallback = onDrag;
        _box.startClickCallback = onStartDrag;
    }

    private function onStartDrag():void {
        if (_isVertical) {
            _startDragSourcePoint = _box.y + _box.height/2;
            _startDragPoint = g.ownMouse.mouseY;
        } else {
            _startDragSourcePoint = _box.x;
            _startDragPoint = g.ownMouse.mouseX;
        }
    }

    private var _delta:int;
    private var _percent:Number;
    private function onDrag(_globalX:int, _globalY:int):void {
        if (_isVertical) {
            _delta = _globalY - _startDragPoint;
            _box.y = _startDragSourcePoint + _delta  - _box.height/2;
            if (_box.y > _size - _box.height/2) _box.y = _size - _box.height/2;
            if (_box.y <_box.height/2) _box.y = _box.height/2;
            _percent = _box.y / (_size - _box.height);
        } else {
            // для горизонталього скролла
        }
        if (_dragCallback != null) {
            _dragCallback.apply(null, [_percent]);
        }
    }

    public function resetPosition():void {
        _box.y = _box.height/2;
        _box.x = 0;
    }

}
}
