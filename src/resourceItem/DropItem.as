/**
 * Created by user on 6/24/15.
 */
package resourceItem {

import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import data.BuildType;

import data.DataMoney;

import flash.geom.Point;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;

import temp.DropResourceVariaty;

import utils.MCScaler;

public class DropItem {
    private var _source:Sprite;
    private var _image:Image;

    private var g:Vars = Vars.getInstance();

    public function DropItem(_x:int, _y:int, prise:Object) {
        var endPoint:Point;

        _source = new Sprite();

        if (prise.type == DropResourceVariaty.DROP_TYPE_RESOURSE) {
            _image = new Image(g.instrumentAtlas.getTexture(g.dataResource.objectResources[prise.id].imageShop));
             endPoint = g.craftPanel.pointXY();
             g.craftPanel.showIt(BuildType.PLACE_SKLAD);
        } else {
            endPoint = g.couponePanel.getPoint();
            switch (prise.id) {
                case DataMoney.HARD_CURRENCY:
                    _image = new Image(g.interfaceAtlas.getTexture('diamont'));
                    endPoint = g.softHardCurrency.getHardCurrencyPoint();
                    break;
                case DataMoney.SOFT_CURRENCY:
                    _image = new Image(g.interfaceAtlas.getTexture('coin'));
                    endPoint = g.softHardCurrency.getSoftCurrencyPoint();
                    break;
                case DataMoney.BLUE_COUPONE:
                    _image = new Image(g.interfaceAtlas.getTexture('blue_coupone'));
                    break;
                case DataMoney.GREEN_COUPONE:
                    _image = new Image(g.interfaceAtlas.getTexture('green_coupone'));
                    break;
                case DataMoney.RED_COUPONE:
                    _image = new Image(g.interfaceAtlas.getTexture('red_coupone'));
                    break;
                case DataMoney.YELLOW_COUPONE:
                    _image = new Image(g.interfaceAtlas.getTexture('yellow_coupone'));
                    break;
            }
        }
        MCScaler.scale(_image, 50, 50);
        _source.addChild(_image);
        _source.pivotX = _source.width / 2;
        _source.pivotY = _source.height / 2;
        _source.x = _x;
        _source.y = _y;
        g.cont.animationsResourceCont.addChild(_source);

        var f1:Function = function():void {
            g.cont.animationsResourceCont.removeChild(_source);
            while (_source.numChildren) {
                _source.removeChildAt(0);
            }
            _source = null;
            if (prise.type == DropResourceVariaty.DROP_TYPE_RESOURSE) {
                g.userInventory.addResource(prise.id, prise.count);
                var item:ResourceItem = new ResourceItem();
                item.fillIt(g.dataResource.objectResources[prise.id]);
                g.craftPanel.afterFly(item);
            } else {
                g.userInventory.addMoney(prise.id, prise.count);
            }
        };
        var tempX:int = _source.x - 70;
        var tempY:int = _source.y + 30 + int(Math.random()*20);
        var dist:int = int(Math.sqrt((_source.x - endPoint.x)*(_source.x - endPoint.x) + (_source.y - endPoint.y)*(_source.y - endPoint.y)));
        new TweenMax(_source, dist/250, {bezier:[{x:tempX, y:tempY}, {x:endPoint.x, y:endPoint.y}], ease:Linear.easeOut ,onComplete: f1, delay:.3});
    }
}
}
