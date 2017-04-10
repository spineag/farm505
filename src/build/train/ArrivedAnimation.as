/**
 * Created by user on 2/9/16.
 */
package build.train {
import build.TownAreaBuildSprite;

import manager.Vars;

import starling.display.Image;

import starling.display.Sprite;

import utils.CSprite;

public class ArrivedAnimation {
    private var _parent:TownAreaBuildSprite;
    private var _bottomSprite:Sprite;
    private var _mediumSprite:Sprite;
    private var _topSprite:Sprite;
    private var g:Vars = Vars.getInstance();
    private var _callback:Function;

    // <- lentaBack
    // lenta1    ->       moving basket
    private var _lenta:ArrivedLenta;
    private var _lentaBack:ArrivedLenta;

    public function ArrivedAnimation(p:TownAreaBuildSprite) {
        _parent = p;
        _bottomSprite = new Sprite();
        _parent.addChildAt(_bottomSprite, 0);
        _bottomSprite.touchable = false;
        _mediumSprite = new Sprite();
        _parent.addChild(_mediumSprite);
        _mediumSprite.touchable = false;
        _topSprite = new Sprite();
        _parent.addChild(_topSprite);
        _topSprite.touchable = false;

        createPillars();
        createLentaFront();
        createLentaBack();
    }

    public function set visible(v:Boolean):void {
        _bottomSprite.visible = v;
        _mediumSprite.visible = v;
        _topSprite.visible = v;
    }

    private function createPillars():void {
        var im:Image = new Image(g.allData.atlas['buildAtlas'].getTexture('pillar_1'));
        im.pivotX = im.width/2;
        im.pivotY = im.height;
        im.x = -920*g.scaleFactor;
        im.y = 588*g.scaleFactor;
        _mediumSprite.addChild(im);

        im = new Image(g.allData.atlas['buildAtlas'].getTexture('pillar_1'));
        im.pivotX = im.width/2;
        im.pivotY = im.height;
        im.x = -1724*g.scaleFactor;
        im.y = 974*g.scaleFactor;
        _mediumSprite.addChild(im);

        im = new Image(g.allData.atlas['buildAtlas'].getTexture('pillar_new'));
        im.pivotX = im.width/2;
        im.pivotY = im.height;
        im.x = -912*g.scaleFactor;
        im.y = 182*g.scaleFactor;
        _topSprite.addChild(im);

        im = new Image(g.allData.atlas['buildAtlas'].getTexture('pillar_new'));
        im.pivotX = im.width/2;
        im.pivotY = im.height;
        im.x = -1716*g.scaleFactor;
        im.y = 568*g.scaleFactor;
        _topSprite.addChild(im);
    }

    private function createLentaFront():void {
        _lenta = new ArrivedLenta(-82*g.scaleFactor, -228*g.scaleFactor, -2500*g.scaleFactor, 938*g.scaleFactor, _mediumSprite, true);
    }

    private function createLentaBack():void {
        _lentaBack = new ArrivedLenta(-144*g.scaleFactor, -270*g.scaleFactor, -2560*g.scaleFactor, 900*g.scaleFactor, _bottomSprite, false);
    }

    public function makeArriveKorzina(f:Function):void {
        _lenta.startAnimateKorzina(f);
    }

    public function makeAwayKorzina(f:Function):void {
        _callback = f;
        _lenta.directAway(f0);
    }

    private function f0():void {
        _lentaBack.startAnimateKorzina(fBackEnd);
    }

    private function fBackEnd():void {
        if (_callback != null) {
            _callback.apply();
            _callback = null;
        }
    }

    public function showKorzina():void {
        _lenta.showDirectKorzina();
    }

    public function deleteIt():void {
        _lenta.deleteIt();
        _lentaBack.deleteIt();
        _bottomSprite.dispose();
        _mediumSprite.dispose();
        _topSprite.dispose();
        _parent = null;
    }
}
}
