/**
 * Created by user on 10/26/16.
 */
package ui.stock {
import flash.display.Bitmap;

import manager.Vars;

import starling.display.Image;

import starling.textures.Texture;

import utils.CSprite;

import windows.WindowsManager;

public class StockPanel {
    private var _source:CSprite;
    private var g:Vars = Vars.getInstance();

    public function StockPanel() {
        _source = new CSprite();
        _source.endClickCallback = onClick;
        _source.hoverCallback = function():void { g.hint.showIt("Акция") };
        _source.outCallback = function():void { g.hint.hideIt() };
        onResize();
//        g.cont.interfaceCont.addChild(_source);
//        g.load.loadImage(g.dataPath.getGraphicsPath() + 'qui/action_icon.png',onLoad);
    }


    private function onLoad(bitmap:Bitmap):void {
        var im:Image = new Image(Texture.fromBitmap(g.pBitmaps[g.dataPath.getGraphicsPath() + 'qui/action_icon.png'].create() as Bitmap));
        _source.addChild(im);
    }

    public function onResize():void {
        _source.y = 120;
        _source.x = g.managerResize.stageWidth - 108;
    }

    private function onClick():void {
        g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, false);
    }
}
}
