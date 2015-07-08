/**
 * Created by user on 7/7/15.
 */
package ui.couponePanel {
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

public class CouponePanel {
    private var _source:CSprite;
    private var _contCoupone:Sprite;
    private var _imCoupone:Image;
    private var _imYellow:Image;
    private var _imRed:Image;
    private var _imBlue:Image;
    private var _imGreen:Image;

    private var _txtYellow:TextField;
    private var _txtRed:TextField;
    private var _txtBlue:TextField;
    private var _txtGreen:TextField;

    private var g:Vars = Vars.getInstance();
    public function CouponePanel() {
        _source = new CSprite();
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
        g.cont.interfaceCont.addChild(_source);
        g.cont.interfaceCont.addChild(_contCoupone);
        _imCoupone = new Image(g.interfaceAtlas.getTexture("buy_coupons"));
        _imGreen = new Image(g.interfaceAtlas.getTexture("green_coupone"));
        _imBlue = new Image(g.interfaceAtlas.getTexture("blue_coupone"));
        _imRed = new Image(g.interfaceAtlas.getTexture("red_coupone"));
        _imYellow = new Image(g.interfaceAtlas.getTexture("yellow_coupone"));

        _txtGreen = new TextField(50,50,"","Arial",14,Color.WHITE);
        _txtBlue = new TextField(50,50,"","Arial",18,Color.WHITE);
        _txtRed = new TextField(50,50,"","Arial",18,Color.WHITE);
        _txtYellow = new TextField(50,50,"","Arial",18,Color.WHITE);
        _source.addChild(_imCoupone);

        _source.x = 5;
        _source.y = 80;

        _contCoupone.addChild(_imGreen);
        _contCoupone.addChild(_imBlue);
        _contCoupone.addChild(_imRed);
        _contCoupone.addChild(_imYellow);

        _contCoupone.addChild(_txtGreen);
        _contCoupone.addChild(_txtBlue);
        _contCoupone.addChild(_txtRed);
        _contCoupone.addChild(_txtYellow);
        _contCoupone.visible = false;
    }
    private function onHover():void {
        _txtGreen.text = String(g.user.greenCouponCount);
        _txtBlue.text = String(g.user.blueCouponCount);
        _txtRed.text = String(g.user.redCouponCount);
        _txtYellow.text = String(g.user.yellowCouponCount);
        _contCoupone.visible = true;
    }

    private function onOut():void {
        _contCoupone.visible = false;
    }
}
}
