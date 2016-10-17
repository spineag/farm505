/**
 * Created by user on 10/17/16.
 */
package windows.shop.decorRadioButton {
import com.junkbyte.console.Cc;
import manager.Vars;
import starling.display.Image;
import utils.CSprite;

public class DecorRadioButtonItem {
    private var _source:CSprite;
    private var _data:Object;
    private var g:Vars = Vars.getInstance();
    private var _hoverImage:Image;
    private var _image:Image;
    private var _checkImage:Image;
    private var _callback:Function;

    public function DecorRadioButtonItem(ob:Object, f:Function) {
        _data = ob;
        _callback = f;
        _source = new CSprite();
        _hoverImage = new Image(g.allData.atlas['interfaceAtlas'].getTexture('select_light'));
        _hoverImage.x = -_hoverImage.width/2;
        _hoverImage.y = -_hoverImage.height/2;
        _source.addChild(_hoverImage);
        _hoverImage.visible = false;
        switch (_data.color) {
            case 'yellow': _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('select_yellow')); break;
            case 'blue': _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('select_lblue')); break;
            case 'green': _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('select_lgreen')); break;
            case 'orange': _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('select_orange')); break;
            case 'pink': _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('select_pink')); break;
            case 'red': _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('select_red')); break;
            default: Cc.error('DecorRadioButtonItem:: unknown color: ' + _data.color);
        }
        _image.x = -_image.width/2;
        _image.y = -_image.height/2;
        _source.addChild(_image);
        _checkImage = new Image(g.allData.atlas['interfaceAtlas'].getTexture('select_color'));
        _checkImage.visible = false;
        _checkImage.x = 1;
        _checkImage.y = -3;
        _source.addChild(_checkImage);

        _source.hoverCallback = function():void { _hoverImage.visible = true };
        _source.outCallback = function():void { _hoverImage.visible = false };
        _source.endClickCallback = onClick;
    }

    public function get source():CSprite {
        return _source;
    }

    private function onClick():void {
        if (_callback!=null) {
            _callback.apply(null, [_data, this]);
        }
        activateIt();
    }

    public function activateIt(v:Boolean=true):void {
        _checkImage.visible = v;
        _source.isTouchable = !v;
    }

    public function deleteIt():void {
       _source.deleteIt();
        _data = null;
        _callback = null;
    }
}
}
