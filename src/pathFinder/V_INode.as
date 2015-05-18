package pathFinder {
	public interface V_INode{
				
		function setAllDistance(val:Number):void
		function getAllDistance():Number
		function setRating(val:Number):void
		function getRating():Number
		function getName():String
		function traceNode():void;
		function ratingToChild(num:int):Number
	}	
}