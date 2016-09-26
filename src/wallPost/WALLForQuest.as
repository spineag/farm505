/**
 * Created by user on 5/31/16.
 */
package wallPost {
import flash.display.Bitmap;
import flash.display.StageDisplayState;
import flash.geom.Rectangle;
import manager.Vars;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

public class WALLForQuest {
    protected var g:Vars = Vars.getInstance();
    private var _source:Sprite;

    public function WALLForQuest() {
        _source = new Sprite();
    }

    public function showItParams(callback:Function, params:Array):void {
        if (Starling.current.nativeStage.displayState != StageDisplayState.NORMAL) {
            Starling.current.nativeStage.displayState = StageDisplayState.NORMAL;
            Starling.current.viewPort = new Rectangle(0, 0, Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight);
            g.starling.stage.stageWidth = Starling.current.nativeStage.stageWidth;
            g.starling.stage.stageHeight = Starling.current.nativeStage.stageHeight;
        }
        var st:String = g.dataPath.getGraphicsPath();
        g.load.loadImage(st + 'wall/quest_posting.jpg',onLoad);
    }

    private function onLoad(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + 'wall/quest_posting.jpg'].create() as Bitmap;
        _source.addChild(new Image(Texture.fromBitmap(bitmap)));
//        var bitMap:Bitmap = DrawToBitmap.drawToBitmap(Starling.current, _source);
        g.socialNetwork.wallPostBitmap(String(g.user.userSocialId),String('Новая увлекательная игра о Долине Рукоделия!'), bitmap, 'interfaceAtlas');
        delete g.pBitmaps[st + 'wall/quest_posting.jpg'];
    }
}
}
