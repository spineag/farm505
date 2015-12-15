/**
 * Created by user on 7/13/15.
 */
package hint.fabricHint {
import com.junkbyte.console.Cc;

import data.BuildType;

import manager.ManagerFilters;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;
import starling.utils.HAlign;

import utils.MCScaler;

public class FabricHintItem {
    public var source:Sprite;
    private var _image:Image;
    private var _imageBg:Image;

    private var g:Vars = Vars.getInstance();

    public function FabricHintItem(obId:int, needCount:int) {
        source = new Sprite();
        var txt:TextField = new TextField(50,50,'',g.allData.fonts['BloggerBold'],14,Color.WHITE);
        txt.hAlign = HAlign.LEFT;
        txt.y = 55;
        txt.x = 45;
        txt.nativeFilters = ManagerFilters.TEXT_STROKE_LIGHT_BLUE;
        txt.text = String("/" + String(needCount));
        source.addChild(txt);
        var userCount:int = g.userInventory.getCountResourceById(g.dataResource.objectResources[obId].id);
        if (userCount >= needCount) {
            txt = new TextField(50,50,'',g.allData.fonts['BloggerBold'],14,Color.WHITE);
            txt.nativeFilters = ManagerFilters.TEXT_STROKE_LIGHT_BLUE;
        } else {
            txt = new TextField(50,51,'',g.allData.fonts['BloggerBold'],15,ManagerFilters.TEXT_ORANGE);
        }
        txt.hAlign = HAlign.RIGHT;
        txt.y = 55;
        txt.x = -1;
        txt.text = String(userCount);
        source.addChild(txt);


        if (!g.dataResource.objectResources[obId]) {
            Cc.error('FabricHintItem error: g.dataResource.objectResources[obId] = null');
            g.woGameError.showIt();
            return;
        }
        if (g.dataResource.objectResources[obId].buildType == BuildType.PLANT || g.dataResource.objectResources[obId].buildType == BuildType.RESOURCE) {
            _image = new Image(g.allData.atlas[g.dataResource.objectResources[obId].url].getTexture(g.dataResource.objectResources[obId].imageShop));
        }
        _imageBg = new Image(g.allData.atlas['interfaceAtlas'].getTexture("production_window_blue_d"));
        _imageBg.width = _imageBg.height = 44;
        _imageBg.x = 50 - _imageBg.width/2;
        _imageBg.y = 50 - _imageBg.height/2;
        source.addChild(_imageBg);
        if (_image) {
            source.addChild(_image);
            MCScaler.scale(_image, 36, 36);
            _image.x = 50 - _image.width / 2;
            _image.y = 50 - _image.height / 2;
        } else {
            Cc.error('no such image: ' + g.dataResource.objectResources[obId].imageShop + ' for id: ' +  obId);
            g.woGameError.showIt();
        }
    }
}
}
