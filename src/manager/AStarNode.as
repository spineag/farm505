package manager {

public class AStarNode {
    public var x:int;
    public var y:int;
    public var g:int;
    public var h:int;
    public var parentNode:AStarNode;

    //Constructor
    public function AStarNode(xPos:int, yPos:int, gVal:int, hVal:int, link:AStarNode) {
        x = xPos;
        y = yPos;
        g = gVal;
        h = hVal;
        parentNode = link;
    }

}
}