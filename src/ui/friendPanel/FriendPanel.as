/**
 * Created by user on 7/29/15.
 */
package ui.friendPanel {
import manager.Vars;

import starling.core.Starling;

import starling.display.Image;
import starling.display.Sprite;
import starling.filters.BlurFilter;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

public class FriendPanel {
    private var _source:Sprite;
    private var _contArrowRight:CSprite;
    private var _contArrowLeft:CSprite;
    private var _contMyFriend:CSprite;
    private var _contMyNeighbors:CSprite;
    private var _contHelping:CSprite;
    private var _contNeedHelp:CSprite;
    private var _contAddFriend:CSprite;
    private var _txtLvl:TextField;
    private var _imageBg:Image;


    private var g:Vars = Vars.getInstance();
    public function FriendPanel() {
        _source = new Sprite();
        _imageBg = new Image(g.interfaceAtlas.getTexture("friends_plawka"));
        _source.addChild(_imageBg);
        _source.x = 115;
        _source.y = g.stageHeight - 120;
        g.cont.interfaceCont.addChild(_source);
        createList();
        _source.visible = false;
    }

    public function onResize():void {
        _source.x = Starling.current.nativeStage.stageWidth - g.stageWidth + 115;
        _source.y = Starling.current.nativeStage.stageHeight - 120;
    }

    public function showIt():void {
//        updateList();
        _source.visible = true;
    }

    public function hideIt():void {
        _source.visible = false;
    }

    public function get isShowed():Boolean {
        return _source.visible;
    }

    private function createList():void {
        var im:Image;
        var txt:TextField;
        var item:FriendItem;
        item = new FriendItem();
        _source.addChild(item.source);
        _contMyFriend = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture('friends_tab'));
        txt = new TextField(100,50,"Мои друзья","Arial",12,Color.BLACK);
        txt.y = -10;
        _contMyFriend.addChild(im);
        _contMyFriend.addChild(txt);
        _contMyFriend.x = 90;
        _contMyFriend.y = -20;
        _source.addChild(_contMyFriend);
        _contMyFriend.hoverCallback = function():void { _contMyFriend.filter = BlurFilter.createGlow(Color.WHITE, 10, 2, 1) };
        _contMyFriend.outCallback = function():void { _contMyFriend.filter = null };
        _contMyFriend.endClickCallback = function():void {onClick('myFriend')};

        _contMyNeighbors = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture('friends_tab'));
        txt = new TextField(100,50,"Мои соседи","Arial",12,Color.BLACK);
        txt.y = -10;
        _contMyNeighbors.addChild(im);
        _contMyNeighbors.addChild(txt);
        _contMyNeighbors.x = 220;
        _contMyNeighbors.y = -20;
        _source.addChild(_contMyNeighbors);
        _contMyNeighbors.hoverCallback = function():void { _contMyNeighbors.filter = BlurFilter.createGlow(Color.WHITE, 10, 2, 1) };
        _contMyNeighbors.outCallback = function():void { _contMyNeighbors.filter = null };
        _contMyNeighbors.endClickCallback = function():void {onClick('myNeighbors')};

        _contHelping = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture('friends_tab'));
        txt = new TextField(100,50,"Помогли","Arial",12,Color.BLACK);
        txt.y = -10;
        _contHelping.addChild(im);
        _contHelping.addChild(txt);
        _contHelping.x = 350;
        _contHelping.y = -20;
        _source.addChild(_contHelping);
        _contHelping.hoverCallback = function():void { _contHelping.filter = BlurFilter.createGlow(Color.WHITE, 10, 2, 1) };
        _contHelping.outCallback = function():void { _contHelping.filter = null };
        _contHelping.endClickCallback = function():void {onClick('helping')};

        _contNeedHelp = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture('friends_tab'));
        txt = new TextField(100,50,"Нужна помощь","Arial",12,Color.BLACK);
        txt.y = -10;
        _contNeedHelp.addChild(im);
        _contNeedHelp.addChild(txt);
        _contNeedHelp.x = 480;
        _contNeedHelp.y = -20;
        _source.addChild(_contNeedHelp);
        _contNeedHelp.hoverCallback = function():void { _contNeedHelp.filter = BlurFilter.createGlow(Color.WHITE, 10, 2, 1) };
        _contNeedHelp.outCallback = function():void { _contNeedHelp.filter = null };
        _contNeedHelp.endClickCallback = function():void {onClick('needHelp')};

        _contAddFriend = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture("add_friend"));
        im.x = 10;
        im.y = 10;
        _contAddFriend.addChild(im);
        _source.addChild(_contAddFriend);
        _contAddFriend.hoverCallback = function():void { _contAddFriend.filter = BlurFilter.createGlow(Color.WHITE, 10, 2, 1) };
        _contAddFriend.outCallback = function():void { _contAddFriend.filter = null };
        _contAddFriend.endClickCallback = function():void {onClick('addFriend')};

        _contArrowRight = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture("arrow_small"));
        im.x = _imageBg.width - 30;
        im.y = _imageBg.height - 30;
        _contArrowRight.addChild(im);
        _source.addChild(_contArrowRight);
        _contArrowRight.hoverCallback = function():void { _contArrowRight.filter = BlurFilter.createGlow(Color.WHITE, 10, 2, 1) };
        _contArrowRight.outCallback = function():void { _contArrowRight.filter = null };
        _contArrowRight.endClickCallback = function():void {onClick('arrowRight')};

        _contArrowLeft = new CSprite();
        im = new Image(g.interfaceAtlas.getTexture("arrow_small"));
        im.x = 125;
        im.y = _imageBg.height - 30;
        im.scaleX *= -1;
        _contArrowLeft.addChild(im);
        _source.addChild(_contArrowLeft);
        _contArrowLeft.hoverCallback = function():void { _contArrowLeft.filter = BlurFilter.createGlow(Color.WHITE, 10, 2, 1) };
        _contArrowLeft.outCallback = function():void { _contArrowLeft.filter = null };
        _contArrowLeft.endClickCallback = function():void {onClick('arrowLeft')};
    }

    private function onClick(reason:String):void {
        switch (reason) {
            case 'myFriend':
                break;
            case 'myNeighbors':
                break;
            case 'helping':
                break;
            case 'needHelp':
                break;
            case 'addFriend':
                break;
            case 'arrowRight':
                break;
            case 'arrowLeft':
                break;
        }
    }

}
}
