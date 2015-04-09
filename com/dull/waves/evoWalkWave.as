package com.dull.waves 
{
	import Box2D.Common.Math.b2Vec2;
	import com.dull.*;
	
	/**
	 * ...
	 * @author longying.zhang
	 */
	public class evoWalkWave extends evoWave 
	{
		
		public function evoWalkWave(level:evoLevel) 
		{
			super(level);
			
		}
		public override function init() 
		{
			_wave_enemies_num_max = 50;

			emitterEnemy(400, 400, 100);
		}
		
			
		public  override function callBackOfEmitterEveryEnemy(enemy:evoEnemy){
			
			var seek_x = Math.random() * 800;
			var seek_y = Math.random ()* 800;
			//enemy.seek(new b2Vec2(600 / pixel_per_meter, 500 / pixel_per_meter));
			enemy.walk(new b2Vec2(seek_x / _level.pixel_per_meter, seek_y / _level.pixel_per_meter))
		}
		
	}

}