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
        _objText[1][2] = 'Давай осмотримся, поищем телочек';

        _objText[2] = {};
        _objText[2][0] = 'А местечко неплохое. Пщеница прямо на галазах выросла, и на руках тоже. Можно собирать уже!';

        _objText[3] = {};
        _objText[3][0] = 'Пшеница всегда пригодиться. Засеем грядки и пополним запасы! Будем крыс приманывать';
        _objText[3][4] = 'Сажай одну пшеницу - а через время получишь 2! Капитализм, йо!';

        _objText[4] = {};
        _objText[4][1] = 'Снова куры все сожрали! Покорми их!';
        _objText[4][3] = 'Чтобы курочка быстрее оплодилась - нажми на неё и выбери Узбагоить';
        _objText[4][5] = 'Поразкидал тут яйца - подбери давай!';

        _objText[5] = {};
        _objText[5][1] = 'Поздравляем! Ты получил новый уровень! Но все равно еще нуб..';

        _objText[6] = {};
        _objText[6][0] = 'В нашем курятнике будет место еще для нескольких ципочек.';
        _objText[6][3] = 'Все куры попадают не в коровник, а в курятник!';

        _objText[7] = {};
        _objText[7][0] = 'А теперь давай построим Дробилку, где производится корм для нашых красавиц';
        _objText[7][4] = 'Кликни по зданию, открой заведение!';

        _objText[8] = {};
        _objText[8][0] = 'Теперь можем произвести дифосфат кальция в промышленных масштабах!';

        _objText[9] = {};
        _objText[9][1] = 'Давай еще где-нибудь разбросаем чернозем';
        _objText[9][3] = 'Выбери место, где спать будешь';

        _objText[10] = {};
        _objText[10][1] = 'Э, сышь, давай еще что-нибудь посадим? Эти, пупыришки желтые, как их там..';

        _objText[11] = {};
        _objText[11][1] = 'Пошли посмотрим, че там у Семеныча в холодильнике стучит';
        _objText[11][1] = 'Ты смотри, еще кто-то мчится на халявную жратву';
        _objText[11][5] = 'Давай с серйозной мордой ему что-то впарим!';
        _objText[11][8] = 'Поздравляю с открытием! Надо мной хозяин поизгалялся, хоть куриные будут';
        _objText[11][9] = 'Спасибо большое! Теперь будет что делать перед сном!';

        _objText[12] = {};
        _objText[12][0] = 'Теперь можно построить Булочную и торговать чебукрысами!';
    }

    public function get objText():Object { return _objText }
}
}
