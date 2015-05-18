package com.astar{
	
	public class GraphNode{
		
		public var x:int = 0;
		public var y:int = 0;
		
		//public var g:Number = 0;
		//public var f:Number = 0;
		//public var h:Number = 0;

		//public var parent:GraphNode = null;
		public var isWall:Boolean = false;
        public var isUsed:Boolean = false;
		
		public function GraphNode(x:int,y:int){
			this.x = x;
			this.y = y;
		}

		public function toString():String{
			return '['+x+','+y+']';
		}
		
	}
}