/**
 * Created by user on 2/2/17.
 */
package manager {
import flash.display.Bitmap;

import loaders.PBitmap;

import starling.textures.Texture;
import starling.textures.TextureAtlas;

import windows.WindowsManager;

public class ManagerPartyNew {
    private var g:Vars = Vars.getInstance();
    private var count:int = 0;
    public var dataParty:Object;
    public var userParty:Object;

    public function ManagerPartyNew() {


    }

    private function onLoad(smth:*=null):void {
        count++;
        if (count >=2) createAtlases();
    }

    public function atlasLoad():void {
//        if (g.manager)
        g.load.loadImage(g.dataPath.getGraphicsPath() + 'partyAtlas.png' + g.getVersion('partyAtlas'), onLoad);
        g.load.loadXML(g.dataPath.getGraphicsPath() + 'partyAtlas.xml' + g.getVersion('partyAtlas'), onLoad);
    }

    private function createAtlases():void {
        g.allData.atlas['partyAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[g.dataPath.getGraphicsPath() + 'partyAtlas.png' + g.getVersion('partyAtlas')].create() as Bitmap), g.pXMLs[g.dataPath.getGraphicsPath() + 'partyAtlas.xml' + g.getVersion('partyAtlas')]);
        (g.pBitmaps[g.dataPath.getGraphicsPath() + 'partyAtlas.png' + g.getVersion('partyAtlas')] as PBitmap).deleteIt();
        g.party();
        delete  g.pBitmaps[g.dataPath.getGraphicsPath() + 'partyAtlas.png' + g.getVersion('partyAtlas')];
        delete  g.pXMLs[g.dataPath.getGraphicsPath() + 'partyAtlas.xml' + g.getVersion('partyAtlas')];
    }

}
}
