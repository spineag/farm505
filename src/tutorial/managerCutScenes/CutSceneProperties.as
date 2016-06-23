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
        obj.text = "Ура! Теперь ты можешь продавать продукты по желаемой цене, а также выставлять объявления об этом в газету. Попробуй!";
        obj.text2 = "На рынке ты всегда можешь продавать различные товары.";
        _prop.push(obj);

        obj = {};
        obj.reason = ManagerCutScenes.REASON_NEW_LEVEL;
        obj.level = 5;
        obj.id_action = ManagerCutScenes.ID_ACTION_SHOW_PAPPER;
        obj.text = "Открой газету, посмотри, что продают другие!";
        _prop.push(obj);

        obj = {};
        obj.reason = ManagerCutScenes.REASON_NEW_LEVEL;
        obj.level = 8;
        obj.id_action = ManagerCutScenes.ID_ACTION_BUY_DECOR;
        obj.text = 'Нашу долину можно украшать! Нажми на кнопку “Магазин”';
        _prop.push(obj);

        obj = {};
        obj.reason = ManagerCutScenes.REASON_NEW_LEVEL;
        obj.level = 8;
        obj.id_action = ManagerCutScenes.ID_ACTION_TO_INVENTORY_DECOR;
        obj.text = 'Между прочим, декор еще можно помещать в инвентарь!';
        _prop.push(obj);

        obj = {};
        obj.reason = ManagerCutScenes.REASON_NEW_LEVEL;
        obj.level = 8;
        obj.id_action = ManagerCutScenes.ID_ACTION_FROM_INVENTORY_DECOR;
        obj.text = 'Декор всегда можно достать из инвентаря и вернуть на поляну.';
        _prop.push(obj);

        obj = {};
        obj.reason = ManagerCutScenes.REASON_NEW_LEVEL;
        obj.level = 17;
        obj.id_action = ManagerCutScenes.ID_ACTION_TRAIN_AVAILABLE;
        obj.text = 'Мы уже многому научились и вырабатываем отличные продукты. Теперь можно открыть канатную дорожку для доставки в самые отдаленные места!';
        _prop.push(obj);

        obj = {};
        obj.reason = ManagerCutScenes.REASON_OPEN_TRAIN;
        obj.level = 0;
        obj.id_action = ManagerCutScenes.ID_ACTION_OPEN_TRAIN;
        obj.text = 'Первая корзинка уже прибыла. Давай посмотрим, что заказывают.';
        obj.text2 = 'Сначала выбираем ячейку с запрашиваемым продуктом';
        obj.text3 = 'Затем загружаем продукт нажав “загрузить”';
        obj.text4 = 'За загрузку ячейки ты получаешь очки опыта и монеты, а загрузив все ячейки - еще и дополнительную награду.';
        obj.text5 = 'После полной загрузки корзинку можно отправить или подождать пока она отправиться сама.';
        obj.text6 = 'Также за полную загрузку корзинки ты получаешь один случайный ваучер. Их можно обменять в магазине на особые покупки.';
        _prop.push(obj);
    }
}
}
