package com.astar {
import flash.geom.Point;

import manager.Vars;

public class Graph {
    private var _width:uint = 0;
    private var _height:uint = 0;

    private var arr:Object = {};

    private var _area:uint = 0;

    private var _graph:Vector.<GraphNode> = null;
    private var _neighbors:Vector.<GraphNode> = new Vector.<GraphNode>();

    private var _maxX:int = 0;
    private var _maxY:int = 0;
    private var _minX:int = 0;
    private var _minY:int = 0;

    protected var g:Vars = Vars.getInstance();

    public function Graph(width:uint, height:uint, startPoint:Point) {
        _width = width;
        _height = height;


        _minX = startPoint.x;
        _maxX = startPoint.x + _width + (_height / 2) - 1;

        _minY = startPoint.y - _width;
        _maxY = startPoint.y + (_height / 2) - 1;

        _area = _width * _height;

        _graph = new Vector.<GraphNode>(_area, true);

        var x:int = startPoint.x - 1;
        var y:int = startPoint.y;
        var _x:int = x;
        var _y:int = y;

        for (var i:int = 0; i < _height; i++) {
            if (i % 2) {
                ++x;
            } else {
                ++y;
            }
            _x = x;
            _y = y;
            for (var j:int = 0; j < _width; j++) {
                _x = _x + 1;
                _y = _y - 1;

                if (arr[_x]) {
                    (arr[_x] as Object)[_y] = new GraphNode(_x, _y);
                } else {
                    arr[_x] = {};
                    (arr[_x] as Object)[_y] = new GraphNode(_x, _y);
                }
            }
        }
    }

    public function get width():uint {
        return _width;
    }

    public function get height():uint {
        return _height;
    }


    public function getNeighbors(currentNode:GraphNode):Vector.<GraphNode> {
        _neighbors.length = 0;

        var x:uint = currentNode.x;
        var y:uint = currentNode.y;

        if (x > _minX) {
            _neighbors[_neighbors.length] = getNode(x - 1, y);
            if (y > _minY)
                _neighbors[_neighbors.length] = getNode(x - 1, y - 1);
            if (y < _maxY)
                _neighbors[_neighbors.length] = getNode(x - 1, y + 1);
        }
        if (x < _maxX) {
            _neighbors[_neighbors.length] = getNode(x + 1, y);
            if (y > _minY)
                _neighbors[_neighbors.length] = getNode(x + 1, y - 1);
            if (y < _maxY)
                _neighbors[_neighbors.length] = getNode(x + 1, y + 1);
        }
        if (y > _minY)
            _neighbors[_neighbors.length] = getNode(x, y - 1);
        _neighbors[_neighbors.length] = getNode(x, y + 1);

        return _neighbors;
    }

    private function getNode(x:int, y:int):GraphNode {
        var node:GraphNode = (arr && arr[x] && arr[x][y]) ? arr[x][y] : null;
        if (node && !node.isUsed) {
            return node;
        } else {
            return null;
        }
    }

}
}