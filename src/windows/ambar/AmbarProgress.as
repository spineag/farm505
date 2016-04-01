/**
 * Created by user on 6/26/15.
 */
package windows.ambar {
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;

import utils.MCScaler;

import windows.WOComponents.CartonBackground;
import windows.WOComponents.ProgressBarComponent;

public class AmbarProgress {
    public var source:Sprite;
    private var _bar:ProgressBarComponent;
    private var imAmbar:Image;
    private var imSklad:Image;

    private var g:Vars = Vars.getInstance();

    public function AmbarProgress(addImages:Boolean = true, ambarSklad:Boolean = true) {
        source = new Sprite();
        source.touchable = false;
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('storage_window_pr'));
        source.addChild(im);
        source.pivotX = source.width/2;
        source.pivotY = source.height/2;
        _bar = new ProgressBarComponent(g.allData.atlas['interfaceAtlas'].getTexture('storage_window_prl_l'), g.allData.atlas['interfaceAtlas'].getTexture('storage_window_prl_c'),
                g.allData.atlas['interfaceAtlas'].getTexture('storage_window_prl_r'), 403);
        _bar.x = 12;
        _bar.y = 13;
        source.addChild(_bar);

        if (addImages) {
            imAmbar = new Image(g.allData.atlas['iconAtlas'].getTexture('ambar_icon'));
            MCScaler.scale(imAmbar, 50, 50);
            imAmbar.x = 416;
            imAmbar.y = -2;
            source.addChild(imAmbar);
            imSklad = new Image(g.allData.atlas['iconAtlas'].getTexture('sklad_icon'));
            MCScaler.scale(imSklad, 50, 50);
            imSklad.x = 410;
            imSklad.y = 2;
            source.addChild(imSklad);
        }
    }

    public function setProgress(a:Number):void {
        _bar.progress = a;
//        imSklad.x = 430;
    }

    public function showAmbarIcon(v:Boolean):void {
        imAmbar.visible = v;
        imSklad.visible = !v;
    }

    public function deleteIt():void {
        source.removeChild(_bar);
        _bar.deleteIt();
        _bar = null;
        source.dispose();
        source = null;
    }
}
}
