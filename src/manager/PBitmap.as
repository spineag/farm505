package manager {
import flash.display.Bitmap;

public class PBitmap {
    private var arr:Array;
    private var _content:Bitmap;

    public function PBitmap(content:Bitmap) {
        _content = content;
        arr = [];
    }

    public function create():Bitmap {
        var buffer:Bitmap;

        if (!_content)
            return null;

        if (arr.length == 0) {
            buffer = new Bitmap();
            buffer.bitmapData = _content.bitmapData.clone();
            buffer.smoothing = true;
        }
        else {
            buffer = arr.pop() as Bitmap;
        }

        buffer.x = 0;
        buffer.y = 0;
        buffer.scaleX = 1;
        buffer.scaleY = 1;

        return buffer;
    }

    public function remove(source:Bitmap):void {
        source.scaleX = source.scaleY = 1;
        arr.push(source);
    }
}
}