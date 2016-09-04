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

import utils.CTextField;

import utils.MCScaler;

import windows.WindowsManager;

public class WOLastResourceItem {
    public var source:Sprite;
    private var _image:Image;
    private var _txtCount:CTextField;
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
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woLastResourceItem');
            return;
        }
        var st:String;
        if (ob.buildType == BuildType.FARM){
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

        _txtCount = new CTextField(50,50,String(g.userInventory.getCountResourceById(id)));
        _txtCount.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.TEXT_BROWN_COLOR);
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
