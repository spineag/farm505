/**
 * Created by andriy.grynkiv on 1/2/15.
 */
package loaders {
import data.AllData;

import manager.*;

import dragonBones.factories.StarlingFactory;
import flash.events.Event;
import flash.text.Font;

public class EmbedAssets {
    // Texture
//    [Embed(source="../../assets/interfaceAtlas.png")]
//    private const InterfaceTexture:Class;
//    [Embed(source="../../assets/instrumentAtlas.png")]
//    private const InstrumentTexture:Class;

    // XML
//    [Embed(source="../../assets/interfaceAtlas.xml", mimeType="application/octet-stream")]
//    private const InterfaceTextureXML:Class;
//    [Embed(source="../../assets/instrumentAtlas.xml", mimeType="application/octet-stream")]
//    private const InstrumentTextureXML:Class;

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

    [Embed(source="../../assets/animations/x1/cat_tutorial.png", mimeType = "application/octet-stream")]
    private const CatTutorial:Class;
    [Embed(source="../../assets/animations/x1/cat_tutorial_big.png", mimeType = "application/octet-stream")]
    private const CatTutorialBig:Class;

    private var g:Vars = Vars.getInstance();

    public function EmbedAssets(onLoadCallback:Function) {
        createTexture(onLoadCallback);
    }

    private function createTexture(onLoadCallback:Function):void {
        g.allData = new AllData();

//        var texture:Texture = Texture.fromBitmap(new ResourceTexture());
//        var xml:XML= XML(new ResourceTextureXML());
//        g.allData.atlas['resourceAtlas'] = new TextureAtlas(texture, xml);
//        texture = Texture.fromBitmap(new BuildTexture());
//        xml= XML(new BuildTextureXML());
//        g.allData.atlas['buildAtlas'] = new TextureAtlas(texture, xml);

        g.allData.fonts['BloggerBold'] = (new BloggerBold() as Font).fontName;
        g.allData.fonts['BloggerItalic'] = (new BloggerItalic() as Font).fontName;
        g.allData.fonts['BloggerLight'] = (new BloggerLight() as Font).fontName;
        g.allData.fonts['BloggerRegular'] = (new BloggerRegular() as Font).fontName;
        g.allData.fonts['BloggerMedium'] = (new BloggerMedium() as Font).fontName;
        g.allData.fonts['HouschkaBold'] = (new HouschkaBold() as Font).fontName;

        var count:int = 2;
        var checkCount:Function = function ():void {
            count--;
            if (count <= 0) {
                if (onLoadCallback != null) {
                    onLoadCallback.apply();
                    onLoadCallback = null;
                }
            }
        };
        loadFactory('tutorialCat', CatTutorial, checkCount);
        loadFactory('tutorialCatBig', CatTutorialBig, checkCount);
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
