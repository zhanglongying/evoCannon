package com.dull 
{
	/**
	 * ...
	 * @author longying.zhang
	 */
	import com.dull.levels.evoTutorialLevel;
	import flash.display.SimpleButton;
	import playButton;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class evoMainMenu extends evoGameState
	{
		
		public function evoMainMenu() 
		{
			
		}
		
		
		public function evoGameState() 
		{
			
		}
	
		public override function Init(){
			
			
			var p1:SimpleButton = new playButton();			
			p1.x = 400;
			p1.y = 400;
			
			
			var p2:SimpleButton = new playButton();
			p2.x = 400;
			p2.y = 450;
			
			this.addChild(p2)
			this.addChild(p1);
			p1.addEventListener(MouseEvent.MOUSE_UP, playClick);
			p2.addEventListener(MouseEvent.MOUSE_UP, playT);

		}
		
		public function playClick(e:MouseEvent){
			
			Main.gameMain.changeState(new evoLevel());
			
			
		}
		
		public function playT(e:MouseEvent){
			
			Main.gameMain.changeState(new evoTutorialLevel());

			
		}
		
		
		
		public override function Destroy(){
			

			
		}
		
	
		
		
		
		public override function update(deltaTime:int){
			
			trace("menu update!");

			
		}
		

		
		
	}

}