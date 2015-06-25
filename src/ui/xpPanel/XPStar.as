/**
 * Created by user on 6/24/15.
 */
package ui.xpPanel {

import manager.Vars;

import resourceItem.ResourceItem;

import starling.animation.Tween;

import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;
import utils.MCScaler;

public class XPStar {

    private var _source:CSprite;
    private var _image:Image;
    private var _resourceItem:ResourceItem;
    private var _txtStar:TextField;

    private var g:Vars = Vars.getInstance();

    public function XPStar(_x:int, _y:int,resourceItem:ResourceItem) {
        _source = new CSprite();
        _txtStar = new TextField(50,50," ","Arial",18,Color.WHITE);
        _txtStar.y = 25;
        _image = new Image(g.interfaceAtlas.getTexture("star"));
        _resourceItem = resourceItem;
        g.cont.mainCont.addChild(_source);
        MCScaler.scale(_image, 50, 50);
        _source.addChild(_image);
        _source.pivotX = _source.width / 2;
        _source.pivotY = _source.height / 2;
        _source.x = _x;
        _source.y = _y;
        _source.addChild(_txtStar);
        flyItStar();

    }

    public function flyItStar():void {
        var endX:int = g.stageWidth - 200;
        var endY:int = 50;
        var tween:Tween = new Tween(_source, 1);
        tween.moveTo(endX, endY);
        _txtStar.text = String(_resourceItem.craftXP);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
            while (_source.numChildren) {
                _source.removeChildAt(0);
                g.xpPanel.addXP(_resourceItem.craftXP);
            }
            _source = null;
        };
        g.starling.juggler.add(tween);
    }
}
}
