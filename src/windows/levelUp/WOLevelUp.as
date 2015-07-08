/**
 * Created by user on 7/8/15.
 */
package windows.levelUp {
import flash.geom.Rectangle;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

import windows.Window;

public class WOLevelUp extends Window{
    private var _txtCongratulations:TextField;
    private var _txtLevel:TextField;
    private var _txtContinue:TextField;
    private var _imageUp:Image;
    private var _imageDown:Image;
    private var _imageBtn:Image;
    private var _contBtn:CSprite;
    private var _contClipRect:Sprite;

    public function WOLevelUp() {
        super ();
        createTempBG(600, 600, Color.GRAY);
        _contBtn = new CSprite();
        _contClipRect = new Sprite();
        _source.addChild(_contClipRect);
        _contClipRect.clipRect = new Rectangle(15,0,400,400);
        _contBtn.endClickCallback = onClick;
        _txtCongratulations = new TextField(100,100,"","Arial",18,Color.WHITE);
        _txtLevel = new TextField(300,100,"","Arial",18,Color.WHITE);
        _txtContinue = new TextField(100,100,"","Arial",18,Color.WHITE);
        _imageUp = new Image(g.interfaceAtlas.getTexture("scroll_box"));
        _imageDown = new Image(g.interfaceAtlas.getTexture("scroll_box"));
        _imageBtn = new Image(g.interfaceAtlas.getTexture("btn1"));

        _contBtn.addChild(_imageBtn);
        _source.addChild(_imageUp);
        _source.addChild(_imageDown);
        _source.addChild(_txtCongratulations);
        _source.addChild(_txtLevel);
        _contBtn.addChild(_txtContinue);
        _source.addChild(_contBtn);

        _txtCongratulations.x = -40;
        _txtCongratulations.y = -250;
        _txtLevel.x = -135;
        _txtLevel.y = -200;
        _txtContinue.x = -40;
        _txtContinue.y = 200;
        _imageUp.y = -130;
        _imageDown.y = 160;
        _imageBtn.x = -100;
        _imageBtn.y = 225;
    }

    public function showLevelUp():void {
        _txtCongratulations.text = "КРАСАВА";
        _txtLevel.text = "Вы достигли " + g.user.level + " уровень";
        _txtContinue.text = "окей";
        showIt();
    }

    public function onClick():void {
        hideIt();
    }
}
}
