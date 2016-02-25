/**
 * Created by user on 6/15/15.
 */
package windows.WOComponents {

import flash.geom.Rectangle;

import manager.Vars;

import starling.display.Sprite;
import starling.textures.Texture;

public class DefaultVerticalScrollSprite {
    private var _source:Sprite;
    private var _scrolledSprite:Sprite;
    private var _width:int;
    private var _height:int;
    private var _cellW:int;
    private var _cellH:int;
    private var _scroll:OwnScroll;
    private var _arrCell:Array;
    private var _nextCellX:int;
    private var _nextCellY:int;
    private var _percent:int;


    public function DefaultVerticalScrollSprite(w:int, h:int, cellW:int, cellH:int) {
        _nextCellX = 0;
        _nextCellY = 0;
        _width = w;
        _height = h;
        _cellH = cellH;
        _cellW = cellW;
        _arrCell = [];
        _source = new Sprite();
        _scrolledSprite = new Sprite();
        _source.addChild(_scrolledSprite);
        _source.clipRect = new Rectangle(0, 0, _width*2, _height); // умножили ширину на 2, так как иначе не будет видно полосу прокрутки
    }

    public function createScoll(x:int, y:int, h:int, lineTexture:Texture, boxTexture:Texture):void {
        _scroll = new OwnScroll(h, lineTexture, boxTexture, checkPercent,percentNumber);
        _scroll.source.x = x;
        _scroll.source.y = y;
        _source.addChild(_scroll.source);
        _scroll.source.visible = false;
    }

    private function checkPercent(percent:Number):void {
        _scrolledSprite.y = -int(( _scrolledSprite.height - _height)*percent);
        // можно еще будет дописать передвижение по У к ближайшей точке, так чтобы не резало клетки, а прокручивало на минимальную высоту, равную _cellH
    }

    private function percentNumber(percent:Number):void {
        _percent = -int(( _scrolledSprite.height - _height)*percent);

    }

    public function addNewCell(_cellSource:Sprite):void {
        _scrolledSprite.y = -_percent;
        _cellSource.x = _nextCellX;
        _cellSource.y = _nextCellY + _percent;

        _scrolledSprite.addChild(_cellSource);
        if (_nextCellX + _cellW > _width - 10) {
            _nextCellX = 0;
            _nextCellY += _cellH;
        } else {
            _nextCellX += _cellW;
        }
        _scroll.source.visible = _scrolledSprite.height > _height + _cellH/2;

    }

    public function resetAll():void {
        _nextCellX = 0;
        _nextCellY = 0;
        while (_scrolledSprite.numChildren) {
            _scrolledSprite.removeChildAt(0);
        }
        _scrolledSprite.y = 0;
        _scroll.resetPosition();
        _scroll.source.visible = false;
    }

    public function get source():Sprite {
        return _source;
    }
    public function get scrolleSource():Sprite {
        return _scrolledSprite;
    }
}
}
