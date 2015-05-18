package pathFinder {

	public interface V_IGraf{
		function getNumChildrens(node:V_INode):uint;
		function getChildAt(node:V_INode,num:uint):V_INode
	}	 
}