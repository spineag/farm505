/**
 * Created by user on 2/15/17.
 */
package manager {
import flash.display.Bitmap;

import loaders.PBitmap;

import starling.textures.Texture;

import starling.textures.TextureAtlas;

public class ManagerSalePack {
    public var dataSale:Object;
    private var g:Vars = Vars.getInstance();
    private var count:int = 0;
    public function ManagerSalePack() {
        g.directServer.getDataSalePack(startSalePack)
    }

    private function startSalePack():void {
        if (!g.user.salePack && g.userTimer.saleTimerToEnd > 0 && (g.managerSalePack.dataSale.timeToStart  - int(new Date().getTime() / 1000)) <= 0 && g.user.level >= 6 && g.user.isTester) {
            atlasLoad();
            g.createSaleUi();
        }
    }

    public function sartAfterSaleTimer():void {
        if (g.userTimer.saleTimerToStart <= 0 && g.user.level >= 6 && g.user.isTester) {
            atlasLoad();
            g.userTimer.saleToEnd(g.managerSalePack.dataSale.timeToEnd - int(new Date().getTime() / 1000));
            g.createSaleUi();
        }
    }

    private function onLoad(smth:*=null):void {
        count++;
        if (count >=2) createAtlases();
    }

    public function atlasLoad():void {
        if (!g.allData.atlas['saleAtlas']) {
            g.load.loadImage(g.dataPath.getGraphicsPath() + 'saleAtlas.png' + g.getVersion('saleAtlas'), onLoad);
            g.load.loadXML(g.dataPath.getGraphicsPath() + 'saleAtlas.xml' + g.getVersion('saleAtlas'), onLoad);
        }
    }

    private function createAtlases():void {
        g.allData.atlas['saleAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[g.dataPath.getGraphicsPath() + 'saleAtlas.png' + g.getVersion('saleAtlas')].create() as Bitmap), g.pXMLs[g.dataPath.getGraphicsPath() + 'saleAtlas.xml' + g.getVersion('saleAtlas')]);
        (g.pBitmaps[g.dataPath.getGraphicsPath() + 'saleAtlas.png' + g.getVersion('saleAtlas')] as PBitmap).deleteIt();
        delete  g.pBitmaps[g.dataPath.getGraphicsPath() + 'saleAtlas.png' + g.getVersion('saleAtlas')];
        delete  g.pXMLs[g.dataPath.getGraphicsPath() + 'saleAtlas.xml' + g.getVersion('saleAtlas')];
    }
}
}
