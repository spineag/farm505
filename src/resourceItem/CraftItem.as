/**
 * Created by user on 6/12/15.
 */
package resourceItem {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import data.BuildType;
import flash.geom.Point;
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import ui.xpPanel.XPStar;

import utils.CSprite;
import utils.MCScaler;

public class CraftItem {
    private var _source:CSprite;
    private var _resourceItem:ResourceItem;
    private var _image:Image;
    private var _callback:Function;
    private var _count:int;
    private var _txtNumber:TextField;

    private var g:Vars = Vars.getInstance();

    public function CraftItem(_x:int, _y:int, resourceItem:ResourceItem, parent:Sprite, count:int = 1, f:Function = null) {
        _count = count;
        _callback = f;
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
        _txtNumber.x = 15;
        _txtNumber.y = 25;
        _source.addChild(_txtNumber);
    }

    public function removeDefaultCallbacks():void {
        _source.endClickCallback = null;
        _source.touchable = false;
    }

    public function set callback(f:Function):void {
        _callback = f;
    }

    public function get source():CSprite {
        return _source;
    }

    public function flyIt():void {
        if (_resourceItem.placeBuild == BuildType.PLACE_AMBAR && g.userInventory.currentCountInAmbar + _count >= g.user.ambarMaxCount) {
            g.flyMessage.showIt(_source,"Амбар заполнен");
            return;
        }

        if (_resourceItem.placeBuild == BuildType.PLACE_SKLAD && g.userInventory.currentCountInSklad + _count >= g.user.skladMaxCount) {
            g.flyMessage.showIt(_source,"Склад заполнен");
            return;
        }

        if (_resourceItem.placeBuild != BuildType.PLACE_NONE)
            g.craftPanel.showIt(_resourceItem.placeBuild);

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
        if (_source.parent && _source.parent.contains(_source)) _source.parent.removeChild(_source);

//        _image.width = 100;
        _image.scaleY = _image.scaleX = 1;
        _source.scaleY = _source.scaleX = 1;
        MCScaler.scale(_image, 50, 50);
        var endPoint:Point = g.craftPanel.pointXY();
        _source.x = start.x;
        _source.y = start.y;
        g.cont.animationsResourceCont.addChild(_source);
        if (g.managerDropResources.checkDrop()) {
            g.managerDropResources.makeDrop(_source.x,_source.y);
        }

        var f1:Function = function():void {
            g.cont.animationsResourceCont.removeChild(_source);
            while (_source.numChildren) {
                _source.removeChildAt(0);
            }
            _source = null;
            g.userInventory.addResource(_resourceItem.resourceID, _count);
            if (_resourceItem.placeBuild != BuildType.PLACE_NONE)
                g.craftPanel.afterFly(_resourceItem);
        };
        var tempX:int;
        _source.x < endPoint.x ? tempX = _source.x + 50 : tempX = _source.x - 50;
        var tempY:int = _source.y + 30 + int(Math.random()*20);
        var dist:int = int(Math.sqrt((_source.x - endPoint.x)*(_source.x - endPoint.x) + (_source.y - endPoint.y)*(_source.y - endPoint.y)));
        var v:Number = 250;
        new TweenMax(_source, dist/v, {bezier:[{x:tempX, y:tempY}, {x:endPoint.x, y:endPoint.y}], ease:Linear.easeOut ,onComplete: f1});
        new XPStar(_source.x,_source.y,_resourceItem.craftXP);
        if (_count > 1) {
            _txtNumber.text = String(_count);
        } else {
            _txtNumber.text = '';
        }
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
