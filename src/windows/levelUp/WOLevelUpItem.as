/**
 * Created by user on 7/8/15.
 */
package windows.levelUp {
import com.junkbyte.console.Cc;

import data.BuildType;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.MCScaler;

public class WOLevelUpItem {
    public var source:Sprite;
    private var _txt:TextField;
    private var _image:Image;
    private var _imageBg:Image;
    private var g:Vars = Vars.getInstance();

    public function WOLevelUpItem(ob:Object, st:String) {
        if (!ob) {
            Cc.error('WOLvelUpItem:: ob == null');
            g.woGameError.showIt();
            return;
        }

        source = new Sprite();
        var st:String;
        _txt = new TextField(source.width, source.height, st, "Arial", 20, Color.BLACK);
        if (ob.buildType == BuildType.FARM || ob.buildType == BuildType.TEST){
            st = ob.image;
            _image = new Image(g.tempBuildAtlas.getTexture(st));
        } else if (ob.buildType == BuildType.FABRICA || ob.buildType == BuildType.RIDGE) {
            st = ob.image;
            _image = new Image(g.tempBuildAtlas.getTexture(st));
        } else if (ob.buildType == BuildType.TREE) {
            st = ob.imageGrowBig;
            _image = new Image(g.treeAtlas.getTexture(st));
        } else if (ob.buildType == BuildType.PLANT || ob.buildType == BuildType.RESOURCE) {
            st = ob.imageShop;
            if(ob.url == "plantAtlas") {
                _image = new Image(g.plantAtlas.getTexture(st));
            }else {
                _image = new Image(g.resourceAtlas.getTexture(st));
            }
        } else if (ob.buildType == BuildType.DECOR_FULL_FENСE || ob.buildType == BuildType.DECOR_POST_FENCE
                || ob.buildType == BuildType.DECOR_TAIL || ob.buildType == BuildType.PET_HOUSE || ob.buildType == BuildType.DECOR) {
            st = ob.image;
            _image = new Image(g.tempBuildAtlas.getTexture(st));
        } else if (ob.buildType == BuildType.ANIMAL){
            st = ob.imageShop;
            _image = new Image(g.tempBuildAtlas.getTexture(st));
        } else if (ob.buildType == BuildType.INSTRUMENT) {
            st = ob.imageShop;
            _image = new Image(g.instrumentAtlas.getTexture(st));
        } else if (ob.buildType == BuildType.PET) {

        } else if (ob.buildType == BuildType.MARKET || ob.buildType == BuildType.ORDER || ob.buildType == BuildType.DAILY_BONUS
                || ob.buildType == BuildType.SHOP || ob.buildType == BuildType.CAVE || ob.buildType == BuildType.PAPER || ob.buildType == BuildType.TRAIN) {
            st = ob.image;
            _image = new Image(g.tempBuildAtlas.getTexture(st));
        }

        _imageBg = new Image(g.interfaceAtlas.getTexture("hint_circle"));
        _imageBg.width = _imageBg.height = 95;
        _imageBg.x = 50 - _imageBg.width/2;
        _imageBg.y = 50 - _imageBg.height/2;
        source.addChild(_imageBg);
        if (_image) {
            MCScaler.scale(_image, 80, 80);
            _image.x = 50 - _image.width / 2;
            _image.y = 50 - _image.height / 2;
            source.addChild(_image);
        } else {
            Cc.error('WOLevelUpItem:: no such image: ' + st);
        }
        source.addChild(_txt);
    }
}
}
