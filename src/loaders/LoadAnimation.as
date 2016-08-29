/**
 * Created by andy on 5/19/16.
 */
package loaders {
import dragonBones.starling.StarlingFactory;

import flash.display.BitmapData;
import flash.geom.Matrix;

import manager.*;
import dragonBones.objects.DragonBonesData;
import flash.display.Bitmap;

import starling.display.Image;
import starling.textures.Texture;

public class LoadAnimation {
    private var _url:String;
    private var _name:String;
    private var _callback:Function;
    private var _count:int;
    private var g:Vars = Vars.getInstance();

    public function LoadAnimation(url:String, name:String, f:Function) {
        _url = url;
        _name = name;
        _callback = f;
    }

    public function startLoad():void {
        _count = 3;
        g.load.loadImage(_url + '/texture.png' + g.getVersion(_name), onLoad);
        g.load.loadJSON(_url + '/texture.json' + g.getVersion(_name), onLoad);
        g.load.loadJSON(_url + '/skeleton.json' + g.getVersion(_name), onLoad);
    }

    private function onLoad(smth:*=null):void {
        _count--;
        if (_count <=0) {
            if (_name == 'tutorial_mult') {
                var bd:BitmapData = new BitmapData(149, 149);
                var m:Matrix = new Matrix();
                m.translate(-637, -720);
                var b:Bitmap = g.pBitmaps[_url + '/texture.png' + g.getVersion(_name)].create() as Bitmap;
                bd.draw(b, m);
                g.pBitmaps['tutorial_mult_map'] = new PBitmap(new Bitmap(bd));
            }

            var factory:StarlingFactory = new StarlingFactory();
            var dragonBonesData:DragonBonesData = factory.parseDragonBonesData(g.pJSONs[_url + '/skeleton.json' + g.getVersion(_name)]);
            factory.parseTextureAtlasData(g.pJSONs[_url + '/texture.json' + g.getVersion(_name)], Texture.fromBitmap(g.pBitmaps[_url + '/texture.png' + g.getVersion(_name)].create() as Bitmap));
//            _armatureDisplay = factory.buildArmatureDisplay(dragonBonesData.armatureNames[0]); as example

// old
//            var skeletonData:DragonBonesData = factory.parseDragonBonesData(g.pXMLs[_url + '/skeleton.xml' + g.getVersion(_name)]);
//            factory.addSkeletonData(skeletonData);
//            var texture:Texture = Texture.fromBitmap(g.pBitmaps[_url + '/texture.png' + g.getVersion(_name)].create() as Bitmap);
//            var textureAtlas:StarlingTextureAtlasData = new StarlingTextureAtlasData(texture, g.pXMLs[_url + '/texture.xml' + g.getVersion(_name)]);
//            factory.addTextureAtlas(textureAtlas);

            g.allData.factory[_name] = factory;
            g.allData.factoryData[_name] = dragonBonesData;

            delete g.pBitmaps[_url + '/texture.png' + g.getVersion(_name)];
            delete g.pJSONs[_url + '/texture.json' + g.getVersion(_name)];
            delete g.pJSONs[_url + '/skeleton.json' + g.getVersion(_name)];

            if (_callback != null) _callback.apply(null, [_url, this]);
        }
    }
}
}
