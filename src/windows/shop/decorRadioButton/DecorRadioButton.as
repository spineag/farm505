/**
 * Created by user on 10/17/16.
 */
package windows.shop.decorRadioButton {
import com.junkbyte.console.Cc;

import starling.display.Sprite;
import utils.CSprite;

public class DecorRadioButton {
    private var _source:Sprite;
    private var _items:Array;
    private var _parent:CSprite;
    private var _activeItem:DecorRadioButtonItem;
    private var _updateCallback:Function;

    public function DecorRadioButton(p:CSprite, f:Function) {
        _items = [];
        _source = new Sprite();
        _parent = p;
        _source.y = 153;
        _parent.addChild(_source);
        _updateCallback = f;
    }

    public function addItem(ob:Object):void {
        var item:DecorRadioButtonItem = new DecorRadioButtonItem(ob, onClick);
        if (!_items.length) {
            item.activateIt();
            _activeItem = item;
        }
        _items.push(item);
        _source.addChild(item.source);
    }

    public function calculatePositions():void {
        // width = 145
        switch (_items.length) {
            case 0: Cc.error('DecorRadioButton:: no items'); break;
            case 1: _items[0].source.x = 72; break;
            case 2: _items[0].source.x = 45; _items[1].source.x = 100; break;
            case 3: _items[0].source.x = 40; _items[1].source.x = 72; _items[2].source.x = 104; break;
            case 4: _items[0].source.x = 20; _items[1].source.x = 55; _items[2].source.x = 90; _items[3].source.x = 125; break;
            default: Cc.error('DecorRadioButton:: 5 items and more');
        }
    }

    private function onClick(ob:Object, item:DecorRadioButtonItem):void {
        if (_activeItem != item) {
            _activeItem.activateIt(false);
            _activeItem = item;
            if (_updateCallback != null) {
                _updateCallback.apply(null, [ob]);
            }
        }
    }

    public function deleteIt():void {
        _activeItem = null;
        for (var i:int=0; i<_items.length; i++) {
            _source.removeChild(_items[i].source);
            _items[i].deleteIt();
        }
        _items = [];
        _parent.removeChild(_source);
        _parent=null;
        _source.dispose();
    }
}
}
