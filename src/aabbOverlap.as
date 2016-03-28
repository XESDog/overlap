/**
 * Created by work on 16/3/28.
 */
package {
    public function aabbOverlap(ax:int, ay:int, aw:int, ah:int, bx:int, by:int, bw:int, bh:int) {
        var ax2:int=ax+aw;
        var ay2:int=ay+ah;
        var bx2:int=bx+bw;
        var by2:int=by+bh;
        var d1x:int=bx-ax2;
        var d1y:int=by-ay2;
        var d2x:int=ax-bx2;
        var d2y:int=ay-by2;

        if(d1x>0||d1y>0||d2x>0||d2y>0)return false;
        return true;

    }
}
