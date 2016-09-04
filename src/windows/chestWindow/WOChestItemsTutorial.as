/**
 * Created by user on 5/6/16.
 */
package windows.chestWindow {
import manager.ManagerChest;
import starling.display.Sprite;

public class WOChestItemsTutorial {
    private var _source:Sprite;
    private var _arrData:Array;

    public function WOChestItemsTutorial(parent:Sprite, f:Function) {
        _arrData = [{type: ManagerChest.HARD_MONEY, count: 10, countItems: 5},
                    {type: ManagerChest.SOFT_MONEY, count: 250, countItems: 5}];
        _source = new Sprite();
        _source.touchable = false;
        parent.addChild(_source);
        var item:ItemChest;
        for (var i:int=0; i<_arrData.length; i++) {
            if (!i) {
                item = new ItemChest(_arrData[i], null);
                item.source.x = -55;
                _source.addChild(item.source);
                item.showIt(0);
            } else {
                item = new ItemChest(_arrData[i], f);
                item.source.x = 55;
                _source.addChild(item.source);
                item.showIt(.4);
            }
        }
    }
}
}

import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import data.DataMoney;
import flash.geom.Point;
import manager.ManagerChest;
import manager.ManagerFilters;
import manager.Vars;
import resourceItem.DropItem;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;
import temp.DropResourceVariaty;

import utils.CTextField;
import utils.MCScaler;

internal class ItemChest {
    public var source:Sprite;
    private var _data:Object;
    private var _txt:CTextField;
    private var _countUpdate:int;
    private var _countPerUpdate:int;
    private var _callback:Function;
    private var g:Vars = Vars.getInstance();

    public function ItemChest(data:Object, f:Function) {
        _data = data;
        _callback = f;
        _countUpdate = 0;
        _countPerUpdate = _data.count/_data.countItems;
        source = new Sprite();
        var im:Image = createImage();
        source.addChild(im);
        _txt = new CTextField(80, 60, '+'+String(_data.count));
        _txt.setFormat(CTextField.MEDIUM30, 26, Color.WHITE, ManagerFilters.TEXT_BROWN_COLOR);
        _txt.x = 0;
        _txt.y = 5;
        source.addChild(_txt);
    }

    private function createImage():Image {
        var im:Image;
        switch (_data.type) {
//            case ManagerChest.RESOURCE:
//                im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.dataResource.objectResources[obj.id].imageShop));
//                break;
//            case ManagerChest.PLANT:
//                im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.dataResource.objectResources[obj.id].imageShop + '_icon'));
//                break;
            case ManagerChest.SOFT_MONEY:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
                break;
            case ManagerChest.HARD_MONEY:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
                break;
//            case ManagerChest.INSTRUMENT:
//                im = new Image(g.allData.atlas['instrumentAtlas'].getTexture(g.dataResource.objectResources[obj.id].imageShop));
//                break;
        }
        MCScaler.scale(im, 80, 80);
        im.x = -im.width/2;
        im.y = -im.height/2;
        return im;
    }

    public function showIt(delay:Number):void {
        source.alpha = 0;
        source.scaleX = source.scaleY = .5;
        new TweenMax(source, .1, {scaleX:1.5, scaleY:1, alpha: 1, ease:Linear.easeIn, onComplete:showIt1, delay:delay});
    }

    private function showIt1():void {
        new TweenMax(source, .1, {scaleX:1, scaleY:1.5, ease:Linear.easeIn, onComplete:showIt2});
    }

    private function showIt2():void {
        new TweenMax(source, .1, {scaleX:1, scaleY:1, ease:Linear.easeIn, onComplete:showIt3});
    }

    private function showIt3():void {
        TweenMax.delayedCall(1.5, flyItems, []);
    }

    private function flyItems():void {
        var p:Point = new Point(0,0);
        p = source.localToGlobal(p);
        var type:int;
        if (_data.type == ManagerChest.SOFT_MONEY) {
            type = DataMoney.SOFT_CURRENCY;
        } else {
            type = DataMoney.HARD_CURRENCY;
        }
        new DropItem(p.x, p.y, {type:DropResourceVariaty.DROP_TYPE_MONEY, id:type, count:_countPerUpdate}, 0, 80);
        _countUpdate++;
        _txt.text = '+'+String(_data.count - _countPerUpdate*_countUpdate);
        if (_countUpdate >= _data.countItems) {
            if (_callback != null) {
                _callback.apply()
            }
        } else {
            TweenMax.delayedCall(.2, flyItems, []);
        }
    }

}
