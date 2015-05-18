package pathFinder
{
import flash.display.Graphics;

//import spark.events.IndexChangeEvent;

	public class V_CorrectPath	{
		private var correctArray:Array;
		private var points:Array;
		private var curr_graf:V_GrafGrid;
		public static var prohod:int=1;
		public const CELL_W:Number = 20;
		public const CELL_H:Number = 20;
		private var finder:V_Finder;
		private var hev:V_HevristicToTarget;
		private var tmp:Array;
		public function V_CorrectPath(){
			correctArray=[];
			points=[];
			finder=new V_Finder();
			hev=new V_HevristicToTarget();	
			tmp=[];
		}
		
		
		
		public function correctPath(_path:Array,graf:V_GrafGrid):Array{
			if (_path.length<2) return null;
			var path:Array=_path.concat();
			curr_graf=graf;
			//while(count>0){
				correctArray.length=0;
				points.length=0;
				path[path.length-1].color=0xFFFF00;
				correctArray.push(path[path.length-1]);
				points.push(path[path.length-1]);	
				var l:int=0;
				var r:int=path.length-1;
				var flag:Boolean=true;
				var l1:int=l;
				var r1:int=r;
				
				while(flag){
					var check_to:V_GridNode=path[l1];
					var check_from:V_GridNode=path[r1];
						
					if (graf.tracePath(check_from,check_to,1)){
						correctArray.push(check_to);
						check_to.color=0xFFFF00;
						points.push(check_to);
						r1=l1;
						l1=l;
					}else{
						var p:int=Math.round((r1-l1)/2);
						if (p==0)
							p=1;
							
							l1+=p;
					}
					 
					if (l1>=r1){
						r1-=1;
						l1=l;
						//.color=0xFFFF00	
						//correctArray.push(check_to)	
						//points.push(check_to)	
					}
					
					if (r1<=0)
						flag=false;
				}	
				//count-=1;	
				//path=correctArray.concat()
				//correctArray.length=0	
			//}
			if (prohod==1){
				correctNewPath();
				correctNewPath();
			}
					
			return correctArray;
		}
		
		private  function getDiagonalNode(i:int,j:int,prev:V_GridNode,curr_node:V_GridNode):V_GridNode{
			var checkNode:V_GridNode=curr_graf.getNode(prev.i, prev.j, i,j) as V_GridNode;
			
			if (curr_graf.tracePath(prev,checkNode,0.5) && curr_graf.tracePath(checkNode,curr_node,0.5)){
				return checkNode;
			}
			
			return null;
		}
		
		public function checkWaveNodes(i:int,j:int,prev:V_GridNode,next:V_GridNode):V_GridNode{
			var node:V_GridNode=curr_graf.getNode(prev.i, prev.j, i,j) as V_GridNode;
			if (!curr_graf.tracePath(prev,node,0.3)){
				node=null;
			}	
			return node;
		}
		
		private function findFreeObj(i:int,j:int,di:int,dj:int):V_GridNode{
			var diri:int=di/Math.abs(di);
			var dirj:int=dj/Math.abs(dj);	
			var node:V_GridNode;
				
			if (Math.abs(di)>Math.abs(dj)){
				node=curr_graf.getNode(i,j,i+1*diri,j) as V_GridNode;
				if (node)
					return node;
				
				node=curr_graf.getNode(i,j,i,j+1*dirj) as V_GridNode;
				if (node)
					return node;
				
				node=curr_graf.getNode(i,j,i-1*diri,j) as V_GridNode;
				if (node)
					return node;
				
				node=curr_graf.getNode(i,j,i,j-1*dirj) as V_GridNode;
				if (node)
					return node;
				
				node=curr_graf.getNode(i,j,i-1*diri,j-1*dirj) as V_GridNode;
				if (node)
					return node;
					
			}else{
				node=curr_graf.getNode(i,j,i,j+1*dirj) as V_GridNode;
				if (node)
					return node;
					
				node=curr_graf.getNode(i,j,i+1*diri,j) as V_GridNode;
				if (node)
					return node;
					
					
				node=curr_graf.getNode(i,j,i,j-1*dirj) as V_GridNode;
				if (node)
					return node;
				
				node=curr_graf.getNode(i,j,i-1*diri,j) as V_GridNode;
				if (node)
					return node;
				
				node=curr_graf.getNode(i,j,i-1*diri,j-1*dirj) as V_GridNode;
				if (node)
					return node;	
				
			}		
				
			return null;
		}
		
		
		
		private function correctNewPath():void{
			var pos:int=1;
			var iters:int=0;
			/*var prev:V_GridNode
			var curr_node:V_GridNode
			var next_node:V_GridNode
			var del_node:V_GridNode
			var di:int=0
			var dj:int=0*/
				
			while(pos<correctArray.length){
				iters+=1;
				
				var prev:V_GridNode=correctArray[pos-1];
				var curr_node:V_GridNode=correctArray[pos];
				var di:int=curr_node.i-prev.i;
				var dj:int=curr_node.j-prev.j;
					
				if (pos<correctArray.length-1){
					var next_node:V_GridNode=correctArray[pos+1];
					if (curr_graf.tracePath(prev,next_node,1)){
						correctArray.splice(pos,1);
					}else{
						
						pos+=1;
					}
				}else{					
					pos+=1;
				}
			 
			}	
				
				
			pos=1;
				
			while(pos<correctArray.length){
				iters+=1;
				if (iters>100)
					break;
				if (pos<1)
					pos=1;
				prev=correctArray[pos-1];
				curr_node=correctArray[pos];
				di=curr_node.i-prev.i;
				dj=curr_node.j-prev.j;
				
				if (di==0 || dj==0){
					if (curr_graf.tracePath(prev,curr_node,0.9)){
						pos+=1;
						continue;
					}
				}	
								
				if (Math.abs(di)!=Math.abs(dj) /*&& di!=0 && dj!=0*/){
					
					var d_delta:int=Math.abs(di)-Math.abs(dj);
					var ni:int=0;
					var nj:int=0;
					var diri:int=0;
					var dirj:int=0;
					var checkNode:V_GridNode;
					diri=di/Math.abs(di);
					dirj=dj/Math.abs(dj);
									
					if (d_delta<0){//dj>di	
						ni=prev.i+diri*Math.abs(di);
						nj=prev.j+dirj*Math.abs(di);;
						checkNode=getDiagonalNode(ni,nj,prev,curr_node);
						if (checkNode){
							correctArray.splice(pos,0,checkNode);
							checkNode.color=0xFFF00FF;	
						}else{
							ni=prev.i;
							nj=prev.j+dirj*Math.abs(d_delta);	
							checkNode=getDiagonalNode(ni,nj,prev,curr_node);
							if (checkNode){
								correctArray.splice(pos,0,checkNode);
								checkNode.color=0xFFF00FF;		
							}else{
								ni=prev.i+diri*1;
								nj=prev.j+dirj*1;
								checkNode=curr_graf.getNode(prev.i,prev.j,ni,nj) as V_GridNode;
									
								if (curr_graf.tracePath(curr_node,checkNode,1)){
									correctArray.splice(pos,0,checkNode);
									checkNode.color=0xFFF0000;
									pos+=1;
									continue;	
								}	
								
								ni=prev.i;
								nj=prev.j+dirj*1;
								checkNode=curr_graf.getNode(prev.i,prev.j,ni,nj) as V_GridNode;
									
								if (curr_graf.tracePath(curr_node,checkNode,1)){
									correctArray.splice(pos,0,checkNode);
									checkNode.color=0xFFF0000;
									pos+=1;
									continue;	
								}	
								
								
								ni=prev.i+diri*1;
								nj=prev.j;
								checkNode=curr_graf.getNode(prev.i,prev.j,ni,nj) as V_GridNode;
								
								if (curr_graf.tracePath(curr_node,checkNode,1)){
									correctArray.splice(pos,0,checkNode);
									checkNode.color=0xFFF0000;
									pos+=1;
									continue;	
								}	
															
								finder.refresh();
								finder.addHevristic(hev);
								finder.setGraf(curr_graf);
								if (finder.find(prev,curr_node)){
									var ref:Array=finder.getPath();
									for (var i:int=ref.length-2;i>0;i--){
										checkNode=ref[i];
										checkNode.color=0x00FFFF;
										correctArray.splice(pos,0,checkNode);
										pos+=1;
									}
								}
									
							}
								
						} 							
					}else{//di>dj
						ni=prev.i+diri*Math.abs(dj);
						nj=prev.j+dirj*Math.abs(dj);;
						checkNode=getDiagonalNode(ni,nj,prev,curr_node);
						if (checkNode){
							checkNode.color=0xFFF00FF;
							correctArray.splice(pos,0,checkNode);
						}else{ 
							nj=prev.j;
							ni=prev.i+diri*Math.abs(d_delta);
							checkNode=getDiagonalNode(ni,nj,prev,curr_node);
							if (checkNode){
								checkNode.color=0xFFF00FF;
								correctArray.splice(pos,0,checkNode);
							}else{
								ni=prev.i+diri*1;
								nj=prev.j+dirj*1;
								checkNode=curr_graf.getNode(prev.i,prev.j,ni,nj) as V_GridNode;
								if (curr_graf.tracePath(curr_node,checkNode,1)){
									correctArray.splice(pos,0,checkNode);
									checkNode.color=0xFFF0000;
									pos+=1;
									continue;
								}	
								
								nj=prev.j;
								ni=prev.i+diri*1;
								checkNode=curr_graf.getNode(prev.i,prev.j,ni,nj) as V_GridNode;
								
								if (curr_graf.tracePath(curr_node,checkNode,1)){
									correctArray.splice(pos,0,checkNode);
									checkNode.color=0xFFF0000;
									pos+=1;
									continue;
								}
								
								nj=prev.j+dirj*1;
								ni=prev.i;
								checkNode=curr_graf.getNode(prev.i,prev.j,ni,nj) as V_GridNode;
								
								if (curr_graf.tracePath(curr_node,checkNode,1)){
									correctArray.splice(pos,0,checkNode);
									checkNode.color=0xFFF0000;
									pos+=1;
									continue;
								}	
																
								finder.refresh();
								finder.addHevristic(hev);
								finder.setGraf(curr_graf);
								if (finder.find(prev,curr_node)){
									ref=finder.getPath();
										
									for (i=ref.length-2;i>0;i--){
										checkNode=ref[i];
										checkNode.color=0x00FFFF;
										correctArray.splice(pos,0,checkNode);
										pos+=1;
									}
								}
								
							}
						}
					}
				} 
					
				pos+=1;
			}
			
			//trace("correct iterations ",iters)
		}
		
		private function drawCircle(canvas:Graphics,nx:Number,ny:Number,r:Number,col:uint):void{
			canvas.lineStyle(0);
			canvas.beginFill(col);
			canvas.drawCircle(nx,ny,r);
			canvas.endFill();
		}
		
		public function drawCorrectPath(canvas:Graphics):void{
			if (correctArray.length<2) return;
				
			
			var node1:V_GridNode=correctArray.pop();
			var px:Number=node1.j * CELL_W + CELL_W/2;
			var py:Number=node1.i * CELL_H + CELL_H/2;
			var cx:Number=0;
			var cy:Number=0;
			var color:uint=node1.color;
			while(correctArray.length > 0) {
				canvas.lineStyle(5,0);
				var node2:V_GridNode=correctArray.pop();
				cx=node2.j * CELL_W + CELL_W / 2;
				cy=node2.i * CELL_H + CELL_H / 2;
				canvas.beginFill(0xFF00FF);
				canvas.moveTo(px,py);
				canvas.lineTo(cx,cy);
				canvas.endFill();
				drawCircle(canvas,px,py,5,color);
				px=cx;
				py=cy;
				color=node2.color;
			}	
			
			drawCircle(canvas,px,py,5,color);
			
		}
	}
}