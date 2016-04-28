/**
 * Created by user on 4/28/16.
 */
package tutorial.managerCutScenes {

public class CutSceneProperties {
    private var _prop:Array;
    private var _manager:ManagerCutScenes;

    public function CutSceneProperties(man:ManagerCutScenes) {
        _manager = man;
        _prop = new Array();
        fillProperties();
    }

    public function get properties():Array {
        return _prop;
    }

    private function fillProperties():void {
        var obj:Object = {};

        obj.reason = ManagerCutScenes.REASON_NEW_LEVEL;
        obj.level = 5;
        obj.type = ManagerCutScenes.TYPE_ACTION_SHOW_ORDER_AND_PAPPER;
        obj.cat = ManagerCutScenes.CAT_BIG;
        obj.text_1 = "Ура! Теперь ты можешь продавать продукты по желаемой цене, а также выставлять объявления об этом в газету. Попробуй!"
        obj.text_2 = "Открой газету, посмотри что продают другие!";
        _prop.push(obj);
    }
}
}
