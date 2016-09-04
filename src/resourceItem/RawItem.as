/**
 * Created by user on 6/25/15.
 */
package resourceItem {
import com.junkbyte.console.Cc;

import flash.geom.Point;

import manager.ManagerFilters;

import manager.Vars;

import starling.animation.Tween;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;

import utils.CTextField;

import utils.MCScaler;

import windows.WindowsManager;

public class RawItem {
    private var g:Vars = Vars.getInstance();

    //just animation for raw process
    public function RawItem(endPoint:Point, texture:Texture, count:int, delay:Number):void {
        var _source:Sprite = new Sprite();
        _source.touchable = false;
        var im:Image = new Image(texture);
        if (!im) {
            Cc.error('RawItem:: bad texture');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'rawItem');
            return;
        }
        MCScaler.scale(im, 50, 50);
        _source.addChild(im);
        _source.pivotX = _source.width/2;
        _source.pivotY = _source.height/2;
        _source.x = endPoint.x;
        _source.y = endPoint.y - 100;
        g.cont.animationsResourceCont.addChild(_source);

        var _countTxt:CTextField = new CTextField(50,30,'-' + String(count));
        _countTxt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.TEXT_BROWN_COLOR);
        _countTxt.x = im.width - 30;
        _countTxt.y = im.height - 15;
        _source.addChild(_countTxt);

        var tween:Tween = new Tween(_source, .4);
        tween.moveTo(endPoint.x, endPoint.y);
        tween.delay = delay;
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
            g.cont.animationsResourceCont.removeChild(_source);
            while (_source.numChildren) {
                _source.removeChildAt(0);
            }
        };
        g.starling.juggler.add(tween);
    }
}
}
