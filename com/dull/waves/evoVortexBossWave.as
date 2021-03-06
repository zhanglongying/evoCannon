package com.dull.waves 
{
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
	public class evoVortexBossWave extends evoWave 
	{
		
		public function evoVortexBossWave(level:evoLevel) 
		{
			super(level);
			
		}
		
		public override function init(){
			
			
			//生成漩涡路径，极坐标 
			var delta_angle:Number = Math.PI / 4;
			
			var theta = 0;
			var r = 20;
			
			_view.graphics.lineStyle(0,0x666666);   

			_view.graphics.moveTo(400, 400);
			var x:Number, y:Number;
			for (var i:int = 0; i < 40;i++){
				
				x = 400 + r * Math.cos(theta);
				y = 400 + r * Math.sin(theta);
				_view.graphics.lineTo(x, y);
				
				r +=5;				
				theta += delta_angle;
				_path_point_array.push(new b2Vec2(x / _level.pixel_per_meter, y / _level.pixel_per_meter));
				
				
			}
			_path_point_array.reverse();
			
			
			
			_boss_hp_bar = new BossBar();
			
			_boss_hp_bar.x = 400;
			_boss_hp_bar.y = 750;
			_view.addChild(_boss_hp_bar);
			_boss_hp_bar.gotoAndStop(100);
			emitterEnemy(0, 0, 1);
			
		}
		public override function update(deltaTime:int){
				
			super.update(deltaTime);
			
			if(_boss){

				var per:int = (_boss._hp / _max_hp)*100;
				_boss_hp_bar.gotoAndStop(per);
				if(_boss._hp<=0){
					
					_level.gameWin();
				}
			}
			
			
		}
		
		
		public override function _emitterEnemy(){
			
			
			if (_enemy_emitter_timer_counter > _enemy_emitter_timer_max) {

				if (_enemy_emiiter_cur_num < _enemy_emitter_total_num) {
					
					
					var en:evoEnemy = _level.createEnemy(_enmey_emitter_x, _enemy_emitter_y,45);
					
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
		
		
		
		public  override function callBackOfEmitterEveryEnemy(enemy:evoEnemy){
			
			
			enemy.followPath(_path_point_array, _path_raidus);
		
			enemy.getView().scaleX = 5;
			enemy.getView().scaleY = 5;
			enemy._hp = 10000;
			_boss = enemy;
		}
		
		public var _boss:evoEnemy;
		public var _max_hp:Number = 10000;
		
		public var _boss_hp_bar:MovieClip;
		
	}

}