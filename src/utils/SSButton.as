package utils
{
import starling.display.Button;
import starling.display.Quad;
import starling.events.Event;
import starling.textures.Texture;

public class SSButton extends Button
{
    private var touchZone : Boolean = false;
    private var touchQuad : Quad;
    private var _clickCallback:Function;
    private var _scalePlusOnOver:Boolean;

    public function SSButton(upState : Texture, text : String = "", downState : Texture = null, extendTouchZone : Boolean = false)
    {
        super(upState, text, downState);
        touchZone = extendTouchZone;
        _scalePlusOnOver = false;
        addEventListener(Event.TRIGGERED, onTriggered);
        if (extendTouchZone)
        {
            touchQuad = new Quad(1.5 * this.width, 1.5 * this.height);
            touchQuad.x = (this.width - touchQuad.width) / 2;
            touchQuad.y = (this.height - touchQuad.height) / 2;
            touchQuad.alpha = 0;
            addChildAt(touchQuad, 0);
            //	this.touchGroup = true;
        }
    }

    public function set clickCallback(f:Function):void {
        _clickCallback = f;
    }

    public function set scalePlusOnOver(b:Boolean):void {
        _scalePlusOnOver = b;
    }

    private function onTriggered(event : Event) : void
    {
        if (_clickCallback != null) {
            _clickCallback.apply();
        }
        //Root.playSound("button_click_01");
    }

    override public function get width() : Number
    {
        var n : Number;
        if (touchZone)
        {
            if (touchQuad)
            {
                removeChild(touchQuad);
            }
            n = super.width;
            if (touchQuad)
                addChildAt(touchQuad, 0);
        }
        else
        {
            n = super.width;
        }
        return n;
    }

    override public function get height() : Number
    {
        var n : Number;
        if (touchZone)
        {
            if (touchQuad)
            {
                removeChild(touchQuad);
            }

            n =  super.height;
            if (touchQuad)
                addChildAt(touchQuad, 0);
        }
        else
        {
            return super.height;
        }
        return n;
    }
}
}
