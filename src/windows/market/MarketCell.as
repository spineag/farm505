/**
 * Created by user on 6/17/15.
 */
package windows.market {

import com.junkbyte.console.Cc;

import data.BuildType;

import manager.Vars;

import starling.display.Image;
import starling.display.Quad;

import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

import utils.MCScaler;

import windows.WOComponents.CartonBackgroundIn;

public class MarketCell {
    public var source:CSprite;

    private var _ramka:Quad;
    private var _info:Object; // id & count
    private var _data:Object;
    private var _image:Image;
    private var _countTxt:TextField;
    private var g:Vars = Vars.getInstance();
    private var _clickCallback:Function;

    public function MarketCell(info:Object) {
        _clickCallback = null;
        source = new CSprite();
        source.endClickCallback = onClick;
        _ramka = new Quad(98, 98, Color.RED);
        _ramka.x = 1;
        _ramka.y = 1;
        source.addChild(_ramka);
        _ramka.visible =false;
        var s:CartonBackgroundIn = new CartonBackgroundIn(100, 100);
        source.addChild(s);

        _info = info;
        if (!_info) {
            Cc.error('MarketCell:: _info == null');
            g.woGameError.showIt();
            return;
        }
        _data = g.dataResource.objectResources[_info.id];
        if (_data) {
            if (_data.buildType == BuildType.PLANT) {
                _image = new Image(g.allData.atlas['resourceAtlas'].getTexture(_data.imageShop + '_icon'));
            } else {
                _image = new Image(g.allData.atlas[_data.url].getTexture(_data.imageShop));
            }
            if (!_image) {
                Cc.error('MarketCell:: no such image: ' + _data.imageShop);
                g.woGameError.showIt();
                return;
            }
            MCScaler.scale(_image, 99, 99);
            _image.x = 50 - _image.width/2;
            _image.y = 50 - _image.height/2;
            source.addChild(_image);
        } else {
            Cc.error('MarketCell:: _data == null');
            g.woGameError.showIt();
            return;
        }

        _countTxt = new TextField(30,20,String(_info.count),"Arial",16,Color.BLACK);
        _countTxt.x = 75;
        _countTxt.y = 77;
        source.addChild(_countTxt);
    }

    public function clearIt():void {
        while (source.numChildren) {
            source.removeChildAt(0);
        }
        source = null;
        _image = null;
        _countTxt = null;
    }

    public function set clickCallback(f:Function):void {
        _clickCallback = f;
    }

    private function onClick():void {
       // if (_info.buildType == BuildType.PLANT) {
//            var count:int;
//            count = g.userInventory.getCountResourceById(_data.id);
//            if ((count - 1) == 0) {
//                g.woLastResource.showItMenu(_data);
//                trace("count");
//            }
            if (_clickCallback != null) {
                _clickCallback.apply(null, [_info.id]);
            }
      //  }
        if (g.userInventory.getCountResourceById(_data.id))
//        g.woLastResource.showItMenu(_data.id);
        if (_clickCallback != null) {
            _clickCallback.apply(null, [_info.id]);
        }
        activateIt(true);
    }

    public function activateIt(a:Boolean):void {
        _ramka.visible = a;
    }
}
}
