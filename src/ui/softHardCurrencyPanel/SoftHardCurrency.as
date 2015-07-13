/**
 * Created by user on 7/6/15.
 */
package ui.softHardCurrencyPanel {
import flash.geom.Point;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;

import starling.text.TextField;
import starling.utils.Color;

public class SoftHardCurrency {
    private var _source:Sprite;
    private var _txtSoft:TextField;
    private var _txtHard:TextField;
    private var _imageSoft:Image;
    private var _imageHard:Image;
    private var g:Vars = Vars.getInstance();

    public function SoftHardCurrency() {
        _source = new Sprite();
        g.cont.interfaceCont.addChild(_source);
        _txtSoft = new TextField(100,100,"","Arial",18,Color.WHITE);
        _txtSoft.x = 20;
        _txtSoft.y = -17;
        _txtHard = new TextField(100,100,"","Arial",18,Color.WHITE);
        _txtHard.x = 20;
        _txtHard.y = 35;
        _imageSoft = new Image(g.interfaceAtlas.getTexture("soft_board"));
        _imageSoft.x = 5;
        _imageHard = new Image(g.interfaceAtlas.getTexture("hard_board"));
        _imageHard.x = 5;
        _imageHard.y = 60;
        _source.addChild(_imageSoft);
        _source.addChild(_imageHard);
        _txtSoft.text = String(g.user.softCurrencyCount);
        _txtHard.text = String(g.user.hardCurrency);
        _source.addChild(_txtSoft);
        _source.addChild(_txtHard);

    }

    public function checkSoft():void {
       _txtSoft.text =  String(g.user.softCurrencyCount);
    }
//
//    public function addHard():void {
//
//    }
//
//    public function deleteHard():void {
//
//    }

    public function getHardCurrencyPoint():Point {
        var p:Point = new Point();
        p.x = _imageHard.x + 20;
        p.y = _imageHard.y + 10;
        p = _source.localToGlobal(p);
        return p;
    }

    public function getSoftCurrencyPoint():Point {
        var p:Point = new Point();
        p.x = _imageSoft.x + 20;
        p.y = _imageSoft.y + 10;
        p = _source.localToGlobal(p);
        return p;
    }

    public function checkHard():void {
        _txtHard.text =  String(g.user.hardCurrency);
    }
}
}
