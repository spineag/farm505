/**
 * Created by user on 6/12/15.
 */
package resourceItem {
import com.greensock.TweenMax;
import com.greensock.easing.Back;
import com.greensock.easing.Ease;
import com.greensock.easing.Linear;
import com.greensock.easing.Quint;

import flash.geom.Point;

import resourceItem.ResourceItem;
import manager.Vars;

import starling.animation.Tween;

import starling.display.Image;

import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import ui.xpPanel.XPPanel;

import ui.xpPanel.XPStar;

import ui.xpPanel.XPStar;

import utils.CSprite;
import utils.MCScaler;

public class CraftItem {
    private var _source:CSprite;
    private var _resourceItem:ResourceItem;
    private var _image:Image;
    private var _cont:Sprite;
    private var _callback:Function;
    private var _count:int;
    private var _txtNumber:TextField;

    private var g:Vars = Vars.getInstance();

    public function CraftItem(_x:int, _y:int, resourceItem:ResourceItem, parent:Sprite, count:int = 1, f:Function = null) {
        _count = count;
        _callback = f;
        _cont = g.cont.animationsResourceCont;
        _source = new CSprite();
        _resourceItem = resourceItem;
        if (_resourceItem.url == 'resourceAtlas') {
            _image = new Image(g.resourceAtlas.getTexture(_resourceItem.imageShop));
        } else if (_resourceItem.url == 'plantAtlas') {
            _image = new Image(g.plantAtlas.getTexture(_resourceItem.imageShop));
        }

        MCScaler.scale(_image, 50, 50);
        _source.addChild(_image);
        _source.pivotX = _source.width/2;
        _source.pivotY = _source.height/2;
        _source.x = _x + int(Math.random()*30) - 15;
        _source.y = _y + int(Math.random()*30) - 15;
        parent.addChild(_source);
        _source.endClickCallback = flyIt;
        _txtNumber = new TextField(50,50," ","Arial",18,Color.WHITE);
        _txtNumber.y = 25;
        _source.addChild(_txtNumber);
    }

    private function flyIt():void {
        if (_callback != null) {
            _callback.apply(null, []);
        }
        _source.endClickCallback = null;
        for(var id:String in g.dataRecipe.objectRecipe) {
            if (g.dataRecipe.objectRecipe[id].idResource == _resourceItem.resourceID) {
                _txtNumber.text = String(g.dataRecipe.objectRecipe[id].numberCreate);
            }
        }
        var start:Point = new Point(int(_source.x), int(_source.y));
        start = _source.parent.localToGlobal(start);
        _source.parent.removeChild(_source);
//        _txtNumber.text = "4";

        var endX:int = g.stageWidth/2;
        var endY:int = 50;
        _source.x = start.x;
        _source.y = start.y;
        _cont.addChild(_source);

        // using Starling Tween
//        var tween:Tween = new Tween(_source, 1);
//        tween.moveTo(endX, endY);
//        tween.onComplete = function ():void {
//            g.starling.juggler.remove(tween);
//            _cont.removeChild(_source);
//            while (_source.numChildren) {
//                _source.removeChildAt(0);
//            }
//            _source = null;
//            g.userInventory.addResource(_resourceItem.resourceID, _count);
//        };
//        g.starling.juggler.add(tween);

        // using TweenMax
        var f1:Function = function():void {
            _cont.removeChild(_source);
            while (_source.numChildren) {
                _source.removeChildAt(0);
            }
            _source = null;
            g.userInventory.addResource(_resourceItem.resourceID, _count);
        };
        var tempX:int;
        _source.x < endX ? tempX = _source.x + 50 : tempX = _source.x - 50;
        var tempY:int = _source.y + 30 + int(Math.random()*20);
        var dist:int = int(Math.sqrt((_source.x - endX)*(_source.x - endX) + (_source.y - endY)*(_source.y - endY)));
        var v:Number = 170;
        new TweenMax(_source, dist/v, {bezier:[{x:tempX, y:tempY}, {x:endX, y:endY}], ease:Linear.easeOut ,onComplete: f1});
        new XPStar(_source.x,_source.y,_resourceItem);
    }




// as EXAMPLE
//    private function tweenStarling( obj:Image ):void {
//        var tw:Tween = new Tween(obj, 1+(Math.random()*3), Transitions.EASE_OUT );
//        tw.moveTo( Math.random() * 480 , Math.random() * 762);
//        tw.onComplete = tweenStarling;
//        tw.onCompleteArgs = [obj];
//        Starling.current.juggler.add(tw);
//    }
//
//    private function tweenGreenSock( obj:Image ):void {
//        var tw:TweenLite = new TweenLite(obj, 1 + (Math.random() * 3) , {
//            x:Math.random() * 480 ,
//            y: Math.random() * 762 ,
//            onComplete:tweenGreenSock ,
//            onCompleteParams:[obj]
//        } );
//    }
}
}
