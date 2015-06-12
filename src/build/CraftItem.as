/**
 * Created by user on 6/12/15.
 */
package build {
import manager.ResourceItem;
import manager.Vars;

import starling.display.Image;

import starling.display.Sprite;

import utils.CSprite;
import utils.MCScaler;

public class CraftItem {
    private var _source:CSprite;
    private var _resourceItem:ResourceItem;
    private var _image:Image;

    private var g:Vars = Vars.getInstance();

    public function CraftItem(_x:int, _y:int, resourceItem:ResourceItem, parent:Sprite) {
        _source = new CSprite();
        _resourceItem = resourceItem;
        if (_resourceItem.url == 'resourceAtlas') {
            _image = new Image(g.resourceAtlas.getTexture(_resourceItem.imageShop));
        } else if (_resourceItem.url == 'plantsAtlas') {
            _image = new Image(g.plantAtlas.getTexture(_resourceItem.imageShop));
        }

        MCScaler.scale(_image, 50, 50);
        _source.addChild(_image);
        _source.pivotX = _source.width/2;
        _source.pivotY = _source.height/2;
        _source.x = _x + Math.random()*30 - 15;
        _source.y = _y + Math.random()*30 - 15;
        parent.addChild(_source);
    }
}
}
