/**
 * Created by user on 7/24/15.
 */
package windows.paperWindow {
import data.BuildType;


import manager.Vars;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

import utils.MCScaler;

public class WOPaperItem {
    public var source:CSprite;
    public var s:Sprite;
    private var _imageCoin:Image;
    private var _imageItem:Image;
    private var _txtItem:TextField;
    private var _txtCost:TextField;
    private var _data:Object;
    private var g:Vars = Vars.getInstance();
    public function WOPaperItem(ob:Object) {
        _data = ob;
        source = new CSprite();
        var q:Quad = new Quad(100, 100, Color.AQUA);
        q.pivotX = 0;
        q.pivotY = 0;
        if (ob.buildType == BuildType.INSTRUMENT) {
            _imageItem = new Image(g.instrumentAtlas.getTexture(ob.imageShop));

        } else if (ob.buildType == BuildType.PLANT || ob.buildType == BuildType.RESOURCE) {
            if (ob.url == "plantAtlas") {
                _imageItem = new Image(g.plantAtlas.getTexture(ob.imageShop));
            } else {
                _imageItem = new Image(g.resourceAtlas.getTexture(ob.imageShop));
            }
        }
        _imageCoin = new Image(g.interfaceAtlas.getTexture("coin"));
        _imageCoin.x = 35;
        _imageCoin.y = 60;
        MCScaler.scale(_imageCoin,25,25);
        _txtItem = new TextField(50,50,"5","Arial",14,Color.BLACK);
        _txtItem.x = 35;
        _txtItem.y = 25;
        _txtCost = new TextField(50,50,"100","Arial",14,Color.BLACK);
        _txtCost.x = 50;
        _txtCost.y = 50;
        MCScaler.scale(_imageItem,50,50);
        _imageItem.x = 20;
        _imageItem.y = 5;
        source.addChild(q);
        source.addChild(_txtItem);
        source.addChild(_txtCost);
        source.addChild(_imageItem);
        source.addChild(_imageCoin);
        source.endClickCallback = onClick;
    }

    public function onClick():void {
        var im:WOPaperChoose;
        s = new Sprite();
        im = new WOPaperChoose(_data);
        s.addChild(im.source);
        g.cont.interfaceCont.addChild(s);
    }
}
}
