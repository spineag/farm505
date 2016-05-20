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
        g.load.loadImage(st + 'x1/wildAtlas.png', onLoad);
        g.load.loadXML(st + 'x1/wildAtlas.xml', onLoad);
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

        g.allData.atlas['wildAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[st + 'x1/wildAtlas.png'].create() as Bitmap), g.pXMLs[st + 'x1/wildAtlas.xml']);
        delete  g.pBitmaps[st + 'x1/wildAtlas.png'];
        delete  g.pXMLs[st + 'x1/wildAtlas.xml'];

        loadDBAnimations();
    }

    private function loadDBAnimations():void {
        count = 6;

        g.loadAnimation.load('animations/arrow', 'arrow', onLoadDB);
        g.loadAnimation.load('animations/chest_interface', 'chest_interface', onLoadDB);
        g.loadAnimation.load('animations/order_window', 'orderWindow', onLoadDB);
        g.loadAnimation.load('animations/plot_seller', 'cat_customer', onLoadDB);
        g.loadAnimation.load('animations/preloader_2', 'preloader_2', onLoadDB);
        g.loadAnimation.load('animations/visit_preloader', 'visitPreloader', onLoadDB);
    }

    private function onLoadDB():void {
        count--;
        if (count <=0) {
            loadDBX();
        }
    }

    private function loadDBX():void {
        count = 10;

        g.loadAnimation.load('animations/x1/bfly', 'butterfly', onLoadDB_X);
        g.loadAnimation.load('animations/x1/cat_main', 'cat', onLoadDB_X);
        g.loadAnimation.load('animations/x1/cat_watering_can', 'cat_watering', onLoadDB_X);
        g.loadAnimation.load('animations/x1/cat_feed', 'cat_feed', onLoadDB_X);
        g.loadAnimation.load('animations/x1/cat_queue', 'cat_queue', onLoadDB_X);
        g.loadAnimation.load('animations/x1/explode', 'explode', onLoadDB_X);
        g.loadAnimation.load('animations/x1/explode_gray', 'explode_gray', onLoadDB_X);
        g.loadAnimation.load('animations/x1/plants', 'plant', onLoadDB_X);
        g.loadAnimation.load('animations/x1/tools', 'removeWild', onLoadDB_X);
        g.loadAnimation.load('animations/x1/trees', 'trees', onLoadDB_X);
    }

    private function onLoadDB_X():void {
        count--;
        if (count <=0) {
            if (_callback != null) _callback.apply();
        }
    }
}
}
