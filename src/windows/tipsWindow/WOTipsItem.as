/**
 * Created by user on 8/8/16.
 */
package windows.tipsWindow {
import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;
import tutorial.tips.ManagerTips;
import utils.CButton;
import utils.MCScaler;
import windows.WOComponents.CartonBackgroundIn;

public class WOTipsItem {
    public var source:Sprite;
    private var _bg:CartonBackgroundIn;
    private var _txtBtn:TextField;
    private var _txt:TextField;
    private var _btn:CButton;
    private var _data:Object;
    private var _callback:Function;
    private var g:Vars = Vars.getInstance();

    public function WOTipsItem(f:Function) {
        _callback = f;
        source = new Sprite();
        var q:Quad = new Quad(422, 68);
        source.addChild(q);
        q.alpha = 0;
        _bg = new CartonBackgroundIn(400, 55);
        _bg.x = 19;
        _bg.y = 6;
        source.addChild(_bg);
        _btn = new CButton();
        _btn.addButtonTexture(95, 34, CButton.GREEN, true);
        _txtBtn = new TextField(95, 34, "Показать", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _txtBtn.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        _btn.addChild(_txtBtn);
        _btn.registerTextField(_txtBtn, ManagerFilters.TEXT_STROKE_GREEN);
        _btn.x = 365;
        _btn.y = 34;
        source.addChild(_btn);
        _txt = new TextField(230, 40, "", g.allData.fonts['BloggerBold'], 18, Color.WHITE);
        _txt.nativeFilters = ManagerFilters.TEXT_STROKE_GREEN;
        _txt.autoScale = true;
        _txt.x = 75;
        _txt.y = 14;
        source.addChild(_txt);
    }

    public function fillIt(ob:Object):void {
        _data = ob;
        var im:Image;
        var isPos:Boolean = true;
        switch (_data.type) {
            case ManagerTips.TIP_RAW_RIDGE:
                im = new Image(g.allData.atlas['iconAtlas'].getTexture('ridge_icon'));
                MCScaler.scale(im, 70, 70);
                im.x = 17;
                im.y = 17;
                _txt.text = 'Засеить грядки';
                isPos = false;
                break;
            case ManagerTips.TIP_CRAFT_RIDGE:
                im = new Image(g.allData.atlas['tipsAtlas'].getTexture('crops_icon'));
                _txt.text = 'Собрать урожай';
                break;
            case ManagerTips.TIP_RAW_FABRICA:
                im = new Image(g.allData.atlas['tipsAtlas'].getTexture('factories_icon'));
                _txt.text = 'Создать продукты';
                break;
            case ManagerTips.TIP_CRAFT_FABRICA:
                im = new Image(g.allData.atlas['tipsAtlas'].getTexture('products_icon'));
                _txt.text = 'Собрать продукты фабрик';
                break;
            case ManagerTips.TIP_MARKET:
                im = new Image(g.allData.atlas['tipsAtlas'].getTexture('marcet_icon'));
                _txt.text = 'Продать продукты';
                break;
            case ManagerTips.TIP_PAPPER:
                im = new Image(g.allData.atlas['tipsAtlas'].getTexture('newspaper_icon'));
                _txt.text = 'Купить продукты';
                break;
            case ManagerTips.TIP_ORDER:
                im = new Image(g.allData.atlas['tipsAtlas'].getTexture('orders_icon'));
                _txt.text = 'Выполнить заказы в Лавке';
                break;
            case ManagerTips.TIP_DAILY_BONUS:
                im = new Image(g.allData.atlas['tipsAtlas'].getTexture('wheel_of_fortune_icon'));
                _txt.text = 'Запустить "Колесо фортуны"';
                break;
            case ManagerTips.TIP_WILD:
                im = new Image(g.allData.atlas['wildAtlas'].getTexture('fir_big'));
                MCScaler.scale(im, 65, 65);
                im.x = 27;
                im.y = 25;
                _txt.text = 'Убрать деревья и камни';
                isPos = false;
                break;
            case ManagerTips.TIP_BUY_HERO:
                im = new Image(g.allData.atlas['iconAtlas'].getTexture('cat_icon'));
                MCScaler.scale(im, 70, 70);
                im.x = 22;
                im.y = 15;
                _txt.text = 'Купить помощника';
                isPos = false;
                break;
            case ManagerTips.TIP_RAW_ANIMAL:
                im = new Image(g.allData.atlas['tipsAtlas'].getTexture('animals_icon'));
                _txt.text = 'Покормить животных';
                break;

        }
        if (im) {
            im.pivotX = im.width/2;
            im.pivotY = im.height/2;
            if (isPos) {
                im.x = 36;
                im.y = 34;
            }
            source.addChild(im);
        }
        if (!_data.count) {
            _btn.setEnabled = false;
        } else {
            _btn.clickCallback = onClick;
        }
    }

    private function onClick():void {
        if (_callback != null) {
            _callback.apply(null, [_data]);
        }
    }

    public function deleteIt():void {
        source.removeChild(_bg);
        _bg.deleteIt();
        _bg = null;
        source.removeChild(_btn);
        _btn.deregisterTextField(_txtBtn);
        _btn.removeChild(_txtBtn);
        _txt.nativeFilters = [];
        _btn.deleteIt();
        _btn = null;
        _txtBtn.dispose();
        source.dispose();
        _callback = null;
        _data = null;
    }
}
}
