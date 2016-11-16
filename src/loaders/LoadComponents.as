/**
 * Created by andy on 5/17/16.
 */
package loaders {
import flash.system.ApplicationDomain;

import manager.*;

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
        g.startPreloader.setProgress(6);
        count=0;

        g.load.loadImage(st + 'iconAtlas.png' + g.getVersion('iconAtlas'), onLoad);
        g.load.loadXML(st + 'iconAtlas.xml' + g.getVersion('iconAtlas'), onLoad);
        g.load.loadImage(st + 'instrumentAtlas.png' + g.getVersion('instrumentAtlas'), onLoad);
        g.load.loadXML(st + 'instrumentAtlas.xml' + g.getVersion('instrumentAtlas'), onLoad);
        g.load.loadImage(st + 'interfaceAtlas.png' + g.getVersion('interfaceAtlas'), onLoad);
        g.load.loadXML(st + 'interfaceAtlas.xml' + g.getVersion('interfaceAtlas'), onLoad);
        g.load.loadImage(st + 'resourceAtlas.png' + g.getVersion('resourceAtlas'), onLoad);
        g.load.loadXML(st + 'resourceAtlas.xml' + g.getVersion('resourceAtlas'), onLoad);
        g.load.loadImage(st + 'customisationInterfaceAtlas.png' + g.getVersion('customisationInterfaceAtlas'), onLoad);
        g.load.loadXML(st + 'customisationInterfaceAtlas.xml' + g.getVersion('customisationInterfaceAtlas'), onLoad);

        g.load.loadImage(st + 'x1/buildAtlas.png' + g.getVersion('buildAtlas'), onLoad);
        g.load.loadXML(st + 'x1/buildAtlas.xml' + g.getVersion('buildAtlas'), onLoad);
        g.load.loadImage(st + 'x1/decorAtlas.png' + g.getVersion('decorAtlas'), onLoad);
        g.load.loadXML(st + 'x1/decorAtlas.xml' + g.getVersion('decorAtlas'), onLoad);
        g.load.loadImage(st + 'x1/farmAtlas.png' + g.getVersion('farmAtlas'), onLoad);
        g.load.loadXML(st + 'x1/farmAtlas.xml' + g.getVersion('farmAtlas'), onLoad);
        g.load.loadImage(st + 'x1/wildAtlas.png' + g.getVersion('wildAtlas'), onLoad);
        g.load.loadXML(st + 'x1/wildAtlas.xml' + g.getVersion('wildAtlas'), onLoad);
        g.load.loadImage(st + 'x1/customisationAtlas.png' + g.getVersion('customisationAtlas'), onLoad);
        g.load.loadXML(st + 'x1/customisationAtlas.xml' + g.getVersion('customisationAtlas'), onLoad);
    }

    private function onLoad(smth:*=null):void {
        count++;
        g.startPreloader.setProgress(6 + 2*count);
        if (count >=20) createAtlases();
    }

    private function createAtlases():void {
        g.allData.atlas['iconAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[st + 'iconAtlas.png' + g.getVersion('iconAtlas')].create() as Bitmap), g.pXMLs[st + 'iconAtlas.xml' + g.getVersion('iconAtlas')]);
        (g.pBitmaps[st + 'iconAtlas.png' + g.getVersion('iconAtlas')] as PBitmap).deleteIt();
        delete  g.pBitmaps[st + 'iconAtlas.png' + g.getVersion('iconAtlas')];
        delete  g.pXMLs[st + 'iconAtlas.xml' + g.getVersion('iconAtlas')];

        g.allData.atlas['instrumentAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[st + 'instrumentAtlas.png' + g.getVersion('instrumentAtlas')].create() as Bitmap), g.pXMLs[st + 'instrumentAtlas.xml' + g.getVersion('instrumentAtlas')]);
        (g.pBitmaps[st + 'instrumentAtlas.png' + g.getVersion('instrumentAtlas')] as PBitmap).deleteIt();
        delete  g.pBitmaps[st + 'instrumentAtlas.png' + g.getVersion('instrumentAtlas')];
        delete  g.pXMLs[st + 'instrumentAtlas.xml' + g.getVersion('instrumentAtlas')];

        g.allData.atlas['interfaceAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[st + 'interfaceAtlas.png' + g.getVersion('interfaceAtlas')].create() as Bitmap), g.pXMLs[st + 'interfaceAtlas.xml' + g.getVersion('interfaceAtlas')]);
        (g.pBitmaps[st + 'interfaceAtlas.png' + g.getVersion('interfaceAtlas')] as PBitmap).deleteIt();
        delete  g.pBitmaps[st + 'interfaceAtlas.png' + g.getVersion('interfaceAtlas')];
        delete  g.pXMLs[st + 'interfaceAtlas.xml' + g.getVersion('interfaceAtlas')];

        g.allData.atlas['resourceAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[st + 'resourceAtlas.png' + g.getVersion('resourceAtlas')].create() as Bitmap), g.pXMLs[st + 'resourceAtlas.xml' + g.getVersion('resourceAtlas')]);
        (g.pBitmaps[st + 'resourceAtlas.png' + g.getVersion('resourceAtlas')] as PBitmap).deleteIt();
        delete  g.pBitmaps[st + 'resourceAtlas.png' + g.getVersion('resourceAtlas')];
        delete  g.pXMLs[st + 'resourceAtlas.xml' + g.getVersion('resourceAtlas')];

        g.allData.atlas['buildAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[st + 'x1/buildAtlas.png' + g.getVersion('buildAtlas')].create() as Bitmap), g.pXMLs[st + 'x1/buildAtlas.xml' + g.getVersion('buildAtlas')]);
        (g.pBitmaps[st + 'x1/buildAtlas.png' + g.getVersion('buildAtlas')] as PBitmap).deleteIt();
        delete  g.pBitmaps[st + 'x1/buildAtlas.png' + g.getVersion('buildAtlas')];
        delete  g.pXMLs[st + 'x1/buildAtlas.xml' + g.getVersion('buildAtlas')];

        g.allData.atlas['decorAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[st + 'x1/decorAtlas.png' + g.getVersion('decorAtlas')].create() as Bitmap), g.pXMLs[st + 'x1/decorAtlas.xml' + g.getVersion('decorAtlas')]);
        g.managerHitArea.registerFromAtlas(g.pBitmaps[st + 'x1/decorAtlas.png' + g.getVersion('decorAtlas')].create() as Bitmap, g.pXMLs[st + 'x1/decorAtlas.xml' + g.getVersion('decorAtlas')]);
        (g.pBitmaps[st + 'x1/decorAtlas.png' + g.getVersion('decorAtlas')] as PBitmap).deleteIt();
        delete  g.pBitmaps[st + 'x1/decorAtlas.png' + g.getVersion('decorAtlas')];
        delete  g.pXMLs[st + 'x1/decorAtlas.xml' + g.getVersion('decorAtlas')];

        g.allData.atlas['farmAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[st + 'x1/farmAtlas.png' + g.getVersion('farmAtlas')].create() as Bitmap), g.pXMLs[st + 'x1/farmAtlas.xml' + g.getVersion('farmAtlas')]);
        (g.pBitmaps[st + 'x1/farmAtlas.png' + g.getVersion('farmAtlas')] as PBitmap).deleteIt();
        delete  g.pBitmaps[st + 'x1/farmAtlas.png' + g.getVersion('farmAtlas')];
        delete  g.pXMLs[st + 'x1/farmAtlas.xml' + g.getVersion('farmAtlas')];

        g.allData.atlas['wildAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[st + 'x1/wildAtlas.png' + g.getVersion('wildAtlas')].create() as Bitmap), g.pXMLs[st + 'x1/wildAtlas.xml' + g.getVersion('wildAtlas')]);
        g.managerHitArea.registerFromAtlas(g.pBitmaps[st + 'x1/wildAtlas.png' + g.getVersion('wildAtlas')].create() as Bitmap, g.pXMLs[st + 'x1/wildAtlas.xml' + g.getVersion('wildAtlas')]);
        (g.pBitmaps[st + 'x1/wildAtlas.png' + g.getVersion('wildAtlas')] as PBitmap).deleteIt();
        delete  g.pBitmaps[st + 'x1/wildAtlas.png' + g.getVersion('wildAtlas')];
        delete  g.pXMLs[st + 'x1/wildAtlas.xml' + g.getVersion('wildAtlas')];

        g.allData.atlas['customisationAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[st + 'x1/customisationAtlas.png' + g.getVersion('customisationAtlas')].create() as Bitmap), g.pXMLs[st + 'x1/customisationAtlas.xml' + g.getVersion('customisationAtlas')]);
        (g.pBitmaps[st + 'x1/customisationAtlas.png' + g.getVersion('customisationAtlas')] as PBitmap).deleteIt();
        delete  g.pBitmaps[st + 'x1/customisationAtlas.png' + g.getVersion('customisationAtlas')];
        delete  g.pXMLs[st + 'x1/customisationAtlas.xml' + g.getVersion('customisationAtlas')];

        g.allData.atlas['customisationInterfaceAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[st + 'customisationInterfaceAtlas.png' + g.getVersion('customisationInterfaceAtlas')].create() as Bitmap), g.pXMLs[st + 'customisationInterfaceAtlas.xml' + g.getVersion('customisationInterfaceAtlas')]);
        (g.pBitmaps[st + 'customisationInterfaceAtlas.png' + g.getVersion('customisationInterfaceAtlas')] as PBitmap).deleteIt();
        delete  g.pBitmaps[st + 'customisationInterfaceAtlas.png' + g.getVersion('customisationInterfaceAtlas')];
        delete  g.pXMLs[st + 'customisationInterfaceAtlas.xml' + g.getVersion('customisationInterfaceAtlas')];

        loadDBAnimations();
    }

    private function loadDBAnimations():void {
        g.startPreloader.setProgress(48);
        count = 0;

        g.loadAnimation.load('animations_json/arrow', 'arrow', onLoadDB);
        g.loadAnimation.load('animations_json/chest_interface', 'chest_interface', onLoadDB);
        g.loadAnimation.load('animations_json/order_window', 'order_window', onLoadDB);
        g.loadAnimation.load('animations_json/plot_seller', 'plot_seller', onLoadDB);
        g.loadAnimation.load('animations_json/preloader_2', 'preloader_2', onLoadDB);
        g.loadAnimation.load('animations_json/visit_preloader', 'visit_preloader', onLoadDB);
        g.loadAnimation.load('animations_json/explode_gray_fabric', 'explode_gray_fabric', onLoadDB);
        g.loadAnimation.load('animations_json/add_coins', 'add_coins', onLoadDB);

    }

    private function onLoadDB():void {
        count++;
        g.startPreloader.setProgress(48 + count*2);
        if (count >=8) {
            loadDBX();
        }
    }

    private function loadDBX():void {
        g.startPreloader.setProgress(60);
        count = 0;

        g.loadAnimation.load('animations_json/x1/bfly', 'bfly', onLoadDB_X);
        g.loadAnimation.load('animations_json/x1/cat_main', 'cat_main', onLoadDB_X);
        g.loadAnimation.load('animations_json/x1/cat_watering_can', 'cat_watering_can', onLoadDB_X);
        g.loadAnimation.load('animations_json/x1/cat_feed', 'cat_feed', onLoadDB_X);
        g.loadAnimation.load('animations_json/x1/cat_queue', 'cat_queue', onLoadDB_X);
        g.loadAnimation.load('animations_json/x1/explode', 'explode', onLoadDB_X);
        g.loadAnimation.load('animations_json/x1/explode_an', 'explode_an', onLoadDB_X);
        g.loadAnimation.load('animations_json/x1/explode_gray', 'explode_gray', onLoadDB_X);
        g.loadAnimation.load('animations_json/x1/plant', 'plant', onLoadDB_X);
        g.loadAnimation.load('animations_json/x1/tools', 'tools', onLoadDB_X);
    }

    private function onLoadDB_X():void {
        count++;
        g.startPreloader.setProgress(60 + 2*count);
        if (count >=10) {
            loadHitArea();
        }
    }

    private function loadHitArea():void {
        var url:String = g.dataPath.getGraphicsPath() + 'hitArea.swf';
        g.load.loadSWFModule(url, loadedHitArea);

    }

    private function loadedHitArea(response:ApplicationDomain):void {
        g.startPreloader.setProgress(83);
        g.managerHitArea.registerLoadedHitArea(response);
        if (_callback != null) _callback.apply();
    }
}
}
