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

    public function AmbarProgress() {
        source = new Sprite();
        source.touchable = false;
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('storage_window_pr'));
        source.addChild(im);
        source.pivotX = source.width/2;
        source.pivotY = source.height/2;
        _bar = new ProgressBarComponent(g.allData.atlas['interfaceAtlas'].getTexture('storage_window_prl_l'), g.allData.atlas['interfaceAtlas'].getTexture('storage_window_prl_c'),
                g.allData.atlas['interfaceAtlas'].getTexture('storage_window_prl_r'), 428);
        _bar.x = 12;
        _bar.y = 13;
        source.addChild(_bar);

        imAmbar = new Image(g.allData.atlas['iconAtlas'].getTexture('ambar_icon'));
        MCScaler.scale(imAmbar, 40, 40);
        imAmbar.x = 427;
        imAmbar.y = 3;
        source.addChild(imAmbar);
        imSklad = new Image(g.allData.atlas['iconAtlas'].getTexture('sklad_icon'));
        MCScaler.scale(imSklad, 40, 40);
        imSklad.x = 420;
        imSklad.y = 5;
        source.addChild(imSklad);
    }

    public function setProgress(a:Number):void {
        _bar.progress = a;
    }

    public function showAmbarIcon(v:Boolean):void {
        imAmbar.visible = v;
        imSklad.visible = !v;
    }
}
}
