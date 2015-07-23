/**
 * Created by user on 7/20/15.
 */
package hint {
import build.WorldObject;
import build.WorldObject;

import manager.Vars;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

import utils.MCScaler;

public class TreeHint {
    private var _source:CSprite;
    private var _contDelete:CSprite;
    private var _isOnHover:Boolean;
    private var _isShowed:Boolean;
    private var _imageBg:Image;
    private var _imageCircle:Image;
    private var _imageItem:Image;
    private var _imageHelp:Image;
    private var _txtItem:TextField;
    private var _txtName:TextField;
    private var _worldObject:WorldObject;
    private var _data:Object;
    private var g:Vars = Vars.getInstance();

    public function TreeHint() {
        _source = new CSprite();
        _contDelete = new CSprite();
        _isShowed = false;
        _isOnHover = false;
        _imageBg = new Image(g.interfaceAtlas.getTexture("popup"));
        _imageHelp = new Image(g.interfaceAtlas.getTexture("help_icon"));
        _imageHelp.width = _imageHelp.height = 40;
        _imageHelp.x = 30;
        _imageHelp.y = 30;
        _imageCircle = new Image(g.interfaceAtlas.getTexture("hint_circle"));
        _imageCircle.x = 145;
        _imageCircle.y = 20;

        _txtItem = new TextField(50,50,"","Arial",14,Color.BLACK);
        _txtItem.x = 133;
        _txtItem.y = 8;
        _txtName = new TextField(50,50,"","Arial",14,Color.BLACK);

        _source.addChild(_imageBg);
        _source.addChild(_imageHelp);
        _source.addChild(_imageCircle);
        _source.addChild(_txtName);
        _source.addChild(_contDelete);
        _source.pivotX = _source.width/2;
        _source.pivotY = _source.height;
        var quad:Quad = new Quad(_source.width, _source.height,Color.WHITE ,false);
        quad.alpha = 0;
        _source.addChildAt(quad,0);

        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
        _contDelete.endClickCallback = onClick;
    }

    public function showIt(data:Object,x:int,y:int, name:String,worldobject:WorldObject):void {
        _worldObject = worldobject;
        _data = data;
        if (_isShowed) return;
        _isShowed = true;
        _source.x = x;
        _source.y = y;
        _imageItem = new Image(g.instrumentAtlas.getTexture(g.dataResource.objectResources[data.removeByResourceId].imageShop));
        MCScaler.scale(_imageItem,60,60);
        _imageItem.x = 95;
        _imageItem.y = 20;
        _txtItem.text = String(g.userInventory.getCountResourceById(data.removeByResourceId));
        _contDelete.addChild(_imageItem);
        _source.addChild(_txtItem);
        g.cont.hintCont.addChild(_source);
    }

    public function hideIt():void {
        if (_isOnHover) return;
        _isShowed = false;
        if (g.cont.hintCont.contains(_source)) {
            g.cont.hintCont.removeChild(_source);
        }
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
        g.userInventory.addResource(g.dataResource.objectResources[_data.removeByResourceId].id, -1);
        g.townArea.deleteBuild(_worldObject);
    }
}
}
