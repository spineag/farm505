/**
 * Created by user on 11/30/15.
 */
package heroes {
import dragonBones.Armature;
import dragonBones.Bone;
import dragonBones.animation.WorldClock;
import dragonBones.factories.StarlingFactory;

import starling.display.Sprite;

public class HeroEyesAnimation {
    private var _armatureEyes:Armature;
    private var _armatureClip:Sprite;

    public function HeroEyesAnimation(fact:StarlingFactory, catArmature:Armature) {
        _armatureEyes = fact.buildArmature("eyes");
        _armatureClip = _armatureEyes.display as Sprite;
        WorldClock.clock.add(_armatureEyes);
        var headBone:Bone = catArmature.getBone('head');
//        headBone.display.addChildBone()
        trace('asd');
    }
}
}
