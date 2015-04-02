package com.dull.genes 
{
	import com.dull.genes.evoEyeGene;
	import com.dull.genes.evoGene;
	import com.dull.genes.evoNormalFireGene;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Timer;
	
	import flash.geom.Point;
	import flash.events.TimerEvent;
	
 
	 
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
	import com.dull.*;
	
	/**
	 * ...
	 * @author longying.zhang
	 */
	public class evoNormalFireGene extends evoGene 
	{
		
		public function evoNormalFireGene(c:evoCannon, l:evoLevel) 
		{
			super(c, l);
			
		}

		public override function firing(){
			
			
			fire();
			_cannon.setStatus("waiting");
			_cannon._cannon_wating_timer.start();
		}
		
		
		public  function fire() :void{
			
			
			_cannon._view.gotoAndPlay(6);			
			
			var new_pos:Point = _cannon.localToGlobal(new Point(_cannon._firePos.x, _cannon._firePos.y));
			new_pos.x = new_pos.x / _level.pixel_per_meter;
			new_pos.y = new_pos.y / _level.pixel_per_meter;
			createBullet(new b2Vec2(new_pos.x,new_pos.y));

			
		}
		
		
		
		public function createBullet(p:b2Vec2):void{
			
			var radius_angle =_cannon.rotation * Math.PI / 180;
			
			var new_pos = p;
			var bullet:evoBullet = new evoBullet(_level,_cannon,p);
			var bullet_body:b2Body  = _level.createCircle(new_pos.x , new_pos.y, 0.1, bullet);
			bullet.setPhysBody(bullet_body);
			bullet._harmofEnemy = _cannon._canno_bullet_harm+5*_gene_level;
			_level.addBullet(bullet);
			//_posTest.x = tmpX;
			//_posTest.y = tmpY;
			//bullet_body.ApplyImpulse(new b2Vec2(10, 0), bullet_body.getWorldCenter() );
			
			var vx:Number = _cannon._bulletSpeed * Math.cos(radius_angle);
			var vy:Number = _cannon._bulletSpeed * Math.sin(radius_angle);

			bullet.setSpeed(vx, vy);
			bullet.setLifeRange(_cannon._fire_range);
			
			
			
			
		}
		public override function getName():String{
			
			
			return "normal_fire";
			
		}
		
		
	}

}