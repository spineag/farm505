/**
 * Created by andy on 8/8/17.
 */
package windows.acceptSentGift {
import com.junkbyte.console.Cc;

import data.StructureDataResource;
import data.StructureUserGift;
import flash.display.Bitmap;
import flash.geom.Point;

import manager.ManagerFilters;
import manager.Vars;

import resourceItem.DropItem;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Align;
import starling.utils.Color;

import temp.DropResourceVariaty;

import user.Someone;
import utils.CButton;
import utils.CTextField;
import utils.MCScaler;

public class WOAcceptSentGiftItem {
    private var g:Vars = Vars.getInstance();
    public var source:Sprite;
    private var _data:StructureUserGift;
    private var _dataResource:StructureDataResource;
    private var _person:Someone;
    private var _txtName:CTextField;
    private var _txtResource:CTextField;
    private var _btn:CButton;
    private var _btnExit:CButton;
    private var _hideCallback:Function;

    public function WOAcceptSentGiftItem(d:StructureUserGift, f:Function) {  // 520x90
        _hideCallback = f;
        source = new Sprite();
        var im:Image  = new Image(g.allData.atlas['interfaceAtlas'].getTexture('inbox_window_1'));
        source.addChild(im);
        
        _data = d;
        _dataResource = g.allData.getResourceById(_data.resourceId);
        if (_data.forAsk) _person = g.user.getFriendById(_data.userId2);
        else _person = g.user.getFriendById(_data.userId1);
        if (_person.photo) {
            g.load.loadImage(_person.photo, onLoadPhoto);
        } else Cc.ch('social', 'WOAcceptSentGiftItem no photo for uid: ' + _person.userSocialId);

        _txtName = new CTextField(100, 70, '');
        _txtName.needCheckForASCIIChars = true;
        _txtName.setFormat(CTextField.BOLD18, 18, ManagerFilters.BLUE_COLOR);
        _txtName.alignH = Align.LEFT;
        _txtName.x = 90;
        _txtName.y = 10;
        _txtName.text = _person.name + ' ' + _person.lastName;
        source.addChild(_txtName);

        _btnExit = new CButton();
        _btnExit.addDisplayObject(new Image(g.allData.atlas['interfaceAtlas'].getTexture('bt_close')));
        _btnExit.scaleIt(.4);
        _btnExit.setPivots();
        _btnExit.x = 485;
        _btnExit.y = 10;
        _btnExit.createHitArea('bt_close');
        source.addChild(_btnExit);
        _btnExit.clickCallback = onClickClose;

        _btn = new CButton();
        _btn.addButtonTexture(120, 40, CButton.GREEN, true);
        _btn.x = 420;
        _btn.y = 47;
        var t:CTextField = new CTextField(120, 37, "");
        t.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        if (_data.forAsk) t.text = 'Принять';
            else t.text = 'Подарить';
        _btn.addChild(t);
        source.addChild(_btn);
        _btn.clickCallback = onClickBtn;

        im = new Image(g.allData.atlas[_dataResource.url].getTexture(_dataResource.imageShop));
        MCScaler.scale(im, 60, 60);
        im.alignPivot();
        im.x = 230;
        im.y = 45;
        source.addChild(im);
        _txtResource = new CTextField(100, 70, _dataResource.name);
        _txtResource.setFormat(CTextField.BOLD18, 18, ManagerFilters.BLUE_COLOR);
        _txtResource.alignH = Align.LEFT;
        _txtResource.x = 270;
        _txtResource.y = 5;
        source.addChild(_txtResource);
    }
    
    public function get dataGift():StructureUserGift { return _data; }
    public function get resourceId():int { return _dataResource.id; }

    private function onLoadPhoto(bitmap:Bitmap):void {
        if (!bitmap) return;
        var im:Image = new Image(Texture.fromBitmap(bitmap));
        MCScaler.scale(im, 60, 60);
        im.x = 25;
        im.y = 12;
        source.addChild(im);
    }

    private function onClickClose():void {
        if (_hideCallback != null) _hideCallback.apply(null, [this]);
    }

    private function onClickBtn():void {
        if (_data.forAsk) { 
            acceptGiftResource();
            g.managerAskGift.onAcceptGiftFromFriend(_data);
        } else { 
            g.managerAskGift.onSendGiftToFriend(_data);
        }
        onClickClose();
    }

    public function acceptGiftResource(isAll:Boolean = false, delay:Number = 0):void {
        var obj:Object = {};
        obj.id = _dataResource.id;
        obj.type = DropResourceVariaty.DROP_TYPE_RESOURSE;
        obj.count = 1;
        var p:Point = new Point();
        if (isAll) {
            p.x = g.managerResize.stageWidth/2;
            p.y = g.managerResize.stageHeight/2;
        } else {
            p.x = 230;
            p.y = 45;
            p = source.localToGlobal(p);
        }
        new DropItem(p.x, p.y, obj, delay, 60);
    }

    public function deleteIt():void {
        if (!source) return;
        source.removeChild(_txtName);
        _txtName.deleteIt();
        source.removeChild(_txtResource);
        _txtResource.deleteIt();
        source.removeChild(_btn);
        _btn.deleteIt();
        source.removeChild(_btnExit);
        _btnExit.deleteIt();
        source.dispose();
        _data = null;
        _dataResource = null;
        _person = null;
    }
}
}
