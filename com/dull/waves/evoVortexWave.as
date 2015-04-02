package com.dull.waves 
{
	/**
	 * ...
	 * @author longying.zhang
	 */
	
	import com.dull.*;
	import flash.utils.Timer;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.Dictionary;
 
	 
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	import Box2D.Dynamics.Joints.*;
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	
	import Box2D.Dynamics.Joints.*;
	import flash.events.TimerEvent;
	import flash.events.Event; 
	 
	 
	 
	public class evoVortexWave  extends evoWave
	{
		
		public function evoVortexWave(l:evoLevel) {
			
			
			super(l);
			
		}
		
		public override function init(){
			
			
			//生成漩涡路径，极坐标 
			var delta_angle:Number = Math.PI / 6;
			
			var theta = 0;
			var r = 20;
			
			_view.graphics.lineStyle(0,0x666666);   

			_view.graphics.moveTo(400, 400);
			var x:Number, y:Number;
			for (var i:int = 0; i < 80;i++){
				
				x = 400 + r * Math.cos(theta);
				y = 400 + r * Math.sin(theta);
				_view.graphics.lineTo(x, y);
				
				r += 5;				
				theta += delta_angle;
				_path_point_array.push(new b2Vec2(x / _level.pixel_per_meter, y / _level.pixel_per_meter));
				
				
			}
			_path_point_array.reverse();
			
			
			emitterEnemy(0, 0, 50);
			
		}
		
		
		public  override function callBackOfEmitterEveryEnemy(enemy:evoEnemy){
			
			
			enemy.followPath(_path_point_array, _path_raidus);

		}
		
		
	}

}