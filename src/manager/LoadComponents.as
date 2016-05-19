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
        trace('count on loaded Atlases: ' + count);
        if (count <=0) createAtlases();
    }

    private function createAtlases():void {
        trace('createAtlases');
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

    private function loadDBAnimations():void {
        count = -1;

//        g.load.loadImage(st + 'animations/arrow.png', onLoadDB);
//        g.load.loadXML(st + 'animations/arrow.xml', onLoadDB);
//        g.load.loadDB_PNG(st + 'animations/chest_interface.png', 'chest_interface', onLoadDB);
//        g.load.loadDB_PNG(st + 'animations/order_window2.png', 'orderWindow', onLoadDB);
//        g.load.loadDB_PNG(st + 'animations/plot_seller.png', 'catCustomer', onLoadDB);
//        g.load.loadDB_PNG(st + 'animations/preloader_2.png', 'preloader_2', onLoadDB);
//        g.load.loadDB_PNG(st + 'animations/visit_preloader.png', 'visitPreloader', onLoadDB);
//        g.load.loadDB_PNG(st + 'animations/x1/aerial_tram.png', 'train', onLoadDB);
//                                                          g.load.loadDB_PNG(st + 'animations/x1/bfly.png', 'butterfly', onLoadDB);
//        g.load.loadDB_PNG(st + 'animations/x1/building.png', 'buildingBuild', onLoadDB);
    }

    private function onLoadDB():void {
        count--;
        if (count <=0) createFabricas();
    }

    private function createFabricas():void {
//        var tex:Texture = Texture.fromBitmap(g.pBitmaps[st + 'animations/arrow.png'].create() as Bitmap);
//        var xml:XML = g.pXMLs[st + 'animations/arrow.xml'];


    }
}
}
