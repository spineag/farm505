/**
 * Created by user on 12/5/16.
 */
package tutorial.miniScenes {
import manager.Vars;

public class MiniSceneProps {
    private var _prop:Array;
    private var g:Vars = Vars.getInstance();
    public function MiniSceneProps() {
        _prop = new Array();
        fillProperties();
    }
    public function get properties():Array {
        return _prop;
    }

    private function fillProperties():void {
        var obj:Object = {};

        obj.id = 1;
        obj.prevId = 0; // prev mini scene id
        obj.reason = ManagerMiniScenes.OPEN_ORDER;
        obj.level = 3;
        obj.text = String(g.managerLanguage.allTexts[534]);
        _prop.push(obj);

        obj = {};
        obj.id = 2;
        obj.prevId = 1; //
        obj.reason = ManagerMiniScenes.BUY_ORDER;
        obj.level = 3;
        obj.text = String(g.managerLanguage.allTexts[535]);
        _prop.push(obj);

        obj = {};
        obj.id = 3;
        obj.prevId = 2; //
        obj.reason = ManagerMiniScenes.BUY_BUILD;
        obj.level = 3;
        obj.text = String(g.managerLanguage.allTexts[536]);
        _prop.push(obj);

        obj = {};
        obj.id = 4;
        obj.prevId = 3; //
        obj.reason = ManagerMiniScenes.GO_NEIGHBOR;
        obj.level = 3;
        obj.text = String(g.managerLanguage.allTexts[537]);
        _prop.push(obj);

        obj = {};
        obj.id = 5;
        obj.prevId = 0; //
        obj.reason = ManagerMiniScenes.ON_GO_NEIGHBOR;
        obj.level = 3;
        obj.text = String(g.managerLanguage.allTexts[538]);
        _prop.push(obj);

        obj = {};
        obj.id = 6;
        obj.prevId = 5; //
        obj.reason = ManagerMiniScenes.BUY_INSTRUMENT;
        obj.level = 3;
        obj.text = String(g.managerLanguage.allTexts[539]);
        obj.text2 = String(g.managerLanguage.allTexts[540]);
        _prop.push(obj);
    }
}
}
