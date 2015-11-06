/**
 * Created by andriy.grynkiv on 1/2/15.
 */
package manager {

import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class EmbedAssets {
    // Texture
    [Embed(source="../../assets/mapAtlas3.png")]
    public static const MapTexture:Class;
    [Embed(source="../../assets/buildAtlas3.png")]
    public static const BuildTexture:Class;
    [Embed(source="../../assets/plants3.png")]
    public static const PlantTexture:Class;
    [Embed(source="../../assets/interfaceAtlas.png")]
    public static const InterfaceTexture:Class;
    [Embed(source="../../assets/instrumentAtlas3.png")]
    public static const InstrumentTexture:Class;
    [Embed(source="../../assets/resourceAtlas3.png")]
    public static const ResourceTexture:Class;
    [Embed(source="../../assets/treeAtlas3.png")]
    public static const TreeTexture:Class;
    [Embed(source="../../assets/cats3.png")]
    public static const CatTexture:Class;
    [Embed(source="../../assets/wildAtlas3.png")]
    public static const WildTexture:Class;
    [Embed(source="../../assets/farmAtlas3.png")]
    public static const FarmTexture:Class;
    [Embed(source="../../assets/decorAtlas3.png")]
    public static const DecorTexture:Class;

    // XML
    [Embed(source="../../assets/mapAtlas3.xml", mimeType="application/octet-stream")]
    public static const MapTextureXML:Class;
    [Embed(source="../../assets/buildAtlas3.xml", mimeType="application/octet-stream")]
    public static const BuildTextureXML:Class;
    [Embed(source="../../assets/plants3.xml", mimeType="application/octet-stream")]
    public static const PlantTextureXML:Class;
    [Embed(source="../../assets/interfaceAtlas.xml", mimeType="application/octet-stream")]
    public static const InterfaceTextureXML:Class;
    [Embed(source="../../assets/instrumentAtlas3.xml", mimeType="application/octet-stream")]
    public static const InstrumentTextureXML:Class;
    [Embed(source="../../assets/resourceAtlas3.xml", mimeType="application/octet-stream")]
    public static const ResourceTextureXML:Class;
    [Embed(source="../../assets/treeAtlas3.xml", mimeType="application/octet-stream")]
    public static const TreeTextureXML:Class;
    [Embed(source="../../assets/cats3.xml", mimeType="application/octet-stream")]
    public static const CatTextureXML:Class;
    [Embed(source="../../assets/wildAtlas3.xml", mimeType="application/octet-stream")]
    public static const WildTextureXML:Class;
    [Embed(source="../../assets/farmAtlas3.xml", mimeType="application/octet-stream")]
    public static const FarmTextureXML:Class;
    [Embed(source="../../assets/decorAtlas3.xml", mimeType="application/octet-stream")]
    public static const DecorTextureXML:Class;

    private var g:Vars = Vars.getInstance();

    public function EmbedAssets() {
        createTexture();
    }

    private function createTexture():void {
        g.allData = new AllData();

        var texture:Texture = Texture.fromBitmap(new MapTexture());
        var xml:XML = XML(new MapTextureXML());
        g.allData.atlas['mapAtlas'] = new TextureAtlas(texture, xml);

        texture = Texture.fromBitmap(new ResourceTexture());
        xml= XML(new ResourceTextureXML());
        g.allData.atlas['resourceAtlas'] = new TextureAtlas(texture, xml);

        texture = Texture.fromBitmap(new BuildTexture());
        xml= XML(new BuildTextureXML());
        g.allData.atlas['buildAtlas'] = new TextureAtlas(texture, xml);

        texture = Texture.fromBitmap(new PlantTexture());
        xml= XML(new PlantTextureXML());
        g.allData.atlas['plantAtlas'] = new TextureAtlas(texture, xml);

        texture = Texture.fromBitmap(new InterfaceTexture());
        xml= XML(new InterfaceTextureXML());
        g.allData.atlas['interfaceAtlas'] = new TextureAtlas(texture, xml);

        texture = Texture.fromBitmap(new InstrumentTexture());
        xml= XML(new InstrumentTextureXML());
        g.allData.atlas['instrumentAtlas'] = new TextureAtlas(texture, xml);

        texture = Texture.fromBitmap(new TreeTexture());
        xml= XML(new TreeTextureXML());
        g.allData.atlas['treeAtlas'] = new TextureAtlas(texture, xml);

        texture = Texture.fromBitmap(new CatTexture());
        xml= XML(new CatTextureXML());
        g.allData.atlas['catAtlas'] = new TextureAtlas(texture, xml);

        texture = Texture.fromBitmap(new WildTexture());
        xml= XML(new WildTextureXML());
        g.allData.atlas['wildAtlas'] = new TextureAtlas(texture, xml);

        texture = Texture.fromBitmap(new FarmTexture());
        xml= XML(new FarmTextureXML());
        g.allData.atlas['farmAtlas'] = new TextureAtlas(texture, xml);

        texture = Texture.fromBitmap(new DecorTexture());
        xml= XML(new DecorTextureXML());
        g.allData.atlas['decorAtlas'] = new TextureAtlas(texture, xml);
    }
}
}
