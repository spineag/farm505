/**
 * Created by user on 5/31/16.
 */
package wallPost {
import flash.display.Bitmap;
import flash.display.Bitmap;
import flash.display.BitmapData;

import loaders.PBitmap;

import manager.Vars;

import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Color;

import utils.DrawToBitmap;

public class WALLNewFabric {
    protected var g:Vars = Vars.getInstance();
    private var _data:Object;
    private var _loaderCounter:int;

    public function WALLNewFabric() {}

    public function showItParams(callback:Function, params:Object):void {
        var st:String = g.dataPath.getGraphicsPath();
        _data = params;
        _loaderCounter = 3;
        g.load.loadImage(st + 'wall/wall_new_fabric.jpg',onLoad);
        g.load.loadImage(st + 'iconAtlas.png' + g.getVersion('iconAtlas'), onLoad);
        g.load.loadXML(st + 'iconAtlas.xml' + g.getVersion('iconAtlas'), onLoad);
    }

    private function onLoad(smth:*=null):void {
        _loaderCounter--;
        if (_loaderCounter <= 0) onLoadTotal();
    }

    private function onLoadTotal():void {
        var st:String = g.dataPath.getGraphicsPath();
        var bitmap:Bitmap = g.pBitmaps[st + 'wall/wall_new_fabric.jpg'].create() as Bitmap;
        var sp:flash.display.Sprite = new flash.display.Sprite();
        sp.addChild(bitmap);

        var bd:BitmapData = DrawToBitmap.getBitmapFromTextureBitmapAndTextureXML(g.pBitmaps[st + 'iconAtlas.png' + g.getVersion('iconAtlas')].create() as Bitmap,
                g.pXMLs[st + 'iconAtlas.xml' + g.getVersion('iconAtlas')], _data.url + '_icon');
        var j:int;
        for (var i:int=0; i<bd.width; i++) {
            for (j=0; j<bd.height; j++) {
                if (bd.getPixel(i, j) == Color.WHITE){
                    bd.setPixel32(i, j, 0x00ffffff);
                }
            }
        }
        if (bd) {
            var b:Bitmap = new Bitmap(bd);
            b.x = 220 - b.width/2;
            b.y = 300 - b.height/2;
            sp.addChild(b);
        }
        var rbd:BitmapData = new BitmapData(sp.width, sp.height);
        rbd.draw(sp);
        var rb:Bitmap = new Bitmap(rbd);
        g.socialNetwork.wallPostBitmap(String(g.user.userSocialId),String('Ура! Мы построили новую фабрику! Теперь в Долине Рукоделия еще больше прибыльного производства!'),rb,'interfaceAtlas');
        (g.pBitmaps[st + 'iconAtlas.png' + g.getVersion('iconAtlas')] as PBitmap).deleteIt();
        delete  g.pBitmaps[st + 'iconAtlas.png' + g.getVersion('iconAtlas')];
        delete  g.pXMLs[st + 'iconAtlas.xml' + g.getVersion('iconAtlas')];
        (g.pBitmaps[st + 'wall/wall_new_fabric.jpg'] as PBitmap).deleteIt();
        delete g.pBitmaps[st + 'wall/wall_new_fabric.jpg'];
    }
}
}
