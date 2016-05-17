/**
 * Created by andy on 5/17/16.
 */
package manager {
import flash.display.Bitmap;

import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class LoadComponents {
    private var _callback:Function;
    private var count:int;
    private var st:String;
    private var g:Vars = Vars.getInstance();

    public function LoadComponents(f:Function) {
        _callback = f;
        st = g.dataPath.getGraphicsPath();
        loadAtlases();
    }

    private function loadAtlases():void {
        count=16;

        g.load.loadImage(st + 'iconAtlas.png', onLoad);
        g.load.loadXML(st + 'iconAtlas.xml', onLoad);
        g.load.loadImage(st + 'instrumentAtlas.png', onLoad);
        g.load.loadXML(st + 'instrumentAtlas.xml', onLoad);
        g.load.loadImage(st + 'interfaceAtlas.png', onLoad);
        g.load.loadXML(st + 'interfaceAtlas.xml', onLoad);
        g.load.loadImage(st + 'resourceAtlas.png', onLoad);
        g.load.loadXML(st + 'resourceAtlas.xml', onLoad);

        g.load.loadImage(st + 'x1/buildAtlas.png', onLoad);
        g.load.loadXML(st + 'x1/buildAtlas.xml', onLoad);
        g.load.loadImage(st + 'x1/decorAtlas.png', onLoad);
        g.load.loadXML(st + 'x1/decorAtlas.xml', onLoad);
        g.load.loadImage(st + 'x1/farmAtlas.png', onLoad);
        g.load.loadXML(st + 'x1/farmAtlas.xml', onLoad);
        g.load.loadImage(st + 'x1/wildAtlas2.png', onLoad);
        g.load.loadXML(st + 'x1/wildAtlas2.xml', onLoad);
    }

    private function onLoad(smth:*=null):void {
        count--;
        if (count <=0) createAtlases();
    }

    private function createAtlases():void {
        g.allData.atlas['iconAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[st + 'iconAtlas.png'].create() as Bitmap), g.pXMLs[st + 'iconAtlas.xml']);
        delete  g.pBitmaps[st + 'iconAtlas.png'];
        delete  g.pXMLs[st + 'iconAtlas.xml'];

        g.allData.atlas['instrumentAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[st + 'instrumentAtlas.png'].create() as Bitmap), g.pXMLs[st + 'instrumentAtlas.xml']);
        delete  g.pBitmaps[st + 'instrumentAtlas.png'];
        delete  g.pXMLs[st + 'instrumentAtlas.xml'];

        g.allData.atlas['interfaceAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[st + 'interfaceAtlas.png'].create() as Bitmap), g.pXMLs[st + 'interfaceAtlas.xml']);
        delete  g.pBitmaps[st + 'interfaceAtlas.png'];
        delete  g.pXMLs[st + 'interfaceAtlas.xml'];

        g.allData.atlas['resourceAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[st + 'resourceAtlas.png'].create() as Bitmap), g.pXMLs[st + 'resourceAtlas.xml']);
        delete  g.pBitmaps[st + 'resourceAtlas.png'];
        delete  g.pXMLs[st + 'resourceAtlas.xml'];

        g.allData.atlas['buildAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[st + 'x1/buildAtlas.png'].create() as Bitmap), g.pXMLs[st + 'x1/buildAtlas.xml']);
        delete  g.pBitmaps[st + 'x1/buildAtlas.png'];
        delete  g.pXMLs[st + 'x1/buildAtlas.xml'];

        g.allData.atlas['decorAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[st + 'x1/decorAtlas.png'].create() as Bitmap), g.pXMLs[st + 'x1/decorAtlas.xml']);
        delete  g.pBitmaps[st + 'x1/decorAtlas.png'];
        delete  g.pXMLs[st + 'x1/decorAtlas.xml'];

        g.allData.atlas['farmAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[st + 'x1/farmAtlas.png'].create() as Bitmap), g.pXMLs[st + 'x1/farmAtlas.xml']);
        delete  g.pBitmaps[st + 'x1/farmAtlas.png'];
        delete  g.pXMLs[st + 'x1/farmAtlas.xml'];

        g.allData.atlas['wildAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[st + 'x1/wildAtlas2.png'].create() as Bitmap), g.pXMLs[st + 'x1/wildAtlas2.xml']);
        delete  g.pBitmaps[st + 'x1/wildAtlas2.png'];
        delete  g.pXMLs[st + 'x1/wildAtlas2.xml'];

//        loadDBAnimations();
        if (_callback != null) _callback.apply();
    }

//    private function loadDBAnimations():void {
//        count = 0;
//    }
//
//    private function onLoadDBAnimation(smth:*=null):void {
//
//    }
}
}
