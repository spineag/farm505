/**
 * Created by andriy.grynkiv on 1/2/15.
 */
package manager {

import dragonBones.factories.StarlingFactory;

import flash.events.Event;

import flash.text.Font;

import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class EmbedAssets {
    // Texture
    [Embed(source="../../assets/mapAtlas3.png")]
    private const MapTexture:Class;
    [Embed(source="../../assets/buildAtlas.png")]
    private const BuildTexture:Class;
    [Embed(source="../../assets/plants.png")]
    private const PlantTexture:Class;
    [Embed(source="../../assets/interfaceAtlas.png")]
    private const InterfaceTexture:Class;
    [Embed(source="../../assets/instrumentAtlas3.png")]
    private const InstrumentTexture:Class;
    [Embed(source="../../assets/resourceAtlas.png")]
    private const ResourceTexture:Class;
    [Embed(source="../../assets/cats3.png")]
    private const CatTexture:Class;
    [Embed(source="../../assets/wildAtlas3.png")]
    private const WildTexture:Class;
    [Embed(source="../../assets/farmAtlas3.png")]
    private const FarmTexture:Class;
    [Embed(source="../../assets/decorAtlas.png")]
    private const DecorTexture:Class;
    [Embed(source="../../assets/iconAtlas.png")]
    private const IconTexture:Class;

    // XML
    [Embed(source="../../assets/mapAtlas3.xml", mimeType="application/octet-stream")]
    private const MapTextureXML:Class;
    [Embed(source="../../assets/buildAtlas.xml", mimeType="application/octet-stream")]
    private const BuildTextureXML:Class;
    [Embed(source="../../assets/plants.xml", mimeType="application/octet-stream")]
    private const PlantTextureXML:Class;
    [Embed(source="../../assets/interfaceAtlas.xml", mimeType="application/octet-stream")]
    private const InterfaceTextureXML:Class;
    [Embed(source="../../assets/instrumentAtlas3.xml", mimeType="application/octet-stream")]
    private const InstrumentTextureXML:Class;
    [Embed(source="../../assets/resourceAtlas.xml", mimeType="application/octet-stream")]
    private const ResourceTextureXML:Class;
    [Embed(source="../../assets/cats3.xml", mimeType="application/octet-stream")]
    private const CatTextureXML:Class;
    [Embed(source="../../assets/wildAtlas3.xml", mimeType="application/octet-stream")]
    private const WildTextureXML:Class;
    [Embed(source="../../assets/farmAtlas3.xml", mimeType="application/octet-stream")]
    private const FarmTextureXML:Class;
    [Embed(source="../../assets/decorAtlas.xml", mimeType="application/octet-stream")]
    private const DecorTextureXML:Class;
    [Embed(source="../../assets/iconAtlas.xml", mimeType="application/octet-stream")]
    private const IconTextureXML:Class;

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

    [Embed(source = "../../assets/animations/cat9.png", mimeType = "application/octet-stream")]
    private const CatData:Class;
    [Embed(source = "../../assets/animations/buildingBuild.png", mimeType = "application/octet-stream")]
    private const BuildingBuild:Class;
    [Embed(source = "../../assets/animations/trees2.png", mimeType = "application/octet-stream")]
    private const BuildingTrees:Class;

    [Embed(source = "../../assets/animations/beehive.png", mimeType = "application/octet-stream")]
    private const Beehive:Class;
    [Embed(source = "../../assets/animations/chicken.png", mimeType = "application/octet-stream")]
    private const Chicken:Class;
    [Embed(source = "../../assets/animations/cow.png", mimeType = "application/octet-stream")]
    private const Cow:Class;
    [Embed(source = "../../assets/animations/pig.png", mimeType = "application/octet-stream")]
    private const Pig:Class;
    [Embed(source = "../../assets/animations/sheep.png", mimeType = "application/octet-stream")]
    private const Sheep:Class;

    private var g:Vars = Vars.getInstance();

    public function EmbedAssets(onLoadCallback:Function) {
        createTexture(onLoadCallback);
    }

    private function createTexture(onLoadCallback:Function):void {
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

        texture = Texture.fromBitmap(new IconTexture());
        xml= XML(new IconTextureXML());
        g.allData.atlas['iconAtlas'] = new TextureAtlas(texture, xml);

        g.allData.fonts['BloggerBold'] = (new BloggerBold() as Font).fontName;
        g.allData.fonts['BloggerItalic'] = (new BloggerItalic() as Font).fontName;
        g.allData.fonts['BloggerLight'] = (new BloggerLight() as Font).fontName;
        g.allData.fonts['BloggerRegular'] = (new BloggerRegular() as Font).fontName;
        g.allData.fonts['BloggerMedium'] = (new BloggerMedium() as Font).fontName;
        g.allData.fonts['HouschkaBold'] = (new HouschkaBold() as Font).fontName;




        var count:int = 8;
        var factoryTree:StarlingFactory = new StarlingFactory();
        var fTree:Function = function (e:Event):void {
            g.allData.factory['tree'] = factoryTree;
            count--;
            if (count <= 0) {
                if (onLoadCallback != null) {
                    onLoadCallback.apply();
                    onLoadCallback = null;
                }
            }
        };
        factoryTree.addEventListener(Event.COMPLETE, fTree);
        factoryTree.parseData(new BuildingTrees());

        var factoryCat:StarlingFactory = new StarlingFactory();
        var fCat:Function = function (e:Event):void {
            g.allData.factory['cat'] = factoryCat;
            count--;
            if (count <= 0) {
                if (onLoadCallback != null) {
                    onLoadCallback.apply();
                    onLoadCallback = null;
                }
            }
        };
        factoryCat.addEventListener(Event.COMPLETE, fCat);
        factoryCat.parseData(new CatData());

        var factoryBuild:StarlingFactory = new StarlingFactory();
        var fBuild:Function = function (e:Event):void {
            g.allData.factory['buildingBuild'] = factoryBuild;
            count--;
            if (count <= 0) {
                if (onLoadCallback != null) {
                    onLoadCallback.apply();
                    onLoadCallback = null;
                }
            }
        };
        factoryBuild.addEventListener(Event.COMPLETE, fBuild);
        factoryBuild.parseData(new BuildingBuild());

        var factoryBeehive:StarlingFactory = new StarlingFactory();
        var fBee:Function = function (e:Event):void {
            g.allData.factory['beehive'] = factoryBeehive;
            count--;
            if (count <= 0) {
                if (onLoadCallback != null) {
                    onLoadCallback.apply();
                    onLoadCallback = null;
                }
            }
        };
        factoryBeehive.addEventListener(Event.COMPLETE, fBee);
        factoryBeehive.parseData(new Beehive());

        var factoryChicken:StarlingFactory = new StarlingFactory();
        var fChicken:Function = function (e:Event):void {
            g.allData.factory['chicken'] = factoryChicken;
            count--;
            if (count <= 0) {
                if (onLoadCallback != null) {
                    onLoadCallback.apply();
                    onLoadCallback = null;
                }
            }
        };
        factoryChicken.addEventListener(Event.COMPLETE, fChicken);
        factoryChicken.parseData(new Chicken());

        var factoryCow:StarlingFactory = new StarlingFactory();
        var fCow:Function = function (e:Event):void {
            g.allData.factory['cow'] = factoryCow;
            count--;
            if (count <= 0) {
                if (onLoadCallback != null) {
                    onLoadCallback.apply();
                    onLoadCallback = null;
                }
            }
        };
        factoryCow.addEventListener(Event.COMPLETE, fCow);
        factoryCow.parseData(new Cow());

        var factoryPig:StarlingFactory = new StarlingFactory();
        var fPig:Function = function (e:Event):void {
            g.allData.factory['pig'] = factoryPig;
            count--;
            if (count <= 0) {
                if (onLoadCallback != null) {
                    onLoadCallback.apply();
                    onLoadCallback = null;
                }
            }
        };
        factoryPig.addEventListener(Event.COMPLETE, fPig);
        factoryPig.parseData(new Pig());

        var factorySheep:StarlingFactory = new StarlingFactory();
        var fSheep:Function = function (e:Event):void {
            g.allData.factory['sheep'] = factorySheep;
            count--;
            if (count <= 0) {
                if (onLoadCallback != null) {
                    onLoadCallback.apply();
                    onLoadCallback = null;
                }
            }
        };
        factorySheep.addEventListener(Event.COMPLETE, fSheep);
        factorySheep.parseData(new Sheep());
    }
}
}
