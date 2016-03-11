/**
 * Created by user on 3/7/16.
 */
package tutorial {
public class TutorialTexts {
    private var _objText:Object;

    public function TutorialTexts() {
        _objText = {};
        _objText['next'] = 'Продолжить';
        _objText['ok'] = 'Далее';
        _objText['lookAround'] = 'На полный экран';

        _objText[1] = {};
        _objText[1][1] = 'Ну спасибо! Мы жители лоскутного мира! Закройте коробку! Нас и так мало осталось! А с вашей помощью вообще повымираем!';
        _objText[1][2] = 'Давай осмотримся';

        _objText[2] = {};
        _objText[2][0] = 'А местечко неплохое. Пщеница прямо на галазах выросла, и на руках тоже. Можно собирать уже!';

        _objText[3] = {};
        _objText[3][0] = 'Пшеница всегда пригодиться. Засеем грядки и пополним запасы!'
        _objText[3][4] = 'Сажай одну пшеницу - а через время получишь 2!';

        _objText[4] = {};
        _objText[4][1] = 'Снова куры все сожрали! Покорми их!';
    }

    public function get objText():Object { return _objText }
}
}
