/**
 * Created by user on 12/10/15.
 */
package windows.market {
import manager.ManagerFilters;
import manager.Vars;

import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import windows.WOComponents.CartonBackground;

import windows.WOComponents.DefaultVerticalScrollSprite;

public class MarketAllFriend {
    public var source:Sprite;
    private var _scrollSprite:DefaultVerticalScrollSprite;

    private var g:Vars = Vars.getInstance();

    public function MarketAllFriend(_arrFriends:Array,_panel:WOMarket) {
        source = new Sprite();
        source.x = -100;
        _scrollSprite = new DefaultVerticalScrollSprite(200, 150, 84, 76);
        _scrollSprite.source.x = 35;
        _scrollSprite.source.y = 55;
        _scrollSprite.createScoll(285, 0, 200, g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_line'), g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_c'));
        var woWidth:int = 314;
        var woHeight:int = 0;
        if (_arrFriends.length <= 3) {
            woHeight = 143;
        } else if (_arrFriends.length > 3 && _arrFriends.length <= 6) {
            woHeight = 218;
//        } else if (_arrFriends.length > 6 && _arrFriends.length <= 9){
//            woHeight = 300;

        } else {
            woHeight = 218;
//            woHeight = 300;
            _scrollSprite.source.x = 12;

        }
        var c:CartonBackground = new CartonBackground(woWidth, woHeight);
        c.filter = ManagerFilters.SHADOW_LIGHT;
        source.addChild(c);
        for (var i:int=0; i < _arrFriends.length; i++) {
            var item:MarketFriendsPanelItem = new MarketFriendsPanelItem(_arrFriends[i],_panel, i);
            _scrollSprite.addNewCell(item.source);
        }
        source.addChild(_scrollSprite.source);
        var txtPanel:TextField = new TextField(220, 25, 'Быстрый доступ к друзьям по игре:', g.allData.fonts['BloggerBold'], 13, Color.WHITE);
        txtPanel.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        txtPanel.x = 42;
        txtPanel.y = 11;
        source.addChild(txtPanel);
        source.visible = false;
    }

    public function showIt():void {
        source.visible = true;
    }

    public function hideIt():void {
        source.visible = false;
    }
}
}
