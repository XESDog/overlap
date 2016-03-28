/**
 * Created by work on 16/3/28.
 */
package {
import flash.geom.Point;

/**
 *
 * @param ax
 * @param ay
 * @param aRadius
 * @param bx
 * @param by
 * @param bRadius
 */
public function circleAndCircleDistance(ax:int, ay:int, aRadius:int, bx:int, by:int, bRadius:int):int {
    return Point.distance(new Point(ax, ay), new Point(bx, by)) - aRadius - bRadius;
}
}
