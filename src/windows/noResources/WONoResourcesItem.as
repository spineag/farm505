/**
 * Created by user on 7/16/15.
 */
package windows.noResources {
import com.junkbyte.console.Cc;

import data.BuildType;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.MCScaler;

public class WONoResourcesItem {
    public var source:Sprite;
    private var _image:Image;
    private var _txtCount:TextField;

    private var g:Vars = Vars.getInstance();

    public function WONoResourcesItem(id:int, count:int) {
        source = new Sprite();
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
        } else if (ob.buildType == BuildType.PLANT || ob.buildType == BuildType.RESOURCE) {
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
        _txtCount = new TextField(50,50,String(count),"Arial",12,Color.WHITE);
        if (!_image) {
            Cc.error('WONoResourcesItem:: no such image ' + st);
        }
        MCScaler.scale(_image,50,50);
        _txtCount.y = 25;
        _image.x = 50 - _image.width/2;
        _image.y = 50 - _image.height/2;
        if(_image) source.addChild(_image);
        source.addChild(_txtCount);
    }
}
}
