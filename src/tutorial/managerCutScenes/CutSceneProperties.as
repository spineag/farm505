/**
 * Created by user on 4/28/16.
 */
package tutorial.managerCutScenes {
import manager.Vars;

public class CutSceneProperties {
    private var _prop:Array;
    private var _manager:ManagerCutScenes;
    private var g:Vars = Vars.getInstance();

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
        obj.text = String(g.managerLanguage.allTexts[516]);
        obj.text2 = String(g.managerLanguage.allTexts[517]);
        _prop.push(obj);

        obj = {};
        obj.reason = ManagerCutScenes.REASON_NEW_LEVEL;
        obj.level = 5;
        obj.id_action = ManagerCutScenes.ID_ACTION_SHOW_PAPPER;
        obj.text = String(g.managerLanguage.allTexts[518]);
        _prop.push(obj);

        obj = {};
        obj.reason = ManagerCutScenes.REASON_NEW_LEVEL;
        obj.level = 6;
        obj.id_action = ManagerCutScenes.ID_ACTION_BUY_DECOR;
        obj.text = String(g.managerLanguage.allTexts[519]);
        _prop.push(obj);

        obj = {};
        obj.reason = ManagerCutScenes.REASON_NEW_LEVEL;
        obj.level = 6;
        obj.id_action = ManagerCutScenes.ID_ACTION_TO_INVENTORY_DECOR;
        obj.text = String(g.managerLanguage.allTexts[520]);
        _prop.push(obj);

        obj = {};
        obj.reason = ManagerCutScenes.REASON_NEW_LEVEL;
        obj.level = 6;
        obj.id_action = ManagerCutScenes.ID_ACTION_FROM_INVENTORY_DECOR;
        obj.text = String(g.managerLanguage.allTexts[521]);
        _prop.push(obj);

        obj = {};
        obj.reason = ManagerCutScenes.REASON_NEW_LEVEL;
        obj.level = 11;
        obj.id_action = ManagerCutScenes.ID_ACTION_TRAIN_AVAILABLE;
        obj.text = String(g.managerLanguage.allTexts[522]);
        _prop.push(obj);

        obj = {};
        obj.reason = ManagerCutScenes.REASON_OPEN_TRAIN;
        obj.level = 0;
        obj.id_action = ManagerCutScenes.ID_ACTION_OPEN_TRAIN;
        obj.text = String(g.managerLanguage.allTexts[523]);
        obj.text2 = String(g.managerLanguage.allTexts[524]);
        obj.text3 = String(g.managerLanguage.allTexts[525]);
        obj.text4 = String(g.managerLanguage.allTexts[526]);
        obj.text5 = String(g.managerLanguage.allTexts[527]);
        obj.text6 = String(g.managerLanguage.allTexts[528]);
        _prop.push(obj);

        obj = {};
        obj.reason = ManagerCutScenes.REASON_OPEN_WO_PLANT;
        obj.level = 10;
        obj.text = String(g.managerLanguage.allTexts[529]);
        _prop.push(obj);

        obj = {};
        obj.reason = ManagerCutScenes.REASON_ADD_TO_PAPPER;
        obj.level = 4;
        obj.text = String(g.managerLanguage.allTexts[530]);
        obj.text2 = String(g.managerLanguage.allTexts[531]);
        _prop.push(obj);
    }
}
}
