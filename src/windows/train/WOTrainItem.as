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

    public function WOTrainItem(type:int) {
        _index = -1;
        source = new CSprite();

        source.alpha = .25;
        _txt = new TextField(100,30,"","Arial",16,Color.BLACK);
        _txt.y = 50;
        source.addChild(_txt);
        _galo4ka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
        MCScaler.scale(_galo4ka, 30, 30);
        _galo4ka.x = 65;
        _galo4ka.y = 40;
        source.addChild(_galo4ka);
        _galo4ka.visible = false;
        var _bg:Image;
        switch (type) {
            case (WOTrain.CELL_BLUE):
                _bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('a_tr_blue'));
                source.addChild(_bg);
                break;
            case (WOTrain.CELL_GREEN):
                _bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('a_tr_green'));
                source.addChild(_bg);
                break;
            case (WOTrain.CELL_RED):
                _bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('a_tr_red'));
                source.addChild(_bg);
                break;
        }
    }

    public function fillIt(t:TrainCell, i:int):void {
        _index = i;
//        source.alpha = .7;
        _info = t;
        if (!t || !g.dataResource.objectResources[_info.id]) {
            Cc.error('WOTrainItem fillIt:: trainCell==null or g.dataResource.objectResources[_info.id]==null');
            g.woGameError.showIt();
            return;
        }

        _txt.text = String(g.userInventory.getCountResourceById(_info.id) + '/' + String(_info.count));
        _im = new Image(g.allData.atlas[g.dataResource.objectResources[_info.id].url].getTexture(g.dataResource.objectResources[_info.id].imageShop));
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
//        if (_index >= 0) source.alpha = .7;
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
//        source.alpha = 1;
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
//        source.alpha = .25;
        source.endClickCallback = null;
    }
}
}
