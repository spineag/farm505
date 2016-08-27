/**
 * Created by user on 5/23/16.
 */
package wallPost {
import flash.display.Bitmap;
import flash.filters.GlowFilter;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;

public class WALLNewLevel {
    protected var g:Vars = Vars.getInstance();
    private var _source:starling.display.Sprite;
    private var _txtLevel:starling.text.TextField;

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
        _txtLevel = new starling.text.TextField(500,200,String(g.user.level));
        _txtLevel.format.setTo(g.allData.bFonts['BloggerBold72'],83,Color.WHITE);
        _txtLevel.x = 60;
        _txtLevel.y = 90;
        ManagerFilters.setStrokeStyle(_txtLevel, ManagerFilters.TEXT_BROWN_COLOR);
        _source.addChild(_txtLevel);

//        var bitMap:Bitmap = DrawToBitmap.drawToBitmap(Starling.current, _source);
        var sp:flash.display.Sprite = new flash.display.Sprite();
        var t:flash.text.TextField = new flash.text.TextField();
        sp.addChild(t);
        var myFormat:TextFormat = new TextFormat();
        myFormat.size = 90;
        myFormat.bold = true;
        myFormat.align = TextFormatAlign.CENTER;
//        myFormat.font = 'Arial';
        t.defaultTextFormat = myFormat;
        t.textColor = Color.WHITE;
        t.text = String(g.user.level);
        t.width = 500;
        t.height = 200;
        t.x = 60;
        t.y = 150;
        t.filters = [new GlowFilter(ManagerFilters.TEXT_BROWN_COLOR)];
        bitmap.bitmapData.draw(sp);
        g.socialNetwork.wallPostBitmap(String(g.user.userSocialId),String('Ура! У меня новый уровень в игре Умелые Лапки! Теперь мне доступно еще больше уникальных объектов!'),bitmap,'interfaceAtlas');
        delete g.pBitmaps[st + 'wall/wall_new_level.jpg'];
    }
}
}
