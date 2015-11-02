/**
 * Created by user on 9/14/15.
 */
package windows.train {
import build.train.TrainCell;

import com.junkbyte.console.Cc;

import data.BuildType;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;

import utils.CSprite;
import utils.MCScaler;

public class WOTrainOrderItem {
    public var source:CSprite;
    private var _im:Image;
    private var _index:int;
    private var _info:TrainCell;


    private var g:Vars = Vars.getInstance();

    public function WOTrainOrderItem() {
        source = new CSprite();
        source.hoverCallback = onHover;
        source.outCallback = onOut;
        var _bg:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_item'));
        MCScaler.scale(_bg, 80, 80);
        _bg.width = 100;
        source.addChild(_bg);
    }

    public function fillIt(t:TrainCell, i:int):void {
        _index = i;
        _info = t;
        if (!t || !g.dataResource.objectResources[_info.id]) {
            Cc.error('WOTrainOrderItem fillIt:: trainCell==null or g.dataResource.objectResources[_info.id]==null');
            g.woGameError.showIt();
            return;
        }
        _im = new Image(g.allData.atlas[g.dataResource.objectResources[_info.id].url].getTexture(g.dataResource.objectResources[_info.id].imageShop));
        if (!_im) {
            Cc.error('WOTrainOrderItem fillIt:: no such image: ' + g.dataResource.objectResources[_info.id].imageShop);
            g.woGameError.showIt();
            return;
        }
        MCScaler.scale(_im, 50, 50);
        _im.x = 50 - _im.width/2;
        _im.y = 5;
        source.addChild(_im);
    }

    private function onHover():void {
        g.resourceHint.showIt(_info.id,"",source.x,source.y,source);
    }

    private function onOut():void {
        g.resourceHint.hideIt();
    }
}
}
