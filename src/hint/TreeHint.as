/**
 * Created by user on 7/20/15.
 */
package hint {
import build.WorldObject;
import build.WorldObject;

import com.greensock.TweenMax;

import com.greensock.easing.Linear;

import com.junkbyte.console.Cc;

import manager.ManagerFilters;

import manager.Vars;

import starling.core.Starling;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

import utils.MCScaler;

import windows.WOComponents.HintBackground;

public class TreeHint {
    private var _source:CSprite;
    private var _contDelete:CSprite;
    private var _contWatering:CSprite;
    private var _isOnHover:Boolean;
    private var _isShowed:Boolean;
    private var _txtText:TextField;
    private var _imageCircle:Image;
    private var _imageBgItem:Image;
    private var _imageBgItemHelp:Image;
    private var _imageItem:Image;
    private var _imageHelp:Image;
    private var _txtItem:TextField;
    private var _txtName:TextField;
    private var _worldObject:WorldObject;
    private var _data:Object;
    private var _deleteCallback:Function;
    private var _wateringCallback:Function;

    private var g:Vars = Vars.getInstance();

    public function TreeHint() {
        _source = new CSprite();
        _contDelete = new CSprite();
        _contWatering = new CSprite();
        _isShowed = false;
        _isOnHover = false;
        var bg:HintBackground = new HintBackground(176, 104, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
        _source.addChild(bg);

        _imageHelp = new Image(g.allData.atlas['interfaceAtlas'].getTexture("watering_can"));
        _imageHelp.width = _imageHelp.height = 40;
        _imageHelp.x = -60;
        _imageHelp.y = -90;
        _imageBgItem = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_blue_d'));
        _imageBgItem.y = -100;
        _imageBgItemHelp = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_blue_d'));
        _imageBgItemHelp.x = -75;
        _imageBgItemHelp.y = -100;
        _imageCircle = new Image(g.allData.atlas['interfaceAtlas'].getTexture("cursor_number_circle"));
        _imageCircle.x = 45;
        _imageCircle.y = -110;

        _txtItem = new TextField(50,50,"",g.allData.fonts['BloggerBold'],14,Color.WHITE);
        _txtItem.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtItem.x = 38;
        _txtItem.y = -118;
        _txtName = new TextField(200,50,"",g.allData.fonts['BloggerBold'],18,Color.WHITE);
        _txtName.nativeFilters = ManagerFilters.TEXT_STROKE_BLUE;
        _txtName.x = -100;
        _txtName.y = -150;
        _txtText = new TextField(50,30,'УСКОРИТЬ',g.allData.fonts['BloggerBold]'],16,ManagerFilters.TEXT_BLUE);

        _contWatering.addChild(_imageHelp);
        _source.addChild(_imageBgItem);
        _source.addChild(_imageBgItemHelp);
        _source.addChild(_contWatering);
        _source.addChild(_imageCircle);
        _source.addChild(_txtName);
        _source.addChild(_contDelete);
        _source.addChild(_txtText);
        var quad:Quad = new Quad(bg.width, bg.height+45,Color.WHITE ,false);
        quad.alpha = 0;
        quad.x = -bg.width/2;
        quad.y = -bg.height;
        _source.addChildAt(quad,0);

        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
        _contDelete.endClickCallback = onClickDelete;
        _contWatering.endClickCallback = onClickWatering;
    }

    public function showIt(data:Object, x:int, y:int, name:String, worldobject:WorldObject):void {
        if (!data || !worldobject) {
            Cc.error('TreeHint show it:: empty data or worldObject');
            g.woGameError.showIt();
            return;
        }
        if (!g.dataResource.objectResources[data.removeByResourceId]) {
            Cc.error('TreeHint show it:: g.dataResource.objectResources[data.removeByResourceId] = null');
            g.woGameError.showIt();
            return;
        }
//        var obj:Object;
//        var id:String;
//        obj = g.dataBuilding.objectBuilding;
//        for (id in obj) {
            if ( data.removeByResourceId == 124) {
                _txtName.text = "Засохшее дерево";
            } else {
                _txtName.text = "Засохший куст";
            }
//        }
        _worldObject = worldobject;
        _data = data;
        if (_isShowed) return;
        _isShowed = true;
        _source.x = x;
        _source.y = y;
        _imageItem = new Image(g.allData.atlas['instrumentAtlas'].getTexture(g.dataResource.objectResources[data.removeByResourceId].imageShop));
        if (!_imageItem) {
            Cc.error('TreeHint showIt:: no such image: ' + g.dataResource.objectResources[data.removeByResourceId].imageShop);
            g.woGameError.showIt();
            return;
        }
        MCScaler.scale(_imageItem,55,55);
        _imageItem.y = -95;
        _imageItem.x = 5;
        _txtItem.text = String(g.userInventory.getCountResourceById(data.removeByResourceId));
        _contDelete.addChild(_imageItem);
        _source.addChild(_txtItem);
        g.cont.hintCont.addChild(_source);

        if (_source.y < _source.height + 50 || _source.x < _source.width/2 + 50 || _source.x > Starling.current.nativeStage.stageWidth -_source.width/2 - 50) {
            var dY:int = 0;
            if (_source.y < _source.height + 50)
                dY = _source.height + 50 - _source.y;
            var dX:int = 0;
            if (_source.x < _source.width/2 + 50) {
                dX = _source.width/2 + 50 - _source.x;
            } else if (_source.x > Starling.current.nativeStage.stageWidth -_source.width/2 - 50) {
                dX = Starling.current.nativeStage.stageWidth -_source.width/2 - 50 - _source.x;
            }
            g.cont.deltaMoveGameCont(dX, dY, .5);
            new TweenMax(_source, .5, {x:_source.x + dX, y:_source.y + dY, ease:Linear.easeOut});
        }
    }

    public function hideIt():void {
        if (_isOnHover) return;
        _isShowed = false;
        if (g.cont.hintCont.contains(_source)) {
            g.cont.hintCont.removeChild(_source);
            _contDelete.removeChild(_imageItem);
        }
    }

    private function onHover():void {
        _isOnHover = true;
    }

    private function onOut():void {
        _isOnHover = false;
        hideIt();
    }

    private function onClickDelete():void {
        onOut();
        if (_deleteCallback != null) {
            _deleteCallback.apply();
            _deleteCallback = null;
        }
        _wateringCallback = null;
    }

    private function onClickWatering():void {
        onOut();
        if (_wateringCallback != null) {
            _wateringCallback.apply();
            _wateringCallback = null;
        }
        _deleteCallback = null;
    }

    public function set onDelete(f:Function):void {
        _deleteCallback = f;
    }

    public function set onWatering(f:Function):void {
        _wateringCallback = f;
    }
}
}
