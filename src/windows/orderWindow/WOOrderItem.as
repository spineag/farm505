/**
 * Created by user on 7/22/15.
 */
package windows.orderWindow {
import data.BuildType;

import manager.Vars;

import starling.display.Image;

import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

import utils.MCScaler;
public class WOOrderItem {
    public var source:Sprite;
    private var _contItem:CSprite;
    private var _imageBg:Image;
    private var _imageCoin:Image;
    private var _imageXp:Image;
    private var _txtCost:TextField;
    private var _txtCount:TextField;

    private var g:Vars = Vars.getInstance();
    public function WOOrderItem() {
        source = new Sprite();
        _contItem = new CSprite();
        _imageCoin = new Image(g.interfaceAtlas.getTexture("coin"));
        MCScaler.scale(_imageCoin,25,25);
        _imageCoin.x = 70;
        _imageCoin.y = 60;
        _imageXp = new Image(g.interfaceAtlas.getTexture("star"));
        MCScaler.scale(_imageXp,25,25);
        _imageXp.x = 50;
        _imageXp.y = 40;
        _imageBg = new Image(g.interfaceAtlas.getTexture("tempItemBG"));
        _txtCost = new TextField(50,50,"","Arial",14,Color.BLACK);
        _txtCount = new TextField(50,50,"","Arial",14,Color.BLACK);
        source.addChild(_imageBg);
        source.addChild(_txtCost);
        source.addChild(_txtCount);
        source.addChild(_imageCoin);
        source.addChild(_imageXp);
    }
}
}
