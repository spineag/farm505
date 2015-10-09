/**
 * Created by user on 10/9/15.
 */
package ui.toolsPanel {
import flash.geom.Rectangle;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;

import utils.CSprite;

public class RepositoryBox {
    public var source:Sprite;
    private var _contRect:Sprite;
    private var _cont:Sprite;
    private var _leftBtn:CSprite;
    private var _rightBtn:CSprite;
    private var _arrItems:Array;

    private var g:Vars = Vars.getInstance();

    public function RepositoryBox() {
        _arrItems = [];
        source = new Sprite();
        var im:Image = new Image(g.interfaceAtlas.getTexture("friends_plawka"));
        im.height = 100;
        im.width = 330;
        source.addChild(im);
        _contRect = new Sprite();
        _contRect.clipRect = new Rectangle(0, 0, 270, 90);
        _contRect.y = 5;
        _contRect.x = 20;
        source.addChild(_contRect);
        _cont = new Sprite();
        _contRect.addChild(_cont);

        _leftBtn = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture('shop_arrow'));
        im.scaleX = im.scaleY = .5;
        im.x = im.width;
        im.y = im.height;
        im.rotation = Math.PI;
        _leftBtn.addChild(im);
        _rightBtn = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture('shop_arrow'));
        im.scaleX = im.scaleY = .5;
        _rightBtn.addChild(im);

        _leftBtn.y = 90/2 - _leftBtn.height/2;
        _leftBtn.x = 2;
        _rightBtn.y = 90/2 - _rightBtn.height/2;
        _rightBtn.x = 20 + 270 + 2;
        source.addChild(_leftBtn);
        source.addChild(_rightBtn);
    }

    public function set visible(value:Boolean):void {
        source.visible = value;
        deleteItems();
        if (value) {
            showItems();
        }
    }

    private function showItems():void {
        var item:RepoItem;
        var i:int = 0;
        var ob:Object = g.userInventory.decorInventory;
        for(var id:String in ob) {
            item = new RepoItem();
            item.fillIt(g.dataBuilding.objectBuilding[id], ob[id].count, this);
            item.source.x = i*90;
            _cont.addChild(item.source);
            _arrItems.push(item);
            i++;
        }
        if (i < 3) {
            for (i; i<3; i++) {
                item = new RepoItem();
                item.source.x = i*90;
                _cont.addChild(item.source);
                _arrItems.push(item);
            }
        }
    }

    private function deleteItems():void {
        for (var i:int=0; i<_arrItems.length; i++) {
            _arrItems[i].clearIt();
        }
        while (_cont.numChildren) _cont.removeChildAt(0);
        _arrItems.length = 0;
    }
}
}
