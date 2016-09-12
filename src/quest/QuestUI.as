/**
 * Created by andy on 9/9/16.
 */
package quest {
import manager.Vars;
import starling.display.Sprite;

public class QuestUI {
    private var MAX_COUNT:int=3;
    private var g:Vars = Vars.getInstance();
    private var _cont:Sprite;
    private var _arrIcons:Array;
    private var _countLoaded:int;

    public function QuestUI() {
        _arrIcons = [];
        _cont = new Sprite();
        _cont.x = 70;
        g.cont.interfaceCont.addChild(_cont);
        checkContPosition();
    }

    public function checkContPosition():void {
        if (g.user.level > 17) {
            _cont.y = 210;
        } else if (g.user.level > 9) {
            _cont.y = 20;
        } else {
            _cont.y = 280;
        }
    }

    public function addQuest(qData:Object, click:Function):void {
        var f:Function = null;
        if (_arrIcons.length < MAX_COUNT) {
            f = onLoadIcon;
            _countLoaded++;
        }
        var icon:QuestIcon = new QuestIcon(qData, click, f);
        icon.setPosition(_cont, _arrIcons.length);
        _arrIcons.push(icon);
    }

    private function onLoadIcon():void {
        _countLoaded--;
        if (_countLoaded <= 0) {
            for (var i:int=0; i<_arrIcons.length; i++) {
                if (i >= MAX_COUNT) return;
                (_arrIcons[i] as QuestIcon).showAnimate(i * .5);
            }
        }
    }
}
}
