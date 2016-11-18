/**
 * Created by user on 7/16/15.
 */
package server {
import build.WorldObject;
import build.decor.DecorTail;
import build.fabrica.Fabrica;
import build.farm.Animal;
import build.ridge.Ridge;
import build.train.Train;
import build.tree.Tree;
import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.geom.Point;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.utils.getTimer;
import manager.ManagerAnimal;
import manager.ManagerFabricaRecipe;
import manager.ManagerPlantRidge;
import manager.ManagerTree;
import manager.Vars;
import mouse.ServerIconMouse;
import user.Someone;
import utils.Utils;
import windows.WindowsManager;
import com.adobe.crypto.MD5;

import windows.gameError.PreloadInfoTab;


public class DirectServer {
    private var g:Vars = Vars.getInstance();
    private var iconMouse:ServerIconMouse = new ServerIconMouse();
    private var SECRET:String = '505';

    private function addDefault(variables:URLVariables):URLVariables {
        if (g.user && g.user.sessionKey) variables.sessionKey = g.user.sessionKey;
        variables.channelId = g.socialNetworkID;
        return variables;
    }

    public function getVersion(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DATA_VERSION);

        Cc.ch('server', 'start getVersion', 1);
        var variables:URLVariables = new URLVariables();
        variables = addDefault(variables);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteVersion);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteVersion(e:Event):void { completeVersion(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataRecipe error:' + error.errorID);
        }
    }

    private function completeVersion(response:String, callback:Function = null):void {
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getVersion: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getVersion OK', 5);
            for (var i:int = 0; i<d.message.length; i++) {
                g.version[d.message[i].name] = d.message[i].version;
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('getVersion: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
        }
    }

    public function getDataLevel(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DATA_LEVEL);

        Cc.ch('server', 'start getDataLevel', 1);
        var variables:URLVariables = new URLVariables();
        variables = addDefault(variables);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAllLevels);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        iconMouse.startConnect();
        function onCompleteAllLevels(e:Event):void { completeLevels(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataLevel error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeLevels(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('loadLevels: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'loadLevels: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getDataLevel OK', 5);
            var obj:Object;
            var k:int;
            for (var i:int = 0; i<d.message.length; i++) {
                obj = {};
                obj.id = int(d.message[i].number_level);
                obj.xp = int(d.message[i].count_xp);
                obj.totalXP = int(d.message[i].total_xp);
                obj.countSoft = int(d.message[i].count_soft);
                obj.countHard = int(d.message[i].count_hard);
                if (d.message[i].decor_id) obj.decorId = String(d.message[i].decor_id).split('&');
                for (k = 0; k < obj.decorId.length; k++) obj.decorId[k] = int(obj.decorId[k]);
                if (d.message[i].resource_id) obj.resourceId = String(d.message[i].resource_id).split('&');
                for (k = 0; k < obj.resourceId.length; k++) obj.resourceId[k] = int(obj.resourceId[k]);
                if (d.message[i].count_decor) obj.countDecor = String(d.message[i].count_decor).split('&');
                for (k = 0; k < obj.countDecor.length; k++) obj.countDecor[k] = int(obj.countDecor[k]);
                if (d.message[i].count_resource) obj.countResource = String(d.message[i].count_resource).split('&');
                for (k = 0; k < obj.countResource.length; k++) obj.countResource[k] = int(obj.countResource[k]);
                obj.catCount = int(d.message[i].cat_count);
                obj.ridgeCount = int(d.message[i].ridge_count);
                g.dataLevel.objectLevels[obj.id] = obj;
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('loadLevels: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'loadLevels: id: ' + d.id + '  with message: ' + d.message);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);

        }
    }

    public function getDataAnimal(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DATA_ANIMAL);

        Cc.ch('server', 'start getDataAnimal', 1);
        var variables:URLVariables = new URLVariables();
        variables = addDefault(variables);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteAnimal);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteAnimal(e:Event):void { completeAnimal(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataAnimal error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAnimal(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataAnimal: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataAnimal: wrong JSON:' + String(response));
            return;
        }
        var k:int = 0;
        if (d.id == 0) {
            Cc.ch('server', 'getDataAnimal OK', 5);
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
                if (d.message[i].cost_new) {
                    obj.costNew = String(d.message[i].cost_new).split('&');
                    for (k = 0; k < obj.costNew.length; k++) obj.costNew[k] = int(obj.costNew[k]);
                }

                obj.buildType = BuildType.ANIMAL;
                g.dataAnimal.objectAnimal[obj.id] = obj;
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('getDataAnimal: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataAnimal: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getDataRecipe(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DATA_RECIPE);

        Cc.ch('server', 'start getDataRecipe', 1);
        var variables:URLVariables = new URLVariables();
        variables = addDefault(variables);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteRecipe);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteRecipe(e:Event):void { completeRecipe(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataRecipe error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeRecipe(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataRecipe: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataRecipe: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getDataRecipe OK', 5);
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
            Cc.error('getDataRecipe: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataRecipe: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getDataResource(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DATA_RESOURCE);

        Cc.ch('server', 'start getDataResource', 1);
        var variables:URLVariables = new URLVariables();
        variables = addDefault(variables);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteResource);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteResource(e:Event):void { completeResource(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataResource error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);

        }
    }

    private function completeResource(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataResource: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataResource: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getDataResource OK', 5);
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
                g.dataResource.objectResources[obj.id] = obj;
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('getDataResource: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataResource: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getDataCats(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DATA_CATS);

        Cc.ch('server', 'start getDataCats', 1);
        var variables:URLVariables = new URLVariables();
        variables = addDefault(variables);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteCats);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteCats(e:Event):void { completeCats(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataCats error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);

        }
    }

    private function completeCats(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataCats: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataCats: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getDataCats OK', 5);
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
            Cc.error('getDataResource: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataResource: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getDataBuyMoney(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DATA_BUY_MONEY);

        Cc.ch('server', 'start getDataBuyMoney', 1);
        var variables:URLVariables = new URLVariables();
        variables = addDefault(variables);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetDataBuyMoney);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteGetDataBuyMoney(e:Event):void { completeGetDataBuyMoney(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataBuyMoney error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetDataBuyMoney(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        var k:int = 0;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataBuyMoney: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataBuyMoney: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getDataBuyMoney OK', 5);
            var obj:Object;
            for (var i:int = 0; i<d.message.length; i++) {
                obj = {};
                obj.id = int(d.message[i].id);
                obj.typeMoney = int(d.message[i].type_money);
                obj.cost = int(d.message[i].cost_for_real);
                obj.count = int(d.message[i].count_getted);
                obj.url = d.message[i].url;

                if (d.message[i].bonus) {
                    obj.bonus = String(d.message[i].bonus).split('&');
                    for (k = 0; k < obj.bonus.length; k++) obj.bonus[k] = int(obj.bonus[k]);
                }
                g.allData.dataBuyMoney.push(obj);
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('getDataBuyMoney: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataBuyMoney: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getDataBuilding(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DATA_BUILDING);

        Cc.ch('server', 'start getDataBuilding', 1);
        var variables:URLVariables = new URLVariables();
        variables = addDefault(variables);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteBuilding);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteBuilding(e:Event):void { completeBuilding(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataBuilding error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeBuilding(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataBuilding: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataBuilding: wrong JSON:' + String(response));
            return;
        }

        var k:int;
        if (d.id == 0) {
            Cc.ch('server', 'getDataBuilding OK', 5);
            var obj:Object;
            for (var i:int = 0; i<d.message.length; i++) {
                obj = {};
                    obj.id = int(d.message[i].id);
                    obj.width = int(d.message[i].width);
                    obj.height = int(d.message[i].height);
                    if (d.message[i].inner_x) {
                        obj.innerX = String(d.message[i].inner_x).split('&');
                        if (obj.innerX.length == 1) {
                            obj.innerX = int(obj.innerX[0]) * g.scaleFactor;
                        } else if (obj.innerX.length) {
                            for (k = 0; k < obj.innerX.length; k++) {
                                obj.innerX[k] = int(obj.innerX[k]) * g.scaleFactor;
                            }
                        }
                        obj.innerY = String(d.message[i].inner_y).split('&');
                        if (obj.innerY.length == 1) {
                            obj.innerY = int(obj.innerY[0]) * g.scaleFactor;
                        } else if (obj.innerY.length) {
                            for (k = 0; k < obj.innerY.length; k++) {
                                obj.innerY[k] = int(obj.innerY[k]) * g.scaleFactor;
                            }
                        }
                    }
                    obj.name = d.message[i].name;
                    obj.url = d.message[i].url;
                    obj.image = d.message[i].image;
                    obj.xpForBuild = int(d.message[i].xp_for_build);
                    obj.buildType = int(d.message[i].build_type);
                
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
                if (obj.id == 92) {
                    obj.buildType = BuildType.DECOR_FENCE_ARKA;
                    obj.innerX = []; obj.innerY = [];
                    obj.innerX.push(-41 * g.scaleFactor); obj.innerY.push(-195 * g.scaleFactor); // main (top) part of gate
                    obj.innerX.push(-61 * g.scaleFactor); obj.innerY.push(-236 * g.scaleFactor); // second part of gate
                }
                if (obj.id == 94) {
                    obj.buildType = BuildType.DECOR_FENCE_ARKA;
                    obj.innerX = []; obj.innerY = [];
                    obj.innerX.push(-47 * g.scaleFactor); obj.innerY.push(-146 * g.scaleFactor); // main (top) part of gate
                    obj.innerX.push(-64 * g.scaleFactor); obj.innerY.push(-192 * g.scaleFactor); // second part of gate
                }
                if (obj.id == 96) {
                    obj.buildType = BuildType.DECOR_FENCE_ARKA;
                    obj.innerX = []; obj.innerY = [];
                    obj.innerX.push(-57 * g.scaleFactor); obj.innerY.push(-151 * g.scaleFactor); // main (top) part of gate
                    obj.innerX.push(-72 * g.scaleFactor); obj.innerY.push(-188 * g.scaleFactor); // second part of gate
                }
                if (obj.id == 98) {
                    obj.buildType = BuildType.DECOR_FENCE_ARKA;
                    obj.innerX = []; obj.innerY = [];
                    obj.innerX.push(-55 * g.scaleFactor); obj.innerY.push(-151 * g.scaleFactor); // main (top) part of gate
                    obj.innerX.push(-64 * g.scaleFactor); obj.innerY.push(-189 * g.scaleFactor); // second part of gate
                }
                if (obj.id == 176) {
                    obj.buildType = BuildType.DECOR_FENCE_ARKA;
                    obj.innerX = []; obj.innerY = [];
                    obj.innerX.push(-22 * g.scaleFactor); obj.innerY.push(-148 * g.scaleFactor); // main (top) part of gate
                    obj.innerX.push(-61 * g.scaleFactor); obj.innerY.push(-201 * g.scaleFactor); // second part of gate
                }
                
                    if (d.message[i].count_cell) obj.startCountCell = int(d.message[i].count_cell);
                    if (d.message[i].currency) {
                        obj.currency = String(d.message[i].currency).split('&');
                        for (k = 0; k < obj.currency.length; k++) obj.currency[k] = int(obj.currency[k]);
                    }
                    if (d.message[i].cost) {
                        obj.cost = String(d.message[i].cost).split('&');
                        for (k = 0; k < obj.cost.length; k++) obj.cost[k] = int(obj.cost[k]);
                    }
                    if (d.message[i].delta_cost) obj.deltaCost = int(d.message[i].delta_cost);
                    if (d.message[i].block_by_level) {
                        obj.blockByLevel = String(d.message[i].block_by_level).split('&');
                        for (k = 0; k < obj.blockByLevel.length; k++) obj.blockByLevel[k] = int(obj.blockByLevel[k]);
                    }
                    if (d.message[i].cost_skip) obj.priceSkipHard = int(d.message[i].cost_skip);
                    if (d.message[i].filter) obj.filterType = int(d.message[i].filter);
                    if (d.message[i].build_time) {
                        obj.buildTime = String(d.message[i].build_time).split('&');
                        for (k = 0; k < obj.buildTime.length; k++) obj.buildTime[k] = int(obj.buildTime[k]);
                    }
                    if (d.message[i].count_unblock) obj.countUnblock = int(d.message[i].count_unblock);

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
                    if (d.message[i].max_count) obj.maxAnimalsCount = int(d.message[i].max_count);
                    if (d.message[i].image_active) obj.imageActive = d.message[i].image_active;
                    if (d.message[i].cat_need) obj.catNeed = Boolean(int(d.message[i].cat_need));
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
                    if (d.message[i].visible) obj.visibleTester = Boolean(int(d.message[i].visible));
                    if (d.message[i].color) obj.color = String(d.message[i].color);
                    if (d.message[i].group) {
                        if (int(d.message[i].group) > 0) {
                            obj.group = int(d.message[i].group);
                            g.allData.addToDecorGroup(obj);
                        }
                    }
                obj.visibleAction = true;
                if (g.user.isTester) g.dataBuilding.objectBuilding[obj.id] = obj;
                else if (d.message[i].visible == 0 ) {
                    var startDayNumber:int = int(d.message[i].start_action);
                    var endDayNumber:int = int(d.message[i].end_action);
                    var curDayNumber:int = new Date().getTime()/1000;

                    obj.visibleAction = false;
                    if (startDayNumber == 0 && endDayNumber == 0) {
                        obj.visibleAction = true;
                    } else {
                        if (startDayNumber != 0 && startDayNumber <= curDayNumber) {
                            if (endDayNumber > curDayNumber || endDayNumber == 0) {
                                obj.visibleAction = true;
                            }
                            else {
                                obj.visibleAction = false;
                            }
                        } else if (startDayNumber > curDayNumber) {
                            obj.visibleAction = false;
                        }

                    }
                    g.dataBuilding.objectBuilding[obj.id] = obj;
                }
            }
            g.allData.sortDecorData();
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('getDataBuilding: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataBuilding: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function authUser(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_START);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'authUser', 1);
        g.user.sessionKey = String(int(Math.random()*1000000));
        variables = addDefault(variables);
        variables.idSocial = g.user.userSocialId;
        variables.name = g.user.name;
        variables.lastName = g.user.lastName;
        variables.sex = g.user.sex;
        variables.bornDate = g.user.bornDate;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteAuthUser);
        loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
        function onCompleteAuthUser(e:Event):void { completeAuthUser(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('authUser error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAuthUser(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('authUser: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'authUser OK', 5);
            g.user.userId = int(d.message);
            Cc.info('userID:: ' + g.user.userId);
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('authUser: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'authUser: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getUserInfo(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USER_INFO);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserInfo', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUserInfo);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteUserInfo(e:Event):void { completeUserInfo(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('userInfo error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUserInfo(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('userInfo: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'userInfo: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            var i:int;
            Cc.ch('server', 'getUserInfo OK', 5);
            var ob:Object = d.message;
            var check:int = int(ob.ambar_max) + int(ob.sklad_max) + int(ob.ambar_level) + int(ob.sklad_level) + int(ob.hard_count) + int(ob.soft_count) +
                    int(ob.yellow_count) + int(ob.green_count) + int(ob.red_count) + int(ob.blue_count) + int(ob.level) + int(ob.xp) + int(ob.count_cats) +
                    int(ob.tutorial_step) + int(ob.count_chest) + int(ob.count_daily_bonus);
            if (check != int(ob.test_date)) {
                wrongDataFromServer('getUserInfo');
                return;
            }
            g.user.ambarLevel = int(ob.ambar_level);
            g.userValidates.updateInfo('ambarLevel', g.user.ambarLevel);
            g.user.skladLevel = int(ob.sklad_level);
            g.userValidates.updateInfo('skladLevel', g.user.skladLevel);
            g.user.ambarMaxCount = int(ob.ambar_max);
            g.userValidates.updateInfo('ambarMax', g.user.ambarMaxCount);
            g.user.skladMaxCount = int(ob.sklad_max);
            g.userValidates.updateInfo('skladMax', g.user.skladMaxCount);
            g.user.hardCurrency = int(ob.hard_count);
            g.userValidates.updateInfo('hardCount', g.user.hardCurrency);
            g.user.softCurrencyCount = int(ob.soft_count);
            g.userValidates.updateInfo('softCount', g.user.softCurrencyCount);
            g.user.redCouponCount = int(ob.red_count);
            g.userValidates.updateInfo('redCount', g.user.redCouponCount);
            g.user.yellowCouponCount = int(ob.yellow_count);
            g.userValidates.updateInfo('yellowCount', g.user.yellowCouponCount);
            g.user.blueCouponCount = int(ob.blue_count);
            g.userValidates.updateInfo('softCount', g.user.softCurrencyCount);
            g.user.greenCouponCount = int(ob.green_count);
            g.userValidates.updateInfo('greenCount', g.user.greenCouponCount);
            g.user.blueCouponCount = int(ob.blue_count);
            g.userValidates.updateInfo('blueCount', g.user.blueCouponCount);
            g.user.globalXP = int(ob.xp);
            g.user.allNotification = int(ob.notification_new);
            if (!g.isDebug) {
                if (ob.music == '1') g.soundManager.enabledMusic(true);
                else g.soundManager.enabledMusic(false);
                if (ob.sound == '1') g.soundManager.enabledSound(true);
                else g.soundManager.enabledSound(false);
            } else {
                g.soundManager.enabledMusic(false);
                g.soundManager.enabledSound(false);
            }
            if (int(ob.time_paper) == 0) g.userTimer.timerAtPapper = 0;
                else g.userTimer.timerAtPapper = 300 - (int(new Date().getTime() / 1000) - int(ob.time_paper));
            if (g.userTimer.timerAtPapper > 300) g.userTimer.timerAtPapper = 300;
            if (g.userTimer.timerAtPapper > 0)  g.userTimer.startUserPapperTimer(g.userTimer.timerAtPapper);

            if (int(ob.in_papper) == 0) g.userTimer.papperTimerAtMarket = 0;
                else g.userTimer.papperTimerAtMarket = 300 - (int(new Date().getTime() / 1000) - int(ob.in_papper));
            if (g.userTimer.papperTimerAtMarket > 300) g.userTimer.papperTimerAtMarket = 300;
            if (g.userTimer.papperTimerAtMarket > 0)  g.userTimer.startUserMarketTimer(g.userTimer.papperTimerAtMarket);

            g.user.tutorialStep = int(ob.tutorial_step);
            g.user.marketCell = int(ob.market_cell);
            if (ob.wall_order_item_time == int(new Date().dateUTC)) g.user.wallOrderItem = false;
            else g.user.wallOrderItem = true;

            if (ob.wall_train_item == int(new Date().dateUTC)) g.user.wallTrainItem = false;
            else g.user.wallTrainItem = true;

            g.user.level = int(ob.level);
            g.userValidates.updateInfo('level', g.user.level);
            g.user.checkUserLevel();
            if (ob.mouse_day) {
                g.managerMouseHero.fillFromServer(ob.mouse_day, ob.mouse_count);
            } else {
                g.user.countAwayMouse = 0;
            }
            g.managerDailyBonus.fillFromServer(ob.daily_bonus_day, int(ob.count_daily_bonus));
            g.managerChest.fillFromServer(ob.chest_day, int(ob.count_chest));
            
            g.user.countCats = int(ob.count_cats);
            g.userValidates.updateInfo('countCats', g.user.countCats);
            if (ob.scale) {
                g.currentGameScale = int(ob.scale) / 100;
            }
            if (ob.cut_scene) {
                Cc.info('User cutscenes:: ' + ob.cut_scene);
                g.user.cutScenes = String(ob.cut_scene).split('&');
                for (i = 0; i < g.user.cutScenes.length; i++) {
                    g.user.cutScenes[i] = int(g.user.cutScenes[i]);
                }
            } else {
                g.user.cutScenes = [];
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
            if (ob.quests) g.managerQuest.fromServer(ob.quests);

            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('userInfo: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'userInfo: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserTutorialStep(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_TUTORIAL_STEP);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserTutorialStep', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.step = g.user.tutorialStep;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.step)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onUpdateUserTutorialStep);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onUpdateUserTutorialStep(e:Event):void { completeUpdateUserTutorialStep(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserTutorialStep error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserTutorialStep(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserTutorialStep: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTutorialStep: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserTutorialStep OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserTutorialStep: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTutorialStep: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserTester(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_TESTER);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserTester', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.isTester = g.user.isTester;
        variables.hash = MD5.hash(String(g.user.userId)+String(g.user.isTester)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onСompleteUpdateUserTester);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onСompleteUpdateUserTester(e:Event):void { completeUpdateUserTester(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserTester error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserTester(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserTester: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTester: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserTester OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserTester: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTutorialStep: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getAllFriendsInfo(userSocialIdArr:Array, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ALL_FRIENDS_INFO);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getAllFriendsInfo', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.userSocialIds = userSocialIdArr.join('&');
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteAllFriendsInfo);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteAllFriendsInfo(e:Event):void { completeAllFriendsInfo(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getAllFriendsInfo error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAllFriendsInfo(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getAllFriendsInfo: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getAllFriendsInfo: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getAllFriendsInfo OK', 5);
            g.user.addInfoAboutFriendsFromServer(d.message);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('getAllFriendsInfo: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getAllFriendsInfo: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function addUserMoney(type:int, countAll:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USER_MONEY);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserMoney', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.type = type;
        variables.countAll = countAll;
        variables.hash = MD5.hash(String(g.user.userId)+String(type)+String(countAll)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserMoney);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteAddUserMoney(e:Event):void { completeAddUserMoney(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserMoney error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAddUserMoney(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserMoney: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserMoney: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addUserMoney OK', 5);
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('addUserMoney: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserMoney: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function addUserXP(countAll:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_XP);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserXP', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.countAll = countAll;
        variables.hash = MD5.hash(String(g.user.userId)+String(countAll)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserXP);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteAddUserXP(e:Event):void { completeAddUserXP(e.target.data, callback,loader); }

        try {
            loader.load(request);
        } catch (error:Error) {
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAddUserXP(response:String, callback:Function = null, loader:URLLoader = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);

        } catch (e:Error) {
            Cc.error('addUserXP: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserXP: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);

            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addUserXP OK', 5);
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('addUserXP: id: ' + d.id + '  with message: ' + d.message + d.status + ' '+ d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserXP: id: ' + d.id + '  with message: ' + d.message);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function updateUserLevel(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_LEVEL);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserLevel', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.level = g.user.level;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.level)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserLevel);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteUpdateUserLevel(e:Event):void { completeUpdateUserLevel(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserLevel error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserLevel(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserLevel: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserLevel: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserLevel OK', 5);
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserLevel: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserLevel: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function updateUserTimePaper(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_TIMER_PAPER);
        var variables:URLVariables = new URLVariables();
//        var time:Number = getTimer();
        Cc.ch('server', 'updateUserTimerPaper', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.timePaper = int(new Date().getTime()/1000);
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.timePaper)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserTimePaper);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteUpdateUserTimePaper(e:Event):void { completeUpdateUserTimePaper(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserTimerPaper error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserTimePaper(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserTimerPaper: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTimerPaper: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserTimerPaper OK', 5);
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserTimerPaper: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTimerPaper: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function getUserResource(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_RESOURCE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserResource', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserResource);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteGetUserResource(e:Event):void { completeGetUserResource(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('GetUserResource error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserResource(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
            for (var i:int = 0; i < d.message.length; i++) {
                g.userInventory.addResourceFromServer(int(d.message[i].resource_id), int(d.message[i].count));
            }
        } catch (e:Error) {
            Cc.error('GetUserResource: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserResource: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserResource OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('GetUserResource: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserResource: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function addUserResource(resourceId:int, count:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_RESOURCE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserResource', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.resourceId = resourceId;
        variables.countAll = count;
        variables.hash = MD5.hash(String(g.user.userId)+String(resourceId)+String(count)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserResource);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteAddUserResource(e:Event):void { completeAddUserResource(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserResource error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAddUserResource(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserResource: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserResource: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addUserResource OK', 5);
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('addUserResource: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserResource: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function addUserBuilding(wObject:WorldObject, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_BUILDING);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserBuilding', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.buildingId = wObject.dataBuild.id;
        variables.posX = wObject.posX;
        variables.posY = wObject.posY;
        if (wObject is Fabrica) {
            variables.countCell = wObject.dataBuild.countCell;
        } else {
            variables.countCell = 0;
        }
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.buildingId)+String(variables.posX)+String(variables.posY)+String(variables.countCell)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserBuilding);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteAddUserBuilding(e:Event):void { completeAddUserBuilding(e.target.data, wObject, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserBuilding error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAddUserBuilding(response:String, wObject:WorldObject, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserBuilding: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserBuilding: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addUserBuilding OK', 5);
            wObject.dbBuildingId = int(d.message);
            if (g.user.userBuildingData[wObject.dataBuild.id])
                (g.user.userBuildingData[wObject.dataBuild.id] as Object).dbId = int(d.message);
            if (callback != null) {
                callback.apply(null, [true, wObject]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('addUserBuilding: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserBuilding: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function getUserBuilding(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_BUILDING);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserBuilding', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserBuilding);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteGetUserBuilding(e:Event):void { completeGetUserBuilding(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('GetUserBuilding error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserBuilding(response:String, callback:Function = null):void {
        iconMouse.endConnect();
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
            Cc.ch('server', 'getUserBuilding OK', 5);
            g.user.userDataCity.objects = new Array();
            for (var i:int = 0; i < d.message.length; i++) {
                d.message[i].id ? dbId = int(d.message[i].id) : dbId = 0;
                if (!g.dataBuilding.objectBuilding[int(d.message[i].building_id)]) {
                    Cc.error('no in g.dataBuilding.objectBuilding such id: ' + int(d.message[i].building_id));
                    continue;
                }
                dataBuild = Utils.objectDeepCopy(g.dataBuilding.objectBuilding[int(d.message[i].building_id)]);
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
                    if (dataBuild.buildType == BuildType.CAVE || dataBuild.buildType == BuildType.MARKET ||
                            dataBuild.buildType == BuildType.PAPER || dataBuild.buildType == BuildType.DAILY_BONUS || dataBuild.buildType == BuildType.TRAIN ||  dataBuild.buildType == BuildType.CHEST
                            || dataBuild.buildType == BuildType.CAT_HOUSE) {
                        //do nothing, use usual x and y from server
//                        p.x *= g.scaleFactor;
//                        p.y *= g.scaleFactor;  // scaleFactor will use at pasteBuild
                    } else {
                        // in another case we get isometric coordinates from server
                        p = g.matrixGrid.getXYFromIndex(p);
                    }

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
                    var build:WorldObject = g.townArea.createNewBuild(dataBuild, dbId);
                    if (build is DecorTail) {
                        g.townArea.pasteTailBuild(build as DecorTail, p.x, p.y, false);
                    } else {
                        g.townArea.pasteBuild(build, p.x, p.y, false);
                    }
                }
            }
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('GetUserBuilding: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserBuilding: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function startBuildBuilding(wObject:WorldObject, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_START_BUILD_BUILDING);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'startBuildMapBuilding', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.buildingId = wObject.dataBuild.id;
        variables.dbId = wObject.dbBuildingId;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.buildingId)+String(variables.dbId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteStartBuildMapBuilding);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteStartBuildMapBuilding(e:Event):void { completeStartBuildMapBuilding(e.target.data, wObject, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('startBuildMapBuilding error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeStartBuildMapBuilding(response:String, wObject:WorldObject, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('startBuildMapBuilding: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'startBuildMapBuilding: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'startBuildMapBuilding OK', 5);
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('startBuildMapBuilding: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'startBuildMapBuilding: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function openBuildedBuilding(wObject:WorldObject, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_OPEN_BUILDED_BUILDING);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'openBuildMapBuilding', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.buildingId = wObject.dataBuild.id;
        variables.dbId = wObject.dbBuildingId;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.buildingId)+String(variables.dbId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteOpenBuildMapBuilding);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteOpenBuildMapBuilding(e:Event):void { completeOpenBuildMapBuilding(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('openBuildMapBuilding error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeOpenBuildMapBuilding(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('openBuildMapBuilding: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'openBuildMapBuilding: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'openBuildMapBuilding OK', 5);
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('openBuildMapBuilding: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'openBuildMapBuilding: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function addFabricaRecipe(recipeId:int, dbId:int, delay:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_FABRICA_RECIPE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addFabricaRecipe', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.recipeId = recipeId;
        variables.dbId = dbId;
        variables.delay = delay;
        variables.hash = MD5.hash(String(g.user.userId)+String(dbId)+String(recipeId)+String(delay)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAddFabricaRecipe);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteAddFabricaRecipe(e:Event):void { completeAddFabricaRecipe(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addFabricaRecipe error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAddFabricaRecipe(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addFabricaRecipe: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addFabricaRecipe: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addFabricaRecipe OK', 5);
            if (callback != null) {
                callback.apply(null, [d.message]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('addFabricaRecipe: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addFabricaRecipe: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function getUserFabricaRecipe(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_FABRICA_RECIPE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserFabricaRecipe', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserFabricaRecipe);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteGetUserFabricaRecipe(e:Event):void { completeGetUserFabricaRecipe(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('GetUserFabricaRecipe error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserFabricaRecipe(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('GetUserFabricaRecipe: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserFabricaRecipe: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserFabricaRecipe OK', 5);
            (d.message as Array).sortOn('delay', Array.NUMERIC);
            g.managerFabricaRecipe = new ManagerFabricaRecipe();
            for (var i:int = 0; i < d.message.length; i++) {
                g.managerFabricaRecipe.addRecipeFromServer(d.message[i]);
            }
            g.managerFabricaRecipe.onLoadFromServer();
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('GetUserFabricaRecipe: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserFabricaRecipe: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function craftFabricaRecipe(dbId:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_CRAFT_FABRICA_RECIPE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'craftFabricaRecipe', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        variables.hash = MD5.hash(String(g.user.userId)+String(dbId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteCraftFabricaRecipe);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteCraftFabricaRecipe(e:Event):void { completeCraftFabricaRecipe(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('craftFabricaRecipe error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeCraftFabricaRecipe(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('craftFabricaRecipe: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'craftFabricaRecipe: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'craftFabricaRecipe OK', 5);
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('craftFabricaRecipe: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'craftFabricaRecipe: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function rawPlantOnRidge(plantId:int, dbId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_RAW_PLANT_RIDGE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'rawPlantOnRidge', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.plantId = plantId;
        variables.dbId = dbId;
        variables.hash = MD5.hash(String(g.user.userId)+String(plantId)+String(dbId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteRawPlantOnRidge);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteRawPlantOnRidge(e:Event):void { completeRawPlantOnRidge(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('rawPlantOnRidge error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeRawPlantOnRidge(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('rawPlantOnRidge: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'rawPlantOnRidge: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'rawPlantOnRidge OK', 5);
            if (callback != null) {
                callback.apply(null, [d.message]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('rawPlantOnRidge: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'rawPlantOnRidge: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function getUserPlantRidge(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_PLANT_RIDGE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserPlantRidge', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserPlantRidge);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteGetUserPlantRidge(e:Event):void { completeGetUserPlantRidge(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('GetUserPlantRidge error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserPlantRidge(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('GetUserPlantRidge: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserPlantRidge: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserPlantRidge OK', 5);
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
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('GetUserPlantRidge: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserPlantRidge: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function craftPlantRidge(dbId:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_CRAFT_PLANT_RIDGE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'craftPlantRidge', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        variables.hash = MD5.hash(String(g.user.userId)+String(dbId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteCraftPlantRidge);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteCraftPlantRidge(e:Event):void { completeCraftPlantRidge(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('craftPlantRidge error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeCraftPlantRidge(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('craftPlantRidge: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'craftPlantRidge: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'craftPlantRidge OK', 5);
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('craftPlantRidge: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'craftPlantRidge: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function addUserTree(wObject:WorldObject, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_TREE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserTree', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = wObject.dbBuildingId;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.dbId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserTree);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteAddUserTree(e:Event):void { completeAddUserTree(e.target.data, wObject, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserTree error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAddUserTree(response:String, wObject:WorldObject, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserTree: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserTree: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addUserTree OK', 5);
            (wObject as Tree).tree_db_id = d.message;
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('addUserTree: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserTree: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function getUserTree(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_TREE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserTree', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserTree);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteGetUserTree(e:Event):void { completeGetUserTree(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('GetUserTree error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserTree(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('GetUserTree: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserTree: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserTree OK', 5);
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
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('GetUserTree: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserTree: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function  updateUserTreeState(treeDbId:String, state:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_TREE_STATE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserTreeState', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.id = treeDbId;
        variables.state = state;
        variables.hash = MD5.hash(String(g.user.userId)+String(treeDbId)+String(state)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserTreeState);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteUpdateUserTreeState(e:Event):void { completeUpdateUserTreeState(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserTreeState error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserTreeState(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserTreeState: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTreeState: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserTreeState OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserTreeState: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTreeState: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function deleteUserTree(treeDbId:String, dbId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DELETE_USER_TREE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'deleteUserTree', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        variables.treeDbId = treeDbId;
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteDeleteUserTree);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteDeleteUserTree(e:Event):void { completeDeleteUserTree(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('deleteUserTree error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeDeleteUserTree(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('deleteUserTree: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'deleteUserTree: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'deleteUserTree OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('deleteUserTree: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'deleteUserTree: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function addUserAnimal(an:Animal, farmDbId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_ANIMAL);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserAnimal', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.farmDbId = farmDbId;
        variables.animalId = an.animalData.id;
        variables.hash = MD5.hash(String(g.user.userId)+String(farmDbId)+String(variables.animalId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserAnimal);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteAddUserAnimal(e:Event):void { completeAddUserAnimal(e.target.data, an, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserAnimal error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAddUserAnimal(response:String, an:Animal, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserAnimal: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserAnimal: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addUserAnimal OK', 5);
            an.animal_db_id = d.message;
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('addUserTree: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserTree: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function rawUserAnimal(anDbId:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_RAW_USER_ANIMAL);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'rawUserAnimal', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.anDbId = anDbId;
        variables.hash = MD5.hash(String(g.user.userId)+String(anDbId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteRawUserAnimal);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteRawUserAnimal(e:Event):void { completeRawUserAnimal(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('rawUserAnimal error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeRawUserAnimal(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('rawUserAnimal: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'rawUserAnimal: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'rawUserAnimal OK', 5);
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('rawUserTree: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'rawUserTree: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function getUserAnimal(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_ANIMAL);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserAnimal', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserAnimal);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteGetUserAnimal(e:Event):void { completeGetUserAnimal(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('GetUserAnimal error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserAnimal(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('GetUserAnimal: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserAnimal: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserAnimal OK', 5);
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
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('GetUserAnimal: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserAnimal: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function craftUserAnimal(animalDbId:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_CRAFT_USER_ANIMAL);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'craftUserAnimal', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.animalDbId = animalDbId;
        variables.hash = MD5.hash(String(g.user.userId)+String(animalDbId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteCraftUserAnimal);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteCraftUserAnimal(e:Event):void { completeCraftUserAnimal(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('craftUserAnimal error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeCraftUserAnimal(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('craftUserAnimal: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'craftUserAnimal: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'craftUserAnimal OK', 5);
            for (var i:int = 0; i < d.message.length; i++) {
                g.managerAnimal.addAnimal(d.message[i]);
            }
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('craftUserAnimal: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'craftUserAnimal: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function addUserTrain(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_TRAIN);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserTrain', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserTrain);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteAddUserTrain(e:Event):void { completeAddUserTrain(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserTrain error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAddUserTrain(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserTrain: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserTrain: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [0]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addUserTrain OK', 5);
            if (callback != null) {
                callback.apply(null, [d.message]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('addUserTrain: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserTrain: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [0]);
            }
        }
    }

    public function getUserTrain(callback:Function):void {
        var tr:Train = g.townArea.getCityObjectsByType(BuildType.TRAIN)[0];
        if (g.user.level < 17) {
            Cc.ch('server', 'getUserTrain:: g.user.level < 17', 1);
            if (tr) tr.fillItDefault();
            if (callback != null) {
                callback.apply();
            }
            return;
        }

        if (!tr || tr.stateBuild < 4) {
            Cc.ch('server', 'getUserTrain:: train.stateBuild < 4', 1);
           if (tr) tr.fillItDefault();
            if (callback != null) {
                callback.apply();
            }
            return;
        }
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_TRAIN);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserTrain', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserTrain);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteGetUserTrain(e:Event):void { completeGetUserTrain(e.target.data, tr, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserTrain error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserTrain(response:String, tr:Train, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('GetUserTrain: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserTrain: wrong JSON:' + String(response));
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserTrain OK', 5);
            tr.fillFromServer(d.message);
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('GetUserTrain: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserTrain: id: ' + d.id + '  with message: ' + d.message);
        }

        if (callback != null) {
            callback.apply();
        }
    }

    public function updateUserTrainState(state:int, train_db_id:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_TRAIN_STATE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserTrainState', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.state = state;
        variables.id = train_db_id;
        variables.hash = MD5.hash(String(g.user.userId)+String(train_db_id)+String(state)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserTrainState);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteUpdateUserTrainState(e:Event):void { completeUpdateUserTrainState(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserTrainState error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserTrainState(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserTrainState: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTrainState: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply();
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserTrainState OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserTrainState: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTrainState: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply();
            }
        }
    }

    public function getTrainPack(userSocialId:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_TRAIN_PACK);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getTrainPack', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.userSocialId = userSocialId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetTrainPack);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteGetTrainPack(e:Event):void { completeGetTrainPack(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getTrainPack error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetTrainPack(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getTrainPack: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getTrainPack: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getTrainPack OK', 5);
            if (callback != null) {
                callback.apply(null, [d.message]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('getTrainPack: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getTrainPack: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function releaseUserTrainPack(train_db_id:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_RELEASE_USER_TRAIN_PACK);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'releaseUserTrainPack', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.id = train_db_id;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.id)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteReleaseUserTrainPack);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteReleaseUserTrainPack(e:Event):void { completeReleaseUserTrainPack(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('releaseUserTrainPack error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeReleaseUserTrainPack(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('releaseUserTrainPack: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'releaseUserTrainPack: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply();
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'releaseUserTrainPack OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('releaseUserTrainPack: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'releaseUserTrainPack: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply();
            }
        }
    }

    public function updateUserTrainPackItems(train_item_db_id:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_TRAIN_PACK_ITEM);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserTrainPackItems ', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.id = train_item_db_id;
        variables.hash = MD5.hash(String(g.user.userId)+String(train_item_db_id)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserTrainPackItems);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteUpdateUserTrainPackItems(e:Event):void { completeUpdateUserTrainPackItems(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserTrainPackItems error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserTrainPackItems(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserTrainPackItems: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTrainPackItems: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply();
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserTrainPackItems OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserTrainPackItems: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserTrainPackItems: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply();
            }
        }
    }

    public function deleteUser(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DELETE_USER);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'deleteUser', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteDeleteUser);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteDeleteUser(e:Event):void { completeDeleteUser(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('deleteUser error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeDeleteUser(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        if (callback != null) {
            callback.apply();
        }
        Cc.error('deleteUser responce:' + response);
    }

    public function addUserMarketItem(id:int, levelResource:int, count:int, inPapper:Boolean, cost:int, numberCell:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_MARKET_ITEM);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserMarketItem', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.resourceId = id;
        variables.level = levelResource;
        variables.count = count;
        variables.cost = cost;
        variables.numberCell = numberCell;
        variables.inPapper = inPapper ? 1 : 0;
        variables.timeInPapper = 0;
        variables.hash = MD5.hash(String(g.user.userId)+String(id)+String(count)+String(cost)+String(numberCell)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserMarketItem);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteAddUserMarketItem(e:Event):void { completeAddUserMarketItem(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserMarketItem error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAddUserMarketItem(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserMarketItem: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserMarketItem: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addUserMarketItem OK', 5);
            if (callback != null) {
                callback.apply(null, [d.message]);
            }
        } else if (d.id == 13) {
            Cc.ch('server', 'addUserMarketItem anotherGame', 5);
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            Cc.ch('server', 'addUserMarketItem SERVER CRACK', 5);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('addUserMarketItem: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserMarketItem: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getUserMarketItem(socialId:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_MARKET_ITEM);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserMarketItem', 1);
        variables = addDefault(variables);
        variables.userSocialId = socialId;
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserMarketItem);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteGetUserMarketItem(e:Event):void { completeGetUserMarketItem(e.target.data, socialId, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserMarketItem error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserMarketItem(response:String, socialId:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getUserMarketItem: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserMarketItem: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserMarketItem OK', 5);
            if (socialId == g.user.userSocialId) g.user.fillYoursMarketItems(d.message.items, int(d.message.market_cell));
            else g.user.fillSomeoneMarketItems(d.message.items, socialId, int(d.message.market_cell));
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('getUserMarketItem: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserMarketItem: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function buyFromMarket(itemId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_BUY_FROM_MARKET);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'buyFromMarket', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.itemId = itemId;
        variables.hash = MD5.hash(String(g.user.userId)+String(itemId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteBuyFromMarket);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteBuyFromMarket(e:Event):void { completeBuyFromMarket(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('buyFromMarket error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeBuyFromMarket(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('buyFromMarket: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'buyFromMarket: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'buyFromMarket OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('buyFromMarket: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'buyFromMarket: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function deleteUserMarketItem(itemId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DELETE_USER_MARKET_ITEM);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'deleteUserMarketItem', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.itemId = itemId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteDeleteUserMarketItem);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteDeleteUserMarketItem(e:Event):void { completeDeleteUserMarketItem(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('deleteUserMarketItem error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeDeleteUserMarketItem(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('deleteUserMarketItem: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'deleteUserMarketItem: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'deleteUserMarketItem OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('deleteUserMarketItem: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'deleteUserMarketItem: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserBuildPosition(dbId:int, pX:int, pY:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_BUILD_POSITION);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserBuildPosition', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        variables.posX = pX;
        variables.posY = pY;
        variables.hash = MD5.hash(String(g.user.userId)+String(dbId)+String(pX)+String(pY)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserBuildPosition);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteUpdateUserBuildPosition(e:Event):void { completeUpdateUserBuildPosition(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserBuildPosition error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserBuildPosition(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserBuildPosition: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserBuildPosition: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserBuildPosition OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserBuildPosition: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserBuildPosition: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getPaperItems(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_PAPER_ITEMS);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getPaperItems', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.level = g.user.level;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetPaperItems);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteGetPaperItems(e:Event):void { completeGetPaperItems(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getPaperItems error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetPaperItems(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getPaperItems: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getPaperItems: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getPaperItems OK', 5);
            g.managerPaper.fillIt(d.message);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('getPaperItems: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getPaperItems: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserAmbar(isAmbar:int, newLevel:int, newMaxCount:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_AMBAR);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserAmbar', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.isAmbar = isAmbar;
        variables.newLevel = newLevel;
        variables.newMaxCount = newMaxCount;
        variables.hash = MD5.hash(String(g.user.userId)+String(newLevel)+String(newMaxCount)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserAmbar);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteUpdateUserAmbar(e:Event):void { completeUpdateUserAmbar(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserAmbar error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserAmbar(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserAmbar: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserAmbar: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserAmbar OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserAmbar: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserAmbar: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getDataLockedLand(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DATA_LOCKED_LAND);
        var variables:URLVariables = new URLVariables();
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        Cc.ch('server', 'start getDataLockedLand', 1);
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetDataLockedLand);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteGetDataLockedLand(e:Event):void { completeGetDataLockedLand(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataLockedLand error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetDataLockedLand(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataLockedLand: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataLockedLand: wrong JSON:' + String(response));
            return;
        }

        g.allData.lockedLandData = {};
        if (d.id == 0) {
            Cc.ch('server', 'getDataLockedLand OK', 5);
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
            Cc.error('getDataLockedLand: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataLockedLand: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function removeUserLockedLand(id:int, callback:Function = null):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_REMOVE_USER_LOCKED_LAND);
        var variables:URLVariables = new URLVariables();
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.mapBuildingId = id;
        variables.hash = MD5.hash(String(g.user.userId)+String(id)+SECRET);
        request.data = variables;
        Cc.ch('server', 'start removeUserLockedLand', 1);
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteRemoveUserLockedLand);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteRemoveUserLockedLand(e:Event):void { completeRemoveUserLockedLand(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('removeUserLockedLand error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeRemoveUserLockedLand(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('removeUserLockedLand: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'removeUserLockedLand: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'removeUserLockedLand OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('removeUserLockedLand: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'removeUserLockedLand: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function addToInventory(dbId:int, callback:Function = null):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_TO_INVENTORY);
        var variables:URLVariables = new URLVariables();
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        variables.hash = MD5.hash(String(g.user.userId)+String(dbId)+SECRET);
        request.data = variables;
        Cc.ch('server', 'start addToInventory', 1);
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteAddToInventory);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteAddToInventory(e:Event):void { completeAddToInventory(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addToInventory error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAddToInventory(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addToInventory: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addToInventory: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addToInventory',5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('addToInventory: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addToInventory: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function removeFromInventory(dbId:int, posX:int, posY:int, callback:Function = null):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_REMOVE_FROM_INVENTORY);
        var variables:URLVariables = new URLVariables();
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        variables.posX = posX;
        variables.posY = posY;
        variables.hash = MD5.hash(String(g.user.userId)+String(dbId)+SECRET);
        request.data = variables;
        Cc.ch('server', 'start removeFromInventory', 1);
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteRemoveFromInventory);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteRemoveFromInventory(e:Event):void { completeRemoveFromInventory(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('removeFromInventory error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeRemoveFromInventory(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('removeFromInventory: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'removeFromInventory: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'removeFromInventory OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('removeFromInventory: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'removeFromInventory: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getUserNeighborMarket(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_NEIGHBOR_MARKET);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserNeighborMarket', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserNeighborMarket);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteGetUserNeighborMarket(e:Event):void { completeGetUserNeighborMarket(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserMarketItem error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserNeighborMarket(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getUserNeighborMarket: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserNeighborMarket: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserNeighborMarket OK', 5);
            g.user.fillNeighborMarketItems(d.message);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('getUserNeighborMarket: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserNeighborMarket: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function buyFromNeighborMarket(itemId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_BUY_FROM_NEIGHBOR_MARKET);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'buyFromNeighborMarket', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.itemId = itemId;
        variables.hash = MD5.hash(String(g.user.userId)+String(itemId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteBuyFromNeighborMarket);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteBuyFromNeighborMarket(e:Event):void { completeBuyFromNeighborMarket(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('buyFromNeighborMarket error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeBuyFromNeighborMarket(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('buyFromNeighborMarket: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'buyFromNeighborMarket: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'buyFromNeighborMarket OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('buyFromNeighborMarket: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'buyFromNeighborMarket: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getAllCityData(p:Someone, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_ALL_CITY_DATA);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getAllCityData', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.userSocialId = p.userSocialId;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.userSocialId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetAllCityData);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteGetAllCityData(e:Event):void { completeGetAllCityData(e.target.data, p, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getAllCityData error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetAllCityData(response:String, p:Someone, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        var ob:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getAllCityData: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getAllCityData: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getAllCityData OK', 5);
            p.userDataCity.objects = new Array();
            for (var i:int = 0; i < d.message['building'].length; i++) {
                if (!g.dataBuilding.objectBuilding[int(d.message['building'][i].building_id)]) {
                    Cc.error('no in g.dataBuilding.objectBuilding such id: ' + int(d.message['building'][i].building_id));
                    continue;
                }
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
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('getAllCityData: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getAllCityData: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function buyHeroCat(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_BUY_HERO_CAT);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'buyHeroCat', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.countAll = g.user.countCats;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteBuyHeroCat);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteBuyHeroCat(e:Event):void { completeBuyHeroCat(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('buyFromHeroCat error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeBuyHeroCat(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('buyHeroCat: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'buyHeroCat: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'buyHeroCat OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('buyHeroCat: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'buyHeroCat: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function ME_addWild(posX:int, posY:int, w:WorldObject, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ME_ADD_WILD);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'ME_addWild', 1);
        variables.channelId = g.socialNetworkID;
        variables.userId = g.user.userId;
        variables.posX = posX;
        variables.posY = posY;
        variables.wildId = w.dataBuild.id;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteME_addWild);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteME_addWild(e:Event):void { completeME_addWild(e.target.data, w, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('ME_addWild error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeME_addWild(response:String, w:WorldObject, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('ME_addWild: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'ME_addWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'ME_addWild OK', 5);
            w.dbBuildingId = int(d.message);
            if (callback != null) {
                callback.apply(null);
            }
        } else {
            Cc.error('ME_addWild: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'ME_addWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
        }
    }

    public function ME_removeWild(dbId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ME_REMOVE_WILD);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'ME_removeWild', 1);
        variables.channelId = g.socialNetworkID;
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteME_removeWild);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteME_removeWild(e:Event):void { completeME_removeWild(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('ME_removeWild error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeME_removeWild(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('ME_removeWild: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'ME_removeWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'ME_removeWild OK', 5);
            if (callback != null) {
                callback.apply(null);
            }
        } else {
            Cc.error('ME_removeWild: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'ME_removeWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
        }
    }

    public function ME_moveWild(posX:int, posY:int, dbId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ME_MOVE_WILD);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'ME_moveWild', 1);
        variables.channelId = g.socialNetworkID;
        variables.userId = g.user.userId;
        variables.posX = posX;
        variables.posY = posY;
        variables.dbId = dbId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteME_moveWild);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteME_moveWild(e:Event):void { completeME_moveWild(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('ME_moveWild error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeME_moveWild(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('ME_moveWild: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'ME_moveWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'ME_moveWild OK', 5);
            if (callback != null) {
                callback.apply(null);
            }
        } else {
            Cc.error('ME_moveWild: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'ME_moveWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
        }
    }

    public function ME_flipWild(dbId:int, isFlip:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ME_FLIP_WILD);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'ME_flipWild', 1);
        variables.channelId = g.socialNetworkID;
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        variables.isFlip = isFlip;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteME_flipWild);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteME_flipWild(e:Event):void { completeME_flipWild(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('ME_flipWild error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeME_flipWild(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('ME_flipWild: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'ME_flipWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'ME_flipWild OK', 5);
            if (callback != null) {
                callback.apply(null);
            }
        } else {
            Cc.error('ME_flipWild: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'ME_flipWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
        }
    }

    public function getUserWild(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_WILD);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserWild', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserWild);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteGetUserWild(e:Event):void { completeGetUserWild(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('GetUserWild error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserWild(response:String, callback:Function = null):void {
        iconMouse.endConnect();
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
            Cc.ch('server', 'getUserWild OK', 5);
            for (var i:int = 0; i < d.message.length; i++) {
                d.message[i].id ? dbId = int(d.message[i].id) : dbId = 0;
                dataBuild = Utils.objectDeepCopy(g.dataBuilding.objectBuilding[int(d.message[i].building_id)]);
                var p:Point = g.matrixGrid.getXYFromIndex(new Point(int(d.message[i].pos_x), int(d.message[i].pos_y)));
                if (dataBuild) {
                    dataBuild.dbId = dbId;
                    dataBuild.isFlip = int(d.message[i].is_flip);

                    ob = {};
                    ob.buildId = dataBuild.id;
                    ob.posX = int(d.message[i].pos_x);
                    ob.posY = int(d.message[i].pos_y);
                    ob.isFlip = int(d.message[i].is_flip);
                    ob.dbId = dbId;
                    g.user.userDataCity.objects.push(ob);

                    var build:WorldObject = g.townArea.createNewBuild(dataBuild, dbId);
                    g.townArea.pasteBuild(build, p.x, p.y, false);
                }
            }
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            Cc.error('GetUserWild: another game');
        } else {
            Cc.error('GetUserWild: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserWild: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function userBuildingFlip(dbId:int, isFlip:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USER_BUILDING_FLIP);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'userBuildingFlip', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        variables.isFlip = isFlip;
        variables.hash = MD5.hash(String(g.user.userId)+String(dbId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUserBuildingFlip);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteUserBuildingFlip(e:Event):void { completeUserBuildingFlip(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('userBuildingFlip error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUserBuildingFlip(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('userBuildingFlip: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'userBuildingFlip: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'userBuildingFlip OK', 5);
            if (callback != null) {
                callback.apply(null);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('userBuildingFlip: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'userBuildingFlip: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
        }
    }

    public function deleteUserWild(dbId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DELETE_USER_WILD);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'deleteUserWild', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteDeleteUserWild);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteDeleteUserWild(e:Event):void { completeDeleteUserWild(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('deleteUserWild error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeDeleteUserWild(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('deleteUserWildp: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'deleteUserWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'deleteUserWild OK', 5);
            if (callback != null) {
                callback.apply(null);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('deleteUserWild: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'deleteUserWild: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
        }
    }

    public function ME_moveMapBuilding(id:int, posX:int, posY:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ME_MOVE_MAP_BUILDING);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'ME_moveMapBuilding', 1);
        variables.channelId = g.socialNetworkID;
        variables.userId = g.user.userId;
        variables.buildId = id;
        variables.posX = posX;
        variables.posY = posY;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteME_moveMapBuilding);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteME_moveMapBuilding(e:Event):void { completeME_moveMapBuilding(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('ME_moveMapBuilding error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeME_moveMapBuilding(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('ME_moveMapBuilding: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'ME_moveMapBuilding: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'ME_moveMapBuilding OK', 5);
            if (callback != null) {
                callback.apply(null);
            }
        } else {
            Cc.error('ME_moveMapBuilding: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'ME_moveMapBuilding: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null);
            }
        }
    }

    public function saveUserGameScale(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USER_GAME_SCALE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'saveUserGameScale', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.scale = g.currentGameScale*100;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.scale)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteSaveUserGameScale);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteSaveUserGameScale(e:Event):void { completeSaveUserGameScale(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('saveUserGameScale error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeSaveUserGameScale(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('saveUserGameScale: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'saveUserGameScale: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'saveUserGameScale OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('saveUserGameScale: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'saveUserGameScale: wrong JSON:' + String(response));
        }
    }

    public function buyNewCellOnFabrica(dbId:int, count:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_CELL_FABRICA);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'buyNewCellOnFabrica', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = dbId;
        variables.count = count;
        variables.hash = MD5.hash(String(g.user.userId)+String(dbId)+String(count)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteBuyNewCellOnFabrica);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteBuyNewCellOnFabrica(e:Event):void { completeBuyNewCellOnFabrica(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('buyNewCellOnFabrica error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeBuyNewCellOnFabrica(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('buyNewCellOnFabrica: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'buyNewCellOnFabrica: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'buyNewCellOnFabrica OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('buyNewCellOnFabrica: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'buyNewCellOnFabrica: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function skipRecipeOnFabrica(userRecipeDbId:String, leftTime:int, buildDbId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_SKIP_RECIPE_FABRICA);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'skipRecipeOnFabrica', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.recipeDbId = userRecipeDbId;
        variables.leftTime = leftTime;
        variables.buildDbId = buildDbId;
        variables.hash = MD5.hash(String(g.user.userId)+String(userRecipeDbId)+String(leftTime)+String(buildDbId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteSkipRecipeOnFabrica);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteSkipRecipeOnFabrica(e:Event):void { completeSkipRecipeOnFabrica(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('skipRecipeOnFabrica error:' + error.errorID);
//          g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeSkipRecipeOnFabrica(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('skipRecipeOnFabrica: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipRecipeOnFabrica: wrong JSON:' + String(response));
            return;
        }
        if (d.warning != '') {
            Cc.error('DirectServer completeSkipRecipeOnFabrica:: warning: ' + d.warning);
        }

        if (d.id == 0) {
            Cc.ch('server', 'skipRecipeOnFabrica OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('skipRecipeOnFabrica: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipRecipeOnFabrica: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function skipTimeOnRidge(plantTime:int,buildDbId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_SKIP_TIME_RIDGE);
        var variables:URLVariables = new URLVariables();
        var time:Number = getTimer();

        Cc.ch('server', 'skipTimeOnRidge', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.plantTime = time - plantTime;
        variables.buildDbId = buildDbId;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.plantTime)+String(buildDbId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteskipTimeOnRidge);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteskipTimeOnRidge(e:Event):void { completeskipTimeOnRidge(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('skipTimeOnRidge error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeskipTimeOnRidge(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('skipTimeOnRidge: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipTimeOnRidge: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'skipTimeOnRidge OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('skipTimeOnRidge: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipTimeOnRidge: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function skipTimeOnTree(stateTree:int, buildDbId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_SKIP_TIME_TREE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'skipTimeOnTree', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.state = stateTree;
        variables.id = buildDbId;
        variables.hash = MD5.hash(String(g.user.userId)+String(stateTree)+String(buildDbId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteSkipTimeOnTree);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteSkipTimeOnTree(e:Event):void { completeSkipTimeOnTree(e.target.data,callback);}//e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('skipTimeOnTree error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeSkipTimeOnTree(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('skipTimeOnTree: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipTimeOnTree: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'skipTimeOnTree OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('skipTimeOnTree: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipTimeOnTree: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function skipTimeOnAnimal(timeToEnd:int,buildDbId:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_SKIP_TIME_ANIMAL);
        var variables:URLVariables = new URLVariables();
        var time:Number = getTimer();
        Cc.ch('server', 'skipTimeOnAnimal', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.animalDbId = int(buildDbId);
        variables.timeToEnd = time - timeToEnd;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.animalDbId)+String(variables.timeToEnd)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteskipTimeOnAnimal);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteskipTimeOnAnimal(e:Event):void { completeskipTimeOnAnimal(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('skipTimeOnAnimal error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);

        }
    }

    private function completeskipTimeOnAnimal(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('skipTimeOnAnimal: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipTimeOnAnimal: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'skipTimeOnAnimal OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('skipTimeOnAnimal: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipTimeOnAnimal: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function skipTimeOnFabricBuild(leftTime:int, buildDbId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_SKIP_TIME_FABRIC_BUILD);
        var variables:URLVariables = new URLVariables();
        var time:Number = getTimer();

        Cc.ch('server', 'skipTimeOnFabricBuild', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.leftTime = time - leftTime;
        variables.buildDbId = buildDbId;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.leftTime)+String(buildDbId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteSkipTimeOnFabricBuild);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteSkipTimeOnFabricBuild(e:Event):void { completeSkipTimeOnFabricBuild(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('skipTimeOnFabricBuild error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeSkipTimeOnFabricBuild(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('skipTimeOnFabricBuild: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipTimeOnFabricBuild: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'skipTimeOnFabricBuild OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('skipTimeOnFabricBuild: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipTimeOnFabricBuild: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function addUserOrder(order:Object, delay:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_ORDER);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserOrder', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.ids = order.resourceIds.join('&');
        variables.counts = order.resourceCounts.join('&');
        variables.xp = order.xp;
        variables.coins = order.coins;
        variables.addCoupone = int(order.addCoupone);
        variables.delay = delay;
        variables.place = order.placeNumber;
        variables.fasterBuyer = order.fasterBuy;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.ids)+String(variables.counts)+String(variables.xp)+String(variables.coins)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserOrder);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteAddUserOrder(e:Event):void { completeAddUserOrder(e.target.data, order, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserOrder error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAddUserOrder(response:String, order:Object, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserOrder: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserOrder: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addUserOrder OK', 5);
            order.dbId = String(d.message);
            if (callback != null) {
                callback.apply(null, [order]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('addUserOrder: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserOrder: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getUserOrder(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_ORDER);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserOrder', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserOrder);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteGetUserOrder(e:Event):void { completeGetUserOrder(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('GetUserOrder error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserOrder(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('GetUserOrder: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserOrder: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserOrder OK', 5);
            for (var i:int = 0; i < d.message.length; i++) {
                g.managerOrder.addFromServer(d.message[i]);
            }
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('GetUserFOrder: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserOrder: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function deleteUserOrder(orderDbId:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_DELETE_USER_ORDER);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'deleteUserOrder', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = orderDbId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteDeleteUserOrder);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteDeleteUserOrder(e:Event):void { completeDeleteUserOrder(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('deleteUserOrder error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeDeleteUserOrder(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('deleteUserOrder: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'deleteUserOrder: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'deleteUserOrder OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('deleteUserOrder: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'deleteUserOrder: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function askWateringUserTree(treeDbId:String, state:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ASK_WATERING_USER_TREE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'askWateringUserTree', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.id = treeDbId;
        variables.state = state;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.id)+String(state)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAskWateringUserTree);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteAskWateringUserTree(e:Event):void { completeAskWateringUserTree(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('askWateringUserTree error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAskWateringUserTree(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('askWateringUserTree: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'askWateringUserTree: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'askWateringUserTree OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('askWateringUserTree: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'askWateringUserTree: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function makeWateringUserTree(treeDbId:String, state:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_MAKE_WATERING_USER_TREE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'makeWateringUserTree', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.userSocialId = g.user.userSocialId;
        variables.awayUserSocialId = g.visitedUser.userSocialId;
        variables.id = treeDbId;
        variables.state = state;
        variables.hash = MD5.hash(String(g.user.userId)+String(g.user.userSocialId)+String(variables.awayUserSocialId)+String(variables.id)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteMakeWateringUserTree);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteMakeWateringUserTree(e:Event):void { completeMakeWateringUserTree(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('MakeWateringUserTree error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeMakeWateringUserTree(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('makeWateringUserTree: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'makeWateringUserTree: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'makeWateringUserTree OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('makeWateringUserTree: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'makeWateringUserTree: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function skipOrderTimer(orderID:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_SKIP_ORDER_TIMER);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'skipOrderTimer', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.dbId = orderID;
        variables.hash = MD5.hash(String(g.user.userId)+String(orderID)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteSkipOrderTimer);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteSkipOrderTimer(e:Event):void { completeSkipOrderTimer(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('skipOrderTimer error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeSkipOrderTimer(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('skipOrderTimer: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipOrderTimer: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'skipOrderTimer OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('skipOrderTimer: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipOrderTimer: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function craftUserTree(treeDbId:String, state:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_CRAFT_USER_TREE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'craftUserTree', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.id = treeDbId;
        variables.state = state;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.id)+String(state)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteCraftUserTree);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteCraftUserTree(e:Event):void { completeCraftUserTree(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('craftUserTree error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeCraftUserTree(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('craftUserTree: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'craftUserTree: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'craftUserTree OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('craftUserTree: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'craftUserTree: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function useDailyBonus(count:int, callback:Function=null):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USE_DAILY_BONUS);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'useDailyBonus', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.count = count;
        variables.hash = MD5.hash(String(g.user.userId)+String(count)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUseDailyBonus);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteUseDailyBonus(e:Event):void { completeUseDailyBonus(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('useDailyBonus error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUseDailyBonus(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('useDailyBonus: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'useDailyBonus: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'useDailyBonus OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('useDailyBonus: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'useDailyBonus: id: ' + d.id + '  with message: ' + d.message);
        }
    }


    public function buyAndAddToInventory(id:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_BUY_AND_ADD_TO_INVENTORY);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'buyAndAddToInventory', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.buildingId = id;
        variables.posX = 0;
        variables.posY = 0;
        variables.hash = MD5.hash(String(g.user.userId)+String(id)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteBuyAndAddToInventory);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteBuyAndAddToInventory(e:Event):void { completeBuyAndAddToInventory(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('buyAndAddToInventory error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeBuyAndAddToInventory(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('buyAndAddToInventory: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'buyAndAddToInventory: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'buyAndAddToInventory OK', 5);
            if (callback != null) {
                callback.apply(null, [int(d.message)]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('buyAndAddToInventory: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'buyAndAddToInventory: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function ME_addOutGameTile(posX:int, posY:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ME_ADD_OUT_GAME_TILE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'ME_addOutGameTile', 1);
        variables.channelId = g.socialNetworkID;
        variables.userId = g.user.userId;
        variables.posX = posX;
        variables.posY = posY;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteME_addOutGameTile);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteME_addOutGameTile(e:Event):void { completeME_addOutGameTile(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('ME_addOutGameTile error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeME_addOutGameTile(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('ME_addOutGameTile: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'ME_addOutGameTile: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply();
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'ME_addOutGameTile OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('ME_addOutGameTile: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'ME_addOutGameTile: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply();
            }
        }
    }

    public function ME_deleteOutGameTile(posX:int, posY:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ME_DELETE_OUT_GAME_TILE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'ME_deleteOutGameTile', 1);
        variables = addDefault(variables);
        variables.channelId = g.socialNetworkID;
        variables.posX = posX;
        variables.posY = posY;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteME_deleteOutGameTile);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteME_deleteOutGameTile(e:Event):void { completeME_deleteOutGameTile(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('ME_deleteOutGameTile error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeME_deleteOutGameTile(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('ME_deleteOutGameTile: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'ME_deleteOutGameTile: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply();
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'ME_deleteOutGameTile OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('ME_deleteOutGameTile: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'ME_deleteOutGameTile: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply();
            }
        }
    }

    public function getDataOutGameTiles(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_DATA_OUT_GAME_TILES);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getDataOutGameTile', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetDataOutGameTile);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteGetDataOutGameTile(e:Event):void { completeGetDataOutGameTile(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getDataOutGameTile error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetDataOutGameTile(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getDataOutGameTile: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataOutGameTile: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply();
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getDataOutGameTile OK', 5);
            for (var i:int = 0; i < d.message.length; i++) {
                g.townArea.addDeactivatedArea(int(d.message[i].pos_x), int(d.message[i].pos_y), true);
            }
            if (callback != null) {
                callback.apply();
            }
        } else {
            Cc.error('getDataOutGameTile: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getDataOutGameTile: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply();
            }
        }
    }

    public function updateUserMarketCell(cell:int,callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_MARKET_CELL);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserMarketCell', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.marketCell = g.user.marketCell + cell;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.marketCell)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserMarketCell);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteUpdateUserMarketCell(e:Event):void { completeUpdateUserMarketCell(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserMarketCell error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserMarketCell(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserMarketCell: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserMarketCell: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserMarketCell OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserMarketCell: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserMarketCell: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateMarketPapper(numberCell:int,  inPapper:Boolean, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_MARKET_PAPPER);
        var variables:URLVariables = new URLVariables();
        Cc.ch('server', 'updateMarketPapper', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.numberCell = numberCell;
        variables.inPapper = inPapper ? 1 : 0;
        variables.hash = MD5.hash(String(g.user.userId)+String(numberCell)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateMarketPapper);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteUpdateMarketPapper(e:Event):void { completeupdateMarketPapper(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateMarketPapper error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeupdateMarketPapper(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateMarketPapper: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateMarketPapper: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateMarketPapper OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateMarketPapper: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateMarketPapper: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function skipUserInPaper(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_SKIP_USER_IN_PAPER);
        var variables:URLVariables = new URLVariables();
        Cc.ch('server', 'skipUserInPaper', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.inPapper = 0;
        variables.hash = MD5.hash(String(g.user.userId)+'0'+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteSkipUserInPaper);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteSkipUserInPaper(e:Event):void { completeSkipUserInPaper(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('skipUserInPaper error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeSkipUserInPaper(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('skipUserInPaper: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipUserInPaper: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'skipUserInPaper OK', 5);
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('skipUserInPaper: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'skipUserInPaper: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function useChest(count:int, callback:Function=null):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USE_CHEST);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'useChest', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.count = count;
        variables.hash = MD5.hash(String(g.user.userId)+String(count)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUseChest);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteUseChest(e:Event):void { completeUseChest(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('useChest error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUseChest(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('useChest: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'useChest: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'useChest OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('useChest: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'useChest: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserCutScenesData():void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_CUT_SCENE_DATA);
        var variables:URLVariables = new URLVariables();
        Cc.ch('server', 'updateUserCutScenesData', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        
        variables.cutScene = g.user.cutScenes.join('&');
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.cutScene)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserCutScenesData);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteUpdateUserCutScenesData(e:Event):void { completeUpdateUserCutScenesData(e.target.data); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserCutScenesData error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserCutScenesData(response:String):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserCutScenesData: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateMarketPapper: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserCutScenesData OK', 5);
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserCutScenesData: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserCutScenesData: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserOrder(id:int,place:int,callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_ORDER_ITEM);
        var variables:URLVariables = new URLVariables();
        Cc.ch('server', 'updateUserOrder', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.id = id;
        variables.place = place;
        variables.hash = MD5.hash(String(g.user.userId)+String(id)+String(place)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserOrder);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteUpdateUserOrder(e:Event):void { completeUpdateUserOrder(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserOrder error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserOrder(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserOrder: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserOrder: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserOrder OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('updateUserOrder: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserOrder: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function addUserPapperBuy(buyerId:int,resourceId:int,resourceCount:int,xp:int,cost:int,visible:int):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_PAPPER_BUY);
        var variables:URLVariables = new URLVariables();
        Cc.ch('server', 'addUserPapperBuy', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.buyerId = buyerId;
        variables.resourceId = resourceId;
        variables.resourceCount = resourceCount;
        variables.xp = xp;
        variables.cost = cost;
        variables.visible = visible;
        variables.hash = MD5.hash(String(g.user.userId)+String(buyerId)+String(resourceId)+String(resourceCount)+String(xp)+String(cost)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserPapperBuy);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteAddUserPapperBuy(e:Event):void { completeAddUserPapperBuy(e.target.data); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserPapperBuy error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAddUserPapperBuy(response:String):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserPapperBuy: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserPapperBuy: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addUserPapperBuy OK', 5);
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('addUserPapperBuy: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserPapperBuy: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserPapperBuy(buyerId:int,resourceId:int,resourceCount:int,xp:int,cost:int,visible:int, type:int):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_PAPPER_BUY);
        var variables:URLVariables = new URLVariables();
        Cc.ch('server', 'updateUserPapperBuy', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.buyerId = buyerId;
        variables.resourceId = resourceId;
        variables.resourceCount = resourceCount;
        variables.xp = xp;
        variables.cost = cost;
        variables.visible = visible;
        variables.typeResource = type;
        variables.hash = MD5.hash(String(g.user.userId)+String(buyerId)+String(resourceId)+String(resourceCount)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserPapperBuy);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteUpdateUserPapperBuy(e:Event):void { completeUpdateUserPapperBuy(e.target.data); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserPapperBuy error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserPapperBuy(response:String):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserPapperBuy: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserPapperBuy: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserPapperBuy OK', 5);
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserPapperBuy: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserPapperBuy: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getUserPapperBuy(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_PAPPER_BUY);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserPapperBuy', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserPapperBuy);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteGetUserPapperBuy(e:Event):void { completeGetUserPapperBuy(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserPapperBuy error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserPapperBuy(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getUserPapperBuy: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserPapperBuy: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserPapperBuy OK', 5);
            g.managerPaper.fillBot(d.message);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('getUserPapperBuy: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserPapperBuy: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserNotification(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_NOTIFICATION);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserNotification', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.notificationNew = g.user.allNotification;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.notificationNew)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserNotification);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteUpdateUserNotification(e:Event):void { completeUpdateUserNotification(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserNotification error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserNotification(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserNotification: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserNotification: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply(null, [false]);
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserNotification OK', 5);
            if (callback != null) {
                callback.apply(null, [true]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserNotification: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserNotification: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function updateWallTrainItem(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_WALL_TRAIN_ITEM);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateWallTrainItem', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateWallTrainItem);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteUpdateWallTrainItem(e:Event):void { completeUpdateWallTrainItem(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateWallTrainItem error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateWallTrainItem(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateWallTrainItem: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateWallTrainItem: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateWallTrainItem OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateWallTrainItem: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateWallTrainItem: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateWallOrderItem(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_WALL_ORDER_ITEM);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateWallOrderTime', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateWallOrderItem);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteUpdateWallOrderItem(e:Event):void { completeUpdateWallOrderItem(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateWallOrderTime error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateWallOrderItem(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateWallOrderTime: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateWallOrderTime: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateWallOrderTime OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateWallOrderTime: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateWallOrderTime: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserCraftCountTree (treeDbId:String,countCraft:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_CRAFT_COUNT_TREE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserCraftCountTree', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.id = treeDbId;
        variables.craftedCount = countCraft;
        variables.hash = MD5.hash(String(g.user.userId)+String(treeDbId)+String(countCraft)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserCraftCountTree);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteUpdateUserCraftCountTree(e:Event):void { completeUpdateUserCraftCountTree(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserCraftCountTree error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserCraftCountTree(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserCraftCountTree: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserCraftCountTree: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserCraftCountTree OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserCraftCountTree: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserCraftCountTree: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserMusic(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_MUSIC);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserMusic', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.music = int(g.soundManager.isPlayingMusic);
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.music)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserMusic);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteUpdateUserMusic(e:Event):void { completeUpdateUserMusic(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserMusic error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserMusic(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserMusic: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserMusic: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserMusic OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserMusic: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserMusic: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function updateUserSound(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_UPDATE_USER_SOUND);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'updateUserSound', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.sound = int(g.soundManager.isPlayingSound);
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.sound)+SECRET);
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteUpdateUserSound);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteUpdateUserSound(e:Event):void { completeUpdateUserSound(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('updateUserSound error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeUpdateUserSound(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('updateUserSound: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserSound: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'updateUserSound OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('updateUserSound: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'updateUserSound: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function addUserCave(resourceId:int, count:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_ADD_USER_CAVE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'addUserCave', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.resourceId = resourceId;
        variables.count = count;
        variables.hash = MD5.hash(String(g.user.userId)+String(resourceId)+String(count)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteAddUserCave);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteAddUserCave(e:Event):void { completeAddUserCave(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('addUserCave error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeAddUserCave(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('addUserCave: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserCave: wrong JSON:' + String(response));
            if (callback != null) {
                callback.apply();
            }
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'addUserCave OK', 5);
            if (callback != null) {
                callback.apply(null, [d.message]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, d.status);
        } else {
            Cc.error('addUserCave: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'addUserCave: id: ' + d.id + '  with message: ' + d.message);
            if (callback != null) {
                callback.apply(null, [false]);
            }
        }
    }

    public function getUserCave(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_USER_CAVE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getUserCave', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        iconMouse.startConnect();
        loader.addEventListener(Event.COMPLETE, onCompleteGetUserCave);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteGetUserCave(e:Event):void { completeGetUserCave(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getUserCave error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetUserCave(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        var ar:Array;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getUserCave: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getUserCave: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getUserCave OK', 5);
            if (callback != null) {
                callback.apply(null,[d.message]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else {
            Cc.error('userInfo: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'userInfo: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function craftUserCave(resourceId:String, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_CRAFT_USER_CAVE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'craftUserCave', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.resourceId = resourceId;
        variables.hash = MD5.hash(String(g.user.userId)+String(resourceId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteCraftUserCave);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteCraftUserCave(e:Event):void { completeCraftUserCave(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('craftUserCave error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeCraftUserCave(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('craftUserCave: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'craftUserCave: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'craftUserCave OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('craftUserCave: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'craftUserCave: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function getAwayUserTreeWatering(id:int,userSocialId:int,callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_GET_AWAY_USER_TREE_WATERING);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'getAwayUserTreeWatering', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.userSocialId = userSocialId;
        variables.id = id;
        variables.hash = MD5.hash(String(g.user.userId)+String(userSocialId)+String(id)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteGetAwayUserTreeWatering);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteGetAwayUserTreeWatering(e:Event):void { completeGetAwayUserTreeWatering(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('getAwayUserTreeWatering error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeGetAwayUserTreeWatering(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('getAwayUserTreeWatering: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getAwayUserTreeWatering: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'getAwayUserTreeWatering OK', 5);
            if (callback != null) {
                callback.apply(null,[d.message.state]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('getAwayUserTreeWatering: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'getAwayUserTreeWatering: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function releaseUserQuest(questId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_RELEASE_USER_QUEST);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'releaseUserQuest', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.questId = questId;
        variables.hash = MD5.hash(String(g.user.userId)+String(questId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteReleaseUserQuest);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteReleaseUserQuest(e:Event):void { completeReleaseUserQuest(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('releaseUserQuest error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeReleaseUserQuest(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('releaseUserQuest: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'releaseUserQuest: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'releaseUserQuest OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('releaseUserQuest: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function releaseUserQuestAward(questId:int, callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_RELEASE_USER_QUEST_AWARD);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'releaseUserQuestAward', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.questId = questId;
        variables.hash = MD5.hash(String(g.user.userId)+String(questId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteReleaseUserQuestAward);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteReleaseUserQuestAward(e:Event):void { completeReleaseUserQuestAward(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('releaseUserQuest error:' + error.errorID);
        }
    }

    private function completeReleaseUserQuestAward(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('releaseUserQuestAward: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'releaseUserQuest: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'releaseUserQuestAward OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('releaseUserQuestAward: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function useHeroMouse(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_USE_HERO_MOUSE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'useHeroMouse', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.count = g.user.countAwayMouse;
        variables.hash = MD5.hash(String(g.user.userId)+String(variables.count)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteUseHeroMouse);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteUseHeroMouse(e:Event):void { completeUseHeroMouse(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('useHeroMouse error:' + error.errorID);
        }
    }

    private function completeUseHeroMouse(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('UseHeroMouse: wrong JSON:' + String(response));
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'UseHeroMouse: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'UseHeroMouse OK', 5);
            if (callback != null) {
                callback.apply();
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('UseHeroMouse: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
        }
    }

    public function testGetUserFabric(callback:Function):void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_TEST_USER_FABRICA_RECIPE);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'testGetUserFabric', 1);
        variables = addDefault(variables);
        variables.userId = g.user.userId;
        variables.hash = MD5.hash(String(g.user.userId)+SECRET);
        request.data = variables;
        iconMouse.startConnect();
        request.method = URLRequestMethod.POST;
        loader.addEventListener(Event.COMPLETE, onCompleteTestGetUserFabric);
        loader.addEventListener(IOErrorEvent.IO_ERROR,internetNotWork);
        function onCompleteTestGetUserFabric(e:Event):void { completeTestGetUserFabric(e.target.data, callback); }
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('testGetUserFabric error:' + error.errorID);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null,  error.status);
        }
    }

    private function completeTestGetUserFabric(response:String, callback:Function = null):void {
        iconMouse.endConnect();
        var d:Object;
        try {
            d = JSON.parse(response);
        } catch (e:Error) {
            Cc.error('testGetUserFabric: wrong JSON:' + String(response));
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, e.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserFabricaRecipe: wrong JSON:' + String(response));
            return;
        }

        if (d.id == 0) {
            Cc.ch('server', 'testGetUserFabric OK', 5);

            if (callback != null) {
                callback.apply(null,[d.message]);
            }
        } else if (d.id == 13) {
            g.windowsManager.openWindow(WindowsManager.WO_ANOTHER_GAME_ERROR);
        } else if (d.id == 6) {
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_CRACK, null, d.status);
        } else {
            Cc.error('testGetUserFabric: id: ' + d.id + '  with message: ' + d.message + ' '+ d.status);
            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, d.status);
//            g.windowsManager.openWindow(WindowsManager.WO_SERVER_ERROR, null, 'GetUserFabricaRecipe: id: ' + d.id + '  with message: ' + d.message);
        }
    }

    public function setUserLevelToVK():void {
        var loader:URLLoader = new URLLoader();
        var request:URLRequest = new URLRequest(g.dataPath.getMainPath() + g.dataPath.getVersion() + Consts.INQ_SET_USER_LEVEL_VK);
        var variables:URLVariables = new URLVariables();

        Cc.ch('server', 'setUserLevelToVK', 1);
        variables.level = g.user.level;
        variables.id = g.user.userSocialId;
        variables.channelId = g.socialNetworkID;
        request.data = variables;
        request.method = URLRequestMethod.POST;
        try {
            loader.load(request);
        } catch (error:Error) {
            Cc.error('setUserLevelToVK:' + error.errorID);
        }
    }

    private function onIOError(e:IOErrorEvent):void {
        Cc.error('IOError on Auth User:: ' + e.text);
    }

    private function wrongDataFromServer(st:String):void {
        new PreloadInfoTab('Ошибка данных.');
        Cc.error('wrong data from server:: ' + st);
    }

    private function internetNotWork(ev:Event):void {
        if (g.windowsManager) g.windowsManager.openWindow(WindowsManager.WO_SERVER_NO_WORK, null);
            else new PreloadInfoTab('Ошибка соединения.');
        Cc.error('no inet');
    }
}
}
