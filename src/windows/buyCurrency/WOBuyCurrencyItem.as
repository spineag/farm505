/**
 * Created by user on 7/17/15.
 */
package windows.buyCurrency {
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

import utils.MCScaler;


public class WOBuyCurrencyItem {
    public var source:Sprite;
    private var _contBtn:CSprite;
    private var _image:Image;
    private var _imageBg:Image;
    private var _imageBtn:Image;
    private var _txtCount:TextField;
    private var _txtProfit:TextField;
    private var _txtCost:TextField;
    private var cu:String;
    private var co:String;
    private var g:Vars = Vars.getInstance();

    public function WOBuyCurrencyItem(currency:String, count:String, profit:String, cost:String) {
        source = new Sprite();
        _contBtn = new CSprite();
        cu = currency;
        co = count;
        _contBtn.endClickCallback = onClick;
        _txtCount = new TextField(50,50,"+"+count,"Arial",12,Color.BLACK);
        _txtCount.x = 30;
        _txtCount.y = -25;
        _txtProfit = new TextField(80,50,profit,"Arial",12,Color.BLACK);
        _txtProfit.x = 15;
        _txtProfit.y = -10;
        _txtCost = new TextField(50,50,cost,"Arial",12,Color.BLACK);
        _txtCost.x = 25;
        _txtCost.y = 70;
        _image = new Image(g.interfaceAtlas.getTexture(currency));
        _image.x = 50 - _image.width/2;
        _image.y = 50 - _image.height/2;
        _imageBg = new Image(g.interfaceAtlas.getTexture("tempItemBG"));
        _imageBg.x = 50 - _imageBg.width/2;
        _imageBg.y = 50 - _imageBg.height/2;
        _imageBtn = new Image(g.interfaceAtlas.getTexture("btn4"));
        MCScaler.scale(_imageBtn,60,50);
        _imageBtn.x = 25;
        _imageBtn.y = 80;
        source.addChild(_imageBg);
        _contBtn.addChild(_imageBtn);
        source.addChild(_image);
        source.addChild(_txtCount);
        source.addChild(_txtProfit);
        _contBtn.addChild(_txtCost);
        source.addChild(_contBtn);
    }

    private function onClick():void {
        if(cu == "coin"){
            g.userInventory.addMoney(2, int(co));
        }else if (cu == "diamont"){
            g.userInventory.addMoney(1, int(co));
        }
    }

}
}
