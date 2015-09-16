/**
 * Created by user on 9/14/15.
 */
package windows.train {
import build.train.TrainCell;

import data.BuildType;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;

import utils.CSprite;
import utils.MCScaler;

public class WOTrainOrderItem {
    public var source:Sprite;
    private var _im:Image;
    private var _index:int;
    private var _info:TrainCell;


    private var g:Vars = Vars.getInstance();

    public function WOTrainOrderItem() {
        source = new Sprite();
        var _bg:Image = new Image(g.interfaceAtlas.getTexture('shop_item'));
        MCScaler.scale(_bg, 80, 80);
        _bg.width = 100;
        source.addChild(_bg);
    }

    public function fillIt(t:TrainCell, i:int):void {
        _index = i;
        _info = t;
        if (g.dataResource.objectResources[_info.id].buildType == BuildType.PLANT) {
            _im = new Image(g.plantAtlas.getTexture(g.dataResource.objectResources[_info.id].imageShop));
        } else if (g.dataResource.objectResources[_info.id].buildType == BuildType.RESOURCE) {
            _im = new Image(g.resourceAtlas.getTexture(g.dataResource.objectResources[_info.id].imageShop));
        } else {
            _im = new Image(g.instrumentAtlas.getTexture(g.dataResource.objectResources[_info.id].imageShop));
        }
        MCScaler.scale(_im, 50, 50);
        _im.x = 50 - _im.width/2;
        _im.y = 5;
        source.addChild(_im);
    }
}
}
