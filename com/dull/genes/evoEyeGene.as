package com.dull.genes 
{
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Common.Math.b2Transform;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2Fixture;
	import com.dull.evoCannon;
	import com.dull.evoLevel;
	import com.dull.*;
	import Box2D.Common.Math.*;
	
	/**
	 * ...
	 * @author longying.zhang
	 */
	public class evoEyeGene extends evoGene 
	{
		
		public function evoEyeGene(c:evoCannon, l:evoLevel) 
		{
			super(c, l);
			
		}
		
		
		public override function finding(){
			
			
			_target = null;	
			findTarget();
			
			if(_target!=null){
	
				var targetPos:b2Vec2 = _target.getPhysBody().GetWorldCenter();
				
				//var targetPos:b2Vec2 = new b2Vec2(400 / _level.pixel_per_meter, 400 / _level.pixel_per_meter);
				var cannonPos:b2Vec2 = new b2Vec2(_cannon.x / _level.pixel_per_meter, _cannon.y / _level.pixel_per_meter);
				var dVector:b2Vec2 = b2Math.SubtractVV(targetPos, cannonPos);
				//trace(cannonPos.x, cannonPos.y);
				//trace("------------");
				//trace(dVector.y, dVector.x);
				_cannon.rotation = Math.atan2(dVector.y, dVector.x)*180/Math.PI;				
				
			}
			_cannon._canno_bullet_harm *= 0.25;
			_cannon.setStatus("firing");

			
		}
		
		
		//眼睛寻找目标
		public function findTarget() {
			
			var pos=new b2Vec2(_cannon.x/_level.pixel_per_meter,_cannon.y/_level.pixel_per_meter);
			
			var aabb:b2AABB = new b2AABB();
			aabb.lowerBound.x = pos.x - _cannon._fire_range;
			aabb.lowerBound.y = pos.y - _cannon._fire_range;
			aabb.upperBound.x = pos.x + _cannon._fire_range;
			aabb.upperBound.y = pos.y + _cannon._fire_range;
			
			
			//todo 寻找距离最近的
			_level.m_world.QueryAABB(function(f:b2Fixture) {
				
				var b:b2Body = f.GetBody();
				if(b.GetUserData() is evoEnemy){
					_target = b.GetUserData();
					return false;
				}
				
				return true;
				
			}, aabb);
			
	
			
		}
		
		
		
		public override function getIntro():String{
			
			
			
			return "眼睛基因\n,可以自动准找目标\n"
			
		}
		
		public override function getName():String{
			
			
			return "eye";
			
		}
		

		
		
		public var _target:evoEnemy=null;
		
	}

}