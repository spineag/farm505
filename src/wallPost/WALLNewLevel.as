/**
 * Created by user on 5/23/16.
 */
package wallPost {
import com.junkbyte.console.Cc;

import data.BuildType;

import flash.display.Bitmap;
import flash.display.BitmapData;

import flash.external.ExternalInterface;

import manager.ManagerFilters;

import manager.Vars;

import social.vk.SN_Vkontakte;

import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;

import utils.DrawToBitmap;

import windows.levelUp.WOLevelUp;

import windows.levelUp.WOLevelUpItem;

public class WALLNewLevel {
    protected var g:Vars = Vars.getInstance();
    private var _source:Sprite;
    private var _arrItems:Array;
    private var _arrCells:Array;
    private var _contImage:Sprite;
    private var _txtLevel:TextField;

    public function WALLNewLevel() {
        _arrItems = [];
        _arrCells = [];
        _source = new Sprite();
        _contImage = new Sprite();
    }

    public function showItParams(callback:Function, params:Array):void {
        var st:String = g.dataPath.getGraphicsPath();
        g.load.loadImage(st + 'wall/wall_new_level.jpg',onLoad);
        _arrItems = params[0];
    }

    private function onLoad(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + 'wall/wall_new_level.jpg'].create() as Bitmap;
        _source.addChild(Image.fromBitmap(bitmap));
        _txtLevel = new TextField(500,200,String(g.user.level),g.allData.fonts['BloggerBold'],83,Color.WHITE);
        _txtLevel.nativeFilters = ManagerFilters.TEXT_STROKE_BROWN;
        _txtLevel.x = 60;
        _txtLevel.y = 90;
        _source.addChild(_txtLevel);
        var bitMap:Bitmap = DrawToBitmap.drawToBitmap(_source);
        g.socialNetwork.wallPostBitmap(String(g.user.userSocialId),String('ТЫ КРАСАВА ВААААСССЯЯЯЯ, СУШАЙ ЛЕВЛ ПОЛУЧИЛ ВАААСССЯ'),bitMap,'interfaceAtlas');

    }
}
}
