/**
 * Created by user on 7/28/16.
 */
package temp.catCharacters {
import heroes.OrderCat;

public class DataCat {
    private var _arrCats:Array;
    public function DataCat() {
        _arrCats = [];
        fillDataCat();
    }

    public function fillDataCat():void {
        var obj:Object;
//БАБЫ
        obj = {};
        obj.id = 1;
        obj.color = OrderCat.BROWN;
        obj.isWoman = true;
        obj.name = 'Булавка';
//        obj.idle =
        _arrCats.push(obj);

        obj = {};
        obj.id = 2;
        obj.color = OrderCat.GREEN;
        obj.isWoman = true;
        obj.name = 'Пряжа';
        _arrCats.push(obj);


        obj = {};
        obj.id = 3;
        obj.color = OrderCat.PINK;
        obj.isWoman = true;
        obj.name = 'Петелька';
        _arrCats.push(obj);


        obj = {};
        obj.id = 4;
        obj.color = OrderCat.BLACK;
        obj.isWoman = true;
        obj.name = 'Иголочка';
        _arrCats.push(obj);


        obj = {};
        obj.id = 5;
        obj.color = OrderCat.WHITE;
        obj.isWoman = true;
        obj.name = 'Синтетика';
        _arrCats.push(obj);


        obj = {};
        obj.id = 6;
        obj.color = OrderCat.ORANGE;
        obj.isWoman = true;
        obj.name = 'Бусинка';
        _arrCats.push(obj);


        obj = {};
        obj.id = 7;
        obj.color = OrderCat.BLUE;
        obj.isWoman = true;
        obj.name = 'Ленточка';
        _arrCats.push(obj);

//ПАЦАНЫ

        obj = {};
        obj.id = 8;
        obj.color = OrderCat.BROWN;
        obj.isWoman = false;
        obj.name = 'Ирис';
        _arrCats.push(obj);


        obj = {};
        obj.id = 9;
        obj.color = OrderCat.GREEN;
        obj.isWoman = false;
        obj.name = 'Крючок';
        _arrCats.push(obj);


        obj = {};
        obj.id = 10;
        obj.color = OrderCat.PINK;
        obj.isWoman = false;
        obj.name = 'Акрил';
        _arrCats.push(obj);


        obj = {};
        obj.id = 11;
        obj.color = OrderCat.BLACK;
        obj.isWoman = false;
        obj.name = 'Узелок';
        _arrCats.push(obj);


        obj = {};
        obj.id = 12;
        obj.color = OrderCat.WHITE;
        obj.isWoman = false;
        obj.name = 'Ажур';
        _arrCats.push(obj);


        obj = {};
        obj.id = 13;
        obj.color = OrderCat.ORANGE;
        obj.isWoman = false;
        obj.name = 'Наперсток';
        _arrCats.push(obj);


        obj = {};
        obj.id = 14;
        obj.color = OrderCat.BLUE;
        obj.isWoman = false;
        obj.name = 'Стежок';
        _arrCats.push(obj);

    }

    public function get arrCats():Array {
        return _arrCats;
    }
}
}
