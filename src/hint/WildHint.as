/**
 * Created by user on 6/11/15.
 */
package hint {
import com.junkbyte.console.Cc;

import flash.geom.Point;

import manager.ManagerFilters;

import manager.Vars;

import starling.display.Image;
import starling.display.Quad;
import starling.text.TextField;
import starling.utils.Color;

import ui.xpPanel.XPStar;

import utils.CSprite;
import utils.MCScaler;

import windows.WOComponents.HintBackground;

public class WildHint {
    private var _source:CSprite;
    private var _isShowed:Boolean;
    private var _isOnHover:Boolean;
    private var _circle:Image;
    private var _bgItem:Image;
    private var _iconResource:Image;
    private var _txtCount:TextField;
    private var _txtName:TextField;
    private var _deleteCallback:Function;
    private var _id:int;
    private var _height:int;
    private var bg:HintBackground;
    private var g:Vars = Vars.getInstance();
    private var _quad:Quad;
    public function WildHint() {
        _source = new CSprite();
        _isShowed = false;
        _isOnHover = false;
        bg = new HintBackground(120, 104, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
        _source.addChild(bg);
        _bgItem = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_blue_d'));
        _bgItem.x = -_bgItem.width/2;
        _bgItem.y = -_bgItem.height - 35;
        _source.addChild(_bgItem);
        _circle = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cursor_number_circle'));

        _txtCount = new TextField(50,50,"", g.allData.fonts['BloggerBold'], 12, Color.WHITE);
        _txtCount.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtName = new TextField(100,50,"", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _txtName.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtName.x = -50;
        _txtName.y = -150;
        _circle.x = +_bgItem.width/2 -20;
        _circle.y = -_bgItem.height - 50;
        _source.addChild(_circle);

        _source.addChild(_txtName);
        _source.endClickCallback = onClick;
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
    }

    public function showIt(height:int,x:int,y:int, idResourceForRemoving:int, name:String):void {
       if (_isShowed) return;
        _id = idResourceForRemoving;
        _isShowed = true;
        _height = height;
        _quad = new Quad(bg.width, bg.height + _height *g.currentGameScale,Color.WHITE ,false);
        _quad.alpha = 0;
        _quad.x = -bg.width/2;
        _quad.y = -bg.height;
        _source.addChildAt(_quad,0);
        if (!g.dataResource.objectResources[idResourceForRemoving]) {
            Cc.error('WildHInt showIt:: no such g.dataResource.objectResources[idResourceForRemoving] for idResourceForRemoving: ' + idResourceForRemoving);
            g.woGameError.showIt();
            return;
        }
        _txtName.text = name;
        _txtCount.text = String(g.userInventory.getCountResourceById(idResourceForRemoving));
        _iconResource = new Image(g.allData.atlas['instrumentAtlas'].getTexture(g.dataResource.objectResources[idResourceForRemoving].imageShop));
        _txtCount.text = String(g.userInventory.getCountResourceById(idResourceForRemoving));
        _txtCount.x = +_bgItem.width/2 -28;
        _txtCount.y = -_bgItem.height - 56;
        _iconResource = new Image(g.allData.atlas['instrumentAtlas'].getTexture(g.dataResource.objectResources[idResourceForRemoving].imageShop));
        if (!_iconResource) {
            Cc.error('WildHint showIt:: no such image: ' + g.dataResource.objectResources[idResourceForRemoving].imageShop);
            g.woGameError.showIt();
            return;
        }
        MCScaler.scale(_iconResource, 60, 60);
        _iconResource.x = -_bgItem.width/2 +3;
        _iconResource.y = -_bgItem.height - 32;
        _source.addChild(_txtCount);
        _source.addChild(_iconResource);
        _source.x = x;
        _source.y = y;
        g.cont.hintGameCont.addChild(_source);
    }

    public function hideIt():void {
        if (_isOnHover) return;
        _isShowed = false;
        if (g.cont.hintGameCont.contains(_source))
            g.cont.hintGameCont.removeChild(_source);
        _source.removeChild(_iconResource);
        _source.removeChild(_quad);
        _iconResource = null;
        _height = 0;

    }

    private function onHover():void {
        _isOnHover = true;
    }

    private function onOut():void {
        _isOnHover = false;
        hideIt();
    }


    private function onClick():void {
        onOut();
        if (g.userInventory.getCountResourceById(_id) <= 0){
            g.woNoResources.showItMenu(g.dataResource.objectResources[_id],1,onClick);
        } else {
            g.userInventory.addResource(_id,-1);
//            var start:Point = new Point(int(_source.x), int(_source.y));
//            start = _source.parent.localToGlobal(start);
            new XPStar(_source.x,_source.y,8);
            if (_deleteCallback != null) {
                _deleteCallback.apply();
                _deleteCallback = null;
            }
        }
    }

    public function set onDelete(f:Function):void {
        _deleteCallback = f;
    }
}
}
