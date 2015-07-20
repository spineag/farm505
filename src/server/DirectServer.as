/**
 * Created by user on 7/16/15.
 */
package server {
import com.junkbyte.console.Cc;

import data.BuildType;

import flash.events.Event;

import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

import manager.Vars;

public class DirectServer {
    private var g:Vars = Vars.getInstance();

    public function makeTest():void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_TEST);
        Cc.ch('server', 'start makeTest', 1);
        request.method = URLRequestMethod.POST;
        request.requestHeaders=[new URLRequestHeader("Content-Type", "application/json")];
        loader.addEventListener(Event.COMPLETE, onCompleteTest);
        function onCompleteTest(e:Event):void {
            completeTest(e.target.data);
        }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('test error:' + error.errorID);
        }
    }

    private function completeTest(response:String):void {
        Cc.ch('server', 'on makeTest response: ' + response, 1);
    }

    public function getDataLevel(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DATA_LEVEL);
//        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'start getDataLevel', 1);
//        variables = addDefault(variables);
//        variables.key = generateSecretKey(Consts.INQ_ALLLEVELS);
//        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAllLevels);
        function onCompleteAllLevels(e:Event):void { completeLevels(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataLevel error:' + error.errorID);
        }
    }

    private function completeLevels(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('loadLevels: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            var obj:Object;
            for (var i:int = 0; i<d.message.length; i++) {
                obj = {};
                obj.id = int(d.message[i].number_level);
                obj.xp = int(d.message[i].count_xp);
                g.dataLevel.objectLevels[obj.id] = obj;
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('loadLevels: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getDataAnimal(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DATA_ANIMAL);

        Cc.ch('server', 'start getDataAnimal', 1);
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAnimal);
        function onCompleteAnimal(e:Event):void { completeAnimal(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataAnimal error:' + error.errorID);
        }
    }

    private function completeAnimal(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataAnimal: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            var obj:Object;
            for (var i:int = 0; i<d.message.length; i++) {
                obj = {};
                obj.id = int(d.message[i].id);
                obj.buildId = int(d.message[i].build_id);
                obj.name = d.message[i].name;
                obj.width = 1;
                obj.height = 1;
                obj.url = d.message[i].url;
                obj.image = d.message[i].image;
                obj.cost = int(d.message[i].cost);
                obj.timeCraft = int(d.message[i].time_craft);
                obj.idResource = int(d.message[i].craft_resource_id);
                obj.idResourceRaw = int(d.message[i].raw_resource_id);
                obj.costForceCraft = int(d.message[i].cost_force);
                obj.buildType = BuildType.ANIMAL;
                g.dataAnimal.objectAnimal[obj.id] = obj;
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('getDataAnimal: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getDataRecipe(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DATA_RECIPE);

        Cc.ch('server', 'start getDataRecipe', 1);
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteRecipe);
        function onCompleteRecipe(e:Event):void { completeRecipe(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataRecipe error:' + error.errorID);
        }
    }

    private function completeRecipe(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataRecipe: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            var obj:Object;
            for (var i:int = 0; i<d.message.length; i++) {
                obj = {};
                obj.id = int(d.message[i].id);
                obj.idResource = int(d.message[i].resource_id);
                obj.numberCreate = int(d.message[i].count_create);
                obj.ingridientsId = String(d.message[i].ingredients_id).split('&');
                obj.ingridientsCount = String(d.message[i].ingredients_count).split('&');
                obj.buildingId = int(d.message[i].building_id);
                obj.priceSkipHard = int(d.message[i].prise_skip);
                obj.blockByLevel = int(d.message[i].block_by_level);
                g.dataRecipe.objectRecipe[obj.id] = obj;
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('getDataRecipe: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getDataResource(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DATA_RESOURCE);

        Cc.ch('server', 'start getDataResource', 1);
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteResource);
        function onCompleteResource(e:Event):void { completeResource(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataResource error:' + error.errorID);
        }
    }

    private function completeResource(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataResource: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            var obj:Object;
            for (var i:int = 0; i<d.message.length; i++) {
                obj = {};
                obj.id = int(d.message[i].id);
                obj.blockByLevel = int(d.message[i].block_by_level);
                obj.priceHard = int(d.message[i].cost_hard);
                obj.name = d.message[i].name;
                obj.url = d.message[i].url;
                obj.imageShop = d.message[i].image_shop;
                obj.currency = int(d.message[i].currency);
                obj.costMax = int(d.message[i].cost_max);
                obj.costMin = int(d.message[i].cost_min);
                obj.buildType = int(d.message[i].resource_type);
                obj.placeBuild = int(d.message[i].resource_place);
                if (d.message[i].cost_skip) obj.priceSkipHard = d.message[i].cost_skip;
                if (d.message[i].build_time) obj.buildTime = d.message[i].build_time;
                if (d.message[i].craft_xp) obj.craftXP = d.message[i].craft_xp;
                if (d.message[i].image1) obj.image1 = d.message[i].image1;
                if (d.message[i].image2) obj.image2 = d.message[i].image2;
                if (d.message[i].image3) obj.image3 = d.message[i].image3;
                if (d.message[i].image4) obj.image4 = d.message[i].image4;
                if (d.message[i].image_harvested) obj.imageHarvested = d.message[i].image_harvested;
                if (d.message[i].inner_positions) {
                    obj.innerPositions = String(d.message[i].inner_positions).split('&');
                    for (var k:int = 0; k < obj.innerPositions.length; k++) obj.innerPositions[k] = int(obj.innerPositions[k]);
                }
                g.dataResource.objectResources[obj.id] = obj;
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('getDataResource: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getDataBuilding(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DATA_BUILDING);

        Cc.ch('server', 'start getDataBuilding', 1);
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteBuilding);
        function onCompleteBuilding(e:Event):void { completeBuilding(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataBuilding error:' + error.errorID);
        }
    }

    private function completeBuilding(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataBuilding: wrong JSON:' + String(response));
            return;
        }

        var k:int;
        if (d.id == 0) {
            var obj:Object;
            for (var i:int = 0; i<d.message.length; i++) {
                obj = {};
                obj.id = int(d.message[i].id);
                obj.width = int(d.message[i].width);
                obj.height = int(d.message[i].height);
                obj.innerX = int(d.message[i].inner_x);
                obj.innerY = int(d.message[i].inner_y);
                obj.name = d.message[i].name;
                obj.url = d.message[i].url;
                obj.image = d.message[i].image;
                obj.buildType = int(d.message[i].build_type);

                if (d.message[i].currency) obj.currency = int(d.message[i].currency);
                if (d.message[i].cost) obj.cost = int(d.message[i].cost);
                if (d.message[i].block_by_level) obj.blockByLevel = String(d.message[i].block_by_level).split('&');
                for (k = 0; k < obj.blockByLevel.length; k++) obj.blockByLevel[k] = int(obj.blockByLevel[k]);
                if (d.message[i].cost_skip) obj.priceSkipHard = d.message[i].cost_skip;
                if (d.message[i].build_time) obj.buildTime = d.message[i].build_time;
                if (d.message[i].image_s) obj.imageGrowSmall = d.message[i].image_s;
                if (d.message[i].image_s_flower) obj.imageGrowSmallFlower = d.message[i].image_s_flower;
                if (d.message[i].image_s_growed) obj.imageGrowedSmall = d.message[i].image_s_growed;
                if (d.message[i].image_m) obj.imageGrowMiddle = d.message[i].image_m;
                if (d.message[i].image_m_flower) obj.imageGrowMiddleFlower = d.message[i].image_m_flower;
                if (d.message[i].image_m_growed) obj.imageGrowedMiddle = d.message[i].image_m_growed;
                if (d.message[i].image_b) obj.imageGrowBig = d.message[i].image_b;
                if (d.message[i].image_b_flower) obj.imageGrowBigFlower = d.message[i].image_b_flower;
                if (d.message[i].image_b_growed) {
                    obj.imageGrowedBig = d.message[i].image_b_growed;
                    obj.image = obj.imageGrowedBig;
                }
                if (d.message[i].image_dead) obj.imageDead = d.message[i].image_dead;
                if (d.message[i].inner_position_s) {
                    obj.innerPositionsGrow1 = String(d.message[i].inner_position_s).split('&');
                    for (k = 0; k < obj.innerPositionsGrow1.length; k++) obj.innerPositionsGrow1[k] = int(obj.innerPositionsGrow1[k]);
                }
                if (d.message[i].inner_position_m) {
                    obj.innerPositionsGrow2 = String(d.message[i].inner_position_m).split('&');
                    for (k = 0; k < obj.innerPositionsGrow2.length; k++) obj.innerPositionsGrow2[k] = int(obj.innerPositionsGrow2[k]);
                }
                if (d.message[i].inner_position_b) {
                    obj.innerPositionsGrow3 = String(d.message[i].inner_position_b).split('&');
                    for (k = 0; k < obj.innerPositionsGrow3.length; k++) obj.innerPositionsGrow3[k] = int(obj.innerPositionsGrow3[k]);
                }
                obj.innerPositionsDead = [obj.innerX, obj.innerY];
                if (d.message[i].craft_resource_id) obj.craftIdResource = int(d.message[i].craft_resource_id);
                if (d.message[i].count_craft_resource) {
                    obj.countCraftResource = String(d.message[i].count_craft_resource).split('&');
                    for (k = 0; k < obj.countCraftResource.length; k++) obj.countCraftResource[k] = int(obj.countCraftResource[k]);
                }
                if (d.message[i].start_count_resources) obj.startCountResources = int(d.message[i].start_count_resources);
                if (d.message[i].delta_count_resources) obj.startCountResources = int(d.message[i].delta_count_resources);
                if (d.message[i].start_count_instruments) obj.startCountInstrumets = int(d.message[i].start_count_instruments);
                if (d.message[i].delta_count_instruments) obj.deltaCountAfterUpgrade = int(d.message[i].delta_count_instruments);
                if (d.message[i].up_instrument_id_1) obj.upInstrumentId1 = int(d.message[i].up_instrument_id_1);
                if (d.message[i].up_instrument_id_2) obj.upInstrumentId2 = int(d.message[i].up_instrument_id_2);
                if (d.message[i].up_instrument_id_3) obj.upInstrumentId3 = int(d.message[i].up_instrument_id_3);
                if (d.message[i].image_house) obj.imageHouse = d.message[i].image_house;
                if (d.message[i].inner_house_x) obj.innerHouseX = int(d.message[i].inner_house_x);
                if (d.message[i].inner_house_y) obj.innerHouseY = int(d.message[i].inner_house_y);
                if (d.message[i].max_count) obj.maxAnimalsCount = int(d.message[i].max_count);

                g.dataBuilding.objectBuilding[obj.id] = obj;
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('getDataBuilding: id: ' + d.id + '  with message: ' + d.message);
        }
    }
}
}
