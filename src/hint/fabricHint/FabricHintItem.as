/**
 * Created by user on 7/13/15.
 */
package hint.fabricHint {
import com.junkbyte.console.Cc;

import data.BuildType;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.MCScaler;

public class FabricHintItem {
    public var source:Sprite;
    private var _image:Image;
    private var _imageBg:Image;
    private var _txtItem:TextField;

    private var g:Vars = Vars.getInstance();

    public function FabricHintItem(obId:int, obCount:int) {
        _txtItem = new TextField(100,100,"","Arial",10,Color.BLACK);
        _txtItem.text = String(g.userInventory.getCountResourceById(g.dataResource.objectResources[obId].id) + "/" + obCount);
        source = new Sprite();
        if (!g.dataResource.objectResources[obId]) {
            Cc.error('FabricHintItem error: g.dataResource.objectResources[obId] = null');
            g.woGameError.showIt();
            return;
        }
        if (g.dataResource.objectResources[obId].buildType == BuildType.PLANT || g.dataResource.objectResources[obId].buildType == BuildType.RESOURCE) {
            _image = new Image(g.allData.atlas[g.dataResource.objectResources[obId].url].getTexture(g.dataResource.objectResources[obId].imageShop));
        }
        _imageBg = new Image(g.allData.atlas['interfaceAtlas'].getTexture("tempItemBG"));
        _imageBg.width = _imageBg.height = 40;
        _imageBg.x = 50 - _imageBg.width/2;
        _imageBg.y = 50 - _imageBg.height/2;
        source.addChild(_imageBg);
        if (_image) {
            source.addChild(_image);
            MCScaler.scale(_image, 30, 30);
            _image.x = 50 - _image.width / 2;
            _image.y = 50 - _image.height / 2;
        } else {
            Cc.error('no such image: ' + g.dataResource.objectResources[obId].imageShop + ' for id: ' +  obId);
            g.woGameError.showIt();
        }
        _txtItem.y = 25;
        source.addChild(_txtItem);
    }
}
}
