/**
 * Created by user on 7/15/15.
 */
package windows.buyCoupone {
import com.junkbyte.console.Cc;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

import utils.MCScaler;

public class WOBuyCouponeItem {
    public var source:Sprite;
    private var _contBtn:CSprite;
    private var _imageCoupone:Image;
    private var _imagePlus:Image;
    private var _imageHard:Image;
    private var _imageBtn:Image;
    private var _txtItemCoupone:TextField;
    private var _txtAddCoupone:TextField;
    private var _txtCostCoupone:TextField;
    private var cost:int;
    private var g:Vars = Vars.getInstance();

    public function WOBuyCouponeItem(imageCopone:String, txtItemCoupone:int, txtCostCoupone:int) {
        try {
            source = new Sprite();
            cost = txtCostCoupone;
            _contBtn = new CSprite();
            _contBtn.endClickCallback = onClick;
            _imageCoupone = new Image(g.allData.atlas['interfaceAtlas'].getTexture(imageCopone));
            _txtCostCoupone = new TextField(50,50,String(txtCostCoupone),"Arial",12,Color.BLACK);
            _txtCostCoupone.x = -20;
            _txtCostCoupone.y = 110;
            _txtItemCoupone = new TextField(50,50,String(txtItemCoupone),"Arial",12,Color.BLACK);
            _txtItemCoupone.x = 10;
            _txtItemCoupone.y = 40;
            _imagePlus = new Image(g.allData.atlas['interfaceAtlas'].getTexture("plus"));
            MCScaler.scale(_imagePlus,20,20);
            _imageCoupone.x = -15;
            _imagePlus.y = 60;
            _imageBtn = new Image(g.allData.atlas['interfaceAtlas'].getTexture("btn4"));
            MCScaler.scale(_imageBtn,30,50);
            _imageBtn.x = -10;
            _imageBtn.y = 120;
            _imageHard = new Image(g.allData.atlas['interfaceAtlas'].getTexture("diamont"));
            _imageHard.x = 15;
            _imageHard.y = 125;
            MCScaler.scale(_imageHard,15,15);
            _txtAddCoupone = new TextField(60,50,"Добавить купон","Arial",12,Color.BLACK);
            _txtAddCoupone.x = -15;
            _txtAddCoupone.y = 70;

            _contBtn.addChild(_imageBtn);
            source.addChild(_imageCoupone);
            _contBtn.addChild(_txtCostCoupone);
            source.addChild(_txtItemCoupone);
            source.addChild(_imagePlus);
            _contBtn.addChild(_imageHard);
            source.addChild(_txtAddCoupone);
            source.addChild(_contBtn);
//        onClick(txtCostCoupone);
        } catch (e:Error) {
            Cc.error('WOBuyCouponeItem error: ' + e.errorID + ' - ' + e.message);
            g.woGameError.showIt();
        }
    }

    private function onClick():void {
        trace("click");
        g.userInventory.addMoney(1, -cost);
    }
}
}
