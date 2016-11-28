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
    }

    public function get objText():Object { return _objText }
}
}
