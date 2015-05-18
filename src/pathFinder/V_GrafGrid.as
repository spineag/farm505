package pathFinder {

public class V_GrafGrid implements V_IGraf {
		public var calbackCondition:Function;
		
		private var nodes:Array;
		private var my_arr:Array;
		
		public function V_GrafGrid(){
			nodes=[];
		}
				
		public function buildGraf(arr:Array):void{
			nodes.length=0;
			my_arr=arr;
			
			for (var i:uint = 0; i < arr.length; ++i) {
				nodes[i] = [];
				for (var j:uint = 0; j < arr[i].length; ++j) {					
					//if (arr[i][j]==0)
					{
						var node:V_GridNode=new V_GridNode();
						node.i=i;
						node.j=j;
						nodes[i][j]=node;
					}
				}
			}
		}
		
		public function tracePath(from:V_GridNode,to:V_GridNode,epsilon:Number):Boolean{
			if (!from || !to) return false;
			
			var di:int=to.i-from.i;
			var dj:int=to.j-from.j;
			//var max:int=(Math.abs(di)>Math.abs(dj)	
			var dist:Number=(Math.abs(di)+Math.abs(dj));//* Math.sqrt(di*di+dj*dj)*/
			var step:Number=(1/dist)*epsilon*0.9;//((Math.abs(di)+Math.abs(dj)))*epsilon;//epsilon	
			var t:Number=0;
			
			if (!nodes[from.i][from.j]) return false;
			var inc:int=0;
			while(t<1){
								
				inc+=1;
				t+=step;
				if (t>1) t=1;
				var ni:Number=Math.round((from.i+di*t));
				var nj:Number=Math.round((from.j+dj*t));
				
				if (!getNode(from.i,from.j,int(ni),int(nj)))
					return false; 
				
			}	
			
			//trace("trace inc ",inc)
				
			return true;
		} 
		
		public function getNumChildrens(node:V_INode):uint{
			
			return 4;
		}
		
		
		
		public function getChildAt(node:V_INode,num:uint):V_INode{
			if (!node)
				return null;
			var curr_n:V_GridNode=node as V_GridNode;
			var dsti:int=0;
			var dstj:int=0;
			switch(num)
			{
				case 0:
					dsti=0;
					dstj=-1;
				break;
				case 1:
					dsti=1;
					dstj=0;
				break;
				case 2:
					dsti=0;
					dstj=1;
				break;
				case 3:
					dsti=-1;
					dstj=0; 
				break;
				/*case 0:
					dsti=-1
					dstj=-1
				break;
				case 1:
					dsti=0
					dstj=-1
				break;
				case 2:
					dsti=1
					dstj=-1
				break;	
				case 3:
					dsti=1
					dstj=0
				break;
				case 4:
					dsti=1
					dstj=1
				break;
				case 5:
					dsti=0
					dstj=1
				break;		
				case 5:
					dsti=0
					dstj=-1
				break;
				case 6:
					dsti=-1
					dstj=0 
				break;*/
			}
			
			var n:V_GridNode=getNode(curr_n.i,curr_n.j,curr_n.i+dsti,curr_n.j+dstj) as V_GridNode;	
			
			return n; 
		}
		
		public function getNode(pi:uint, pj:uint, i:uint, j:uint):V_INode {
			if (i >= nodes.length) {
				return null;
			}
			if (j >= nodes[i].length) {
				return null;
			}
			if (calbackCondition != null) {
				if (calbackCondition.apply(null, [i, j])) {
					return null;
				}
			}
			/*if (my_arr[i][j].findId != 0) {
				return null;
			}*/
			
			return nodes[i][j];
		}
	//----------------------------------------------------	
	}
}