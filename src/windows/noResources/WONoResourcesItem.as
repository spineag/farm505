/**
 * Created by user on 7/16/15.
 */
package windows.noResources {
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

    public function WONoResourcesItem(ob:int, count:int) {
        source = new Sprite();
        if (g.dataResource.objectResources[ob].buildType == BuildType.FARM){
            _image = new Image(g.tempBuildAtlas.getTexture(g.dataResource.objectResources[ob].imageShop));
        }else if (g.dataResource.objectResources[ob].buildType == BuildType.FABRICA || g.dataResource.objectResources[ob].buildType == BuildType.RIDGE ||g.dataResource.objectResources[ob].buildType == BuildType.DECOR) {
            _image = new Image(g.tempBuildAtlas.getTexture(g.dataResource.objectResources[ob].imageShop));
        }else if (g.dataResource.objectResources[ob].buildType == BuildType.TREE) {
            _image = new Image(g.treeAtlas.getTexture(g.dataResource.objectResources[ob].imageGrowBig));
        }else if (g.dataResource.objectResources[ob].buildType == BuildType.PLANT || g.dataResource.objectResources[ob].buildType == BuildType.RESOURCE) {
            if(g.dataResource.objectResources[ob].url == "plantAtlas")
            {
                _image = new Image(g.plantAtlas.getTexture(g.dataResource.objectResources[ob].imageShop));
            }else {
                _image = new Image(g.resourceAtlas.getTexture(g.dataResource.objectResources[ob].imageShop));
            }
        }else if (g.dataResource.objectResources[ob].buildType == BuildType.DECOR_FULL_FENСE || g.dataResource.objectResources[ob].buildType == BuildType.DECOR_POST_FENCE
                || g.dataResource.objectResources[ob].buildType == BuildType.DECOR_TAIL || g.dataResource.objectResources[ob].buildType == BuildType.PET_HOUSE) {
            _image = new Image(g.tempBuildAtlas.getTexture(g.dataResource.objectResources[ob].imageShop));
        }else if (g.dataResource.objectResources[ob].buildType == BuildType.ANIMAL) {
            _image = new Image(g.tempBuildAtlas.getTexture(g.dataResource.objectResources[ob].imageShop));
        }
        _txtCount = new TextField(50,50,String(count),"Arial",12,Color.WHITE);
        MCScaler.scale(_image,50,50);
        _txtCount.y = 25;
        _image.x = 50 - _image.width/2;
        _image.y = 50 - _image.height/2;
        if(_image) source.addChild(_image);
        source.addChild(_txtCount);
    }
}
}
