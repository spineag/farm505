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
        obj.id_action = ManagerCutScenes.ID_ACTION_SHOW_MARKET;
        obj.cat = ManagerCutScenes.CAT_SMALL;
        obj.text = "Ура! Теперь ты можешь продавать продукты по желаемой цене, а также выставлять объявления об этом в газету. Попробуй!"
        _prop.push(obj);

        obj = {};
        obj.reason = ManagerCutScenes.REASON_NEW_LEVEL;
        obj.level = 5;
        obj.id_action = ManagerCutScenes.ID_ACTION_SHOW_PAPPER;
        obj.cat = ManagerCutScenes.CAT_SMALL;
        obj.text = "Открой газету, посмотри что продают другие!";
        _prop.push(obj);
    }
}
}
