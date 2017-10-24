/**
 * Created by user on 2/20/17.
 */
package resourceItem {
import starling.display.Image;
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;

import data.BuildType;

import data.DataMoney;

import flash.display.StageDisplayState;

import flash.geom.Point;

import manager.ManagerFilters;

import manager.Vars;

import social.SocialNetworkSwitch;

import starling.core.Starling;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import temp.DropResourceVariaty;

import utils.CTextField;

import utils.MCScaler;

import windows.WindowsManager;

public class DropPartyResource {
    private var _source:Sprite;
    private var _image:Image;

    private var g:Vars = Vars.getInstance();

    public function DropPartyResource(_x:int, _y:int, delay:Number = .3, fromSize:int = 50) {
        var endPoint:Point;
        _source = new Sprite();
        if(g.allData.atlas['partyAtlas'])_image = new Image(g.allData.atlas['partyAtlas'].getTexture('halloween_sheton'));

        MCScaler.scale(_image, fromSize, fromSize);
        _source.addChild(_image);
        _source.pivotX = _source.width / 2;
        _source.pivotY = _source.height / 2;
        _source.x = _x;
        _source.y = _y;
        g.cont.animationsResourceCont.addChild(_source);
        endPoint = g.partyPanel.getPoint();
//        if (g.managerParty.userParty.countResource < g.managerParty.countToGift[4]) {
//            if (g.managerParty.userParty.countResource + 1 <= g.managerParty.countToGift[4]) {
                g.managerParty.userParty.countResource = g.managerParty.userParty.countResource + 1;
                var st:String = g.managerParty.userParty.tookGift[0] + '&' + g.managerParty.userParty.tookGift[1] + '&' + g.managerParty.userParty.tookGift[2] + '&'
                        + g.managerParty.userParty.tookGift[3] + '&' + g.managerParty.userParty.tookGift[4];
                g.directServer.updateUserParty(st, g.managerParty.userParty.countResource, 0, null);
//            }
//        }
        var f1:Function = function():void {
            g.cont.animationsResourceCont.removeChild(_source);
            g.partyPanel.animationBuy();
            while (_source.numChildren) {
                _source.removeChildAt(0);
            }
            _source = null;
        };
        var tempX:int = _source.x - 140 + int(Math.random()*140);
        var tempY:int = _source.y - 40 + int(Math.random()*140);
        var dist:int = int(Math.sqrt((_source.x - tempX)*(_source.x - tempX) + (_source.y - tempY)*(_source.y - tempY)));
        dist += int(Math.sqrt((tempX - endPoint.x)*(tempX - endPoint.x) + (tempY - endPoint.y)*(tempY - endPoint.y)));
        var t:Number = dist/1000 * 2;
        if (t > 2) t -= .6;
        if (t > 3) t -= 1;
        if (fromSize != 50) {
            var scale:Number = _image.scaleX / (fromSize/50);
            new TweenMax(_source, t, {bezier:[{x:tempX, y:tempY}, {x:endPoint.x, y:endPoint.y}], scaleX:scale, scaleY:scale, ease:Linear.easeOut ,onComplete: f1, delay: delay});
        } else new TweenMax(_source, t, {bezier:[{x:tempX, y:tempY}, {x:endPoint.x, y:endPoint.y}], ease:Linear.easeOut ,onComplete: f1, delay: delay});
    }
}
}
