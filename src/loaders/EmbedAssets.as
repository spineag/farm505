/**
 * Created by andriy.grynkiv on 1/2/15.
 */
package loaders {
import data.AllData;
import dragonBones.starling.StarlingFactory;
import manager.*;
import flash.events.Event;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.textures.Texture;
import starling.textures.TextureSmoothing;

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

//    [Embed(source="../../assets/fonts/BloggerSansBold.otf", embedAsCFF="false", fontName="BloggerBold")]
//    private const BloggerBold:Class;
//    [Embed(source="../../assets/fonts/BloggerSansItalic.otf", embedAsCFF="false", fontName="BloggerItalic")]
//    private const BloggerItalic:Class;
//    [Embed(source="../../assets/fonts/BloggerSansLightRegular.otf", embedAsCFF="false", fontName="BloggerLight")]
//    private const BloggerLight:Class;
//    [Embed(source="../../assets/fonts/BloggerSansMediumRegular.otf", embedAsCFF="false", fontName="BloggerMedium")]
//    private const BloggerMedium:Class;
//    [Embed(source="../../assets/fonts/BloggerSansRegular.otf", embedAsCFF="false", fontName="BloggerRegular")]
//    private const BloggerRegular:Class;
//    [Embed(source="../../assets/fonts/HouschkaRoundedBoldRegular.otf", embedAsCFF="false", fontName="HouschkaBold")]
//    private const HouschkaBold:Class;

    [Embed(source="../../assets/fonts/bitmap/BloggerBoldWhite30-export.png")]
    private const BitmapBloggerBoldWhite30png:Class;
    [Embed(source="../../assets/fonts/bitmap/BloggerBoldWhite30-export.xml", mimeType="application/octet-stream")]
    private const BitmapBloggerBoldWhite30xml:Class;
    [Embed(source="../../assets/fonts/bitmap/BloggerBoldWhite24-export.png")]
    private const BitmapBloggerBoldWhite24png:Class;
    [Embed(source="../../assets/fonts/bitmap/BloggerBoldWhite24-export.xml", mimeType="application/octet-stream")]
    private const BitmapBloggerBoldWhite24xml:Class;
    [Embed(source="../../assets/fonts/bitmap/BloggerBoldWhite18-export.png")]
    private const BitmapBloggerBoldWhite18png:Class;
    [Embed(source="../../assets/fonts/bitmap/BloggerBoldWhite18-export.xml", mimeType="application/octet-stream")]
    private const BitmapBloggerBoldWhite18xml:Class;
    [Embed(source="../../assets/fonts/bitmap/BloggerBoldWhite14-export.png")]
    private const BitmapBloggerBoldWhite14png:Class;
    [Embed(source="../../assets/fonts/bitmap/BloggerBoldWhite14-export.xml", mimeType="application/octet-stream")]
    private const BitmapBloggerBoldWhite14xml:Class;
    [Embed(source="../../assets/fonts/bitmap/BloggerMediumWhite30-export.png")]
    private const BitmapBloggerMediumWhite30png:Class;
    [Embed(source="../../assets/fonts/bitmap/BloggerMediumWhite30-export.xml", mimeType="application/octet-stream")]
    private const BitmapBloggerMediumWhite30xml:Class;
    [Embed(source="../../assets/fonts/bitmap/BloggerMediumWhite24-export.png")]
    private const BitmapBloggerMediumWhite24png:Class;
    [Embed(source="../../assets/fonts/bitmap/BloggerMediumWhite24-export.xml", mimeType="application/octet-stream")]
    private const BitmapBloggerMediumWhite24xml:Class;
    [Embed(source="../../assets/fonts/bitmap/BloggerMediumWhite18-export.png")]
    private const BitmapBloggerMediumWhite18png:Class;
    [Embed(source="../../assets/fonts/bitmap/BloggerMediumWhite18-export.xml", mimeType="application/octet-stream")]
    private const BitmapBloggerMediumWhite18xml:Class;
    [Embed(source="../../assets/fonts/bitmap/BloggerMediumWhite14-export.png")]
    private const BitmapBloggerMediumWhite14png:Class;
    [Embed(source="../../assets/fonts/bitmap/BloggerMediumWhite14-export.xml", mimeType="application/octet-stream")]
    private const BitmapBloggerMediumWhite14xml:Class;
    [Embed(source="../../assets/fonts/bitmap/BloggerRegularWhite30-export.png")]
    private const BitmapBloggerRegularWhite30png:Class;
    [Embed(source="../../assets/fonts/bitmap/BloggerRegularWhite30-export.xml", mimeType="application/octet-stream")]
    private const BitmapBloggerRegularWhite30xml:Class;
    [Embed(source="../../assets/fonts/bitmap/BloggerRegularWhite24-export.png")]
    private const BitmapBloggerRegularWhite24png:Class;
    [Embed(source="../../assets/fonts/bitmap/BloggerRegularWhite24-export.xml", mimeType="application/octet-stream")]
    private const BitmapBloggerRegularWhite24xml:Class;
    [Embed(source="../../assets/fonts/bitmap/BloggerRegularWhite18-export.png")]
    private const BitmapBloggerRegularWhite18png:Class;
    [Embed(source="../../assets/fonts/bitmap/BloggerRegularWhite18-export.xml", mimeType="application/octet-stream")]
    private const BitmapBloggerRegularWhite18xml:Class;
    [Embed(source="../../assets/fonts/bitmap/BloggerRegularWhite14-export.png")]
    private const BitmapBloggerRegularWhite14png:Class;
    [Embed(source="../../assets/fonts/bitmap/BloggerRegularWhite14-export.xml", mimeType="application/octet-stream")]
    private const BitmapBloggerRegularWhite14xml:Class;
    [Embed(source="../../assets/fonts/bitmap/BoldNumbers72-export.png")]
    private const BitmapBloggerBold72png:Class;
    [Embed(source="../../assets/fonts/bitmap/BoldNumbers72-export.xml", mimeType="application/octet-stream")]
    private const BitmapBloggerBold72xml:Class;

    [Embed(source="../../assets/animations/x1/cat_tutorial.png", mimeType = "application/octet-stream")]
    private const CatTutorial:Class;
    [Embed(source="../../assets/animations/x1/cat_tutorial_big.png", mimeType = "application/octet-stream")]
    private const CatTutorialBig:Class;

    private var g:Vars = Vars.getInstance();

    public function EmbedAssets(onLoadCallback:Function) {
        createTexture(onLoadCallback);
        registerFonts();
    }

    private function registerFonts():void {
        //        bFont.smoothing = TextureSmoothing.TRILINEAR;
        var texture:Texture = Texture.fromEmbeddedAsset(BitmapBloggerBoldWhite30png);
        var xml:XML = XML(new BitmapBloggerBoldWhite30xml());
        var bFont:BitmapFont = new BitmapFont(texture, xml);
        bFont.smoothing = TextureSmoothing.TRILINEAR;
        g.allData.bFonts['BloggerBold30'] = bFont;
        TextField.registerBitmapFont(bFont);

        texture = Texture.fromEmbeddedAsset(BitmapBloggerBoldWhite24png);
        xml = XML(new BitmapBloggerBoldWhite24xml());
        bFont = new BitmapFont(texture, xml);
        bFont.smoothing = TextureSmoothing.TRILINEAR;
        g.allData.bFonts['BloggerBold24'] = bFont;
        TextField.registerBitmapFont(bFont);

        texture = Texture.fromEmbeddedAsset(BitmapBloggerBoldWhite18png);
        xml = XML(new BitmapBloggerBoldWhite18xml());
        bFont = new BitmapFont(texture, xml);
        bFont.smoothing = TextureSmoothing.TRILINEAR;
        g.allData.bFonts['BloggerBold18'] = bFont;
        TextField.registerBitmapFont(bFont);

        texture = Texture.fromEmbeddedAsset(BitmapBloggerBoldWhite14png);
        xml = XML(new BitmapBloggerBoldWhite14xml());
        bFont = new BitmapFont(texture, xml);
        bFont.smoothing = TextureSmoothing.TRILINEAR;
        g.allData.bFonts['BloggerBold14'] = bFont;
        TextField.registerBitmapFont(bFont);

        texture = Texture.fromEmbeddedAsset(BitmapBloggerMediumWhite30png);
        xml = XML(new BitmapBloggerMediumWhite30xml());
        bFont = new BitmapFont(texture, xml);
        bFont.smoothing = TextureSmoothing.TRILINEAR;
        g.allData.bFonts['BloggerMedium30'] = bFont;
        TextField.registerBitmapFont(bFont);

        texture = Texture.fromEmbeddedAsset(BitmapBloggerMediumWhite24png);
        xml = XML(new BitmapBloggerMediumWhite24xml());
        bFont = new BitmapFont(texture, xml);
        bFont.smoothing = TextureSmoothing.TRILINEAR;
        g.allData.bFonts['BloggerMedium24'] = bFont;
        TextField.registerBitmapFont(bFont);

        texture = Texture.fromEmbeddedAsset(BitmapBloggerMediumWhite18png);
        xml = XML(new BitmapBloggerMediumWhite18xml());
        bFont = new BitmapFont(texture, xml);
        g.allData.bFonts['BloggerMedium18'] = bFont;
        TextField.registerBitmapFont(bFont);

        texture = Texture.fromEmbeddedAsset(BitmapBloggerMediumWhite14png);
        xml = XML(new BitmapBloggerMediumWhite14xml());
        bFont = new BitmapFont(texture, xml);
        bFont.smoothing = TextureSmoothing.TRILINEAR;
        g.allData.bFonts['BloggerMedium14'] = bFont;
        TextField.registerBitmapFont(bFont);

        texture = Texture.fromEmbeddedAsset(BitmapBloggerRegularWhite30png);
        xml = XML(new BitmapBloggerRegularWhite30xml());
        bFont = new BitmapFont(texture, xml);
        bFont.smoothing = TextureSmoothing.TRILINEAR;
        g.allData.bFonts['BloggerRegular30'] = bFont;
        TextField.registerBitmapFont(bFont);

        texture = Texture.fromEmbeddedAsset(BitmapBloggerRegularWhite24png);
        xml = XML(new BitmapBloggerRegularWhite24xml());
        bFont = new BitmapFont(texture, xml);
        bFont.smoothing = TextureSmoothing.TRILINEAR;
        g.allData.bFonts['BloggerRegular24'] = bFont;
        TextField.registerBitmapFont(bFont);

        texture = Texture.fromEmbeddedAsset(BitmapBloggerRegularWhite18png);
        xml = XML(new BitmapBloggerRegularWhite18xml());
        bFont = new BitmapFont(texture, xml);
        bFont.smoothing = TextureSmoothing.TRILINEAR;
        g.allData.bFonts['BloggerRegular18'] = bFont;
        TextField.registerBitmapFont(bFont);

        texture = Texture.fromEmbeddedAsset(BitmapBloggerRegularWhite14png);
        xml = XML(new BitmapBloggerRegularWhite14xml());
        bFont = new BitmapFont(texture, xml);
        bFont.smoothing = TextureSmoothing.TRILINEAR;
        g.allData.bFonts['BloggerRegular14'] = bFont;
        TextField.registerBitmapFont(bFont);

        texture = Texture.fromEmbeddedAsset(BitmapBloggerBold72png);
        xml = XML(new BitmapBloggerBold72xml());
        bFont = new BitmapFont(texture, xml);
        bFont.smoothing = TextureSmoothing.TRILINEAR;
        g.allData.bFonts['BloggerBold72'] = bFont;
        TextField.registerBitmapFont(bFont);
    }

    private function createTexture(onLoadCallback:Function):void {
        g.allData = new AllData();

//        var texture:Texture = Texture.fromBitmap(new ResourceTexture());
//        var xml:XML= XML(new ResourceTextureXML());
//        g.allData.atlas['resourceAtlas'] = new TextureAtlas(texture, xml);
//        texture = Texture.fromBitmap(new BuildTexture());
//        xml= XML(new BuildTextureXML());
//        g.allData.atlas['buildAtlas'] = new TextureAtlas(texture, xml);

//        g.allData.fonts['BloggerBold'] = (new BloggerBold() as Font).fontName;
//        g.allData.fonts['BloggerItalic'] = (new BloggerItalic() as Font).fontName;
//        g.allData.fonts['BloggerLight'] = (new BloggerLight() as Font).fontName;
//        g.allData.fonts['BloggerRegular'] = (new BloggerRegular() as Font).fontName;
//        g.allData.fonts['BloggerMedium'] = (new BloggerMedium() as Font).fontName;
//        g.allData.fonts['HouschkaBold'] = (new HouschkaBold() as Font).fontName;

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
        factory.parseDragonBonesData(new clas());
    }
}
}
