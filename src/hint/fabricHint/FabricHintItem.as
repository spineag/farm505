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
import starling.utils.Align;
import starling.utils.Color;

import utils.CTextField;
import utils.MCScaler;
import windows.WindowsManager;

public class FabricHintItem {
    public var source:Sprite;
    private var _image:Image;
    private var _imageBg:Image;
    private var _txtOrange:CTextField;
    private var _txtWhite:CTextField;
    private var _needCount:int;
    private var _id:int;
    private var g:Vars = Vars.getInstance();

    public function FabricHintItem(obId:int, needCount:int) {
        source = new Sprite();
        _needCount = needCount;
        _id = obId;
        _txtWhite = new CTextField(50,50,String("/" + String(_needCount)));
        _txtWhite.setFormat(CTextField.BOLD14, 14, Color.WHITE, ManagerFilters.LIGHT_BLUE_COLOR);
        _txtWhite.alignH = Align.LEFT;
        _txtOrange = new CTextField(50,50,'');
        _txtOrange.setFormat(CTextField.BOLD14, 16, ManagerFilters.ORANGE_COLOR);
        _txtOrange.alignH = Align.LEFT;
//        _txtOrange.y = 55;
//        _txtOrange.x = 34;
        source.addChild(_txtWhite);
        source.addChild(_txtOrange);
        var userCount:int = g.userInventory.getCountResourceById(g.dataResource.objectResources[obId].id);
        _txtOrange.text = String(userCount);
        if (userCount >= needCount) {
            _txtOrange.changeTextColor = ManagerFilters.GREEN_COLOR;
        } else {
            _txtOrange.changeTextColor = ManagerFilters.ORANGE_COLOR;
        }
        _txtOrange.x = 34;
        _txtOrange.y = 55;
        _txtWhite.x = _txtOrange.x + _txtOrange.textBounds.width - 2;
        _txtWhite.y = 55;
        if (!g.dataResource.objectResources[obId]) {
            Cc.error('FabricHintItem error: g.dataResource.objectResources[obId] = null');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'fabricHintItem');
            return;
        }
        if (g.dataResource.objectResources[obId].buildType == BuildType.PLANT) {
            _image = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.dataResource.objectResources[obId].imageShop + '_icon'));
        } else if (g.dataResource.objectResources[obId].buildType == BuildType.RESOURCE) {
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
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'fabricHintItem');
        }
    }

    public function updateCount():void {
        var userCount:int = g.userInventory.getCountResourceById(g.dataResource.objectResources[_id].id);
        userCount -= _needCount;
        if (userCount >= _needCount) {
            _txtOrange.changeTextColor = ManagerFilters.GREEN_COLOR;
        } else {
            _txtOrange.changeTextColor = ManagerFilters.ORANGE_COLOR;
        }
    }

    public function updateTextField():void {
        _txtOrange.updateIt();
        _txtWhite.updateIt();
    }
}
}
