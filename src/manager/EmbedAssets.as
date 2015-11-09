/**
 * Created by andriy.grynkiv on 1/2/15.
 */
package manager {

import flash.text.Font;

import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class EmbedAssets {
    // Texture
    [Embed(source="../../assets/mapAtlas3.png")]
    private const MapTexture:Class;
    [Embed(source="../../assets/buildAtlas3.png")]
    private const BuildTexture:Class;
    [Embed(source="../../assets/plants3.png")]
    private const PlantTexture:Class;
    [Embed(source="../../assets/interfaceAtlas2.png")]
    private const InterfaceTexture:Class;
    [Embed(source="../../assets/instrumentAtlas3.png")]
    private const InstrumentTexture:Class;
    [Embed(source="../../assets/resourceAtlas3.png")]
    private const ResourceTexture:Class;
    [Embed(source="../../assets/treeAtlas3.png")]
    private const TreeTexture:Class;
    [Embed(source="../../assets/cats3.png")]
    private const CatTexture:Class;
    [Embed(source="../../assets/wildAtlas3.png")]
    private const WildTexture:Class;
    [Embed(source="../../assets/farmAtlas3.png")]
    private const FarmTexture:Class;
    [Embed(source="../../assets/decorAtlas3.png")]
    private const DecorTexture:Class;

    // XML
    [Embed(source="../../assets/mapAtlas3.xml", mimeType="application/octet-stream")]
    private const MapTextureXML:Class;
    [Embed(source="../../assets/buildAtlas3.xml", mimeType="application/octet-stream")]
    private const BuildTextureXML:Class;
    [Embed(source="../../assets/plants3.xml", mimeType="application/octet-stream")]
    private const PlantTextureXML:Class;
    [Embed(source="../../assets/interfaceAtlas.xml", mimeType="application/octet-stream")]
    private const InterfaceTextureXML:Class;
    [Embed(source="../../assets/instrumentAtlas3.xml", mimeType="application/octet-stream")]
    private const InstrumentTextureXML:Class;
    [Embed(source="../../assets/resourceAtlas3.xml", mimeType="application/octet-stream")]
    private const ResourceTextureXML:Class;
    [Embed(source="../../assets/treeAtlas3.xml", mimeType="application/octet-stream")]
    private const TreeTextureXML:Class;
    [Embed(source="../../assets/cats3.xml", mimeType="application/octet-stream")]
    private const CatTextureXML:Class;
    [Embed(source="../../assets/wildAtlas3.xml", mimeType="application/octet-stream")]
    private const WildTextureXML:Class;
    [Embed(source="../../assets/farmAtlas3.xml", mimeType="application/octet-stream")]
    private const FarmTextureXML:Class;
    [Embed(source="../../assets/decorAtlas3.xml", mimeType="application/octet-stream")]
    private const DecorTextureXML:Class;

    [Embed(source="../../assets/fonts/BloggerSansBold.otf", embedAsCFF="false", fontName="BloggerBold")]
    private const BloggerBold:Class;
    [Embed(source="../../assets/fonts/BloggerSansItalic.otf", embedAsCFF="false", fontName="BloggerItalic")]
    private const BloggerItalic:Class;
    [Embed(source="../../assets/fonts/BloggerSansLightRegular.otf", embedAsCFF="false", fontName="BloggerLight")]
    private const BloggerLight:Class;
    [Embed(source="../../assets/fonts/BloggerSansMediumRegular.otf", embedAsCFF="false", fontName="BloggerMedium")]
    private const BloggerMedium:Class;
    [Embed(source="../../assets/fonts/BloggerSansRegular.otf", embedAsCFF="false", fontName="BloggerRegular")]
    private const BloggerRegular:Class;
    [Embed(source="../../assets/fonts/HouschkaRoundedBoldRegular.otf", embedAsCFF="false", fontName="HouschkaBold")]
    private const HouschkaBold:Class;

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

        g.allData.fonts['BloggerBold'] = (new BloggerBold() as Font).fontName;
        g.allData.fonts['BloggerItalic'] = (new BloggerItalic() as Font).fontName;
        g.allData.fonts['BloggerLight'] = (new BloggerLight() as Font).fontName;
        g.allData.fonts['BloggerRegular'] = (new BloggerRegular() as Font).fontName;
        g.allData.fonts['BloggerMedium'] = (new BloggerMedium() as Font).fontName;
        g.allData.fonts['HouschkaBold'] = (new HouschkaBold() as Font).fontName;
    }
}
}
