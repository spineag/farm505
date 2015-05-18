package pathFinder {

	public class V_GridNode implements V_INode{
		public var i:uint=0;
		public var j:uint=0;
		public var childrens:Array;
		public var color:uint=0xFF0000;
		private var value:Number=0;
		private static var counter:uint=0;
		private var name:String="";
		private var rating:Number;
		public function V_GridNode(){
			childrens=[];
			counter+=1;
			name=counter.toString();
		}	

		public function getNumChildrens():uint{
			return childrens.length;
		}
		
		public function getChildAt(num:uint):V_INode{
			if (num>=childrens.length) return null;
			return childrens[num];
		}
		
		public function setAllDistance(val:Number):void{
			value=val;
		}
		
		public function getAllDistance():Number{
			return value;
		}
			
		
		public function getName():String{
			return name;
		}
		
		public function traceNode():void{
		
		}
		
		public function setRating(val:Number):void{
			rating=val;
		}
		
		public function getRating():Number{
			return rating;
		}
		
		public function ratingToChild(num:int):Number{
			if (num>=childrens.length) return 0;
//			var node1:V_GridNode=childrens[num];
			
			//var val1:Number=node1.i-i
			//var val2:Number=node1.j-j
			
			//var dist:Number=Math.sqrt(val1*val1+val2*val2)
			//if (val1!=0 && val2!=0)
				//dist*=0.8
			
			return  1;  
		}
	//-----------------------------------------		
	}
}