package com.dull.waves 
{
	/**
	 * 关卡中每一波怪的基类
	 * 
	 * 
	 * 
	 * 
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
	
	 
	public class evoWave 
	{
		
		
		
		public function evoWave(level:evoLevel) 
		{
			
			_level = level;
			
			_path_point_array = new Array();
			_view = new MovieClip();
			_level.addView(_view);
			
			_enemy_emitter_timer = new Timer(100, 0);
			_enemy_emitter_timer.addEventListener(TimerEvent.TIMER, enmeyEmitterHandle);
			_enemy_emitter_timer.stop();
			
			

		}
		
		public function enmeyEmitterHandle(e:Event){
			
			_enemy_emitter_timer_counter += _enemy_emitter_timer_speed;
			
		}
		
		
		public virtual function init(){
			
			
		
			
		}
		
		
		public function update(deltaTime:int){
			
			_emitterEnemy();
			
			if (_wave_enemies_num_max <= 0 && _level.enemiesArray.length == 0) {
				_level.nextWave();
			}
			
		}
		
		
		//删除中的数据
		public function destory(){
			
			
			_level.delView(_view);

		}
		
		
		
		public function addPointToPath(p:b2Vec2){			
			
			_path_point_array.push(p);
			
			
		}
		
		
		public function emitterEnemy(x:Number,y:Number,num:int){
			
			
			
			_enemy_emitter_timer.start();
			_enmey_emitter_x = x;
			_enemy_emitter_y = y;
			_enemy_emitter_total_num = num;
			_enemy_emitter_timer_counter = 0;
			
			
		}
		
		public function _emitterEnemy(){
			
			
			if (_enemy_emitter_timer_counter > _enemy_emitter_timer_max) {

				if (_enemy_emiiter_cur_num < _enemy_emitter_total_num) {
					
					
					var en:evoEnemy = _level.createEnemy(_enmey_emitter_x, _enemy_emitter_y);
					
					//_enemy_list.push(en);
					callBackOfEmitterEveryEnemy(en);
					_enemy_emiiter_cur_num++;
					_wave_enemies_num_max--;

				}
				else{
					
					_enemy_emitter_timer.stop();
					_enemy_emiiter_cur_num = 0;
					_enemy_emitter_total_num = 0;
					
				}
				_enemy_emitter_timer_counter = 0;

			}
			
		}
		
	
		
		
		public  virtual function callBackOfEmitterEveryEnemy(enemy:evoEnemy){
			
						
		}
		
		
		
		
		public var _level:evoLevel;
		
		public var _enemies_array:Array;
		
		//均以box2d中的单位
		public var _path_point_array:Array;
		public var _path_raidus:Number = 20;//路的宽度的一半
		
		//wave的status暂时没想到什么用
		public var _status = ""
		
		public var _view:MovieClip;
		
		public var _enemy_emitter_timer:Timer;
		public var _enemy_emitter_timer_counter:Number=0;
		public var _enemy_emitter_timer_speed:Number = 0.1;
		public var _enemy_emitter_timer_max:Number = 1;
		
		public var _enemy_emitter_total_num = 0;
		public var _enemy_emiiter_cur_num = 0;
		
		public var _enmey_emitter_x:Number;
		public var _enemy_emitter_y:Number;
		
		
		//public var _enemy_list:Array = new Array();
		
		public var _wave_enemies_num_max:Number = 50;

	}

}