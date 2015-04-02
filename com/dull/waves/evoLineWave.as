package com.dull.waves 
{
	import com.dull.evoLevel;
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
	 
	/**
	 * ...
	 * @author longying.zhang
	 */
	public class evoLineWave extends evoWave 
	{
		
		public function evoLineWave(level:evoLevel) 
		{
			super(level);
			
		}
		
		public override function init(){
			
			
			var delta_angle:Number = Math.PI / 6;
			
			var theta = 0;
			var r = 20;
			
			_view.graphics.lineStyle(0,0x666666);   

			_view.graphics.moveTo(100, 400);

			_view.graphics.lineTo(700, 400);
			_path_point_array.push(new b2Vec2(100 / _level.pixel_per_meter, 400 / _level.pixel_per_meter));

			_path_point_array.push(new b2Vec2(700 / _level.pixel_per_meter, 400 / _level.pixel_per_meter));
	
			_path_point_array.reverse();
			
			
			emitterEnemy(700, 10, 50);
			
		}
		
		
		public  override function callBackOfEmitterEveryEnemy(enemy:evoEnemy){
			
			
			enemy.followPath(_path_point_array, _path_raidus);

		}
		
	}

}