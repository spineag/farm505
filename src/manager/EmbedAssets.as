/**
 * Created by andriy.grynkiv on 1/2/15.
 */
package manager {

import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class EmbedAssets
{
    // Texture
    [Embed(source="../../assets/mapAtlas.png")]
    public static const MapTexture:Class;
//    [Embed(source="../../assets/stadium_page.png")]
//    public static const GameTexture:Class;

    // XML
    [Embed(source="../../assets/mapAtlas.xml", mimeType="application/octet-stream")]
    public static const MapTextureXML:Class;
//    [Embed(source="../../assets/stadium_page.xml", mimeType="application/octet-stream")]
//    public static const GameTextureXML:Class;

    private var g:Vars = Vars.getInstance();

    public function EmbedAssets() {
        createTexture();
    }

    private function createTexture():void {
        var texture:Texture = Texture.fromBitmap(new MapTexture());
        var xml:XML = XML(new MapTextureXML());
        var atlas:TextureAtlas = new TextureAtlas(texture, xml);

        g.mapAtlas = atlas;

//        texture = Texture.fromBitmap(new GameTexture());
//        xml = XML(new GameTextureXML());
//        atlas = new TextureAtlas(texture, xml);
//
//        g.gameAtlas = atlas;
    }

   }
}
