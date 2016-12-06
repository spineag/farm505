/**
 * Created by user on 5/23/16.
 */
package wallPost {
import com.junkbyte.console.Cc;

import flash.display.Bitmap;
import flash.filters.GlowFilter;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import loaders.PBitmap;

import manager.ManagerFabricaRecipe;

import manager.ManagerFilters;
import manager.Vars;

import social.SocialNetworkSwitch;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;

import utils.CTextField;

public class WALLNewLevel {
    protected var g:Vars = Vars.getInstance();
    private var _source:starling.display.Sprite;
    private var _txtLevel:CTextField;

    public function WALLNewLevel() {
        _source = new starling.display.Sprite();
    }

    public function showItParams(callback:Function, params:Array):void {
        var st:String = g.dataPath.getGraphicsPath();
        g.load.loadImage(st + 'wall/wall_new_level.jpg',onLoad);
    }

    private function onLoad(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + 'wall/wall_new_level.jpg'].create() as Bitmap;
        _source.addChild(new Image(Texture.fromBitmap(bitmap)));
        _txtLevel = new CTextField(500,200,String(g.user.level));
        _txtLevel.setFormat(CTextField.BOLD72, 78, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtLevel.x = 60;
        _txtLevel.y = 90;
        _source.addChild(_txtLevel);

        var sp:flash.display.Sprite = new flash.display.Sprite();
        var t:flash.text.TextField = new flash.text.TextField();
        sp.addChild(t);
        var myFormat:TextFormat = new TextFormat();
        myFormat.size = 90;
        myFormat.bold = true;
        myFormat.align = TextFormatAlign.CENTER;
        t.defaultTextFormat = myFormat;
        t.textColor = Color.WHITE;
        t.text = String(g.user.level);
        t.width = 500;
        t.height = 200;
        t.x = 5;
        t.y = 235;
        t.filters = [new GlowFilter(ManagerFilters.BROWN_COLOR)];
        bitmap.bitmapData.draw(sp);
        if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) {
            g.socialNetwork.wallPostBitmap(String(g.user.userSocialId),String('Ура! У меня новый уровень в игре Умелые Лапки! Теперь мне доступно еще больше уникальных объектов!'),bitmap,'interfaceAtlas');
        } else if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID) {
            try {
                g.socialNetwork.wallPostBitmap(String(g.user.userSocialId), String('Ура! У меня новый уровень в игре Умелые Лапки! Теперь мне доступно еще больше уникальных объектов!'),
                        null, st + 'wall/wall_new_level.jpg');
            } catch (e:Error) {
                Cc.error('error during wallpost');
            }
        }
        (g.pBitmaps[st + 'wall/wall_new_level.jpg'] as PBitmap).deleteIt();
        delete g.pBitmaps[st + 'wall/wall_new_level.jpg'];
    }
}
}
