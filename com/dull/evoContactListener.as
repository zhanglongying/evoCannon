package com.dull{

	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.Joints.*;
	import Box2D.Common.*;
	import Box2D.Dynamics.Contacts.*;
	
	public class evoContactListener extends b2ContactListener{
		/**
	 * Called when two fixtures begin to touch.
	 */
		public override function BeginContact(contact:b2Contact):void {
			
			var f1:b2Fixture = contact.GetFixtureA();
			var f2:b2Fixture = contact.GetFixtureB();
			var b1:b2Body = f1.GetBody();
			var b2:b2Body = f2.GetBody();
			
		
			
			if(b1.GetUserData() is evoBullet){
				if(b2.GetUserData() is evoEnemy){
					
					b1.GetUserData().boom(b2.GetUserData());
					b2.GetUserData().boom(b1.GetUserData());
					
				}

			}
			
			
			
		}

		/**
		 * Called when two fixtures cease to touch.
		 */
		public override function EndContact(contact:b2Contact):void {
		}

		/**
		 * This is called after a contact is updated. This allows you to inspect a
		 * contact before it goes to the solver. If you are careful, you can modify the
		 * contact manifold (e.g. disable contact).
		 * A copy of the old manifold is provided so that you can detect changes.
		 * Note: this is called only for awake bodies.
		 * Note: this is called even when the number of contact points is zero.
		 * Note: this is not called for sensors.
		 * Note: if you set the number of contact points to zero, you will not
		 * get an EndContact callback. However, you may get a BeginContact callback
		 * the next step.
		 */
		public override function PreSolve(contact:b2Contact, oldManifold:b2Manifold):void {
			
			
		}

		/**
		 * This lets you inspect a contact after the solver is finished. This is useful
		 * for inspecting impulses.
		 * Note: the contact manifold does not include time of impact impulses, which can be
		 * arbitrarily large if the sub-step is small. Hence the impulse is provided explicitly
		 * in a separate data structure.
		 * Note: this is only called for contacts that are touching, solid, and awake.
		 */
		public override function PostSolve(contact:b2Contact, impulse:b2ContactImpulse):void { 
			
			
			
		};
	
	}
}