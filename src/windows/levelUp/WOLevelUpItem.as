/**
 * Created by user on 7/8/15.
 */
package windows.levelUp {
import com.junkbyte.console.Cc;

import data.BuildType;

import manager.ManagerFilters;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.MCScaler;

public class WOLevelUpItem {
    public var source:Sprite;
//    private var _txtNew:TextField;
//    private var _txtCount:TextField;
    private var _image:Image;
    private var _imageBg:Image;
    private var g:Vars = Vars.getInstance();

    public function WOLevelUpItem(ob:Object, st:String) {
        if (!ob) {
            Cc.error('WOLevelUpItem:: ob == null');
            g.woGameError.showIt();
            return;
        }
//        _txtNew = new TextField(80,20,'НОВОЕ!',g.allData.fonts['BloggerBold'],16,Color.WHITE);
//        _txtNew.nativeFilters = ManagerFilters.TEXT_STROKE_RED;
//        _txtCount = new TextField(80,20,st,g.allData.fonts['BloggerBold'],16,Color.WHITE);
//        _txtCount.nativeFilters = ManagerFilters.TEXT_STROKE_RED;

        source = new Sprite();
        try {
            var st:String;
            if (ob.buildType == BuildType.FARM) {
                st = ob.image;
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture(st + '_icon'));
            } else if (ob.buildType == BuildType.RIDGE) {
                st = ob.image;
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture(st + '_icon'));
            } else if (ob.buildType == BuildType.FABRICA) {
                st = ob.image;
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture(st + '_icon'));
            } else if (ob.buildType == BuildType.TREE) {
                st = ob.image;
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture(st + '_icon'));
            } else if (ob.buildType == BuildType.RESOURCE) {
                st = ob.imageShop;
                _image = new Image(g.allData.atlas[ob.url].getTexture(st));
            } else if (ob.buildType == BuildType.PLANT) {
                st = ob.imageShop;
                _image = new Image(g.allData.atlas['resourceAtlas'].getTexture(st + '_icon'));
            } else if (ob.buildType == BuildType.DECOR_FULL_FENСE || ob.buildType == BuildType.DECOR_POST_FENCE
                    || ob.buildType == BuildType.DECOR_TAIL || ob.buildType == BuildType.DECOR) {
                st = ob.image;
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture(st + '_icon'));
                if (!_image) {
                    _image = new Image(g.allData.atlas[ob.url].getTexture(st));
                }
            } else if (ob.buildType == BuildType.ANIMAL) {
                st = ob.image;
                _image = new Image(g.allData.atlas['iconAtlas'].getTexture(st + '_icon'));
            } else if (ob.buildType == BuildType.INSTRUMENT) {
                st = ob.imageShop;
                _image = new Image(g.allData.atlas[ob.url].getTexture(st));
            } else if (ob.buildType == BuildType.MARKET || ob.buildType == BuildType.ORDER || ob.buildType == BuildType.DAILY_BONUS
                    || ob.buildType == BuildType.SHOP || ob.buildType == BuildType.CAVE || ob.buildType == BuildType.PAPER || ob.buildType == BuildType.TRAIN) {
                st = ob.image;
                 _image = new Image(g.allData.atlas['iconAtlas'].getTexture(st + '_icon'));
            }
        } catch (e:Error) {
            Cc.error('WOLevelUpItem:: error with _image for data.id: ' + ob.id);
        }

        _imageBg = new Image(g.allData.atlas['interfaceAtlas'].getTexture("production_window_blue_d"));
        MCScaler.scale(_imageBg, 77, 77);
        _imageBg.x = 50 - _imageBg.width/2;
        _imageBg.y = 50 - _imageBg.height/2;
        source.addChild(_imageBg);
        if (_image) {
            MCScaler.scale(_image, 68, 68);
            _image.x = 50 - _image.width / 2;
            _image.y = 50 - _image.height / 2;
            source.addChild(_image);
        } else {
            Cc.error('WOLevelUpItem:: no such image: ' + st);
        }
    }

    public function clearIt():void {
        while (source.numChildren) source.removeChildAt(0);
        if (_image) _image.dispose();
        _imageBg.dispose();
        _image = null;
        _imageBg = null;
        source = null;
    }
}
}
