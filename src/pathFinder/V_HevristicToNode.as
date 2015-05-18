package pathFinder {

	public class V_HevristicToNode implements V_IHevristic{
		public function V_HevristicToNode(){
			
		}

		public function rating(fromNode:V_INode,toNode:V_INode,currNode:V_INode):Number{
			var node1:V_GridNode=fromNode as V_GridNode;
			var curr:V_GridNode=currNode as V_GridNode;
								
			var val1:Number=node1.i-curr.i;
			var val2:Number=node1.j-curr.j;
			
			var dist:Number=Math.sqrt(val1*val1+val2*val2);
				
			return dist;
		}
		
	}
}