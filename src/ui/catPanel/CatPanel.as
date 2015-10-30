/**
 * Created by user on 10/27/15.
 */
package ui.catPanel {
import heroes.HeroCat;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.MCScaler;

public class CatPanel {
    private var _source:Sprite;
    private var _imageBg:Image;
    private var _imageCat:Image;
    private var _txtCount:TextField;

    private var g:Vars = Vars.getInstance();
    public function CatPanel() {
        _source = new Sprite();
        _source.x = 5;
        _source.y = 200;
        _imageBg = new Image(g.interfaceAtlas.getTexture("plawka7"));
        _imageCat = new Image(g.interfaceAtlas.getTexture("neighbor"));
        MCScaler.scale(_imageCat,30,30);
        _txtCount = new TextField(50,50,'',"Arial",14,Color.BLACK);
        _txtCount.x = 15;
        _txtCount.y = -5;
        _source.addChild(_imageBg);
        _source.addChild(_imageCat);
        _source.addChild(_txtCount);
        g.cont.interfaceCont.addChild(_source);
    }

    public function checkCat():void {
        _txtCount.text = String(g.managerCats.countFreeCats + "/" + g.managerCats.curCountCats);
    }
}
}
