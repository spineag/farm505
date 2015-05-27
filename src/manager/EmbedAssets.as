/**
 * Created by andriy.grynkiv on 1/2/15.
 */
package manager {

import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class EmbedAssets {
    // usual embed
    [Embed(source="../../diff/valey.png")]
    public static const Valey:Class;

    // Texture
    [Embed(source="../../assets/mapAtlas.png")]
    public static const MapTexture:Class;
    [Embed(source="../../assets/buildAndTree.png")]
    public static const BuildTexture:Class;

    // XML
    [Embed(source="../../assets/mapAtlas.xml", mimeType="application/octet-stream")]
    public static const MapTextureXML:Class;
    [Embed(source="../../assets/buildAndTree.xml", mimeType="application/octet-stream")]
    public static const BuildTextureXML:Class;

    private var g:Vars = Vars.getInstance();

    public function EmbedAssets() {
        createTexture();
    }

    private function createTexture():void {
        var texture:Texture = Texture.fromBitmap(new MapTexture());
        var xml:XML = XML(new MapTextureXML());
        g.mapAtlas = new TextureAtlas(texture, xml);

        texture = Texture.fromBitmap(new BuildTexture());
        xml= XML(new BuildTextureXML());
        g.tempBuildAtlas = new TextureAtlas(texture, xml);
    }
}
}
