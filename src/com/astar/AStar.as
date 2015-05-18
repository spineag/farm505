package com.astar {

import manager.Vars;

public class AStar{

        public static var instances:Vector.<AStar> = new Vector.<AStar>(50);

        private var openList:Vector.<GraphNode>;
        private var closedList:Vector.<GraphNode>;
        private var objects:Vector.<Object>;
        private var graph:Graph;
        private var start:GraphNode;
        private var end:GraphNode;
        private var showGrid:Boolean = false;  // включає відображення сітки

        protected var g:Vars = Vars.getInstance();

        public function AStar(pvt:PrivateClass) {
            openList = new Vector.<GraphNode>();
            closedList = new Vector.<GraphNode>();
            objects = new Vector.<Object>();
        }

        public static function getInstance(map_id:int):AStar {
           if (instances[map_id] == null) {
                AStar.instances[map_id] = new AStar(new PrivateClass());
           }
           return AStar.instances[map_id];
        }

        public function settings(graph:Graph, start:GraphNode, end:GraphNode):void {
            this.graph = graph;
            this.start = start;
            this.end = end;
        }

//		public function search():void {
//            var color:uint;
//            var obj:Object;
//            var source:WorldObject;
//
//			openList.length = 0;
//			closedList.length = 0;
//
//            if (showGrid) {
//                g.area.clearGrid();
//            }
//
//			openList[openList.length] = start;
//
//			while(openList.length > 0) {
//
//				var currentNode:GraphNode = openList[0];
//
//				openList.splice(0,1);
//				closedList[closedList.length] = currentNode;
//                currentNode.isWall = true;
//
//                obj = g.area.getElementMatrix(currentNode.x, currentNode.y);
//
//                if (!obj.isNorm) {
//                    continue;
//                }
//
//                if (obj && obj.findId != 0){
//                    source = obj.sources[0];
//                    if (source) {
//                        (source as AreaObject).tint = false;
//                    }
//                }
//
//				var neighbors:Vector.<GraphNode> = graph.getNeighbors(currentNode);
//				for( var i:int = 0; i < neighbors.length; i++) {
//                    color = 0xffff00;
//
//					var neighbor:GraphNode = neighbors[i];
//
//                    if (neighbor == null) {
//                        continue;
//                    }
//                    neighbor.isUsed = true;
//                    obj = g.area.getElementMatrix(neighbor.x, neighbor.y);
//
//                    if (obj && obj.sources.length > 0){
//                        for (var j:int = 0; j < obj.sources.length; j++) {
//                            source = obj.sources[j];
//                            if ( source is BuildingWild ) {
//                                closedList[closedList.length] = neighbor;
//                                neighbor.isWall = true;
//                                color = 0xff0000;
//                                (source as AreaObject).unlockFromAstar();
//                            } else if (source is BuildingBridge || source is BuildingTemple || source is BuildingSpec || source is BuildingInformer){
//                                (source as AreaObject).unlockFromAstar();
//                            }
//                        }
//                    }
//
//					if(openList.indexOf(neighbor) == -1 && closedList.indexOf(neighbor) == -1) {
//						openList.push(neighbor);
//					}
//
//                    if (showGrid) {
//                        g.area.drawGrid(neighbor.x, neighbor.y, 1, 1, color);
//                    }
//				}
//			}
//		}
//
//        public function research():void {
//            var color:uint;
//            var obj:Object;
//            var source:WorldObject;
//
//            while(openList.length > 0) {
//
//                var currentNode:GraphNode = openList[0];
//
//                openList.splice( openList.indexOf(currentNode) ,1);
//                closedList[closedList.length] = currentNode;
//                currentNode.isWall = true;
//
//                obj = g.area.getElementMatrix(currentNode.x, currentNode.y);
//
//                if (!obj.isNorm) {
//                    continue;
//                }
//
//                if (obj && obj.findId !=0){
//                    source = obj.sources[0];
//                    source && (source as AreaObject).unlockFromAstar();
//                }
//
//                var neighbors:Vector.<GraphNode> = graph.getNeighbors(currentNode);
//                for( var i:int = 0; i < neighbors.length; i++) {
//                    color = 0xffffff;
//
//                    var neighbor:GraphNode = neighbors[i];
//
//                    if (neighbor == null) {
//                        continue;
//                    }
//                    neighbor.isUsed = true;
//                    obj = g.area.getElementMatrix(neighbor.x, neighbor.y);
//
//                    if (obj && obj.sources.length > 0){
//                        for (var j:int = 0; j < obj.sources.length; j++) {
//                            source = obj.sources[j];
//                            if ( source is BuildingWild ) {
//                                neighbor.isWall = true;
//                                color = 0xff0000;
//                                closedList[closedList.length] = neighbor;
//                                (source as AreaObject).unlockFromAstar();
//                            } else if (source is BuildingBridge || source is BuildingTemple || source is BuildingSpec || source is BuildingInformer){
//                                (source as AreaObject).unlockFromAstar();
//                            }
//                        }
//                    }
//
//                    if(openList.indexOf(neighbor) == -1 && closedList.indexOf(neighbor) == -1) {
//                        openList.push(neighbor);
//                    }
//
//                    if (showGrid) {
//                        g.area.drawGrid(neighbor.x, neighbor.y, 1, 1, color);
//                    }
//                }
//            }
//        }

//        public function updatePlant(x:int, y:int, width:int, height:int):void {
//            for (var i:int = 0; i < width; i++) {
//                for (var j:int = 0; j < height; j++) {
//                    openList.push(new GraphNode(x + i,y + j));
//                }
//            }
//            research();
//        }

    public function changeShowGrid():void {
        showGrid = !showGrid;
    }

	}
}

class PrivateClass {

}