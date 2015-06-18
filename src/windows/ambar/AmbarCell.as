/**
 * Created by user on 6/17/15.
 */
package windows.ambar {

import manager.Vars;

import starling.display.Image;
import starling.display.Quad;

import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.MCScaler;

public class AmbarCell {
    public var source:Sprite;
    private var _info:Object; // id & count
    private var _data:Object;
    private var _image:Image;
    private var _countTxt:TextField;
    private var g:Vars = Vars.getInstance();

    public function AmbarCell(info:Object) {
        source = new Sprite();
        source.touchable = false;
        var quad:Quad = new Quad(99, 99, Color.BLACK);
        quad.alpha = .1 + Math.random()*.3;
        source.addChild(quad);

        _info = info;
        _data = g.dataResource.objectResources[_info.id];
        if (_data) {
            if (_data.url == 'resourceAtlas') {
                _image = new Image(g.resourceAtlas.getTexture(_data.imageShop));
            } else if (_data.url == 'plantAtlas') {
                _image = new Image(g.plantAtlas.getTexture(_data.imageShop));
            } else if (_data.url == 'instrumentAtlas') {
                _image = new Image(g.instrumentAtlas.getTexture(_data.imageShop));
            }
            MCScaler.scale(_image, 99, 99);
            _image.x = 50 - _image.width/2;
            _image.y = 50 - _image.height/2;
            source.addChild(_image);
        }

        _countTxt = new TextField(30,20,String(_info.count),"Arial",16,Color.BLACK);
        _countTxt.x = 75;
        _countTxt.y = 77;
        source.addChild(_countTxt);
    }

    public function clearIt():void {
        while (source.numChildren) {
            source.removeChildAt(0);
        }
        source = null;
        _image = null;
        _countTxt = null;
    }
}
}
