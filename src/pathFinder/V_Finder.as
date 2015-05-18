package pathFinder {
import flash.utils.Dictionary;

public class V_Finder{
		private var hevristics:Array;
		private var graf:V_IGraf;
		private var path:Array;
		private var queue:Array;
		private var complete:Boolean=false;  
		private var iters:int=0;
		private var hash:Dictionary;
		private var ref_call:Function;
		
		public function V_Finder(){
			hevristics = [];
		}
		
		public function addHevristic(hev:V_IHevristic):void{
			hevristics.push(hev);
		}
		
		public function setGraf(ref:V_IGraf):void{
			graf=ref;
		}
		
		public function refresh():void{
			path 		= [];
			hash		= new Dictionary();
			queue 		= [];
			hevristics	= [];
			graf		= null;
			complete	= false;
			iters		= 0;
			
		}
		
		public function setCall(ref:Function):void {
			ref_call=ref;	
		}
		
		public function find(from_node:V_INode,to_node:V_INode):Boolean{
			if (!from_node || !to_node) return false;
			from_node.setAllDistance(0);
			from_node.setRating(0);
			checkNode(from_node,to_node,from_node);
			while(queue.length){
				var curr_node:V_INode=queue.shift().node as V_INode;
				iters+=1;
				if (ref_call as Function)
					ref_call(hash[curr_node],curr_node);
				
				if (curr_node.getName()==to_node.getName()){
					buildPath(from_node,to_node);
					//trace(iters)
					//trace("path length "+path.length.toString())
					break;
				}
				
				checkNode(from_node,to_node,curr_node);
			}
			
			return true;
		}
		
		private function checkNode(from_node:V_INode,to_node:V_INode,curr_node:V_INode):void{
			
			for (var i:uint=0;i<graf.getNumChildrens(curr_node);i++){
				var node:V_INode=graf.getChildAt(curr_node,i);
				if (!node)
					continue;
					
					 
				var all_dist:Number=curr_node.ratingToChild(i)+curr_node.getAllDistance();
								
				var rating:Number=all_dist;
								
						
				var li:int=i;
				for (i=0;i<hevristics.length;i++){
					var h:V_IHevristic=hevristics[i];
					rating+=h.rating(from_node,to_node,node);
				}
				i=li;
									
				if (!hash[node]){ 
					hash[node]=curr_node;
					node.setRating(rating);
					node.setAllDistance(all_dist);
					var obj:Object={};
					obj.node=node;
					obj.rating=rating;
					var ins_flag:Boolean=false;
					/*for (var ii:uint=0;ii<queue.length;ii++){
						var nobj:Object=queue[ii]
						if (nobj.rating>=obj.rating){
							queue.splice(ii,0,obj)
							ins_flag=true;
							break;
						}	
					}	*/
					if (!ins_flag){
						queue.push(obj);
					}
					obj.name=curr_node.getName();
				}else{
					if (node.getAllDistance()>all_dist){
						for (var j:uint=0;j<queue.length;j++){
							if (queue[j].name==node.getName()){
								node.setAllDistance(all_dist);
								node.setRating(rating);
								queue[j].rating=rating;
							}	
						}	 
					}
				}
			}			
			queue.sortOn("rating",Array.NUMERIC);
			//traceQueue()
		}
		
		private function buildPath(fromNode:V_INode,toNode:V_INode):void{
			var currNode:V_INode=toNode;
			path.push(currNode);
			while(currNode.getName()!=fromNode.getName()){
				currNode=hash[currNode];
				path.push(currNode);
			}		
		}
		
		public function getPath():Array{
			return path;
		}
	//--------------------------------------------------------	
	}
}