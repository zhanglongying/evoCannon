package com.dull 
{
	/**
	 * ...
	 * @author longying.zhang
	 */
	
	 
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import flash.geom.Point;
	
 
	 
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
	
	 
	public class evoBullet extends Sprite 
	{
		
		public function evoBullet(level:evoLevel,cannon:evoCannon,from:b2Vec2) 
		{
			
			_level = level;
			_cannon = cannon;
			_from_pos = from;
			
			_bulletView = new BulletView();
			this.addChild(_bulletView)
			
		}
		
		public function setPhysBody(phys_body:b2Body){
			_phys_body = phys_body;
			
		}
		public function getPhysBody(){
			
			return _phys_body;
			
		}
		
		public function setSpeed(vx:Number,vy:Number){
			
			if(_phys_body){
				_phys_body.SetLinearVelocity(new b2Vec2(vx, vy));
			}

			
		}
		
		public function getView(){
			
			
			return _bulletView;
		}
		
		
		public function update(deltaTime:int):void{
			
			_bulletView.x = _phys_body.GetWorldCenter().x*_level.pixel_per_meter;
			_bulletView.y = _phys_body.GetWorldCenter().y * _level.pixel_per_meter;
			
			//超出射程
			outOfRange();
			
		}
		
		public function setClear(clear:Boolean = true){
			
			_isNeedClear = true;
		}
		
		public function isNeedClear(){
			
			return _isNeedClear;
		}
		
		
		//boom bullet爆炸的行为
		public function boom(enemy:evoEnemy){
			
			setClear(true);
		}
		
		
		public function getHarmOfEnemy(){
			
			
			return _harmofEnemy;
		}
		
		//超出子弹射程
		public function outOfRange(){
			
			var d:b2Vec2 = b2Math.SubtractVV(_phys_body.GetWorldCenter(), _from_pos);
			if(d.Length()>_life_range){
				
				setClear();
				
			}
			
		}
		
		public function setLifeRange(n:Number){
			
			_life_range = n;
			
		}
		
		
		public var _level:evoLevel;

		public var _cannon:evoCannon;
		public var _phys_body:b2Body;
		
		public var _bulletView:BulletView;
		
		public var _isNeedClear:Boolean = false;
		
		public var _harmofEnemy:Number = 50;
		
		public var _life_range:Number = 5;
		public var _from_pos:b2Vec2; 
		
		
		//public var _bulletTailArrays:Array = new Array();
	}

}