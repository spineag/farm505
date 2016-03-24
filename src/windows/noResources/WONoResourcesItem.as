/**
 * Created by user on 7/16/15.
 */
package windows.noResources {
import com.junkbyte.console.Cc;

import data.BuildType;

import manager.ManagerFilters;

import manager.Vars;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

import utils.MCScaler;

import windows.WOComponents.CartonBackground;
import windows.WOComponents.CartonBackgroundIn;
import windows.WindowsManager;

public class WONoResourcesItem {
    public var source:CSprite;
    private var _image:Image;
    private var _txtCount:TextField;
    private var _inHover:Boolean;
    private var _dataId:int;

    private var g:Vars = Vars.getInstance();

    public function WONoResourcesItem() {
        source = new CSprite();
        var bg:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("production_window_k"));
        MCScaler.scale(bg,66, 70);
        source.addChild(bg);
        source.hoverCallback = onHover;
        source.outCallback = onOut;
        _inHover = false;
    }

    public function fillWithResource(id:int, count:int):void {
        var ob:Object = g.dataResource.objectResources[id];
        _dataId = id;
        if (!ob) {
            Cc.error('WONoResourcesItem:: g.dataResource.objectResources[id] = null  for id = ' + id);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woNoResourceItem');
            return;
        }
        var st:String;
        if (ob.buildType == BuildType.FARM || ob.buildType == BuildType.TEST){
            st = ob.image;
            _image = new Image(g.allData.atlas[ob.url].getTexture(st));
        } else if (ob.buildType == BuildType.FABRICA || ob.buildType == BuildType.RIDGE) {
            st = ob.image;
            _image = new Image(g.allData.atlas[ob.url].getTexture(st));
        } else if (ob.buildType == BuildType.TREE) {
            st = ob.imageGrowBig;
            _image = new Image(g.allData.atlas[ob.url].getTexture(st));
        } else if (ob.buildType == BuildType.PLANT) {
            st = ob.imageShop + '_icon';
            _image = new Image(g.allData.atlas['resourceAtlas'].getTexture(st));
        } else if (ob.buildType == BuildType.RESOURCE) {
            st = ob.imageShop;
            _image = new Image(g.allData.atlas[ob.url].getTexture(st));
        } else if (ob.buildType == BuildType.DECOR_FULL_FENСE || ob.buildType == BuildType.DECOR_POST_FENCE
                || ob.buildType == BuildType.DECOR_TAIL || ob.buildType == BuildType.DECOR) {
            st = ob.imageShop;
            _image = new Image(g.allData.atlas[ob.url].getTexture(st));
        } else if (ob.buildType == BuildType.ANIMAL){
            st = ob.imageShop;
            _image = new Image(g.allData.atlas[ob.url].getTexture(st));
        } else if (ob.buildType == BuildType.INSTRUMENT) {
            st = ob.imageShop;
            _image = new Image(g.allData.atlas[ob.url].getTexture(st));
        } else if (ob.buildType == BuildType.MARKET || ob.buildType == BuildType.ORDER || ob.buildType == BuildType.DAILY_BONUS
                || ob.buildType == BuildType.CAVE || ob.buildType == BuildType.PAPER || ob.buildType == BuildType.TRAIN) {
            st = ob.image;
            _image = new Image(g.allData.atlas[ob.url].getTexture(st));
        }

        if (!_image) {
            Cc.error('WONoResourcesItem:: no such image ' + st);
        } else {
            MCScaler.scale(_image, 50, 50);
            _image.x = 33 - _image.width / 2;
            _image.y = 33 - _image.height / 2;
            source.addChild(_image);
        }

        _txtCount = new TextField(66, 20, String(count), g.allData.fonts['BloggerMedium'], 16, Color.WHITE);
        _txtCount.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtCount.y = 40;
        _txtCount.x = 20;
        source.addChild(_txtCount);
//        var quad:Quad = new Quad(source.width,source.height,Color.GREEN,false);
//        quad.y = 100;
//        source.addChild(quad);
    }

    public function fillWithMoney(count:int):void {
        _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
        MCScaler.scale(_image, 50, 50);
        _image.x = 33 - _image.width / 2;
        _image.y = 33 - _image.height / 2;
        source.addChild(_image);

        _txtCount = new TextField(66, 20, String(count), g.allData.fonts['BloggerMedium'], 12, Color.WHITE);
        _txtCount.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtCount.y = 50;
        source.addChild(_txtCount);
    }

    public function deleteIt():void {
        while (source.numChildren) {
            source.removeChildAt(0);
        }
    }

    private function onHover():void {
        if (_inHover) return;
        _inHover = true;
        g.marketHint.showIt(_dataId,source.x,source.y,source);

    }

    private function onOut():void {
        _inHover = false;
        g.marketHint.hideIt();
    }
}
}
