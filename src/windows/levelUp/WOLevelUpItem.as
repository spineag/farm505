/**
 * Created by user on 7/8/15.
 */
package windows.levelUp {
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
        source = new Sprite();
        _txt = new TextField(source.width, source.height, st, "Arial", 20, Color.BLACK);
        if (ob.buildType == BuildType.FARM){
            _image = new Image(g.tempBuildAtlas.getTexture(ob.image));
        }else if (ob.buildType == BuildType.FABRICA || ob.buildType == BuildType.RIDGE || ob.buildType == BuildType.DECOR) {
            _image = new Image(g.tempBuildAtlas.getTexture(ob.image));
        }else if (ob.buildType == BuildType.TREE) {
            _image = new Image(g.treeAtlas.getTexture(ob.imageGrowBig));
        }else if (ob.buildType == BuildType.PLANT || ob.buildType == BuildType.RESOURCE) {
            if(ob.url == "plantAtlas")
            {
                _image = new Image(g.plantAtlas.getTexture(ob.imageShop));
            }else {
                _image = new Image(g.resourceAtlas.getTexture(ob.imageShop));
            }
        }else if (ob.buildType == BuildType.DECOR_FULL_FENСE || ob.buildType == BuildType.DECOR_POST_FENCE
                || ob.buildType == BuildType.DECOR_TAIL || ob.buildType == BuildType.PET_HOUSE) {
            _image = new Image(g.tempBuildAtlas.getTexture(ob.imageShop));
        }else if (ob.buildType == BuildType.ANIMAL){
            _image = new Image(g.tempBuildAtlas.getTexture(ob.imageShop));
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
        }
        source.addChild(_txt);
    }
}
}
