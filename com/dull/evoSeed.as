package com.dull 
{
	import Box2D.Common.Math.b2Vec2;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author longying.zhang
	 */
	public class evoSeed  extends Sprite 
	{
		
		public function evoSeed() 
		{
			_view = new BeedView();
			this.addChild(_view);
			
		}
		
		
		public function seek(target:b2Vec2) {
			
			_target = target;
			

		}
		
		
		public function update(deltaTime:int):void{
			
		
			
			_velocity.x = (_target.x - this.x) /4;
			
			_velocity.y = (_target.y - this.y) /4;
			
			this.x += _velocity.x;
			this.y += _velocity.y;
			
			
			var dx:Number = _target.x - this.x 
			var dy:Number = _target.y - this.y;
			var dis= Math.sqrt(dx*dx+dy*dy);
			if (dis<2&&_status=='normal'){
				
				_velocity.x = 0;
				_velocity.y = 0;
				_view.gotoAndPlay(3);
				_status = 'arrival';
			}			
				
		}
		
		public function getView():MovieClip{
			
			
			return _view;
		}
		public function getStatus():String{
			
			
			return _status;
		}
		
		

	
	
		public var _view:MovieClip;
	

	
		public var _speedCount = 24;
		public var _velocity:b2Vec2 = new b2Vec2(0, -0);
		public var _target:b2Vec2 = new b2Vec2(400, 400);
		// normal arrival
		public var _status='normal'
			
	}
	

}