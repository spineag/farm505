package manager {

public class AStarNode {
    public var x;
    public var y;
    public var g;
    public var h;
    public var parentNode:AStarNode;

    //Constructor
    public function AStarNode(xPos, yPos, gVal, hVal, link) {
        x = xPos;
        y = yPos;
        g = gVal;
        h = hVal;
        parentNode = link;
    }

}
}