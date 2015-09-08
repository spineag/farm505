/**
 * Created by user on 6/24/15.
 */
package ui.bottomInterface {
import manager.Vars;

import starling.core.Starling;

import starling.display.Image;
import starling.display.Sprite;
import starling.filters.BlurFilter;
import starling.utils.Color;

import utils.CSprite;

public class MainBottomPanel {
    private var _source:Sprite;
    private var _bg:Image;
    private var _shopBtn:CSprite;
    private var _friendsBtn:CSprite;
    private var _toolsBtn:CSprite;
    private var _optionBtn:CSprite;
    private var b:Boolean;
    private var g:Vars = Vars.getInstance();

    public function MainBottomPanel() {
        _source = new Sprite();
        _source.y = 490;
        g.cont.interfaceCont.addChild(_source);
        _bg = new Image(g.interfaceAtlas.getTexture('interface_bg'));
        _bg.x = 837;
        _bg.y = 4;
        _source.addChild(_bg);
        b = true;
        fillBtns();
    }

    private function fillBtns():void {
        var im:Image;
        _shopBtn = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture('shop_icon'));
        _shopBtn.addChild(im);
        _shopBtn.x = 902;
        _shopBtn.y = 56;
        _source.addChild(_shopBtn);
        _shopBtn.hoverCallback = function():void { _shopBtn.filter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1) };
        _shopBtn.outCallback = function():void { _shopBtn.filter = null };
        _shopBtn.endClickCallback = function():void {onClick('shop')};

        _optionBtn = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture('option_icon'));
        _optionBtn.addChild(im);
        _optionBtn.x = 931;
        _optionBtn.y = 6;
        _source.addChild(_optionBtn);
        _optionBtn.hoverCallback = function():void { _optionBtn.filter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1) };
        _optionBtn.outCallback = function():void { _optionBtn.filter = null };
        _optionBtn.endClickCallback = function():void {onClick('option')};

        _toolsBtn = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture('tools_icon'));
        _toolsBtn.addChild(im);
        _toolsBtn.x = 836;
        _toolsBtn.y = 85;
        _source.addChild(_toolsBtn);
        _toolsBtn.hoverCallback = function():void { _toolsBtn.filter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1) };
        _toolsBtn.outCallback = function():void { _toolsBtn.filter = null };
        _toolsBtn.endClickCallback = function():void {onClick('tools')};

        _friendsBtn = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture('friends_icon'));
        _friendsBtn.addChild(im);
        _friendsBtn.x = 854;
        _friendsBtn.y = 17;
        _source.addChild(_friendsBtn);
        _friendsBtn.hoverCallback = function():void { _friendsBtn.filter = BlurFilter.createGlow(Color.YELLOW, 10, 2, 1) };
        _friendsBtn.outCallback = function():void { _friendsBtn.filter = null };
        _friendsBtn.endClickCallback = function():void {onClick('friends')};
    }

    private function onClick(reason:String):void {
        switch (reason) {
            case 'shop':
                    g.woShop.showIt();
                break;
            case 'tools':
                if (b == true){
                    g.toolsPanel.showIt();
                    b = false;
                } else if (b == false){
                    g.toolsPanel.hideIt();
                    b = true;
                }
                break;
            case 'option':
                 b = g.optionPanel.isShowed;
                 if (b == true){
                        g.optionPanel.showIt();
                        b = false;
                 } else if (b == false){
                        g.optionPanel.hideIt();
                        b = true;
                 }

                break;
            case 'friends':
                if (b == true){
                    g.friendPanel.showIt();
                    b = false;
                } else if (b == false){
                    g.friendPanel.hideIt();
                    b = true;
                }
                break;
        }
    }

    public function onResize():void {
        _source.x = Starling.current.nativeStage.stageWidth - g.stageWidth;
        _source.y = Starling.current.nativeStage.stageHeight - 150;
    }

}
}
