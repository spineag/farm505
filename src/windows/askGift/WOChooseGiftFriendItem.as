/**
 * Created by andy on 8/7/17.
 */
package windows.askGift {
import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.utils.Align;
import starling.utils.Color;
import user.Someone;
import utils.CSprite;
import utils.CTextField;

public class WOChooseGiftFriendItem {
    private var g:Vars = Vars.getInstance();
    public var source:CSprite;
    private var _galo4ka:Image;
    private var _callback:Function;
    private var _isCheck:Boolean;
    private var _txtName:CTextField;
    private var _friend:Someone;
    private var _wo:WOChooseGiftFriend;
    private var _imBox:Image;

    public function WOChooseGiftFriendItem(p:Someone, f:Function, wo:WOChooseGiftFriend) {
        _wo = wo;
        _callback = f;
        _friend = p;
        source = new CSprite();
        _imBox = new Image(g.allData.atlas['interfaceAtlas'].getTexture('inbox_window_4'));
        _imBox.y = 12;
        source.addChild(_imBox);
        _galo4ka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('check'));
        _galo4ka.x = 4;
        _galo4ka.y = 10;
        source.addChild(_galo4ka);
        _galo4ka.visible = false;
        _isCheck = false;

        _txtName = new CTextField(160, 37, '');
        _txtName.needCheckForASCIIChars = true;
        _txtName.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtName.alignH = Align.LEFT;
        _txtName.x = 40;
        _txtName.y = 5;
        _txtName.text = _friend.name + ' ' + _friend.lastName;
        source.addChild(_txtName);

        source.endClickCallback = function ():void {
            if (_isCheck) {
                _isCheck = false;
                _galo4ka.visible = false;
                if (_callback != null) {
                    _callback.apply();
                }
            } else {
                if (_wo.isMaxCountFriendsFull) return;
                _isCheck = true;
                _galo4ka.visible = true;
                if (_callback != null) {
                    _callback.apply();
                }
            }
        };
    }

    public function get isCheck():Boolean { return _isCheck; }
    public function get friend():Someone { return _friend; }

    public function disableIt():void {
        source.touchable = false;
        _galo4ka.visible = true;
        _galo4ka.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
        _imBox.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
    }
    
    public function deleteIt():void {
        if (!source) return;
        _galo4ka.filter = null;
        _imBox.filter = null;
        source.removeChild(_txtName);
        _txtName.deleteIt();
        source.deleteIt();
        source = null;
    }
}
}
