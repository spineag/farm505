/**
 * Created by yusjanja on 05.03.2016.
 */
package tutorial {
import dragonBones.Armature;

import manager.Vars;

import starling.display.Sprite;

public class CutScene {
    private var _source:Sprite;
    private var _armature:Armature;
    private var g:Vars = Vars.getInstance();
    private var _bubble:CutSceneTextBubble;
    private var _cont:Sprite;

    public function CutScene() {
        _cont = g.cont.popupCont;
        _source = new Sprite();
    }
}
}
