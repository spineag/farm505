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

    // 6 <- 5 <- 4
    // 1 -> 2 -> 3   moving basket
    private var _lenta1:ArrivedLenta;
    private var _lenta2:ArrivedLenta;
    private var _lenta3:ArrivedLenta;
    private var _lentaBack4:ArrivedLenta;
    private var _lentaBack5:ArrivedLenta;
    private var _lentaBack6:ArrivedLenta;

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
        _lenta3 = new ArrivedLenta(-82*g.scaleFactor, -228*g.scaleFactor, -888*g.scaleFactor, 166*g.scaleFactor, _mediumSprite, true);
        _lenta3.setEmptyState();

        _lenta2 = new ArrivedLenta(-888*g.scaleFactor, 158*g.scaleFactor, -1694*g.scaleFactor, 548*g.scaleFactor, _mediumSprite, true);
        _lenta2.setEmptyState();

        _lenta1 = new ArrivedLenta(-1694*g.scaleFactor, 548*g.scaleFactor, -2500*g.scaleFactor, 938*g.scaleFactor, _mediumSprite, true);
        _lenta1.setEmptyState();
    }

    private function createLentaBack():void {
        _lentaBack4 = new ArrivedLenta(-144*g.scaleFactor, -270*g.scaleFactor, -952*g.scaleFactor, 124*g.scaleFactor, _bottomSprite, false);
        _lentaBack4.setEmptyState();

        _lentaBack5 = new ArrivedLenta(-952*g.scaleFactor, 124*g.scaleFactor, -1756*g.scaleFactor, 512*g.scaleFactor, _bottomSprite, false);
        _lentaBack5.setEmptyState();

        _lentaBack6 = new ArrivedLenta(-1756*g.scaleFactor, 512*g.scaleFactor, -2560*g.scaleFactor, 900*g.scaleFactor, _bottomSprite, false);
        _lentaBack6.setEmptyState();
    }

    public function makeArriveKorzina(f:Function):void {
        _callback = f;
        _lenta1.startAnimateKorzina(f1);
    }

    private function f1():void {
        _lenta2.startAnimateKorzina(f2);
    }

    private function f2():void {
        _lenta3.startAnimateKorzina(f3, true);
    }

    private function f3():void {
        if (_callback != null) {
            _callback.apply();
        }
    }

    public function makeAwayKorzina(f:Function):void {
        _callback = f;
        _lenta3.directAway(f0);
    }

    private function f0():void {
        _lentaBack4.startAnimateKorzina(f4);
    }

    private function f4():void {
        _lentaBack5.startAnimateKorzina(f5);
    }

    private function f5():void {
        _lentaBack6.startAnimateKorzina(f6);
    }

    private function f6():void {
        if (_callback != null) {
            _callback.apply();
        }
    }

    public function showKorzina():void {
        _lenta3.showDirectKorzina();
    }

    public function deleteIt():void {
        _lenta1.deleteIt();
        _lenta2.deleteIt();
        _lenta3.deleteIt();
        _lentaBack4.deleteIt();
        _lentaBack5.deleteIt();
        _lentaBack6.deleteIt();
        _bottomSprite.dispose();
        _mediumSprite.dispose();
        _topSprite.dispose();
        _parent = null;
    }
}
}
