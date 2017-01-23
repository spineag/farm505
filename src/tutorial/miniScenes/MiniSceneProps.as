/**
 * Created by user on 12/5/16.
 */
package tutorial.miniScenes {
public class MiniSceneProps {
    private var _prop:Array;

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
        obj.text = "Пришло время открыть Лавку, чтобы радовать других отличными продуктами!";
        _prop.push(obj);

        obj = {};
        obj.id = 2;
        obj.prevId = 1; //
        obj.reason = ManagerMiniScenes.BUY_ORDER;
        obj.level = 3;
        obj.text = "Ура! Поздравляю с открытием! А вот и первые покупатели. Давай посмотрим чем мы можем их порадовать";
        _prop.push(obj);

        obj = {};
        obj.id = 3;
        obj.prevId = 2; //
        obj.reason = ManagerMiniScenes.BUY_BUILD;
        obj.level = 3;
        obj.text = "Скоро покупателей будет еще больше, самое время построить Булочную!";
        _prop.push(obj);

        obj = {};
        obj.id = 4;
        obj.prevId = 3; //
        obj.reason = ManagerMiniScenes.GO_NEIGHBOR;
        obj.level = 3;
        obj.text = "Пока производство идет полным ходом зайдем в гости к соседу.";
        _prop.push(obj);

        obj = {};
        obj.id = 5;
        obj.prevId = 0; //
        obj.reason = ManagerMiniScenes.ON_GO_NEIGHBOR;
        obj.level = 3;
        obj.text = "Красиво здесь, а у нас будет еще лучше. Посмотрим что здесь полезного можно прикупить!";
        _prop.push(obj);

        obj = {};
        obj.id = 6;
        obj.prevId = 5; //
        obj.reason = ManagerMiniScenes.BUY_INSTRUMENT;
        obj.level = 3;
        obj.text = "Инструмент лишним не бывает. Нажми, чтобы приобрести.";
        obj.text2 = "На рынках у друзей можно купить много чего интересного.";
        _prop.push(obj);
    }
}
}
