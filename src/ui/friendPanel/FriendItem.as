/**
 * Created by user on 7/31/15.
 */
package ui.friendPanel {
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;

public class FriendItem {
    public var source:Sprite;
    private var _imageFriend:Image;
    private var _imageFriendFrame:Image;

    private var g:Vars = Vars.getInstance();
    public function FriendItem() {
        source = new Sprite();
        _imageFriendFrame = new Image(g.interfaceAtlas.getTexture("friend_frame"));
        _imageFriendFrame.x = 120;
        _imageFriendFrame.y = 10;
        source.addChild(_imageFriendFrame);
    }
}
}
