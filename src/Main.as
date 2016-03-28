package {

import com.bit101.utils.MinimalConfigurator;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

[SWF(width=800, height=600, frameRate=60, backgroundColor="0x999999")]
public class Main extends Sprite {

    /**
     * 1:创建圆
     * 2:创建方
     * 100:check
     */
    private var _stat:int = 0;
    private var _downP:Point = new Point();
    private var _moveP:Point = new Point();
    private var _upP:Point = new Point();
    private var _g:Graphics = graphics;

    private var _canvas:Sprite = new Sprite();
    private var _drag:Avatar;
    private var _dragX:int;
    private var _dragY:int;
    private var _contactList:Array=[];

    private var menuXML:XML = new XML('<comps>' +
            '<HBox>' +
            '<PushButton label="circle"    event="click:onBtnClick"></PushButton>' +
            '<PushButton label="rectangle" event="click:onBtnClick"></PushButton>' +
            '<PushButton label="check"     event="click:onBtnClick"></PushButton>' +
            '</HBox>' +
            '</comps>');


    public function Main() {
        var menuConfig:MinimalConfigurator = new MinimalConfigurator(this);
        menuConfig.parseXML(menuXML);

        stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
        stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseHandler);
        stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);

        addChild(_canvas);
    }

    private function mouseHandler(e:MouseEvent):void {
        switch (e.type) {
            case 'mouseDown':
                _downP = new Point();
                _downP.x = e.localX;
                _downP.y = e.localY;
                if (_stat == 100) {
                    _drag = getAvatarUnderPoint(_downP);
                    if (_drag) {
                        _dragX = _drag.x;
                        _dragY = _drag.y;
                    }
                }
                break;
            case 'mouseMove':
                if (!_downP)break;

                _moveP.x = e.localX;
                _moveP.y = e.localY;
                if (_stat == 100) {
                    //check
                    if (_drag) {
                        _drag.x = _dragX + _moveP.x - _downP.x;
                        _drag.y = _dragY + _moveP.y - _downP.y;

                        var source:Avatar, target:Avatar;

                        if(_contactList.length>0){
                            _contactList.forEach(function (item:Avatar, index, arr) {
                                item.drawNormal();
                            })
                        }
                        _contactList=[];

                        for (var i:int = 0; i < _canvas.numChildren; i++) {
                            for (var j:int = i + 1; j < _canvas.numChildren; j++) {
                                source = _canvas.getChildAt(i) as Avatar;
                                target = _canvas.getChildAt(j) as Avatar;
                                var distance:int;
                                if (source.type != target.type) {
                                    var circle:Avatar = source.type == 1 ? source : target
                                    var rectangle:Avatar = target.type == 2 ? target : source
                                    distance = circleAndRectangleDistance(circle.x, circle.y, circle.radius, rectangle.x, rectangle.y, rectangle.width, rectangle.height);
                                    if (distance < 0) {
                                        if(_contactList.indexOf(circle)==-1){
                                            _contactList.push(circle);
                                        }
                                        if(_contactList.indexOf(rectangle)==-1){
                                            _contactList.push(rectangle);
                                        }
                                    }
                                }
                                if(source.type==1&&target.type==1){
                                    distance = circleAndCircleDistance(source.x, source.y, source.radius, target.x, target.y, target.radius);
                                    if (distance < 0) {
                                        if(_contactList.indexOf(source)==-1){
                                            _contactList.push(source);
                                        }
                                        if(_contactList.indexOf(target)==-1){
                                            _contactList.push(target);
                                        }
                                    }
                                }
                                if(source.type==2&&target.type==2){
                                    distance = aabbOverlap(source.x-(source.width>>1), source.y-(source.height>>1), source.width, source.height, target.x-(target.width>>1), target.y-(target.height>>1), target.width, target.height);
                                    if (distance ==1) {
                                        if(_contactList.indexOf(source)==-1){
                                            _contactList.push(source);
                                        }
                                        if(_contactList.indexOf(target)==-1){
                                            _contactList.push(target);
                                        }
                                    }
                                }
                            }
                        }
                        _contactList.forEach(function(item:Avatar,index,arr){
                            item.drawSelect();
                        });


                    }

                } else if (_stat == 1) {
                    _g.clear();
                    _g.lineStyle(1);

                    var centre:Point = Point.interpolate(_moveP, _downP, 0.5);
                    _g.drawCircle(centre.x, centre.y, Point.distance(_moveP, centre));
                } else if (_stat == 2) {
                    _g.clear();
                    _g.lineStyle(1);
                    _g.drawRect(_downP.x, _downP.y, _moveP.x - _downP.x, _moveP.y - _downP.y);
                }
                break;
            case 'mouseUp':
                _g.clear();
                _upP = new Point();
                _upP.x = e.localX;
                _upP.y = e.localY;

                if (Point.distance(_downP, _upP) < 2){
                    _downP = _upP = null;
                    break;
                }
                if (_stat <= 2) {
                    var avatar:Avatar = new Avatar(_stat, _downP, _upP);
                    var centre:Point = Point.interpolate(_upP, _downP, 0.5);
                    _canvas.addChild(avatar);
                    avatar.x=centre.x;
                    avatar.y=centre.y;

                }
                _downP = _upP = null;
                break;
        }
    }

    

    public function onBtnClick(e:Event):void {

        switch (e.target.label) {
            case 'circle':
                _stat = 1;
                break;
            case 'rectangle':
                _stat = 2;
                break;
            case 'check':
                _stat = 100;
                break;
        }
    }

    private function getAvatarUnderPoint(p:Point):Avatar {
        var objs:Array = _canvas.getObjectsUnderPoint(p);
        objs.reverse();


        return objs.length > 0 ? objs[0] : null;
    }


}
}
