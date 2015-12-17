/**
 * Created by user on 7/16/15.
 */
package server {
import build.WorldObject;
import build.WorldObject;
import build.fabrica.Fabrica;
import build.farm.Animal;
import build.ridge.Ridge;
import build.train.Train;
import build.tree.Tree;
import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;

import flash.events.Event;
import flash.geom.Point;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.utils.getTimer;

import manager.ManagerAnimal;
import manager.ManagerFabricaRecipe;
import manager.ManagerPlantRidge;
import manager.ManagerTree;
import manager.Vars;

import user.Someone;

import user.Someone;

import windows.serverError.WOServerError;


public class DirectServer {
    private var g:Vars = Vars.getInstance();
    private var woError:WOServerError = new WOServerError();

    public function makeTest():void {
        if (!g.useDataFromServer) return;

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
        if (!g.useDataFromServer) return;

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
            woError.showItParams('getDataLevel error:' + error.errorID);
        }
    }

    private function completeLevels(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('loadLevels: wrong JSON:' + String(response));
            woError.showItParams('loadLevels: wrong JSON:' + String(response));
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
            woError.showItParams('loadLevels: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getDataAnimal(callback:Function):void {
        if (!g.useDataFromServer) return;

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
            woError.showItParams('getDataAnimal error:' + error.errorID);
        }
    }

    private function completeAnimal(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataAnimal: wrong JSON:' + String(response));
            woError.showItParams('getDataAnimal: wrong JSON:' + String(response));
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
                obj.cost2 = int(d.message[i].cost2);
                obj.cost3 = int(d.message[i].cost3);
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
            woError.showItParams('getDataAnimal: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getDataRecipe(callback:Function):void {
        if (!g.useDataFromServer) return;

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
            woError.showItParams('getDataRecipe error:' + error.errorID);
        }
    }

    private function completeRecipe(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataRecipe: wrong JSON:' + String(response));
            woError.showItParams('getDataRecipe: wrong JSON:' + String(response));
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
                obj.blockByLevel = g.dataResource.objectResources[obj.idResource].blockByLevel;
                g.dataRecipe.objectRecipe[obj.id] = obj;
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('getDataRecipe: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('getDataRecipe: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getDataResource(callback:Function):void {
        if (!g.useDataFromServer) return;

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
            woError.showItParams('getDataResource error:' + error.errorID);
        }
    }

    private function completeResource(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataResource: wrong JSON:' + String(response));
            woError.showItParams('getDataResource: wrong JSON:' + String(response));
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
                obj.costDefault = int(d.message[i].cost_default);
                obj.costMax = int(d.message[i].cost_max);
                obj.costMin = int(d.message[i].cost_min);
                obj.orderPrice = int(d.message[i].order_price);
                obj.orderXP = int(d.message[i].order_xp);
                obj.visitorPrice = int(d.message[i].visitor_price);
                obj.buildType = int(d.message[i].resource_type);
                obj.placeBuild = int(d.message[i].resource_place);
                obj.orderType = int(d.message[i].order_type);
                obj.opys = d.message[i].descript;
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
            woError.showItParams('getDataResource: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getDataCats(callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DATA_CATS);

        Cc.ch('server', 'start getDataCats', 1);
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteCats);
        function onCompleteCats(e:Event):void { completeCats(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataCats error:' + error.errorID);
            woError.showItParams('getDataCats error:' + error.errorID);
        }
    }

    private function completeCats(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataCats: wrong JSON:' + String(response));
            woError.showItParams('getDataCats: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            var obj:Object;
            g.dataCats = new Array();
            for (var i:int = 0; i<d.message.length; i++) {
                obj = {};
                obj.id = int(d.message[i].id);
                obj.blockByLevel = [int(d.message[i].block_by_level)];
                obj.cost = int(d.message[i].cost);
                obj.currency == DataMoney.SOFT_CURRENCY
                g.dataCats.push(obj);
            }
            g.dataCats.sortOn('blockByLevel', Array.NUMERIC);
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('getDataResource: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('getDataResource: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getDataBuilding(callback:Function):void {
        if (!g.useDataFromServer) return;

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
            woError.showItParams('getDataBuilding error:' + error.errorID);
        }
    }

    private function completeBuilding(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataBuilding: wrong JSON:' + String(response));
            woError.showItParams('getDataBuilding: wrong JSON:' + String(response));
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
                obj.xpForBuild = int(d.message[i].xp_for_build);
                obj.buildType = int(d.message[i].build_type);

                if (d.message[i].count_cell) obj.startCountCell = int(d.message[i].count_cell);
                if (d.message[i].currency) obj.currency = int(d.message[i].currency);
                if (d.message[i].cost) obj.cost = int(d.message[i].cost);
                if (d.message[i].delta_cost) obj.deltaCost = int(d.message[i].delta_cost);
                if (d.message[i].block_by_level) {
                    obj.blockByLevel = String(d.message[i].block_by_level).split('&');
                    for (k = 0; k < obj.blockByLevel.length; k++) obj.blockByLevel[k] = int(obj.blockByLevel[k]);
                }
                if (d.message[i].cost_skip) obj.priceSkipHard = d.message[i].cost_skip;
                if (d.message[i].build_time) obj.buildTime = int(d.message[i].build_time);
                if (d.message[i].count_unblock) obj.countUnblock = int(d.message[i].count_unblock);
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
//                    obj.image = obj.imageGrowedBig;
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
                if (d.message[i].instrument_id) obj.removeByResourceId = int(d.message[i].instrument_id);
                if (d.message[i].start_count_resources) obj.startCountResources = int(d.message[i].start_count_resources);
                if (d.message[i].delta_count_resources) obj.deltaCountResources = int(d.message[i].delta_count_resources);
                if (d.message[i].start_count_instruments) obj.startCountInstrumets = int(d.message[i].start_count_instruments);
                if (d.message[i].delta_count_instruments) obj.deltaCountAfterUpgrade = int(d.message[i].delta_count_instruments);
                if (d.message[i].up_instrument_id_1) obj.upInstrumentId1 = int(d.message[i].up_instrument_id_1);
                if (d.message[i].up_instrument_id_2) obj.upInstrumentId2 = int(d.message[i].up_instrument_id_2);
                if (d.message[i].up_instrument_id_3) obj.upInstrumentId3 = int(d.message[i].up_instrument_id_3);
                if (d.message[i].image_house) obj.imageHouse = d.message[i].image_house;
                if (d.message[i].inner_house_x) obj.innerHouseX = int(d.message[i].inner_house_x);
                if (d.message[i].inner_house_y) obj.innerHouseY = int(d.message[i].inner_house_y);
                if (d.message[i].max_count) obj.maxAnimalsCount = int(d.message[i].max_count);
                if (d.message[i].image_active) obj.imageActive = d.message[i].image_active;
                if (d.message[i].resource_id) {
                    obj.idResource = String(d.message[i].resource_id).split('&');
                    for (k = 0; k < obj.idResource.length; k++) obj.idResource[k] = int(obj.idResource[k]);
                }
                if (d.message[i].raw_resource_id) {
                    obj.idResourceRaw = String(d.message[i].raw_resource_id).split('&');
                    for (k = 0; k < obj.idResourceRaw.length; k++) obj.idResourceRaw[k] = int(obj.idResourceRaw[k]);
                }
                if (d.message[i].variaty) {
                    obj.variaty = String(d.message[i].variaty).split('&');
                    for (k = 0; k < obj.variaty.length; k++) obj.variaty[k] = Number(obj.variaty[k]);
                }

                g.dataBuilding.objectBuilding[obj.id] = obj;
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('getDataBuilding: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('getDataBuilding: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function authUser(callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_START);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'authUser', 1);
//        variables = addDefault(variables);
        variables.idSocial = g.user.userSocialId;
        variables.name = g.user.name;
        variables.lastName = g.user.lastName;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAuthUser);
        function onCompleteAuthUser(e:Event):void { completeAuthUser(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('authUser error:' + error.errorID);
            woError.showItParams('authUser error:' + error.errorID);
        }
    }

    private function completeAuthUser(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('authUser: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            g.user.userId = int(d.message);
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('authUser: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('authUser: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getUserInfo(callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USER_INFO);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserInfo', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteUserInfo);
        function onCompleteUserInfo(e:Event):void { completeUserInfo(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('userInfo error:' + error.errorID);
            woError.showItParams('userInfo error:' + error.errorID);
        }
    }

    private function completeUserInfo(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('userInfo: wrong JSON:' + String(response));
            woError.showItParams('userInfo: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            var ob:Object = d.message;
            g.user.ambarLevel = int(ob.ambar_level);
            g.user.skladLevel = int(ob.sklad_level);
            g.user.ambarMaxCount = int(ob.ambar_max);
            g.user.skladMaxCount = int(ob.sklad_max);
            g.user.hardCurrency = int(ob.hard_count);
            g.user.softCurrencyCount = int(ob.soft_count);
            g.user.redCouponCount = int(ob.red_count);
            g.user.yellowCouponCount = int(ob.yellow_count);
            g.user.blueCouponCount = int(ob.blue_count);
            g.user.greenCouponCount = int(ob.green_count);
            g.user.globalXP = int(ob.xp);
//            g.user.level = int(ob.level);
            g.user.countCats = int(ob.count_cats);
            if (ob.scale) {
                g.currentGameScale = int(ob.scale)/100;
            }
            if (ob.is_tester && int(ob.is_tester) > 0) {
                g.user.isTester = true;
                if (int(ob.is_tester) > 1) {
                    g.user.isMegaTester = true;
                }
            } else {
                g.user.isMegaTester = false;
                g.user.isTester = false;
            }

            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('userInfo: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('userInfo: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getFriendsInfo(userSocialId:int,_person:Someone,callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_FRIENDS_INFO);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getFriendsInfo', 1);
        variables.userSocialId = userSocialId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteFriendsInfo);
        function onCompleteFriendsInfo(e:Event):void { completeFriendsInfo(e.target.data,_person, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getFriendsInfo error:' + error.errorID);
            woError.showItParams('getFriendsInfo error:' + error.errorID);
        }
    }

    private function completeFriendsInfo(response:String,_person:Someone, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getFriendsInfo: wrong JSON:' + String(response));
            woError.showItParams('getFriendsInfo: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
                _person.level = d.message.level;
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('getFriendsInfo: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('getFriendsInfo: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function addUserMoney(type:int, count:int, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USER_MONEY);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserMoney', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.type = type;
        variables.count = count;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserMoney);
        function onCompleteAddUserMoney(e:Event):void { completeAddUserMoney(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserMoney error:' + error.errorID);
            woError.showItParams('addUserMoney error:' + error.errorID);
        }
    }

    private function completeAddUserMoney(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserMoney: wrong JSON:' + String(response));
            woError.showItParams('addUserMoney: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else {
            Cc.error('addUserMoney: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('addUserMoney: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function addUserXP(count:int, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_XP);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserXP', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.count = count;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserXP);
        function onCompleteAddUserXP(e:Event):void { completeAddUserXP(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserXP error:' + error.errorID);
            woError.showItParams('addUserXP error:' + error.errorID);
        }
    }

    private function completeAddUserXP(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserXP: wrong JSON:' + String(response));
            woError.showItParams('addUserXP: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else {
            Cc.error('addUserXP: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('addUserXP: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function updateUserLevel(callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_LEVEL);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserLevel', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.level = g.user.level;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserLevel);
        function onCompleteUpdateUserLevel(e:Event):void { completeUpdateUserLevel(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserLevel error:' + error.errorID);
            woError.showItParams('updateUserLevel error:' + error.errorID);
        }
    }

    private function completeUpdateUserLevel(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserLevel: wrong JSON:' + String(response));
            woError.showItParams('updateUserLevel: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else {
            Cc.error('updateUserLevel: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('updateUserLevel: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function getUserResource(callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_RESOURCE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserResource', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserResource);
        function onCompleteGetUserResource(e:Event):void { completeGetUserResource(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('GetUserResource error:' + error.errorID);
            woError.showItParams('GetUserResource error:' + error.errorID);
        }
    }

    private function completeGetUserResource(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
            for (var i:int = 0; i < d.message.length; i++) {
                g.userInventory.addResource(int(d.message[i].resource_id), int(d.message[i].count), false);
            }
        } catch (e:Error) {
            Cc.error('GetUserResource: wrong JSON:' + String(response));
            woError.showItParams('GetUserResource: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('GetUserResource: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('GetUserResource: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function addUserResource(resourceId:int, count:int, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_RESOURCE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserResource', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.resourceId = resourceId;
        variables.count = count;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserResource);
        function onCompleteAddUserResource(e:Event):void { completeAddUserResource(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserResource error:' + error.errorID);
            woError.showItParams('addUserResource error:' + error.errorID);
        }
    }

    private function completeAddUserResource(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserResource: wrong JSON:' + String(response));
            woError.showItParams('addUserResource: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else {
            Cc.error('addUserResource: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('addUserResource: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function addUserBuilding(wObject:WorldObject, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_BUILDING);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserBuilding', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.buildingId = wObject.dataBuild.id;
        variables.posX = wObject.posX;
        variables.posY = wObject.posY;
        if (wObject is Fabrica) {
            variables.countCell = wObject.dataBuild.countCell;
        } else {
            variables.countCell = 0;
        }
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserBuilding);
        function onCompleteAddUserBuilding(e:Event):void { completeAddUserBuilding(e.target.data, wObject, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserBuilding error:' + error.errorID);
            woError.showItParams('addUserBuilding error:' + error.errorID);
        }
    }

    private function completeAddUserBuilding(response:String, wObject:WorldObject, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserBuilding: wrong JSON:' + String(response));
            woError.showItParams('addUserBuilding: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            wObject.dbBuildingId = int(d.message);
            if (g.user.userBuildingData[wObject.dataBuild.id])
                g.user.userBuildingData[wObject.dataBuild.id].dbId = int(d.message);
            if (callback != null) {
                callback.apply(null, [true, wObject]);
            }
        } else {
            Cc.error('addUserBuilding: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('addUserBuilding: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function getUserBuilding(callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_BUILDING);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserBuilding', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserBuilding);
        function onCompleteGetUserBuilding(e:Event):void { completeGetUserBuilding(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('GetUserBuilding error:' + error.errorID);
            woError.showItParams('GetUserBuilding error:' + error.errorID);
        }
    }

    private function completeGetUserBuilding(response:String, callback:Function = null):void {
        var d:Object;
        var ob:Object;
        var dbId:int;
        var dataBuild:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('GetUserBuilding: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            g.user.userDataCity.objects = new Array();
            for (var i:int = 0; i < d.message.length; i++) {
                d.message[i].id ? dbId = int(d.message[i].id) : dbId = 0;
                dataBuild = g.dataBuilding.objectBuilding[int(d.message[i].building_id)];
                if (int(d.message[i].in_inventory)) {
                    g.userInventory.addToDecorInventory(dataBuild.id, dbId);
                } else {
                    if (d.message[i].time_build_building) {
                        ob = {};
                        ob.dbId = dbId;
                        ob.timeBuildBuilding = Number(d.message[i].time_build_building);
                        ob.isOpen = int(d.message[i].is_open);
                        g.user.userBuildingData[int(d.message[i].building_id)] = ob;
                    }
                    dataBuild.dbId = dbId;
                    dataBuild.isFlip = int(d.message[i].is_flip);
                    if (d.message[i].count_cell) dataBuild.countCell = int(d.message[i].count_cell);
                    var p:Point = new Point(int(d.message[i].pos_x), int(d.message[i].pos_y));
                    if (dataBuild.buildType == BuildType.CAVE || dataBuild.buildType == BuildType.MARKET || dataBuild.buildType == BuildType.SHOP ||
                            dataBuild.buildType == BuildType.PAPER || dataBuild.buildType == BuildType.DAILY_BONUS || dataBuild.buildType == BuildType.TRAIN) {
                        //do nothing, use usual x and y from server
                    } else {
                        // in another case we get isometric coordinates from server
                        p = g.matrixGrid.getXYFromIndex(p);
                    }
                    g.townArea.createNewBuild(dataBuild, p.x, p.y, true, dbId);

                    ob = {};
                    ob.buildId = dataBuild.id;
                    ob.posX = int(d.message[i].pos_x);
                    ob.posY = int(d.message[i].pos_y);
                    ob.isFlip = int(d.message[i].is_flip);
                    ob.dbId = dbId;
                    if (d.message[i].time_build_building) {
                        ob.isBuilded = true;
                        ob.isOpen = Boolean(int(d.message[i].is_open));
                    }
                    g.user.userDataCity.objects.push(ob);
                }
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('GetUserBuilding: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('GetUserBuilding: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function startBuildBuilding(wObject:WorldObject, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_START_BUILD_BUILDING);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'startBuildMapBuilding', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.buildingId = wObject.dataBuild.id;
        variables.dbId = wObject.dbBuildingId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteStartBuildMapBuilding);
        function onCompleteStartBuildMapBuilding(e:Event):void { completeStartBuildMapBuilding(e.target.data, wObject, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('startBuildMapBuilding error:' + error.errorID);
            woError.showItParams('startBuildMapBuilding error:' + error.errorID);
        }
    }

    private function completeStartBuildMapBuilding(response:String, wObject:WorldObject, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('startBuildMapBuilding: wrong JSON:' + String(response));
            woError.showItParams('startBuildMapBuilding: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else {
            Cc.error('startBuildMapBuilding: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('startBuildMapBuilding: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function openBuildedBuilding(wObject:WorldObject, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_OPEN_BUILDED_BUILDING);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'openBuildMapBuilding', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.buildingId = wObject.dataBuild.id;
        variables.dbId = wObject.dbBuildingId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteOpenBuildMapBuilding);
        function onCompleteOpenBuildMapBuilding(e:Event):void { completeOpenBuildMapBuilding(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('openBuildMapBuilding error:' + error.errorID);
            woError.showItParams('openBuildMapBuilding error:' + error.errorID);
        }
    }

    private function completeOpenBuildMapBuilding(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('openBuildMapBuilding: wrong JSON:' + String(response));
            woError.showItParams('openBuildMapBuilding: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else {
            Cc.error('openBuildMapBuilding: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('openBuildMapBuilding: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function addFabricaRecipe(recipeId:int, dbId:int, delay:int, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_FABRICA_RECIPE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addFabricaRecipe', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.recipeId = recipeId;
        variables.dbId = dbId;
        variables.delay = delay;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAddFabricaRecipe);
        function onCompleteAddFabricaRecipe(e:Event):void { completeAddFabricaRecipe(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addFabricaRecipe error:' + error.errorID);
            woError.showItParams('addFabricaRecipe error:' + error.errorID);
        }
    }

    private function completeAddFabricaRecipe(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addFabricaRecipe: wrong JSON:' + String(response));
            woError.showItParams('addFabricaRecipe: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply(null, [d.message]);
            }
        } else {
            Cc.error('addFabricaRecipe: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('addFabricaRecipe: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function getUserFabricaRecipe(callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_FABRICA_RECIPE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserFabricaRecipe', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserFabricaRecipe);
        function onCompleteGetUserFabricaRecipe(e:Event):void { completeGetUserFabricaRecipe(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('GetUserFabricaRecipe error:' + error.errorID);
            woError.showItParams('GetUserFabricaRecipe error:' + error.errorID);
        }
    }

    private function completeGetUserFabricaRecipe(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('GetUserFabricaRecipe: wrong JSON:' + String(response));
            woError.showItParams('GetUserFabricaRecipe: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            (d.message as Array).sortOn('delay', Array.NUMERIC);
            g.managerFabricaRecipe = new ManagerFabricaRecipe();
            for (var i:int = 0; i < d.message.length; i++) {
                g.managerFabricaRecipe.addRecipe(d.message[i]);
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('GetUserFabricaRecipe: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('GetUserFabricaRecipe: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function craftFabricaRecipe(dbId:String, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_CRAFT_FABRICA_RECIPE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'craftFabricaRecipe', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteCraftFabricaRecipe);
        function onCompleteCraftFabricaRecipe(e:Event):void { completeCraftFabricaRecipe(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('craftFabricaRecipe error:' + error.errorID);
            woError.showItParams('craftFabricaRecipe error:' + error.errorID);
        }
    }

    private function completeCraftFabricaRecipe(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('craftFabricaRecipe: wrong JSON:' + String(response));
            woError.showItParams('craftFabricaRecipe: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else {
            Cc.error('craftFabricaRecipe: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('craftFabricaRecipe: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function rawPlantOnRidge(plantId:int, dbId:int, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_RAW_PLANT_RIDGE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'rawPlantOnRidge', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.plantId = plantId;
        variables.dbId = dbId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteRawPlantOnRidge);
        function onCompleteRawPlantOnRidge(e:Event):void { completeRawPlantOnRidge(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('rawPlantOnRidge error:' + error.errorID);
            woError.showItParams('rawPlantOnRidge error:' + error.errorID);
        }
    }

    private function completeRawPlantOnRidge(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('rawPlantOnRidge: wrong JSON:' + String(response));
            woError.showItParams('rawPlantOnRidge: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply(null, [d.message]);
            }
        } else {
            Cc.error('rawPlantOnRidge: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('rawPlantOnRidge: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function getUserPlantRidge(callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_PLANT_RIDGE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserPlantRidge', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserPlantRidge);
        function onCompleteGetUserPlantRidge(e:Event):void { completeGetUserPlantRidge(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('GetUserPlantRidge error:' + error.errorID);
            woError.showItParams('GetUserPlantRidge error:' + error.errorID);
        }
    }

    private function completeGetUserPlantRidge(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('GetUserPlantRidge: wrong JSON:' + String(response));
            woError.showItParams('GetUserPlantRidge: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            var ob:Object;
            var time:int;
            var timeWork:int;

            g.user.userDataCity.plants = [];
            g.managerPlantRidge = new ManagerPlantRidge();
            for (var i:int = 0; i < d.message.length; i++) {
                g.managerPlantRidge.addPlant(d.message[i]);

                ob = {};
                ob.plantId = int(d.message[i].plant_id);
                ob.dbId = int(d.message[i].user_db_building_id);
                time = g.dataResource.objectResources[ob.plantId].buildTime;
                timeWork = int(d.message[i].time_work);
                if (timeWork > time) ob.state = Ridge.GROWED;
                else if (timeWork > 2/3*time) ob.state = Ridge.GROW3;
                else if (timeWork > time/3) ob.state = Ridge.GROW2;
                else ob.state = Ridge.GROW1;
                g.user.userDataCity.plants.push(ob);
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('GetUserPlantRidge: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('GetUserPlantRidge: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function craftPlantRidge(dbId:String, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_CRAFT_PLANT_RIDGE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'craftPlantRidge', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteCraftPlantRidge);
        function onCompleteCraftPlantRidge(e:Event):void { completeCraftPlantRidge(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('craftPlantRidge error:' + error.errorID);
            woError.showItParams('craftPlantRidge error:' + error.errorID);
        }
    }

    private function completeCraftPlantRidge(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('craftPlantRidge: wrong JSON:' + String(response));
            woError.showItParams('craftPlantRidge: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else {
            Cc.error('craftPlantRidge: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('craftPlantRidge: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function addUserTree(wObject:WorldObject, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_TREE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserTree', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = wObject.dbBuildingId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserTree);
        function onCompleteAddUserTree(e:Event):void { completeAddUserTree(e.target.data, wObject, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserTree error:' + error.errorID);
            woError.showItParams('addUserTree error:' + error.errorID);
        }
    }

    private function completeAddUserTree(response:String, wObject:WorldObject, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserTree: wrong JSON:' + String(response));
            woError.showItParams('addUserTree: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            (wObject as Tree).tree_db_id = d.message;
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else {
            Cc.error('addUserTree: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('addUserTree: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function getUserTree(callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_TREE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserTree', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserTree);
        function onCompleteGetUserTree(e:Event):void { completeGetUserTree(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('GetUserTree error:' + error.errorID);
            woError.showItParams('GetUserTree error:' + error.errorID);
        }
    }

    private function completeGetUserTree(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('GetUserTree: wrong JSON:' + String(response));
            woError.showItParams('GetUserTree: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            var ob:Object;
            g.user.userDataCity.treesInfo = [];
            g.managerTree = new ManagerTree();
            for (var i:int = 0; i < d.message.length; i++) {
                g.managerTree.addTree(d.message[i]);

                ob = {};
                ob.dbId = int(d.message[i].user_db_building_id);
                ob.time_work = int(ob.time_work);
                g.user.userDataCity.treesInfo.push(ob);
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('GetUserTree: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('GetUserTree: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserTreeState(treeDbId:String, state:int, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_TREE_STATE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserTreeState', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.id = treeDbId;
        variables.state = state;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserTreeState);
        function onCompleteUpdateUserTreeState(e:Event):void { completeUpdateUserTreeState(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserTreeState error:' + error.errorID);
            woError.showItParams('updateUserTreeState error:' + error.errorID);
        }
    }

    private function completeUpdateUserTreeState(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserTreeState: wrong JSON:' + String(response));
            woError.showItParams('updateUserTreeState: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('updateUserTreeState: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('updateUserTreeState: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function deleteUserTree(treeDbId:String, dbId:int, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DELETE_USER_TREE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'deleteUserTree', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        variables.treeDbId = treeDbId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteDeleteUserTree);
        function onCompleteDeleteUserTree(e:Event):void { completeDeleteUserTree(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('deleteUserTree error:' + error.errorID);
            woError.showItParams('deleteUserTree error:' + error.errorID);
        }
    }

    private function completeDeleteUserTree(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('deleteUserTree: wrong JSON:' + String(response));
            woError.showItParams('deleteUserTree: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('deleteUserTree: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('deleteUserTree: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function addUserAnimal(an:Animal, farmDbId:int, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_ANIMAL);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserAnimal', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.farmDbId = farmDbId;
        variables.animalId = an.animalData.id;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserAnimal);
        function onCompleteAddUserAnimal(e:Event):void { completeAddUserAnimal(e.target.data, an, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserAnimal error:' + error.errorID);
            woError.showItParams('addUserAnimal error:' + error.errorID);
        }
    }

    private function completeAddUserAnimal(response:String, an:Animal, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserAnimal: wrong JSON:' + String(response));
            woError.showItParams('addUserAnimal: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            an.animal_db_id = d.message;
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else {
            Cc.error('addUserTree: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('addUserTree: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function rawUserAnimal(anDbId:String, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_RAW_USER_ANIMAL);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'rawUserAnimal', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.anDbId = anDbId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteRawUserAnimal);
        function onCompleteRawUserAnimal(e:Event):void { completeRawUserAnimal(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('rawUserAnimal error:' + error.errorID);
            woError.showItParams('rawUserAnimal error:' + error.errorID);
        }
    }

    private function completeRawUserAnimal(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('rawUserAnimal: wrong JSON:' + String(response));
            woError.showItParams('rawUserAnimal: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else {
            Cc.error('rawUserTree: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('rawUserTree: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function getUserAnimal(callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_ANIMAL);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserAnimal', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserAnimal);
        function onCompleteGetUserAnimal(e:Event):void { completeGetUserAnimal(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('GetUserAnimal error:' + error.errorID);
            woError.showItParams('GetUserAnimal error:' + error.errorID);
        }
    }

    private function completeGetUserAnimal(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('GetUserAnimal: wrong JSON:' + String(response));
            woError.showItParams('GetUserAnimal: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            var ob:Object;
            g.user.userDataCity.animalsInfo = [];
            g.managerAnimal = new ManagerAnimal();
            for (var i:int = 0; i < d.message.length; i++) {
                g.managerAnimal.addAnimal(d.message[i]);

                ob = {};
                ob.animalId = int(d.message[i].animal_id);
                ob.timeWork = int(d.message[i].time_work);
                ob.dbId = int(d.message[i].user_db_building_id);
                g.user.userDataCity.animalsInfo.push(ob);
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('GetUserAnimal: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('GetUserAnimal: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function craftUserAnimal(animalDbId:String, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_CRAFT_USER_ANIMAL);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'craftUserAnimal', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.animalDbId = animalDbId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteCraftUserAnimal);
        function onCompleteCraftUserAnimal(e:Event):void { completeCraftUserAnimal(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('craftUserAnimal error:' + error.errorID);
            woError.showItParams('craftUserAnimal error:' + error.errorID);
        }
    }

    private function completeCraftUserAnimal(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('craftUserAnimal: wrong JSON:' + String(response));
            woError.showItParams('craftUserAnimal: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            g.managerAnimal = new ManagerAnimal();
            for (var i:int = 0; i < d.message.length; i++) {
                g.managerAnimal.addAnimal(d.message[i]);
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('craftUserAnimal: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('craftUserAnimal: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function addUserTrain(callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_TRAIN);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserTrain', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserTrain);
        function onCompleteAddUserTrain(e:Event):void { completeAddUserTrain(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserTrain error:' + error.errorID);
            woError.showItParams('addUserTrain error:' + error.errorID);
        }
    }

    private function completeAddUserTrain(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserTrain: wrong JSON:' + String(response));
            woError.showItParams('addUserTrain: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [0]);
            }
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply(null, [d.message]);
            }
        } else {
            Cc.error('addUserTrain: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('addUserTrain: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [0]);
            }
        }
    }

    public function getUserTrain(callback:Function):void {
        if (!g.useDataFromServer) return;

        var tr:Train;
        for (var i:int=0; i<g.townArea.cityObjects.length; i++) {
            if (g.townArea.cityObjects[i] is Train) {
                tr = g.townArea.cityObjects[i];
                break;
            }
        }
        if (!tr ||tr.stateBuild < 4) {
            if (callback != null) {
                callback.apply();
            }
            return;
        }

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_TRAIN);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserTrain', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserTrain);
        function onCompleteGetUserTrain(e:Event):void { completeGetUserTrain(e.target.data, tr, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserTrain error:' + error.errorID);
            woError.showItParams('getUserTrain error:' + error.errorID);
        }
    }

    private function completeGetUserTrain(response:String, tr:Train, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('GetUserTrain: wrong JSON:' + String(response));
            woError.showItParams('GetUserTrain: wrong JSON:' + String(response));
        }

        if (d.id == 0) {
            tr.fillFromServer(d.message);
        } else {
            Cc.error('GetUserTrain: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('GetUserTrain: id: ' + d.id + '  with message: ' + d.message);
        }

        if (callback != null) {
            callback.apply();
        }
    }

    public function updateUserTrainState(state:int, train_db_id:String, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_TRAIN_STATE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserTrainState', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.state = state;
        variables.id = train_db_id;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserTrainState);
        function onCompleteUpdateUserTrainState(e:Event):void { completeUpdateUserTrainState(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserTrainState error:' + error.errorID);
            woError.showItParams('updateUserTrainState error:' + error.errorID);
        }
    }

    private function completeUpdateUserTrainState(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserTrainState: wrong JSON:' + String(response));
            woError.showItParams('updateUserTrainState: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply();
            }
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('updateUserTrainState: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('updateUserTrainState: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply();
            }
        }
    }

    public function getTrainPack(userSocialId:String, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_TRAIN_PACK);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getTrainPack', 1);
//        variables = addDefault(variables);
        variables.userSocialId = userSocialId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetTrainPack);
        function onCompleteGetTrainPack(e:Event):void { completeGetTrainPack(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getTrainPack error:' + error.errorID);
            woError.showItParams('getTrainPack error:' + error.errorID);
        }
    }

    private function completeGetTrainPack(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getTrainPack: wrong JSON:' + String(response));
            woError.showItParams('getTrainPack: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply(null, [d.message]);
            }
            return;
        } else {
            Cc.error('getTrainPack: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('getTrainPack: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function releaseUserTrainPack(train_db_id:String, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_RELEASE_USER_TRAIN_PACK);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'releaseUserTrainPack', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.id = train_db_id;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteReleaseUserTrainPack);
        function onCompleteReleaseUserTrainPack(e:Event):void { completeReleaseUserTrainPack(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('releaseUserTrainPack error:' + error.errorID);
            woError.showItParams('releaseUserTrainPack error:' + error.errorID);
        }
    }

    private function completeReleaseUserTrainPack(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('releaseUserTrainPack: wrong JSON:' + String(response));
            woError.showItParams('releaseUserTrainPack: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply();
            }
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('releaseUserTrainPack: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('releaseUserTrainPack: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply();
            }
        }
    }

    public function updateUserTrainPackItems(train_item_db_id:String, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_TRAIN_PACK_ITEM);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserTrainPackItems ', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.id = train_item_db_id;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserTrainPackItems);
        function onCompleteUpdateUserTrainPackItems(e:Event):void { completeUpdateUserTrainPackItems(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserTrainPackItems error:' + error.errorID);
            woError.showItParams('updateUserTrainPackItems error:' + error.errorID);
        }
    }

    private function completeUpdateUserTrainPackItems(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserTrainPackItems: wrong JSON:' + String(response));
            woError.showItParams('updateUserTrainPackItems: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply();
            }
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('updateUserTrainPackItems: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('updateUserTrainPackItems: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply();
            }
        }
    }

    public function deleteUser(callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DELETE_USER);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'deleteUser', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteDeleteUser);
        function onCompleteDeleteUser(e:Event):void { completeDeleteUser(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('deleteUser error:' + error.errorID);
            woError.showItParams('deleteUser error:' + error.errorID);
        }
    }

    private function completeDeleteUser(response:String, callback:Function = null):void {
        if (callback != null) {
            callback.apply();
        }
        Cc.error('deleteUser responce:' + response);
    }

    public function addUserMarketItem(id:int, count:int, inPapper:Boolean, cost:int, numberCell:int, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_MARKET_ITEM);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserMarketItem', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.resourceId = id;
        variables.count = count;
        variables.cost = cost;
        variables.numberCell = numberCell;
        variables.inPapper = inPapper ? 1 : 0;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserMarketItem);
        function onCompleteAddUserMarketItem(e:Event):void { completeAddUserMarketItem(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserMarketItem error:' + error.errorID);
            woError.showItParams('addUserMarketItem error:' + error.errorID);
        }
    }

    private function completeAddUserMarketItem(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserMarketItem: wrong JSON:' + String(response));
            woError.showItParams('addUserMarketItem: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply(null, [d.message]);
            }
            return;
        } else {
            Cc.error('addUserMarketItem: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('addUserMarketItem: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getUserMarketItem(socialId:String, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_MARKET_ITEM);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserMarketItem', 1);
//        variables = addDefault(variables);
        variables.userSocialId = socialId;
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserMarketItem);
        function onCompleteGetUserMarketItem(e:Event):void { completeGetUserMarketItem(e.target.data, socialId, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserMarketItem error:' + error.errorID);
            woError.showItParams('getUserMarketItem error:' + error.errorID);
        }
    }

    private function completeGetUserMarketItem(response:String, socialId:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getUserMarketItem: wrong JSON:' + String(response));
            woError.showItParams('getUserMarketItem: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            g.user.fillSomeoneMarketItems(d.message, socialId);
            if (callback != null) {
                callback.apply();
            }
            return;
        } else {
            Cc.error('getUserMarketItem: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('getUserMarketItem: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function buyFromMarket(itemId:int, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_BUY_FROM_MARKET);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'buyFromMarket', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.itemId = itemId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteBuyFromMarket);
        function onCompleteBuyFromMarket(e:Event):void { completeBuyFromMarket(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('buyFromMarket error:' + error.errorID);
            woError.showItParams('buyFromMarket error:' + error.errorID);
        }
    }

    private function completeBuyFromMarket(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('buyFromMarket: wrong JSON:' + String(response));
            woError.showItParams('buyFromMarket: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply();
            }
            return;
        } else {
            Cc.error('buyFromMarket: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('buyFromMarket: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function deleteUserMarketItem(itemId:int, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DELETE_USER_MARKET_ITEM);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'deleteUserMarketItem', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.itemId = itemId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteDeleteUserMarketItem);
        function onCompleteDeleteUserMarketItem(e:Event):void { completeDeleteUserMarketItem(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('deleteUserMarketItem error:' + error.errorID);
            woError.showItParams('deleteUserMarketItem error:' + error.errorID);
        }
    }

    private function completeDeleteUserMarketItem(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('deleteUserMarketItem: wrong JSON:' + String(response));
            woError.showItParams('deleteUserMarketItem: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply();
            }
            return;
        } else {
            Cc.error('deleteUserMarketItem: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('deleteUserMarketItem: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserBuildPosition(dbId:int, pX:int, pY:int, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_BUILD_POSITION);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserBuildPosition', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        variables.posX = pX;
        variables.posY = pY;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserBuildPosition);
        function onCompleteUpdateUserBuildPosition(e:Event):void { completeUpdateUserBuildPosition(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserBuildPosition error:' + error.errorID);
            woError.showItParams('updateUserBuildPosition error:' + error.errorID);
        }
    }

    private function completeUpdateUserBuildPosition(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserBuildPosition: wrong JSON:' + String(response));
            woError.showItParams('updateUserBuildPosition: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('updateUserBuildPosition: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('updateUserBuildPosition: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getPaperItems(callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_PAPER_ITEMS);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getPaperItems', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetPaperItems);
        function onCompleteGetPaperItems(e:Event):void { completeGetPaperItems(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getPaperItems error:' + error.errorID);
            woError.showItParams('getPaperItems error:' + error.errorID);
        }
    }

    private function completeGetPaperItems(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getPaperItems: wrong JSON:' + String(response));
            woError.showItParams('getPaperItems: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            g.managerPaper.fillIt(d.message);
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('getPaperItems: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('getPaperItems: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserAmbar(isAmbar:int, newLevel:int, newMaxCount:int, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_AMBAR);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserAmbar', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.isAmbar = isAmbar;
        variables.newLevel = newLevel;
        variables.newMaxCount = newMaxCount;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserAmbar);
        function onCompleteUpdateUserAmbar(e:Event):void { completeUpdateUserAmbar(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserAmbar error:' + error.errorID);
            woError.showItParams('updateUserAmbar error:' + error.errorID);
        }
    }

    private function completeUpdateUserAmbar(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserAmbar: wrong JSON:' + String(response));
            woError.showItParams('updateUserAmbar: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('updateUserAmbar: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('updateUserAmbar: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getDataLockedLand(callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DATA_LOCKED_LAND);
        var variables:URLVariables = new URLVariables();

        variables.userId = g.user.userId;
        request.data = variables;
        Cc.ch('server', 'start getDataLockedLand', 1);
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetDataLockedLand);
        function onCompleteGetDataLockedLand(e:Event):void { completeGetDataLockedLand(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataLockedLand error:' + error.errorID);
            woError.showItParams('getDataLockedLand error:' + error.errorID);
        }
    }

    private function completeGetDataLockedLand(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataLockedLand: wrong JSON:' + String(response));
            woError.showItParams('getDataLockedLand: wrong JSON:' + String(response));
            return;
        }

        g.allData.lockedLandData = {};
        if (d.id == 0) {
            var obj:Object;
            for (var i:int = 0; i < d.message.length; i++) {
                obj = {};
                obj.id = int(d.message[i].map_building_id);
                obj.blockByLevel = int(d.message[i].block_by_level);
                obj.resourceId = int(d.message[i].resource_id);
                obj.resourceCount = int(d.message[i].resource_count);
                obj.friendsCount = int(d.message[i].friends_count);
                obj.currencyCount = int(d.message[i].currency_count);

                g.allData.lockedLandData[obj.id] = obj;
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('getDataLockedLand: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('getDataLockedLand: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function removeUserLockedLand(id:int, callback:Function = null):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_REMOVE_USER_LOCKED_LAND);
        var variables:URLVariables = new URLVariables();
        variables.userId = g.user.userId;
        variables.mapBuildingId = id;
        request.data = variables;
        Cc.ch('server', 'start removeUserLockedLand', 1);
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteRemoveUserLockedLand);
        function onCompleteRemoveUserLockedLand(e:Event):void { completeRemoveUserLockedLand(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('removeUserLockedLand error:' + error.errorID);
            woError.showItParams('removeUserLockedLand error:' + error.errorID);
        }
    }

    private function completeRemoveUserLockedLand(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('removeUserLockedLand: wrong JSON:' + String(response));
            woError.showItParams('removeUserLockedLand: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('removeUserLockedLand: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('removeUserLockedLand: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function addToInventory(dbId:int, callback:Function = null):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_TO_INVENTORY);
        var variables:URLVariables = new URLVariables();
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        request.data = variables;
        Cc.ch('server', 'start addToInventory', 1);
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAddToInventory);
        function onCompleteAddToInventory(e:Event):void { completeAddToInventory(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addToInventory error:' + error.errorID);
            woError.showItParams('addToInventory error:' + error.errorID);
        }
    }

    private function completeAddToInventory(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addToInventory: wrong JSON:' + String(response));
            woError.showItParams('addToInventory: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('addToInventory: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('addToInventory: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function removeFromInventory(dbId:int, posX:int, posY:int, callback:Function = null):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_REMOVE_FROM_INVENTORY);
        var variables:URLVariables = new URLVariables();
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        variables.posX = posX;
        variables.posY = posY;
        request.data = variables;
        Cc.ch('server', 'start removeFromInventory', 1);
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteRemoveFromInventory);
        function onCompleteRemoveFromInventory(e:Event):void { completeRemoveFromInventory(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('removeFromInventory error:' + error.errorID);
            woError.showItParams('removeFromInventory error:' + error.errorID);
        }
    }

    private function completeRemoveFromInventory(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('removeFromInventory: wrong JSON:' + String(response));
            woError.showItParams('removeFromInventory: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('removeFromInventory: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('removeFromInventory: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getUserNeighborMarket(callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_NEIGHBOR_MARKET);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserNeighborMarket', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserNeighborMarket);
        function onCompleteGetUserNeighborMarket(e:Event):void { completeGetUserNeighborMarket(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserMarketItem error:' + error.errorID);
            woError.showItParams('getUserMarketItem error:' + error.errorID);
        }
    }

    private function completeGetUserNeighborMarket(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getUserNeighborMarket: wrong JSON:' + String(response));
            woError.showItParams('getUserNeighborMarket: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            g.user.fillNeighborMarketItems(d.message);
            if (callback != null) {
                callback.apply();
            }
            return;
        } else {
            Cc.error('getUserNeighborMarket: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('getUserNeighborMarket: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function buyFromNeighborMarket(itemId:int, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_BUY_FROM_NEIGHBOR_MARKET);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'buyFromNeighborMarket', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.itemId = itemId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteBuyFromNeighborMarket);
        function onCompleteBuyFromNeighborMarket(e:Event):void { completeBuyFromNeighborMarket(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('buyFromNeighborMarket error:' + error.errorID);
            woError.showItParams('buyFromNeighborMarket error:' + error.errorID);
        }
    }

    private function completeBuyFromNeighborMarket(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('buyFromNeighborMarket: wrong JSON:' + String(response));
            woError.showItParams('buyFromNeighborMarket: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply();
            }
            return;
        } else {
            Cc.error('buyFromNeighborMarket: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('buyFromNeighborMarket: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getAllCityData(p:Someone, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_ALL_CITY_DATA);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getAllCityData', 1);
//        variables = addDefault(variables);
        variables.userSocialId = p.userSocialId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetAllCityData);
        function onCompleteGetAllCityData(e:Event):void { completeGetAllCityData(e.target.data, p, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getAllCityData error:' + error.errorID);
            woError.showItParams('getAllCityData error:' + error.errorID);
        }
    }

    private function completeGetAllCityData(response:String, p:Someone, callback:Function = null):void {
        var d:Object;
        var ob:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getAllCityData: wrong JSON:' + String(response));
            woError.showItParams('getAllCityData: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            p.userDataCity.objects = new Array();
            for (var i:int = 0; i < d.message['building'].length; i++) {
                ob = {};
                ob.buildId = g.dataBuilding.objectBuilding[int(d.message['building'][i].building_id)].id;
                ob.posX = int(d.message['building'][i].pos_x);
                ob.posY = int(d.message['building'][i].pos_y);
                ob.dbId = int(d.message['building'][i].id);
                ob.isFlip = int(d.message['building'][i].is_flip);
                if (d.message['building'][i].time_build_building) {
                    ob.isBuilded = true;
                    ob.isOpen = Boolean(int(d.message['building'][i].is_open));
                }
                if (d.message['building'][i].train_state) {
                    ob.state = int(d.message['building'][i].train_state);
                }
                p.userDataCity.objects.push(ob);
            }
            p.userDataCity.plants = new Array();
            for (i = 0; i < d.message['plant'].length; i++) {
                ob = {};
                ob.plantId = int(d.message['plant'][i].plant_id);
                ob.dbId = int(d.message['plant'][i].user_db_building_id);
                ob.timeWork = int(d.message['plant'][i].time_work);
                p.userDataCity.plants.push(ob);
            }
            p.userDataCity.treesInfo = new Array();
            for (i=0; i<d.message['tree'].length; i++) {
                ob = {};
                ob.id = d.message['tree'][i].id;
                ob.dbId = int(d.message['tree'][i].user_db_building_id);
                ob.state = int(d.message['tree'][i].state);
                ob.time_work = int(d.message['tree'][i].time_work);
                p.userDataCity.treesInfo.push(ob);
            }
            p.userDataCity.animalsInfo = new Array();
            for (i=0; i<d.message['animal'].length; i++) {
                ob = {};
                ob.animalId = int(d.message['animal'][i].animal_id);
                ob.timeWork = int(d.message['animal'][i].time_work);
                ob.dbId = int(d.message['animal'][i].user_db_building_id);
                p.userDataCity.animalsInfo.push(ob);
            }
            p.userDataCity.recipes = new Array();
            for (i=0; i<d.message['recipe'].length; i++) {
                ob = {};
                ob.recipeId = int(d.message['recipe'][i].recipe_id);
                ob.timeWork = int(d.message['recipe'][i].time_work);
                ob.delay = int(d.message['recipe'][i].delay);
                ob.dbId = int(d.message['recipe'][i].user_db_building_id);
                p.userDataCity.recipes.push(ob);
            }
            for (i = 0; i < d.message['wild'].length; i++) {
                ob = {};
                ob.buildId = g.dataBuilding.objectBuilding[int(d.message['wild'][i].building_id)].id;
                ob.posX = int(d.message['wild'][i].pos_x);
                ob.posY = int(d.message['wild'][i].pos_y);
                ob.dbId = int(d.message['wild'][i].id);
                ob.isFlip = int(d.message['wild'][i].is_flip);
                p.userDataCity.objects.push(ob);
            }
            if (callback != null) {
                callback.apply(null, [p]);
            }
            return;
        } else {
            Cc.error('getAllCityData: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('getAllCityData: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function buyHeroCat(callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_BUY_HERO_CAT);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'buyHeroCat', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteBuyHeroCat);
        function onCompleteBuyHeroCat(e:Event):void { completeBuyHeroCat(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('buyFromHeroCat error:' + error.errorID);
            woError.showItParams('buyHeroCat error:' + error.errorID);
        }
    }

    private function completeBuyHeroCat(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('buyHeroCat: wrong JSON:' + String(response));
            woError.showItParams('buyHeroCat: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply();
            }
            return;
        } else {
            Cc.error('buyHeroCat: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('buyHeroCat: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function ME_addWild(posX:int, posY:int, w:WorldObject, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ME_ADD_WILD);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'ME_addWild', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.posX = posX;
        variables.posY = posY;
        variables.wildId = w.dataBuild.id;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteME_addWild);
        function onCompleteME_addWild(e:Event):void { completeME_addWild(e.target.data, w, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('ME_addWild error:' + error.errorID);
            woError.showItParams('ME_addWild error:' + error.errorID);
        }
    }

    private function completeME_addWild(response:String, w:WorldObject, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('ME_addWild: wrong JSON:' + String(response));
            woError.showItParams('ME_addWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }

        if (d.id == 0) {
            w.dbBuildingId = int(d.message);
            if (callback != null) {
                callback.apply(null);
            }
        } else {
            Cc.error('ME_addWild: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('ME_addWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
        }
    }

    public function ME_removeWild(dbId:int, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ME_REMOVE_WILD);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'ME_removeWild', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteME_removeWild);
        function onCompleteME_removeWild(e:Event):void { completeME_removeWild(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('ME_removeWild error:' + error.errorID);
            woError.showItParams('ME_removeWild error:' + error.errorID);
        }
    }

    private function completeME_removeWild(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('ME_removeWild: wrong JSON:' + String(response));
            woError.showItParams('ME_removeWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply(null);
            }
        } else {
            Cc.error('ME_removeWild: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('ME_removeWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
        }
    }

    public function ME_moveWild(posX:int, posY:int, dbId:int, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ME_MOVE_WILD);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'ME_moveWild', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.posX = posX;
        variables.posY = posY;
        variables.dbId = dbId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteME_moveWild);
        function onCompleteME_moveWild(e:Event):void { completeME_moveWild(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('ME_moveWild error:' + error.errorID);
            woError.showItParams('ME_moveWild error:' + error.errorID);
        }
    }

    private function completeME_moveWild(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('ME_moveWild: wrong JSON:' + String(response));
            woError.showItParams('ME_moveWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply(null);
            }
        } else {
            Cc.error('ME_moveWild: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('ME_moveWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
        }
    }

    public function ME_flipWild(dbId:int, isFlip:int, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ME_FLIP_WILD);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'ME_flipWild', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        variables.isFlip = isFlip;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteME_flipWild);
        function onCompleteME_flipWild(e:Event):void { completeME_flipWild(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('ME_flipWild error:' + error.errorID);
            woError.showItParams('ME_flipWild error:' + error.errorID);
        }
    }

    private function completeME_flipWild(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('ME_flipWild: wrong JSON:' + String(response));
            woError.showItParams('ME_flipWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply(null);
            }
        } else {
            Cc.error('ME_flipWild: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('ME_flipWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
        }
    }

    public function getUserWild(callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_WILD);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserWild', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserWild);
        function onCompleteGetUserWild(e:Event):void { completeGetUserWild(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('GetUserWild error:' + error.errorID);
            woError.showItParams('GetUserWild error:' + error.errorID);
        }
    }

    private function completeGetUserWild(response:String, callback:Function = null):void {
        var d:Object;
        var ob:Object;
        var dbId:int;
        var dataBuild:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('GetUserWild: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            for (var i:int = 0; i < d.message.length; i++) {
                d.message[i].id ? dbId = int(d.message[i].id) : dbId = 0;
                dataBuild = g.dataBuilding.objectBuilding[int(d.message[i].building_id)];
                var p:Point = g.matrixGrid.getXYFromIndex(new Point(int(d.message[i].pos_x), int(d.message[i].pos_y)));
                dataBuild.dbId = dbId;
                dataBuild.isFlip = int(d.message[i].is_flip);
                g.townArea.createNewBuild(dataBuild, p.x, p.y, true, dbId);

                ob = {};
                ob.buildId = dataBuild.id;
                ob.posX = int(d.message[i].pos_x);
                ob.posY = int(d.message[i].pos_y);
                ob.isFlip = int(d.message[i].is_flip);
                ob.dbId = dbId;
                g.user.userDataCity.objects.push(ob);
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('GetUserWild: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('GetUserWild: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function userBuildingFlip(dbId:int, isFlip:int, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USER_BUILDING_FLIP);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'userBuildingFlip', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        variables.isFlip = isFlip;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteUserBuildingFlip);
        function onCompleteUserBuildingFlip(e:Event):void { completeUserBuildingFlip(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('userBuildingFlip error:' + error.errorID);
            woError.showItParams('userBuildingFlip error:' + error.errorID);
        }
    }

    private function completeUserBuildingFlip(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('userBuildingFlip: wrong JSON:' + String(response));
            woError.showItParams('userBuildingFlip: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply(null);
            }
        } else {
            Cc.error('userBuildingFlip: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('userBuildingFlip: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
        }
    }

    public function deleteUserWild(dbId:int, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DELETE_USER_WILD);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'deleteUserWild', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteDeleteUserWild);
        function onCompleteDeleteUserWild(e:Event):void { completeDeleteUserWild(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('deleteUserWild error:' + error.errorID);
            woError.showItParams('deleteUserWild error:' + error.errorID);
        }
    }

    private function completeDeleteUserWild(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('deleteUserWildp: wrong JSON:' + String(response));
            woError.showItParams('deleteUserWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply(null);
            }
        } else {
            Cc.error('deleteUserWild: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('deleteUserWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
        }
    }

    public function ME_moveMapBuilding(id:int, posX:int, posY:int, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ME_MOVE_MAP_BUILDING);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'ME_moveMapBuilding', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.buildId = id;
        variables.posX = posX;
        variables.posY = posY;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteME_moveMapBuilding);
        function onCompleteME_moveMapBuilding(e:Event):void { completeME_moveMapBuilding(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('ME_moveMapBuilding error:' + error.errorID);
            woError.showItParams('ME_moveMapBuilding error:' + error.errorID);
        }
    }

    private function completeME_moveMapBuilding(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('ME_moveMapBuilding: wrong JSON:' + String(response));
            woError.showItParams('ME_moveMapBuilding: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply(null);
            }
        } else {
            Cc.error('ME_moveMapBuilding: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('ME_moveMapBuilding: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
        }
    }

    public function saveUserGameScale(callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USER_GAME_SCALE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'saveUserGameScale', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.scale = g.currentGameScale*100;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteSaveUserGameScale);
        function onCompleteSaveUserGameScale(e:Event):void { completeSaveUserGameScale(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('saveUserGameScale error:' + error.errorID);
            woError.showItParams('saveUserGameScale error:' + error.errorID);
        }
    }

    private function completeSaveUserGameScale(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('saveUserGameScale: wrong JSON:' + String(response));
            woError.showItParams('saveUserGameScale: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('saveUserGameScale: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('saveUserGameScale: wrong JSON:' + String(response));
        }
    }

    public function buyNewCellOnFabrica(dbId:int, count:int, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_CELL_FABRICA);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'buyNewCellOnFabrica', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        variables.count = count;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteBuyNewCellOnFabrica);
        function onCompleteBuyNewCellOnFabrica(e:Event):void { completeBuyNewCellOnFabrica(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('buyNewCellOnFabrica error:' + error.errorID);
            woError.showItParams('buyNewCellOnFabrica error:' + error.errorID);
        }
    }

    private function completeBuyNewCellOnFabrica(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('buyNewCellOnFabrica: wrong JSON:' + String(response));
            woError.showItParams('buyNewCellOnFabrica: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('buyNewCellOnFabrica: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('buyNewCellOnFabrica: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function skipRecipeOnFabrica(userRecipeDbId:String, leftTime:int, buildDbId:int, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_SKIP_RECIPE_FABRICA);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'skipRecipeOnFabrica', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.recipeDbId = userRecipeDbId;
        variables.leftTime = leftTime;
        variables.buildDbId = buildDbId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteSkipRecipeOnFabrica);
        function onCompleteSkipRecipeOnFabrica(e:Event):void { completeSkipRecipeOnFabrica(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('skipRecipeOnFabrica error:' + error.errorID);
            woError.showItParams('skipRecipeOnFabrica error:' + error.errorID);
        }
    }

    private function completeSkipRecipeOnFabrica(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('skipRecipeOnFabrica: wrong JSON:' + String(response));
            woError.showItParams('skipRecipeOnFabrica: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('skipRecipeOnFabrica: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('skipRecipeOnFabrica: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function skipTimeOnRidge(plantTime:int,buildDbId:int, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_SKIP_TIME_RIDGE);
        var variables:URLVariables = new URLVariables();
        var time:Number = getTimer();

        Cc.ch('server', 'skipTimeOnRidge', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.plantTime = time - plantTime;
        variables.buildDbId = buildDbId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteskipTimeOnRidge);
        function onCompleteskipTimeOnRidge(e:Event):void { completeskipTimeOnRidge(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('skipTimeOnRidge error:' + error.errorID);
            woError.showItParams('skipTimeOnRidge error:' + error.errorID);
        }
    }

    private function completeskipTimeOnRidge(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('skipTimeOnRidge: wrong JSON:' + String(response));
            woError.showItParams('skipTimeOnRidge: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('skipTimeOnRidge: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('skipTimeOnRidge: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function skipTimeOnTree(stateTree:int, buildDbId:int, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_SKIP_TIME_TREE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'skipTimeOnTree', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.state = stateTree;
        variables.id = buildDbId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteSkipTimeOnTree);
        function onCompleteSkipTimeOnTree(e:Event):void { completeSkipTimeOnTree(e.target.data,callback);}//e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('skipTimeOnTree error:' + error.errorID);
            woError.showItParams('skipTimeOnTree error:' + error.errorID);
        }
    }

    private function completeSkipTimeOnTree(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('skipTimeOnTree: wrong JSON:' + String(response));
            woError.showItParams('skipTimeOnTree: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('skipTimeOnTree: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('skipTimeOnTree: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function skipTimeOnAnimal(timeToEnd:int,buildDbId:String, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_SKIP_TIME_ANIMAL);
        var variables:URLVariables = new URLVariables();
        var time:Number = getTimer();
        Cc.ch('server', 'skipTimeOnAnimal', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.animalDbId = int(buildDbId);
        variables.timeToEnd = time - timeToEnd;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteskipTimeOnAnimal);
        function onCompleteskipTimeOnAnimal(e:Event):void { completeskipTimeOnAnimal(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('skipTimeOnAnimal error:' + error.errorID);
            woError.showItParams('skipTimeOnAnimal error:' + error.errorID);
        }
    }

    private function completeskipTimeOnAnimal(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('skipTimeOnAnimal: wrong JSON:' + String(response));
            woError.showItParams('skipTimeOnAnimal: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('skipTimeOnAnimal: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('skipTimeOnAnimal: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function skipTimeOnFabricBuild(leftTime:int, buildDbId:int, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_SKIP_TIME_FABRIC_BUILD);
        var variables:URLVariables = new URLVariables();
        var time:Number = getTimer();

        Cc.ch('server', 'skipTimeOnFabricBuild', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.leftTime = time - leftTime;
        variables.buildDbId = buildDbId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteSkipTimeOnFabricBuild);
        function onCompleteSkipTimeOnFabricBuild(e:Event):void { completeSkipTimeOnFabricBuild(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('skipTimeOnFabricBuild error:' + error.errorID);
            woError.showItParams('skipTimeOnFabricBuild error:' + error.errorID);
        }
    }

    private function completeSkipTimeOnFabricBuild(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('skipTimeOnFabricBuild: wrong JSON:' + String(response));
            woError.showItParams('skipTimeOnFabricBuild: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('skipTimeOnFabricBuild: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('skipTimeOnFabricBuild: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function addUserOrder(order:Object, delay:int, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_ORDER);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserOrder', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.ids = order.resourceIds.join('&');
        variables.counts = order.resourceCounts.join('&');
        variables.xp = order.xp;
        variables.coins = order.coins;
        variables.addCoupone = int(order.addCoupone);
        variables.delay = delay;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserOrder);
        function onCompleteAddUserOrder(e:Event):void { completeAddUserOrder(e.target.data, order, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserOrder error:' + error.errorID);
            woError.showItParams('addUserOrder error:' + error.errorID);
        }
    }

    private function completeAddUserOrder(response:String, order:Object, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserOrder: wrong JSON:' + String(response));
            woError.showItParams('addUserOrder: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            order.dbId = String(d.message);
            if (callback != null) {
                callback.apply(null, [order]);
            }
        } else {
            Cc.error('addUserOrder: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('addUserOrder: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getUserOrder(callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_ORDER);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserOrder', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserOrder);
        function onCompleteGetUserOrder(e:Event):void { completeGetUserOrder(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('GetUserOrder error:' + error.errorID);
            woError.showItParams('GetUserOrder error:' + error.errorID);
        }
    }

    private function completeGetUserOrder(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('GetUserOrder: wrong JSON:' + String(response));
            woError.showItParams('GetUserOrder: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            for (var i:int = 0; i < d.message.length; i++) {
                g.managerOrder.addFromServer(d.message[i]);
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('GetUserFOrder: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('GetUserOrder: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function deleteUserOrder(orderDbId:String, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DELETE_USER_ORDER);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'deleteUserOrder', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = orderDbId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteDeleteUserOrder);
        function onCompleteDeleteUserOrder(e:Event):void { completeDeleteUserOrder(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('deleteUserOrder error:' + error.errorID);
            woError.showItParams('GetUserOrder error:' + error.errorID);
        }
    }

    private function completeDeleteUserOrder(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('deleteUserOrder: wrong JSON:' + String(response));
            woError.showItParams('deleteUserOrder: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('deleteUserOrder: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('deleteUserOrder: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function askWateringUserTree(treeDbId:String, state:int, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ASK_WATERING_USER_TREE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'askWateringUserTree', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.id = treeDbId;
        variables.state = state;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAskWateringUserTree);
        function onCompleteAskWateringUserTree(e:Event):void { completeAskWateringUserTree(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('askWateringUserTree error:' + error.errorID);
            woError.showItParams('askWateringUserTree error:' + error.errorID);
        }
    }

    private function completeAskWateringUserTree(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('askWateringUserTree: wrong JSON:' + String(response));
            woError.showItParams('askWateringUserTree: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('askWateringUserTree: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('askWateringUserTree: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function makeWateringUserTree(treeDbId:String, state:int, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_MAKE_WATERING_USER_TREE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'makeWateringUserTree', 1);
//        variables = addDefault(variables);
        variables.userSocialId = g.user.userSocialId;
        variables.awayUserSocialId = g.visitedUser.userSocialId;
        variables.id = treeDbId;
        variables.state = state;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteMakeWateringUserTree);
        function onCompleteMakeWateringUserTree(e:Event):void { completeMakeWateringUserTree(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('MakeWateringUserTree error:' + error.errorID);
            woError.showItParams('MakeWateringUserTree error:' + error.errorID);
        }
    }

    private function completeMakeWateringUserTree(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('makeWateringUserTree: wrong JSON:' + String(response));
            woError.showItParams('makeWateringUserTree: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('makeWateringUserTree: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('makeWateringUserTree: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function skipOrderTimer(orderID:int, callback:Function):void {
        if (!g.useDataFromServer) return;

        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_SKIP_ORDER_TIMER);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'skipOrderTimer', 1);
//        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = orderID;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteSkipOrderTimer);
        function onCompleteSkipOrderTimer(e:Event):void { completeSkipOrderTimer(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('skipOrderTimer error:' + error.errorID);
            woError.showItParams('skipOrderTimer error:' + error.errorID);
        }
    }

    private function completeSkipOrderTimer(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('skipOrderTimer: wrong JSON:' + String(response));
            woError.showItParams('addUserOrder: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('skipOrderTimer: id: ' + d.id + '  with message: ' + d.message);
            woError.showItParams('skipOrderTimer: id: ' + d.id + '  with message: ' + d.message);
        }
    }

}
}
