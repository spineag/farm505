/**
 * Created by user on 12/10/15.
 */
package windows.market {
import manager.ManagerFilters;
import manager.Vars;

import starling.display.Quad;

import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

import windows.WOComponents.CartonBackground;

import windows.WOComponents.DefaultVerticalScrollSprite;

public class MarketAllFriend {
    public var source:Sprite;
    private var quad:Quad;
    private var _contTouch:CSprite;
    private var _scrollSprite:DefaultVerticalScrollSprite;
    private var _callback:Function;
    private var _bg:CartonBackground;

    private var g:Vars = Vars.getInstance();

    public function MarketAllFriend(_arrFriends:Array,_wo:WOMarket,f:Function) {
        source = new Sprite();
        source.x = -153;
        _callback = f;
        _contTouch = new CSprite();
        quad = new Quad(585,520,Color.WHITE);
        quad.alpha = 0;
        quad.x = -213;
        quad.y = -260;
        _contTouch.addChild(quad);
        _contTouch.endClickCallback = onClickQuad;
        source.addChild(_contTouch);
        _scrollSprite = new DefaultVerticalScrollSprite(275, 225, 73, 73);
        _scrollSprite.source.y = 55;
        _scrollSprite.createScoll(330, 0, 225, g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_line'), g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_c'));
        var woWidth:int = 370;
        var woHeight:int = 0;
        if (_arrFriends.length <= 4) {
            woHeight = 143;
            source.y = 82;
            _scrollSprite.source.x = 35;
        } else if (_arrFriends.length > 4 && _arrFriends.length <= 7) {
            woHeight = 218;
            _scrollSprite.source.x = 35;
            source.y = 8;
        } else {
            _scrollSprite.source.x = 15;
            woHeight = 300;
            source.y = -75;

        }
        _bg = new CartonBackground(woWidth, woHeight);
        _bg.filter = ManagerFilters.SHADOW_LIGHT;
        source.addChild(_bg);
        for (var i:int=0; i < _arrFriends.length; i++) {
            var item:MarketFriendsPanelItem = new MarketFriendsPanelItem(_arrFriends[i], _wo, i);
            _scrollSprite.addNewCell(item.source);
        }
        source.addChild(_scrollSprite.source);
        var txtPanel:TextField = new TextField(220, 25, 'Быстрый доступ к друзьям:');
        txtPanel.format.setTo(g.allData.bFonts['BloggerBold18'], 16, Color.WHITE);
        txtPanel.filter = ManagerFilters.TEXT_STROKE_BROWN;
        txtPanel.x = 80;
        txtPanel.y = 16;
        source.addChild(txtPanel);
        source.visible = false;
    }

    public function showIt():void {
        source.visible = true;
    }

    public function hideIt():void {
        source.visible = false;
    }

    private function onClickQuad():void {
        if (_callback != null) {
            _callback.apply(null,[true]);
        }
    }

    public function deleteIt():void {
        source.filter = null;
        source.removeChild(_bg);
        _bg.filter = null;
        _bg.deleteIt();
        _bg = null;
        source.removeChild(_contTouch);
        _contTouch.deleteIt();
        _contTouch = null;
        source.removeChild(_scrollSprite.source);
        _scrollSprite.deleteIt();
        _scrollSprite = null;
        source.dispose();
        source = null;
        _callback = null;
    }
}
}
