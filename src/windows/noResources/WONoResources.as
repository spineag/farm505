/**
 * Created by user on 6/29/15.
 */
package windows.noResources {
import utils.MCScaler;

import windows.*;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;

public class WONoResources extends Window {
    private var _txtHardCost:TextField;
    private var _txtBuyBtn:TextField;
    private var _txtResourceNumber:TextField;
    private var _txtNoResource:TextField;
    private var _txtPanel:TextField;
    private var _imageHard:Image;
    private var _imageResource:Image;
    private var _imageBtn:Image;
    private var _data:Object;

    public function WONoResources() {
        super();
        createTempBG(400,300 , Color.GRAY);
        createExitButton(g.interfaceAtlas.getTexture('btn_exit'), '', g.interfaceAtlas.getTexture('btn_exit_click'), g.interfaceAtlas.getTexture('btn_exit_hover'));
        _btnExit.x += 200;
        _btnExit.y -= 150;
        _btnExit.addEventListener(Event.TRIGGERED, onClickExit);
        _txtHardCost = new TextField(100,100,"","Arial",18,Color.WHITE);
        _txtResourceNumber = new TextField(100,100,"","Arial",18,Color.WHITE);
        _txtBuyBtn = new TextField(100,100,"","Arial",14,Color.WHITE);
        _txtNoResource = new TextField(300,100,"","Arial",18,Color.WHITE);
        _txtPanel = new TextField(350,200,"","Arial",18,Color.WHITE);
        _imageBtn = new Image(g.interfaceAtlas.getTexture("scroll_box"));
        _imageBtn.x -= 50;
        _imageBtn.y +=80;
        _imageBtn.width = 90;


        _txtNoResource.x -= 150;
        _txtNoResource.y -= 150;

        _txtPanel.x -= 180;
        _txtPanel.y -= 150;

        _txtHardCost.x -= 70;
        _txtHardCost.y += 50;

        _txtBuyBtn.x += 30;
        _txtBuyBtn.y += 50;

    }

    private function onClickExit(e:Event):void {
        hideIt();
    }

    public function showItMenu(data:Object, count:int):void {
        _data = data;

        _txtNoResource.text = "НЕДОСТАТОЧНО РЕСУРСОВ";
        _txtPanel.text = "Не хватает ингредиентов. Вы можете купить их за изумруды и начать производство немедленно.";
        _txtBuyBtn.text = "докупить ресурсы";
        if(_data.priceHard) _txtHardCost.text = String(_data.priceHard * count);
        _txtHardCost.text = "666";
        _txtResourceNumber.text = String(count);
        _imageHard = new Image(g.interfaceAtlas.getTexture("interface_bg"));
//        _imageResource = new Image(g.atlas.getTexture(_data.image));
        MCScaler.scale(_imageHard, 20, 20);
        _imageHard.y += 90;
        _source.addChild(_imageBtn);
        _source.addChild(_imageHard);
        _source.addChild(_txtPanel);
        _source.addChild(_txtNoResource);
        _source.addChild(_txtHardCost);
        _source.addChild(_txtBuyBtn);
        _source.addChild(_txtResourceNumber);

        showIt();
    }
}
}
