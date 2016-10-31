/**
 * Created by user on 6/24/15.
 */
package resourceItem {

import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;

import data.BuildType;

import data.DataMoney;

import flash.display.StageDisplayState;

import flash.geom.Point;

import manager.ManagerFilters;

import manager.Vars;

import starling.core.Starling;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import temp.DropResourceVariaty;

import utils.CTextField;

import utils.MCScaler;

import windows.WindowsManager;

public class DropItem {
    private var _source:Sprite;
    private var _image:Image;

    private var g:Vars = Vars.getInstance();

    public function DropItem(_x:int, _y:int, prise:Object, delay:Number = .3, fromSize:int = 50) {
        var endPoint:Point;
        if (!prise) {
            Cc.error('DropItem:: prise == null');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'dropItem');
            return;
        }

        _source = new Sprite();
        if (prise.type == DropResourceVariaty.DROP_TYPE_RESOURSE) {
            _image = new Image(g.allData.atlas[g.dataResource.objectResources[prise.id].url].getTexture(g.dataResource.objectResources[prise.id].imageShop));
            endPoint = g.craftPanel.pointXY();
            g.craftPanel.showIt(BuildType.PLACE_SKLAD);
            g.updateAmbarIndicator();
            g.userInventory.addResource(prise.id, prise.count);
        } else {
            switch (prise.id) {
                case DataMoney.HARD_CURRENCY:
                    _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
                    endPoint = g.softHardCurrency.getHardCurrencyPoint();
                    break;
                case DataMoney.SOFT_CURRENCY:
                    _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
                    endPoint = g.softHardCurrency.getSoftCurrencyPoint();
                    break;
                case DataMoney.BLUE_COUPONE:
                    _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('blue_coupone'));
                    endPoint = g.couponePanel.getPoint();
                    break;
                case DataMoney.GREEN_COUPONE:
                    _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('green_coupone'));
                    endPoint = g.couponePanel.getPoint();
                    break;
                case DataMoney.RED_COUPONE:
                    _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('red_coupone'));
                    endPoint = g.couponePanel.getPoint();
                    break;
                case DataMoney.YELLOW_COUPONE:
                    _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('yellow_coupone'));
                    endPoint = g.couponePanel.getPoint();
                    break;
            }
            g.userInventory.dropItem(prise.id, prise.count);
        }
        if (!_image) {
            Cc.error('DropItem:: no image for type: ' + prise.id);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'dropItem');
            return;
        }
        MCScaler.scale(_image, fromSize, fromSize);
        var txt:CTextField = new CTextField(70,30,'+' + String(prise.count));
        txt.setFormat(CTextField.BOLD18, int(18*fromSize/50), Color.WHITE, ManagerFilters.BROWN_COLOR);
        txt.x = -15;
        txt.y = _image.height - 5;
        _source.addChild(_image);
        _source.pivotX = _source.width / 2;
        _source.pivotY = _source.height / 2;
        _source.addChild(txt);
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
                var item:ResourceItem = new ResourceItem();
                item.fillIt(g.dataResource.objectResources[prise.id]);
                g.craftPanel.afterFly(item);
            } else {
                switch (prise.id) {
                    case DataMoney.HARD_CURRENCY:
                        g.softHardCurrency.animationBuy(true);
                        break;
                    case DataMoney.SOFT_CURRENCY:
                        g.softHardCurrency.animationBuy(false);
                        break;
                    case DataMoney.BLUE_COUPONE:
                        g.couponePanel.animationBuy();
                        break;
                    case DataMoney.GREEN_COUPONE:
                        g.couponePanel.animationBuy();
                        break;
                    case DataMoney.RED_COUPONE:
                        g.couponePanel.animationBuy();
                        break;
                    case DataMoney.YELLOW_COUPONE:
                        g.couponePanel.animationBuy();
                        break;
                }
                g.userInventory.addMoney(prise.id, prise.count,false);
//                g.userInventory.updateMoneyTxt(prise.id, prise.count,false);
                if (g.managerTips) g.managerTips.calculateAvailableTips();
            }
        };
        var tempX:int = _source.x - 140 + int(Math.random()*140);
        var tempY:int = _source.y - 40 + int(Math.random()*140);
        var v:int;
        if (Starling.current.nativeStage.displayState == StageDisplayState.NORMAL) v = 350;
            else v = 460;
        var dist:int = int(Math.sqrt((_source.x - endPoint.x)*(_source.x - endPoint.x) + (_source.y - endPoint.y)*(_source.y - endPoint.y)));

        if (fromSize != 50) {
            var scale:Number = _image.scaleX / (fromSize/50);
            new TweenMax(_source, dist/v, {bezier:[{x:tempX, y:tempY}, {x:endPoint.x, y:endPoint.y}], scaleX:scale, scaleY:scale, ease:Linear.easeOut ,onComplete: f1, delay: delay});
        } else new TweenMax(_source, dist/v, {bezier:[{x:tempX, y:tempY}, {x:endPoint.x, y:endPoint.y}], ease:Linear.easeOut ,onComplete: f1, delay: delay});
    }
}
}
