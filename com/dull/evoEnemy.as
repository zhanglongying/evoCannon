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
	 
	 
	 
	public class evoEnemy extends Sprite 
	{
		
		
		public function evoEnemy(level:evoLevel) 
		{
			
			_level = level;
			
			initView();
	
		}
		
		public function initView(){
			
			_view = new EnemyView();
			this.addChild(_view);			
			
			
		}
		
		
		
		public function setPhysBody(phys_body:b2Body){
			_phys_body = phys_body;
			
		}
		
		public function getPhysBody():b2Body{
			
			return _phys_body;
			
		}
		
		
		public function setSpeed(vx:Number,vy:Number){
			
			if(_phys_body){
				_phys_body.SetLinearVelocity(new b2Vec2(vx, vy));
			}

			
		}
		
		public function getView():MovieClip{
			
			
			return _view;
		}
		
		
		public function update(deltaTime:int):void{
			
			_view.x = _phys_body.GetWorldCenter().x*_level.pixel_per_meter;
			_view.y = _phys_body.GetWorldCenter().y * _level.pixel_per_meter;
			
			
			//update seek此处可分为两个状态 todo
			
			_walk();				
			_seek();
			
			if(_follow_path){
				_followPath();
			}
			
			//死亡
			if(_hp<=0){
				setClear();
			}
			
		}
		
		public function setClear(clear:Boolean = true){
			
			_isNeedClear = true;
		}

		public function isNeedClear(){
			
			return _isNeedClear;
		}
		
		public function reduceHp(hp:Number){
			
			_hp -= hp;
			if (_hp < 0) hp = 0;
		}
		
		
		public function getAddEpOfCanno():Number{
			
			
			return 50;
		}
		
		public function boom(bullet:evoBullet):void{
			
			reduceHp(bullet.getHarmOfEnemy());
			if(_hp<=0){
				bullet._cannon.addEp(getAddEpOfCanno());
			}
			
		}
		
		
		public function _arrival(){
			
			
			if(_seek_target){
				var desired:b2Vec2 =   b2Math.SubtractVV (_seek_target,_phys_body.GetWorldCenter());
			
				
				var d:Number = desired.Length();
				desired.Normalize();
				
				//确保不会在目标间来回
				if(d<1){
					
					var d:Number = d / 1 * _maxSpeed;
					desired.Multiply(d)
				}
				else{			
				
					desired.Multiply(_maxSpeed);
				}
			
				var steer:b2Vec2 =  b2Math.SubtractVV (desired,_phys_body.GetLinearVelocity());
			
				if(steer.Length()>10){
				
					steer.Normalize() * _maxForce;				
				}
				_phys_body.ApplyForce(steer, _phys_body.GetWorldCenter());
			}
			
				
		}
		
		
		//寻找目标s
		
		public function _seek(){
			
			
			if(_seek_target){
				var desired:b2Vec2 =   b2Math.SubtractVV (_seek_target,_phys_body.GetWorldCenter());
			
				
				var d:Number = desired.Length();
				desired.Normalize();
								
				desired.Multiply(_maxSpeed);
			
				var steer:b2Vec2 =  b2Math.SubtractVV (desired,_phys_body.GetLinearVelocity());
			
				if(steer.Length()>10/_level.pixel_per_meter){
				
					steer.Normalize() * _maxForce;		
				}
				steer.Multiply(_phys_body.GetMass());

				_phys_body.ApplyForce(steer, _phys_body.GetWorldCenter());
			}
			
				
		}
		
		public function seek(target:b2Vec2){
			
			_seek_target = target;
			
		}
		public function noSeek(){
			
			_seek_target = null;
			
		}
		
		
		public function walk(c:b2Vec2,r:Number=10){
			
			_walk_center = c;
			_walk_raidus = r;
			
		}
		
		public function _walk(){
			
			if(_walk_center){
				
				var theta = Math.random() * Math.PI * 2;
				var x:Number =_walk_center.x+ Math.cos(theta) * _walk_raidus;
				var y:Number = _walk_center.y + Math.sin(theta) * _walk_raidus;
				seek(new b2Vec2(x, y));
			}
			
		}
		
		public function noWalk(){
			
			_walk_center = null;
			
		}
		
		public function stopAllTask(){
			
			noSeek();
			noWalk();
			
		}
		
		
		//路径跟随
		
		public function followPath(path:Array,path_radius:Number):void{
			
			
			_follow_path = path;
			_path_radius = path_radius;
			
			
		}
		
		public function _followPath(){
			
			
			var predict:b2Vec2 = _phys_body.GetLinearVelocity().Copy();
			predict.Normalize();
			predict.Multiply(1);			
			var preLocal:b2Vec2 = b2Math.AddVV(_phys_body.GetWorldCenter(), predict); 
			
			var target:b2Vec2 = null;
			var dir:b2Vec2;
		
			var worldRecord:Number = 1000000;
			//var normalPoint:b2Vec2;
			
			for (var i:Number = 0; i < _follow_path.length - 1; i++ ) {
				
				var a:b2Vec2 = _follow_path[i];
				var b:b2Vec2 = _follow_path[i + 1];
				var normalPoint:b2Vec2 = getNormalPoint(preLocal, a, b);
				
				//由左向右 todo判断交换下
				var min_p:b2Vec2;
				var max_p:b2Vec2;
				if (a.x>b.x){
					max_p = a;
					min_p = b;
				}
				else{
					max_p = b;
					min_p = a;
				}
				if (normalPoint.x < min_p.x || normalPoint.x > max_p.x) {
					normalPoint = b.Copy();
				}
				var distance = b2Math.Distance(preLocal, normalPoint);
				
				if(distance< worldRecord){
					worldRecord = distance;
					dir = b2Math.SubtractVV(b, a);					
					target = normalPoint;
					
				}
				
			}	
					
			if(worldRecord>_path_radius){
				seek(target);
			}
			else{
				dir.Normalize();
				dir.Multiply(1);
				seek(b2Math.AddVV(target, dir));
			}
				
			
			
		}
		
		
		public function getNormalPoint(p:b2Vec2,a:b2Vec2,b:b2Vec2):b2Vec2{
			
			
			
			var ap:b2Vec2 = b2Math.SubtractVV(p, a);
			var ab:b2Vec2 = b2Math.SubtractVV(b, a);
			ab.Normalize();
			ab.Multiply(b2Math.Dot(ap, ab));
			var normalPoint:b2Vec2 = b2Math.AddVV(a, ab);
			
			return normalPoint;
			
			
			
		}
		
		
		
		
		public function setLevel(l:Number){
			
			
			_enemy_level = l;
		}
		
		public function getLevel():Number{
			
			
			return _enemy_level;
		}
		
		
		
		public var _level:evoLevel;
		public var _view:MovieClip;		
		public var _phys_body:b2Body;
		
		public var _hp = 100;
		
		public var _isNeedClear:Boolean = false;
		
		
		//转向智能体需要变量
		public var _maxSpeed:Number = 2;
		public var _maxForce:Number = 2;
		
		public var _seek_target:b2Vec2;
		public var _walk_center:b2Vec2;
		public var _walk_raidus:Number = 10;
		
		public var _enemy_level:Number = 1;
		
		public var _follow_path:Array;
		public var _path_radius:Number;
		
	}

}