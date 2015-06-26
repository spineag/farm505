/**
 * Created by user on 6/26/15.
 */
package ui.craftPanel {
import manager.Vars;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;

import utils.MCScaler;

import windows.ambar.AmbarProgress;

public class CraftPanel {
    private var _source:Sprite;
    private var _bg:Quad;
    private var _progress:AmbarProgress;
    private var _isShow:Boolean;
    private var _resourceSprite:Sprite;
    private var _ambarImage:Image;
    private var _skladImage:Image;

    private var g:Vars = Vars.getInstance();

    public function CraftPanel() {
        _isShow = false;
        _source = new Sprite();
        _source.touchable = false;
        _bg = new Quad(300, 45, Color.LIME);
        _source.addChild(_bg);
        _source.pivotX = _source.width/2;
        _source.pivotY = _source.height/2;
        _source.x = g.stageWidth/2;
        _source.y = 70;

        _progress = new AmbarProgress();
        _progress.source.scaleX = _progress.source.scaleY = .75;
        _progress.source.x = _source.width/2;
        _progress.source.y = _source.height/2;
        _source.addChild(_progress.source);

        _resourceSprite = new Sprite();
        _source.addChild(_resourceSprite);

        _ambarImage = new Image(g.tempBuildAtlas.getTexture('ambar'));
        MCScaler.scale(_ambarImage, 30, 30);
        _ambarImage.pivotX = _ambarImage.width/2;
        _ambarImage.pivotY = _ambarImage.height/2;
        _ambarImage.x = 300;
        _source.addChild(_ambarImage);
        _ambarImage.visible = false;

        _skladImage = new Image(g.tempBuildAtlas.getTexture('sklad'));
        MCScaler.scale(_skladImage, 30, 30);
        _skladImage.pivotX = _skladImage.width/2;
        _skladImage.pivotY = _skladImage.height/2;
        _skladImage.x = 300;
        _source.addChild(_skladImage);
        _skladImage.visible = false;
    }

    public function showIt(isAmbar:Boolean):void {
        if (!_isShow) {
            g.cont.interfaceCont.addChild(_source);
            _isShow = true;
        }

        _skladImage.visible = false;
        _ambarImage.visible = false;

        if (isAmbar) {
            _ambarImage.visible = true;
            _progress.setProgress(g.userInventory.getResourcesForAmbar().length/g.user.ambarMaxCount);
        } else {
            _skladImage.visible = true;
            _progress.setProgress(g.userInventory.getResourcesForSklad().length/g.user.skladMaxCount);
        }
    }
}
}
