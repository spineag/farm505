/**
 * Created by user on 7/29/15.
 */
package ui.friendPanel {
import flash.geom.Rectangle;

import manager.Vars;

import social.SocialNetworkEvent;

import starling.core.Starling;

import starling.display.Image;
import starling.display.Sprite;
import starling.filters.BlurFilter;
import starling.text.TextField;
import starling.utils.Color;

import user.Someone;
import user.TempUser;

import utils.CSprite;

public class FriendPanel {
    private var _source:Sprite;
    private var _contRectangle:Sprite;
    private var _cont:Sprite;
    private var _contNewFriend:CSprite;
    private var _contLeftArrow:CSprite;
    private var _contRightArrow:CSprite;
    private var _imageneFriend:Image;
    private var _imageLeftArrow:Image;
    private var _imageRightArrow:Image;
    private var _imageBg:Image;
    private var _arrFriends:Array;
    private var _arrItems:Array;

    private var g:Vars = Vars.getInstance();
    public function FriendPanel() {
        _source = new Sprite();
        _contNewFriend = new CSprite();
        _contLeftArrow = new CSprite();
        _contRightArrow = new CSprite();
        _contRectangle = new Sprite();
        _cont = new Sprite();
        _cont.x = 115;
        _cont.y = 5;
        _contRectangle.clipRect = new Rectangle(115, g.stageHeight - 120, 100, 500);
        _arrFriends = [];
        _arrItems = [];
        _imageBg = new Image(g.allData.atlas['interfaceAtlas'].getTexture("friends_plawka"));
        _imageneFriend = new Image(g.allData.atlas['interfaceAtlas'].getTexture("add_friend"));
        _contNewFriend.addChild(_imageneFriend);
        _imageLeftArrow = new Image(g.allData.atlas['interfaceAtlas'].getTexture("arrow_small"));
        _imageLeftArrow.y = _imageBg.height - 30;
        _imageLeftArrow.x =  100;
        _imageLeftArrow.scaleX *= -1;
        _contLeftArrow.addChild(_imageLeftArrow);
        _imageRightArrow = new Image(g.allData.atlas['interfaceAtlas'].getTexture("arrow_small"));
        _imageRightArrow.y = _imageBg.height - 30;
        _imageRightArrow.x = _imageBg.width - 30;
        _contRightArrow.addChild(_imageRightArrow);
        _source.x = 115;
        _source.y = g.stageHeight - 120;
        g.cont.interfaceCont.addChild(_source);
        _source.visible = false;
        _source.addChild(_imageBg);
//        _source.addChild(_contRectangle);
//        _contRectangle.addChild(_cont);
        _source.addChild(_cont)
        _source.addChild(_contNewFriend);
        _source.addChild(_contLeftArrow);
        _source.addChild(_contRightArrow);

        _contNewFriend.endClickCallback = newFriend;
        _contLeftArrow.endClickCallback = leftArrow;
        _contRightArrow.endClickCallback = rightArrow;
            g.socialNetwork.addEventListener(SocialNetworkEvent.GET_FRIENDS_BY_IDS, addAdditionalUser);

    }

    public function onResize():void {
        _source.x = Starling.current.nativeStage.stageWidth - g.stageWidth + 115;
        _source.y = Starling.current.nativeStage.stageHeight - 120;
    }

    public function showIt():void {
        _source.visible = true;
    }

    public function hideIt():void {
        _source.visible = false;
    }

    public function get isShowed():Boolean {
        return _source.visible;
    }

    private function newFriend():void {}
    private function leftArrow():void {

    }
    private function rightArrow():void {

    }


    public function addAdditionalUser(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_FRIENDS_BY_IDS, addAdditionalUser);
        var item:FriendItem;
        var arrItems:Array;
        arrItems = [];
        _arrFriends = g.user.arrFriends.slice();
        _arrFriends.unshift(g.user.neighbor);
        _arrFriends.unshift(g.user);
        _arrFriends.sortOn("level", Array.DESCENDING | Array.NUMERIC);
        for (var i:int = 0; i < _arrFriends.length; i++) {
            item = new FriendItem(_arrFriends[i]);
            arrItems.push(item);
            item.source.x = i*110;
            _cont.addChild(item.source);
        }
    }

}
}
