package com.dull.levels 
{
	import com.dull.evoLevel;
	import com.dull.waves.*;
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
	public class evoTutorialLevel extends evoLevel 
	{
		
		public function evoTutorialLevel() 
		{
			super();
			
		}
		
		
		public override function initCannonPosAndCannon(){
			
			
						
			//位置网格网格
			for (var m:Number = 620; m < 660;m++ ){
				
				_cannon_pos_array.push(m);
			}
			
			for (var m:Number = 920; m < 960;m++ ){
				
				_cannon_pos_array.push(m);
			}
			
			for (var n:Number = 0; n < 10;n++ ){
				createCannon();
			
			}
			
		}
		
			
		public override function initWave(){
			
						
			_waves_list = new Array();
			_waves_list.push(new evoLineWave (this))

			_boss_wave = new evoLineBoss(this);
			
		}
		
	}

}