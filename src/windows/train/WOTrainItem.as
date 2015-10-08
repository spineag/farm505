/**
 * Created by user on 7/24/15.
 */
package windows.train {
import build.train.TrainCell;

import com.junkbyte.console.Cc;

import data.BuildType;
import data.DataMoney;

import flash.geom.Point;

import manager.Vars;

import resourceItem.DropItem;

import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;

import temp.DropResourceVariaty;

import ui.xpPanel.XPStar;

import utils.CSprite;
import utils.MCScaler;

public class WOTrainItem {
    public var source:CSprite;
    private var _im:Image;
    private var _info:TrainCell;
    private var _txt:TextField;
    private var _index:int;
    private var _f:Function;
    private var _galo4ka:Image;

    private var g:Vars = Vars.getInstance();

    public function WOTrainItem() {
        _index = -1;
        source = new CSprite();
        var _bg:Image = new Image(g.interfaceAtlas.getTexture('shop_item'));
        MCScaler.scale(_bg, 80, 80);
        _bg.width = 100;
        source.addChild(_bg);
        source.alpha = .25;
        _txt = new TextField(100,30,"","Arial",16,Color.BLACK);
        _txt.y = 50;
        source.addChild(_txt);
        _galo4ka = new Image(g.interfaceAtlas.getTexture('galo4ka'));
        MCScaler.scale(_galo4ka, 30, 30);
        _galo4ka.x = 65;
        _galo4ka.y = 40;
        source.addChild(_galo4ka);
        _galo4ka.visible = false;
    }

    public function fillIt(t:TrainCell, i:int):void {
        _index = i;
        source.alpha = .7;
        _info = t;
        if (!t || !g.dataResource.objectResources[_info.id]) {
            Cc.error('WOTrainItem fillIt:: trainCell==null or g.dataResource.objectResources[_info.id]==null');
            g.woGameError.showIt();
            return;
        }

        _txt.text = String(g.userInventory.getCountResourceById(_info.id) + '/' + String(_info.count));
        if (g.dataResource.objectResources[_info.id].buildType == BuildType.PLANT) {
            _im = new Image(g.plantAtlas.getTexture(g.dataResource.objectResources[_info.id].imageShop));
        } else if (g.dataResource.objectResources[_info.id].buildType == BuildType.RESOURCE) {
            _im = new Image(g.resourceAtlas.getTexture(g.dataResource.objectResources[_info.id].imageShop));
        } else {
            _im = new Image(g.instrumentAtlas.getTexture(g.dataResource.objectResources[_info.id].imageShop));
        }
        if (!_im) {
            Cc.error('WOTrainItem fillIt:: no such image: ' + g.dataResource.objectResources[_info.id].imageShop);
            g.woGameError.showIt();
            return;
        }
        MCScaler.scale(_im, 50, 50);
        _im.x = 50 - _im.width/2;
        _im.y = 5;
        source.addChild(_im);
        source.endClickCallback = onClick;
        if (isResourceLoaded) {
            _galo4ka.visible = true;
            _txt.text = '';
        }
    }

    public function set clickCallback(f:Function):void {
        _f = f;
    }

    public function setAlpha():void {
        if (_index >= 0) source.alpha = .7;
    }

    public function get idFree():int {
        return _info.id;
    }

    public function get countFree():int {
        return _info.count;
    }

    private function onClick():void {
        if (_f != null) {
            _f.apply(null, [_index]);
        }
        source.alpha = 1;
    }

    public function get isResourceLoaded():Boolean {
        return _info.isFull;
    }

    public function canFull():Boolean {
        return _info.canBeFull();
    }

    public function fullIt():void {
        _galo4ka.visible = true;
        _txt.text = '';
        _info.fullIt(_im);

        var p:Point = new Point(source.width/2, source.height/2);
        p = source.localToGlobal(p);
        new XPStar(p.x, p.y, 100);
        var prise:Object = {};
        prise.id = DataMoney.SOFT_CURRENCY;
        prise.type = DropResourceVariaty.DROP_TYPE_MONEY;
        prise.count = 100;
        new DropItem(p.x, p.y, prise);
    }

    public function clearIt():void {
        _galo4ka.visible = false;
        _txt.text = '';
        _index = -1;
        source.removeChild(_im);
        _im = null;
        source.alpha = .25;
        source.endClickCallback = null;
    }
}
}
