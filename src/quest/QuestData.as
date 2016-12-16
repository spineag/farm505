/**
 * Created by andy on 9/9/16.
 */
package quest {
import data.DataMoney;

public class QuestData {
    private var _arr:Array;

    public function QuestData() {
        createTempQuests();
    }

    private function createTempQuests():void {
        var ob:Object;
        _arr = [];

        ob = {};
        ob.id = 1;
        ob.type = ManagerQuest.ADD_TO_GROUP;
        ob.text = 'Вступи в группу';
        ob.awardCount = 700;
        ob.awardType = DataMoney.SOFT_CURRENCY;
        ob.iconUrl = 'group.png';
        ob.level = 5;
        ob.isAdded = false;
        _arr.push(ob);

        ob = {};
        ob.id = 2;
        ob.type = ManagerQuest.ADD_LEFT_MENU;
        ob.text = 'Добавь игру в меню';
        ob.awardCount = 1200;
        ob.awardType = DataMoney.SOFT_CURRENCY;
        ob.iconUrl = 'left_menu.png';
        ob.level = 5;
        ob.isAdded = false;
        _arr.push(ob);

        ob = {};
        ob.id = 3;
        ob.type = ManagerQuest.POST;
        ob.text = 'Расскажи друзьям об игре';
        ob.awardCount = 10;
        ob.awardType = DataMoney.HARD_CURRENCY;
        ob.iconUrl = 'posting.png';
        ob.imageUrl = 'quest_posting';
        ob.level = 5;
        ob.isAdded = false;
        _arr.push(ob);
    }

    public function get arrQuests():Array {
        return _arr;
    }
}
}
