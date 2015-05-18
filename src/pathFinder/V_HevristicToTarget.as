package pathFinder {

	public class V_HevristicToTarget implements V_IHevristic{
		public static var div:Number=1;
		public function V_HevristicToTarget(){
			
		}

		public function rating(fromNode:V_INode,toNode:V_INode,currNode:V_INode):Number{	
			var node1:V_GridNode=currNode as V_GridNode;
			var target:V_GridNode=toNode as V_GridNode;		
					
			var val1:Number=node1.i-target.i;
			var val2:Number=node1.j-target.j;
			
			var dist:Number=Math.sqrt(val1*val1+val2*val2);//val1*val1+val2*val2//0 
				
			return dist*2;
		}
	}
}