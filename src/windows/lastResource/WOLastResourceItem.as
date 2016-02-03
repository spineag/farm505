/**
 * Created by user on 2/3/16.
 */
package windows.lastResource {
import com.junkbyte.console.Cc;

import data.BuildType;

import manager.ManagerFilters;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.MCScaler;

public class WOLastResourceItem {
    public var source:Sprite;
    private var _image:Image;
    private var _txtCount:TextField;
    private var g:Vars = Vars.getInstance();

    public function WOLastResourceItem() {
        source = new Sprite();
        var bg:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("production_window_k"));
        MCScaler.scale(bg,66, 70);
        source.addChild(bg);
    }
        public function fillWithResource(id:int):void {
        var ob:Object = g.dataResource.objectResources[id];
        if (!ob) {
            Cc.error('WONoResourcesItem:: g.dataResource.objectResources[id] = null  for id = ' + id);
            g.woGameError.showIt();
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
                || ob.buildType == BuildType.DECOR_TAIL || ob.buildType == BuildType.PET_HOUSE || ob.buildType == BuildType.DECOR) {
            st = ob.imageShop;
            _image = new Image(g.allData.atlas[ob.url].getTexture(st));
        } else if (ob.buildType == BuildType.ANIMAL){
            st = ob.imageShop;
            _image = new Image(g.allData.atlas[ob.url].getTexture(st));
        } else if (ob.buildType == BuildType.INSTRUMENT) {
            st = ob.imageShop;
            _image = new Image(g.allData.atlas[ob.url].getTexture(st));
        } else if (ob.buildType == BuildType.PET) {

        } else if (ob.buildType == BuildType.MARKET || ob.buildType == BuildType.ORDER || ob.buildType == BuildType.DAILY_BONUS
                || ob.buildType == BuildType.SHOP || ob.buildType == BuildType.CAVE || ob.buildType == BuildType.PAPER || ob.buildType == BuildType.TRAIN) {
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

        _txtCount = new TextField(50,50,String(g.userInventory.getCountResourceById(id)),g.allData.fonts['BloggerBold'],18, Color.WHITE);
        _txtCount.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtCount.x = 25;
        _txtCount.y = 30;
        source.addChild(_txtCount);
    }

    public function deleteIt():void {
        while (source.numChildren) {
            source.removeChildAt(0);
        }
    }
}
}
