/**
 * Created by user on 6/17/15.
 */
package windows.market {
import com.junkbyte.console.Cc;
import data.BuildType;
import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;
import utils.CSprite;
import utils.MCScaler;
import windows.WOComponents.CartonBackgroundIn;
import windows.WindowsManager;

public class MarketCell {
    public var source:CSprite;
    public var _cont:Sprite;
    private var _info:Object; // id & count
    private var _data:Object;
    private var _image:Image;
    private var _countTxt:TextField;
    private var g:Vars = Vars.getInstance();
    private var _clickCallback:Function;
    private var _carton:CartonBackgroundIn;

    public function MarketCell(info:Object) {
        _clickCallback = null;
        source = new CSprite();
        _cont = new Sprite();
        source.addChild(_cont);
        source.endClickCallback = onClick;
        _carton = new CartonBackgroundIn(100, 100);
        _cont.addChild(_carton);

        _info = info;
        if (!_info) {
            Cc.error('MarketCell:: _info == null');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'marketCell');
            return;
        }
        _data = g.dataResource.objectResources[_info.id];
        if (_data) {
            if (_data.buildType == BuildType.PLANT) {
                _image = new Image(g.allData.atlas['resourceAtlas'].getTexture(_data.imageShop + '_icon'));
            } else {
                _image = new Image(g.allData.atlas[_data.url].getTexture(_data.imageShop));
            }
            if (!_image) {
                Cc.error('MarketCell:: no such image: ' + _data.imageShop);
                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'marketCell');
                return;
            }
            MCScaler.scale(_image, 99, 99);
            _image.x = 50 - _image.width/2;
            _image.y = 50 - _image.height/2;
            _cont.addChild(_image);
        } else {
            Cc.error('MarketCell:: _data == null');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'marketCell');
            return;
        }

        _countTxt = new TextField(60,20,String(g.userInventory.getCountResourceById(_data.id)));
        _countTxt.format.setTo(g.allData.bFonts['BloggerBold18'],16, Color.WHITE);
        _countTxt.filter = ManagerFilters.TEXT_STROKE_BROWN;
        _countTxt.x = 50;
        _countTxt.y = 77;
        _cont.addChild(_countTxt);
        _cont.x += 2;
        _cont.y += 2;
    }

    public function set clickCallback(f:Function):void {
        _clickCallback = f;
    }

    private function onClick():void {
        if (_clickCallback != null) {
            _clickCallback.apply(null, [_info.id]);
        }
        if (g.userInventory.getCountResourceById(_data.id))
        if (_clickCallback != null) {
            _clickCallback.apply(null, [_info.id]);
        }
        activateIt(true);
    }

    public function activateIt(a:Boolean):void {
        if (a) _cont.filter = ManagerFilters.YELLOW_STROKE;
         else _cont.filter = null;
    }

    public function deleteIt():void {
        _cont.removeChild(_carton);
        _cont.filter = null;
        source.removeChild(_cont);
        _carton.deleteIt();
        _carton = null;
        _clickCallback = null;
        _info = null;
        _data = null;
        _image = null;
        _countTxt = null;
        source.dispose();
        source = null;
    }
}
}
