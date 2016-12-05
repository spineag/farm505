/**
 * Created by user on 11/28/16.
 */
package tutorial.newTuts {
public class TutorialTextsNew {
    private var _objText:Object;

    public function TutorialTextsNew() {
        _objText = {};
        _objText['next'] = 'Продолжить';
        _objText['ok'] = 'Далее';

        _objText[2] = {};
        _objText[2][0] = 'Приветствую тебя user_name в Долине Рукоделия. Пока это маленький мир, но с тобой мы сделаем его прекрасным. Начни с малого - собери урожай пшеницы.';

        _objText[4] = {};
        _objText[4][0] ='Все просто. Садишь одну - через время получаешь две!';

        _objText[6] = {};
        _objText[6][0] = 'Самое время покормить наших курочек!';

        _objText[7] = {};
        _objText[7][0] = 'Нажми "ускорить" чтобы курочка снеслась быстрее.';

        _objText[9] = {};
        _objText[9][0] = 'Отлично, теперь можно сажать кукурузу. Вскопаем еще несколько грядок.';

        _objText[11] = {};
        _objText[11][0] = 'Можем купить еще курочку.';

        _objText[12] = {};
        _objText[12][0] = 'Построим Кормилку, где будем производить корм для животных.';

        _objText[15] = {};
        _objText[15][0] = 'Молодец! Теперь попробуй сам. И вот тебе небольшая награда!';
    }

    public function get objText():Object { return _objText }
}
}
