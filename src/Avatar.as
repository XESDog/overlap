/**
 * Created by work on 16/3/28.
 */
package {

import flash.display.Graphics;
import flash.display.Shape;
import flash.geom.Point;

public class Avatar extends Shape {
    private var _normalColor:int = 0x000000;
    private var _selectColor:int = 0xff0000;
    private var _s:Point;
    private var _e:Point;
    private var _center:Point;
    private var _width:int;
    private var _height:int;
    private var _radius:int;
    /**
     * 1:圆
     * 2:方
     * 3:线
     */
    private var _type:int = 0;
    private var _g:Graphics;

    public function Avatar(type:int = 0, s:Point = null, e:Point = null):void {
        _g = graphics;
        _type = type;
        _s = s;
        _e = e;
        _center = Point.interpolate(_s, _e, 0.5);
        if (type != 0 && s && e)draw(_normalColor);
    }

    public function drawSelect():void {
        draw(_selectColor, 2);
    }

    private function draw(color:uint, thickness:uint = 1):void {
        _g.clear();
        _g.lineStyle(thickness, color);
        _g.beginFill(0, 0.2);

        switch (_type) {
            case 1:
                _radius = Point.distance(_center, _e);
                _g.drawCircle(0, 0, _radius);
                break;
            case 2:
                _width = _e.x - _s.x;
                _height = _e.y - _s.y;
                _g.drawRect(-_width>>1, -_height>>1, _width, _height);
                break;
            case 3:
                var tmp:Point = _e.subtract(_s);
                _g.moveTo(0, 0);
                _g.lineTo(tmp.x, tmp.y);
                break;

        }
        _g.endFill();

    }

    public function set s(value:Point):void {
        _s = value;
    }

    public function set e(value:Point):void {
        _e = value;
    }

    override public function toString():String {
        return "avatar type:" + _type;
    }

    public function get type():int {
        return _type;
    }

    public function get radius():int {
        return _radius;
    }

    public function drawNormal():void {
        draw(_normalColor);
    }
}
}
