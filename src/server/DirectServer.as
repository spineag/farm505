/**
 * Created by user on 7/16/15.
 */
package server {
import build.WorldObject;
import build.WorldObject;
import build.WorldObject;

import com.junkbyte.console.Cc;

import data.BuildType;

import flash.events.Event;
import flash.geom.Point;

import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;

import manager.ManagerFabricaRecipe;

import manager.Vars;

import resourceItem.ResourceItem;

public class DirectServer {
    private var g:Vars = Vars.getInstance();

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
                obj.xpForBuild = int(d.message[i].xp_for_build);
                obj.buildType = int(d.message[i].build_type);

                if (d.message[i].currency) obj.currency = int(d.message[i].currency);
                if (d.message[i].cost) obj.cost = int(d.message[i].cost);
                if (d.message[i].block_by_level) {
                    obj.blockByLevel = String(d.message[i].block_by_level).split('&');
                    for (k = 0; k < obj.blockByLevel.length; k++) obj.blockByLevel[k] = int(obj.blockByLevel[k]);
                }
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
        }
    }

    private function completeUserInfo(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('userInfo: wrong JSON:' + String(response));
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
            g.user.isTester = Boolean(int(ob.is_tester));

            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('userInfo: id: ' + d.id + '  with message: ' + d.message);
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
        }
    }

    private function completeAddUserMoney(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserMoney: wrong JSON:' + String(response));
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
        }
    }

    private function completeAddUserXP(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserXP: wrong JSON:' + String(response));
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
        }
    }

    private function completeUpdateUserLevel(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserLevel: wrong JSON:' + String(response));
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
            return;
        }

        if (d.id == 0) {
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('GetUserResource: id: ' + d.id + '  with message: ' + d.message);
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
        }
    }

    private function completeAddUserResource(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserResource: wrong JSON:' + String(response));
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
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserBuilding);
        function onCompleteAddUserBuilding(e:Event):void { completeAddUserBuilding(e.target.data, wObject, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserBuilding error:' + error.errorID);
        }
    }

    private function completeAddUserBuilding(response:String, wObject:WorldObject, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserBuilding: wrong JSON:' + String(response));
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
            for (var i:int = 0; i < d.message.length; i++) {
                d.message[i].id ? dbId = int(d.message[i].id) : dbId = 0;
                dataBuild = g.dataBuilding.objectBuilding[int(d.message[i].building_id)];
                if (int(d.message[i].in_inventory)) {

                } else {
                    if (d.message[i].time_build_building) {
                        ob = {};
                        ob.dbId = dbId;
                        ob.timeBuildBuilding = Number(d.message[i].time_build_building);
                        ob.isOpen = int(d.message[i].is_open);
                        g.user.userBuildingData[int(d.message[i].building_id)] = ob;
                    }
                    var p:Point = g.matrixGrid.getXYFromIndex(new Point(int(d.message[i].pos_x), int(d.message[i].pos_y)));
                    g.townArea.createNewBuild(dataBuild, p.x, p.y, true, dbId);
                }
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('GetUserBuilding: id: ' + d.id + '  with message: ' + d.message);
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
        }
    }

    private function completeStartBuildMapBuilding(response:String, wObject:WorldObject, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('startBuildMapBuilding: wrong JSON:' + String(response));
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
        }
    }

    private function completeOpenBuildMapBuilding(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('openBuildMapBuilding: wrong JSON:' + String(response));
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
        }
    }

    private function completeAddFabricaRecipe(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addFabricaRecipe: wrong JSON:' + String(response));
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
        }
    }

    private function completeGetUserFabricaRecipe(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('GetUserFabricaRecipe: wrong JSON:' + String(response));
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
        }
    }

    private function completeCraftFabricaRecipe(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('craftFabricaRecipe: wrong JSON:' + String(response));
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
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }
}
}
