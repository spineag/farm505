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
    [Embed(source="../../assets/interfaceAtlas.png")]
    private const InterfaceTexture:Class;
    [Embed(source="../../assets/instrumentAtlas3.png")]
    private const InstrumentTexture:Class;
    [Embed(source="../../assets/resourceAtlas.png")]
    private const ResourceTexture:Class;
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
    [Embed(source="../../assets/interfaceAtlas.xml", mimeType="application/octet-stream")]
    private const InterfaceTextureXML:Class;
    [Embed(source="../../assets/instrumentAtlas3.xml", mimeType="application/octet-stream")]
    private const InstrumentTextureXML:Class;
    [Embed(source="../../assets/resourceAtlas.xml", mimeType="application/octet-stream")]
    private const ResourceTextureXML:Class;
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
    [Embed(source = "../../assets/animations/cat_watering_can.png", mimeType = "application/octet-stream")]
    private const CatWateringData:Class;
    [Embed(source = "../../assets/animations/cat_feed.png", mimeType = "application/octet-stream")]
    private const CatFeedData:Class;
    [Embed(source = "../../assets/animations/buildingBuild.png", mimeType = "application/octet-stream")]
    private const BuildingBuild:Class;
    [Embed(source = "../../assets/animations/trees2.png", mimeType = "application/octet-stream")]
    private const BuildingTrees:Class;
    [Embed(source = "../../assets/animations/plants.png", mimeType = "application/octet-stream")]
    private const BuildingPlants:Class;

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

    [Embed(source = "../../assets/animations/bakery.png", mimeType = "application/octet-stream")]
    private const BakeryFabrica:Class;
    [Embed(source = "../../assets/animations/sugar_mill.png", mimeType = "application/octet-stream")]
    private const SugarMillFabrica:Class;
    [Embed(source = "../../assets/animations/feed_mill.png", mimeType = "application/octet-stream")]
    private const FeedMillFabrica:Class;
    [Embed(source = "../../assets/animations/bbq_grill.png", mimeType = "application/octet-stream")]
    private const BbqGrillFabrica:Class;
    [Embed(source = "../../assets/animations/dairy.png", mimeType = "application/octet-stream")]
    private const DairyFabrica:Class;
    [Embed(source = "../../assets/animations/pie_oven.png", mimeType = "application/octet-stream")]
    private const PieOvenFabrica:Class;
    [Embed(source = "../../assets/animations/juice_press.png", mimeType = "application/octet-stream")]
    private const JuicePressFabrica:Class;
    [Embed(source = "../../assets/animations/loom.png", mimeType = "application/octet-stream")]
    private const LoomFabrica:Class;
    [Embed(source = "../../assets/animations/pizza_maker.png", mimeType = "application/octet-stream")]
    private const PizzaMakerFabrica:Class;
    [Embed(source = "../../assets/animations/smelter.png", mimeType = "application/octet-stream")]
    private const SmelterFabrica:Class;
    [Embed(source = "../../assets/animations/smoke_house.png", mimeType = "application/octet-stream")]
    private const SmokeHouseFabrica:Class;
    [Embed(source = "../../assets/animations/mine.png", mimeType = "application/octet-stream")]
    private const Cave:Class;
    [Embed(source = "../../assets/animations/wheel_of_fortune.png", mimeType = "application/octet-stream")]
    private const DailyBonus:Class;
    [Embed(source = "../../assets/animations/aerial_tram.png", mimeType = "application/octet-stream")]
    private const AerialTram:Class;

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
        texture = Texture.fromBitmap(new InterfaceTexture());
        xml= XML(new InterfaceTextureXML());
        g.allData.atlas['interfaceAtlas'] = new TextureAtlas(texture, xml);
        texture = Texture.fromBitmap(new InstrumentTexture());
        xml= XML(new InstrumentTextureXML());
        g.allData.atlas['instrumentAtlas'] = new TextureAtlas(texture, xml);
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

        var count:int = 25;
        var checkCount:Function = function ():void {
            count--;
            if (count <= 0) {
                if (onLoadCallback != null) {
                    onLoadCallback.apply();
                    onLoadCallback = null;
                }
            }
        };

        loadFactory('tree', BuildingTrees, checkCount);
        loadFactory('plant', BuildingPlants, checkCount);
        loadFactory('cat', CatData, checkCount);
        loadFactory('cat_watering', CatWateringData, checkCount);
        loadFactory('cat_feed', CatFeedData, checkCount);
        loadFactory('buildingBuild', BuildingBuild, checkCount);
        loadFactory('beehive', Beehive, checkCount);
        loadFactory('chicken', Chicken, checkCount);
        loadFactory('cow', Cow, checkCount);
        loadFactory('pig', Pig, checkCount);
        loadFactory('sheep', Sheep, checkCount);
        loadFactory('bakery', BakeryFabrica, checkCount);
        loadFactory('sugar_mill', SugarMillFabrica, checkCount);
        loadFactory('feed_mill', FeedMillFabrica, checkCount);
        loadFactory('bbq_grill', BbqGrillFabrica, checkCount);
        loadFactory('dairy', DairyFabrica, checkCount);
        loadFactory('pie_oven', PieOvenFabrica, checkCount);
        loadFactory('juice_press', JuicePressFabrica, checkCount);
        loadFactory('loom', LoomFabrica, checkCount);
        loadFactory('pizza_maker', PizzaMakerFabrica, checkCount);
        loadFactory('smelter', SmelterFabrica, checkCount);
        loadFactory('smoke_house', SmokeHouseFabrica, checkCount);
        loadFactory('cave', Cave, checkCount);
        loadFactory('daily_bonus', DailyBonus, checkCount);
        loadFactory('train', AerialTram, checkCount);
    }

    private function loadFactory(name:String, clas:Class, onLoad:Function):void {
        var factory:StarlingFactory = new StarlingFactory();
        var f:Function = function (e:Event):void {
            factory.removeEventListener(Event.COMPLETE, f);
            g.allData.factory[name] = factory;
            if (onLoad != null) onLoad.apply();
        };
        factory.addEventListener(Event.COMPLETE, f);
        factory.parseData(new clas());
    }
}
}
