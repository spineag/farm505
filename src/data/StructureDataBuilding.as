/**
 * Created by user on 2/27/17.
 */
package data {
import manager.Vars;

import utils.Utils;

import utils.Utils;

import utils.Utils;


public class StructureDataBuilding {
    private var _blockByLevel:Array;
    private var _buildTime:Array;
    private var _buildType:int;
    private var _catNeed:Boolean;
    private var _color:String;
    private var _cost:Array;
    private var _currency:Array;
    private var _deltaCost:int;
    private var _filterType:int;
    private var _group:int;
    private var _height:int;
    private var _id:int;
    private var _image:String;
    private var _innerX:*;
    private var _innerY:*;
    private var _maxAnimalsCount:int;
    private var _name:String;
    private var _priceSkipHard:int;
    private var _startCountCell:int;
    private var _url:String;
    private var _visibleAction:Boolean;
    private var _visibleTester:Boolean;
    private var _width:int;
    private var _xpForBuild:int;
    private var _countUnblock:int;
    private var _craftIdResource:int;
    private var _countCraftResource:Array;
    private var _removeByResourceId:int;
    private var _startCountResources:int;
    private var _deltaCountResources:int;
    private var _startCountInstrumets:int;
    private var _deltaCountAfterUpgrade: int;
    private var _upInstrumentId1:int;
    private var _upInstrumentId2:int;
    private var _upInstrumentId3:int;
    private var _imageActive:String;
    private var _idResource:Array;
    private var _idResourceRaw:Array;
    private var _variaty:Array;
    private var g:Vars = Vars.getInstance();

    public function StructureDataBuilding(ob:Object) {
        var obj:Object = {};
        var k:int;
        _innerX =[];
        _innerY =[];
        _id = int(ob.id);
        _width = int(ob.width);
        _height = int(ob.height);
        if (ob.inner_x) {
            obj.innerX = Utils.intArray(String(ob.inner_x).split('&'));
            if (obj.innerX.length == 1) {
                obj.innerX = int(obj.innerX[0]) * g.scaleFactor;
            } else if (obj.innerX.length) {
                for (k = 0; k < obj.innerX.length; k++) {
                    obj.innerX[k] = int(obj.innerX[k]) * g.scaleFactor;
                }
            }
            obj.innerY = Utils.intArray(String(ob.inner_y).split('&'));
            if (obj.innerY.length == 1) {
                obj.innerY = int(obj.innerY[0]) * g.scaleFactor;
            } else if (obj.innerY.length) {
                for (k = 0; k < obj.innerY.length; k++) {
                    obj.innerY[k] = int(obj.innerY[k]) * g.scaleFactor;
                }
            }
        }
//        _name = ob.name;
        _name = g.managerLanguage.allTexts[ob.text_id];
        _url = ob.url;
        _image = ob.image;
        _xpForBuild = int(ob.xp_for_build);
        _buildType = int(ob.build_type);

        // temp
//                if (obj.id == 75) {
//                    obj.buildType = BuildType.DECOR_FENCE_GATE;
//                    obj.innerX = [];
//                    obj.innerY = [];
//                    obj.innerX.push(-28 * g.scaleFactor); obj.innerY.push(-30 * g.scaleFactor); // main (top) part of gate
//                    obj.innerX.push(-14 * g.scaleFactor); obj.innerY.push(-21 * g.scaleFactor); // second part of gate
//                    obj.innerX.push(-54 * g.scaleFactor); obj.innerY.push(0 * g.scaleFactor); // second part for shop view
//                    obj.innerX.push(45 * g.scaleFactor); obj.innerY.push(-34 * g.scaleFactor); // line for main part
//                    obj.innerX.push(-36 * g.scaleFactor); obj.innerY.push(10 * g.scaleFactor); // line for second part
//                }
        if (_id == 92) {
            _buildType = BuildType.DECOR_FENCE_ARKA;
            obj.innerX = []; obj.innerY = [];
            obj.innerX.push(-41 * g.scaleFactor); obj.innerY.push(-195 * g.scaleFactor); // main (top) part of gate
            obj.innerX.push(-61 * g.scaleFactor); obj.innerY.push(-236 * g.scaleFactor); // second part of gate
        }
        if (_id == 94) {
            _buildType = BuildType.DECOR_FENCE_ARKA;
            obj.innerX = []; obj.innerY = [];
            obj.innerX.push(-47 * g.scaleFactor); obj.innerY.push(-146 * g.scaleFactor); // main (top) part of gate
            obj.innerX.push(-64 * g.scaleFactor); obj.innerY.push(-192 * g.scaleFactor); // second part of gate
        }
        if (_id == 96) {
            _buildType = BuildType.DECOR_FENCE_ARKA;
            obj.innerX = []; obj.innerY = [];
            obj.innerX.push(-57 * g.scaleFactor); obj.innerY.push(-151 * g.scaleFactor); // main (top) part of gate
            obj.innerX.push(-72 * g.scaleFactor); obj.innerY.push(-188 * g.scaleFactor); // second part of gate
        }
        if (_id == 98) {
            _buildType = BuildType.DECOR_FENCE_ARKA;
            obj.innerX = []; obj.innerY = [];
            obj.innerX.push(-55 * g.scaleFactor); obj.innerY.push(-151 * g.scaleFactor); // main (top) part of gate
            obj.innerX.push(-64 * g.scaleFactor); obj.innerY.push(-189 * g.scaleFactor); // second part of gate
        }
        if (_id == 176) {
            _buildType = BuildType.DECOR_FENCE_ARKA;
            obj.innerX = []; obj.innerY = [];
            obj.innerX.push(-22 * g.scaleFactor); obj.innerY.push(-148 * g.scaleFactor); // main (top) part of gate
            obj.innerX.push(-61 * g.scaleFactor); obj.innerY.push(-201 * g.scaleFactor); // second part of gate
        }
        if (_id == 210) {
            _buildType = BuildType.DECOR_FENCE_ARKA;
            obj.innerX = []; obj.innerY = [];
            obj.innerX.push(-57 * g.scaleFactor); obj.innerY.push(-155 * g.scaleFactor); // main (top) part of gate
            obj.innerX.push(-64 * g.scaleFactor); obj.innerY.push(-189 * g.scaleFactor); // second part of gate
        }

        _innerX = obj.innerX;
        _innerY = obj.innerY;

        if (ob.count_cell) _startCountCell = int(ob.count_cell);
        if (ob.currency) {
            _currency = String(ob.currency).split('&');
            for (k = 0; k < _currency.length; k++) _currency[k] = int(_currency[k]);
        }
        if (ob.cost) {
            _cost = [];
            _cost = String(ob.cost).split('&');
            for (k = 0; k < _cost.length; k++) _cost[k] = int(_cost[k]);
        }
        if (ob.delta_cost) _deltaCost = int(ob.delta_cost);
        if (ob.block_by_level) {
            _blockByLevel = [];
           obj.blockByLevel = String(ob.block_by_level).split('&');
            for (k = 0; k < obj.blockByLevel.length; k++) _blockByLevel[k] = int(obj.blockByLevel[k]);
        }
        if (ob.cost_skip) _priceSkipHard = int(ob.cost_skip);
        if (ob.filter) _filterType = int(ob.filter);
        if (ob.build_time) {
            _buildTime =[];
            obj.buildTime = String(ob.build_time).split('&');
            for (k = 0; k < obj.buildTime.length; k++) _buildTime[k] = int(obj.buildTime[k]);
        }
        if (ob.count_unblock) _countUnblock = int(ob.count_unblock);

        if (ob.craft_resource_id) _craftIdResource = int(ob.craft_resource_id);
        if (ob.count_craft_resource) {
            _countCraftResource = [];
            obj.countCraftResource = String(ob.count_craft_resource).split('&');
            for (k = 0; k < obj.countCraftResource.length; k++) _countCraftResource[k] = int(obj.countCraftResource[k]);
        }

        if (ob.instrument_id) _removeByResourceId = int(ob.instrument_id);
        if (ob.start_count_resources) _startCountResources = int(ob.start_count_resources);
        if (ob.delta_count_resources) _deltaCountResources = int(ob.delta_count_resources);
        if (ob.start_count_instruments) _startCountInstrumets = int(ob.start_count_instruments);
        if (ob.delta_count_instruments) _deltaCountAfterUpgrade = int(ob.delta_count_instruments);
        if (ob.up_instrument_id_1) _upInstrumentId1 = int(ob.up_instrument_id_1);
        if (ob.up_instrument_id_2) _upInstrumentId2 = int(ob.up_instrument_id_2);
        if (ob.up_instrument_id_3) _upInstrumentId3 = int(ob.up_instrument_id_3);
        if (ob.max_count) _maxAnimalsCount = int(ob.max_count);
        if (ob.image_active) _imageActive = ob.image_active;
        if (ob.cat_need) _catNeed = Boolean(int(ob.cat_need));
        if (ob.resource_id) {
            _idResource = [];
            obj.idResource = String(ob.resource_id).split('&');
            for (k = 0; k < obj.idResource.length; k++) _idResource[k] = int(obj.idResource[k]);
        }
        if (ob.raw_resource_id) {
            _idResourceRaw = [];
            obj.idResourceRaw = String(ob.raw_resource_id).split('&');
            for (k = 0; k < obj.idResourceRaw.length; k++) _idResourceRaw[k] = int(obj.idResourceRaw[k]);
        }
        if (ob.variaty) {
            _variaty = [];
            obj.variaty = String(ob.variaty).split('&');
            for (k = 0; k < obj.variaty.length; k++) _variaty[k] = Number(obj.variaty[k]);
        }
        if (ob.visible) _visibleTester = Boolean(int(ob.visible));
        if (ob.color && ob.color != 'default') {
            _color = String(ob.color);
        }

        if (ob.group) {
            if (int(ob.group) > 0) {
                _group = int(ob.group);
                g.allData.addToDecorGroup(this);
            }
        }
        if (ob.visibleAction || g.user.isTester) _visibleAction = true;
        else _visibleAction = false;
    }

    public function get blockByLevel():Array{ return _blockByLevel;}
    public function get buildTime():Array{ return _buildTime;}
    public function get buildType():int{ return _buildType;}
    public function get catNeed():Boolean{ return _catNeed;}
    public function get color():String{ return _color;}
    public function get cost():Array{ return _cost;}
    public function get currency():Array{ return _currency;}
    public function get deltaCost():int{ return _deltaCost;}
    public function get filterType():int{ return _filterType;}
    public function get group():int{ return _group;}
    public function get height():int {return _height;}
    public function get id():int {return _id;}
    public function get image():String{ return _image;}
    public function get innerX():*{ return _innerX;}
    public function get innerY():*{ return _innerY;}
    public function get maxAnimalsCount():int{ return _maxAnimalsCount;}
    public function get name():String {return _name;}
    public function get priceSkipHard():int {return _priceSkipHard;}
    public function get startCountCell():int {return _startCountCell;}
    public function get url():String {return _url;}
    public function get visibleAction():Boolean {return _visibleAction;}
    public function get visibleTester():Boolean {return _visibleTester;}
    public function get width():int {return _width;}
    public function get xpForBuild():int {return _xpForBuild;}
    public function get countUnblock():int {return _countUnblock;}
    public function get craftIdResource():int {return _craftIdResource;}
    public function get countCraftResource():Array {return _countCraftResource;}
    public function get removeByResourceId():int {return _removeByResourceId;}
    public function get startCountResources():int{ return _startCountResources;}
    public function get deltaCountResources():int {return _deltaCountResources;}
    public function get startCountInstrumets():int {return _startCountInstrumets;}
    public function get deltaCountAfterUpgrade():int {return _deltaCountAfterUpgrade;}
    public function get upInstrumentId1():int {return _upInstrumentId1;}
    public function get upInstrumentId2():int{ return _upInstrumentId2;}
    public function get upInstrumentId3():int {return _upInstrumentId3;}
    public function get imageActive():String {return _imageActive;}
    public function get idResource():Array {return _idResource;}
    public function get idResourceRaw():Array {return _idResourceRaw;}
    public function get variaty():Array {return _variaty;}
}
}
