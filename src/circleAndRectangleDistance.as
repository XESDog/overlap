/**
 * Created by work on 16/3/28.
 */
package {
import flash.geom.Point;

/**
 *
 * @param circleX
 * @param circleY
 * @param radius
 * @param recX
 * @param recY
 * @param recW
 * @param recH
 * @return
 */
public function circleAndRectangleDistance(circleX:int, circleY:int, radius:int, recX:int, recY:int, recW:int, recH:int):int {
    var distance:int;
    //以rectangle中心为参考坐标原点,将circle移动到参考坐标的第一象限
    var newCircleX:int = circleX - recX;
    var newCircleY:int = circleY - recY;
    var v:Point;//rectangle中心到circle中心的矢量
    var h:Point;//rectangle中心到第一象限顶点的矢量
    newCircleX = newCircleX < 0 ? -newCircleX : newCircleX;
    newCircleY = newCircleY < 0 ? -newCircleY : newCircleY;
    v = new Point(newCircleX, newCircleY);
    h = new Point(recW >> 1, recH >> 1);

    //v-h,将负的分量设置为0,得到的矢量长度,就是方到圆心的距离
    var d:Point = v.subtract(h);
    d = new Point(d.x < 0 ? 0 : d.x, d.y < 0 ? 0 : d.y);
    distance = Point.distance(d, new Point());
    return distance - radius;
}
}
