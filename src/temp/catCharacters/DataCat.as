/**
 * Created by user on 7/28/16.
 */
package temp.catCharacters {
import heroes.OrderCat;

public class DataCat {
    public static var BULAVKA:int = 1;
    public static var PRYAGA:int = 2;
    public static var PETELKA:int = 3;
    public static var IGOLOCHKA:int = 4;
    public static var SINTETIKA:int = 5;
    public static var BUSINKA:int = 6;
    public static var LENTOCHKA:int = 7;
    public static var IRIS:int = 8;
    public static var KRUCHOK:int = 9;
    public static var AKRIL:int = 10;
    public static var YZELOK:int = 11;
    public static var ASHUR:int = 12;
    public static var NAPERSTOK:int = 13;
    public static var STESHOK:int = 14;
    private var _arrCats:Array;

    public function DataCat() {
        _arrCats = [];
        fillDataCat();
    }

    public function fillDataCat():void {
        var obj:Object;
//БАБЫ
        obj = {};
        obj.type = BULAVKA;
        obj.color = OrderCat.BROWN;
        obj.isWoman = true;
        obj.name = 'Булавка';
        _arrCats.push(obj);

        obj = {};
        obj.type = PRYAGA;
        obj.color = OrderCat.GREEN;
        obj.isWoman = true;
        obj.name = 'Пряжа';
        _arrCats.push(obj);


        obj = {};
        obj.type = PETELKA;
        obj.color = OrderCat.PINK;
        obj.isWoman = true;
        obj.name = 'Петелька';
        _arrCats.push(obj);


        obj = {};
        obj.type = IGOLOCHKA;
        obj.color = OrderCat.BLACK;
        obj.isWoman = true;
        obj.name = 'Иголочка';
        _arrCats.push(obj);


        obj = {};
        obj.type = SINTETIKA;
        obj.color = OrderCat.WHITE;
        obj.isWoman = true;
        obj.name = 'Синтетика';
        _arrCats.push(obj);


        obj = {};
        obj.type = BUSINKA;
        obj.color = OrderCat.ORANGE;
        obj.isWoman = true;
        obj.name = 'Бусинка';
        obj.png = 'necklace';
        _arrCats.push(obj);


        obj = {};
        obj.type = LENTOCHKA;
        obj.color = OrderCat.BLUE;
        obj.isWoman = true;
        obj.name = 'Ленточка';
        _arrCats.push(obj);

//ПАЦАНЫ

        obj = {};
        obj.type = IRIS;
        obj.color = OrderCat.BROWN;
        obj.isWoman = false;
        obj.name = 'Ирис';
        _arrCats.push(obj);


        obj = {};
        obj.type = KRUCHOK;
        obj.color = OrderCat.GREEN;
        obj.isWoman = false;
        obj.name = 'Крючок';
        obj.png = 'cepka';
        _arrCats.push(obj);


        obj = {};
        obj.type = AKRIL;
        obj.color = OrderCat.PINK;
        obj.isWoman = false;
        obj.name = 'Акрил';
        obj.png = 'sharf';
        _arrCats.push(obj);


        obj = {};
        obj.type = YZELOK;
        obj.color = OrderCat.BLACK;
        obj.isWoman = false;
        obj.name = 'Узелок';
        obj.png = 'galstuk';
        _arrCats.push(obj);


        obj = {};
        obj.type = ASHUR;
        obj.color = OrderCat.WHITE;
        obj.isWoman = false;
        obj.name = 'Ажур';
        _arrCats.push(obj);


        obj = {};
        obj.type = NAPERSTOK;
        obj.color = OrderCat.ORANGE;
        obj.isWoman = false;
        obj.name = 'Наперсток';
        _arrCats.push(obj);


        obj = {};
        obj.type = STESHOK;
        obj.color = OrderCat.BLUE;
        obj.isWoman = false;
        obj.name = 'Стежок';
        _arrCats.push(obj);
    }

    public function getRandomCat():Object {
        return _arrCats[int(Math.random()*_arrCats.length)];
    }
}
}
