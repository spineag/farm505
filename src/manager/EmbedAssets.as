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
    [Embed(source="../../assets/plants.png")]
    public static const PlantTexture:Class;
    [Embed(source="../../assets/interfaceAtlas.png")]
    public static const InterfaceTexture:Class;
    [Embed(source="../../assets/instrumentAtlas.png")]
    public static const InstrumentTexture:Class;
    [Embed(source="../../assets/resourceAtlas.png")]
    public static const ResourceTexture:Class;
    [Embed(source="../../assets/treeAtlas.png")]
    public static const TreeTexture:Class;

    // XML
    [Embed(source="../../assets/mapAtlas.xml", mimeType="application/octet-stream")]
    public static const MapTextureXML:Class;
    [Embed(source="../../assets/buildAndTree.xml", mimeType="application/octet-stream")]
    public static const BuildTextureXML:Class;
    [Embed(source="../../assets/plants.xml", mimeType="application/octet-stream")]
    public static const PlantTextureXML:Class;
    [Embed(source="../../assets/interfaceAtlas.xml", mimeType="application/octet-stream")]
    public static const InterfaceTextureXML:Class;
    [Embed(source="../../assets/instrumentAtlas.xml", mimeType="application/octet-stream")]
    public static const InstrumentTextureXML:Class;
    [Embed(source="../../assets/resourceAtlas.xml", mimeType="application/octet-stream")]
    public static const ResourceTextureXML:Class;
    [Embed(source="../../assets/treeAtlas.xml", mimeType="application/octet-stream")]
    public static const TreeTextureXML:Class;

    private var g:Vars = Vars.getInstance();

    public function EmbedAssets() {
        createTexture();
    }

    private function createTexture():void {
        var texture:Texture = Texture.fromBitmap(new MapTexture());
        var xml:XML = XML(new MapTextureXML());
        g.mapAtlas = new TextureAtlas(texture, xml);

        texture = Texture.fromBitmap(new ResourceTexture());
        xml= XML(new ResourceTextureXML());
        g.resourceAtlas = new TextureAtlas(texture, xml);

        texture = Texture.fromBitmap(new BuildTexture());
        xml= XML(new BuildTextureXML());
        g.tempBuildAtlas = new TextureAtlas(texture, xml);

        texture = Texture.fromBitmap(new PlantTexture());
        xml= XML(new PlantTextureXML());
        g.plantAtlas = new TextureAtlas(texture, xml);

        texture = Texture.fromBitmap(new InterfaceTexture());
        xml= XML(new InterfaceTextureXML());
        g.interfaceAtlas = new TextureAtlas(texture, xml);

        texture = Texture.fromBitmap(new InstrumentTexture());
        xml= XML(new InstrumentTextureXML());
        g.instrumentAtlas = new TextureAtlas(texture, xml);

        texture = Texture.fromBitmap(new TreeTexture());
        xml= XML(new TreeTextureXML());
        g.treeAtlas = new TextureAtlas(texture, xml);
    }
}
}
