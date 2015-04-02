package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import com.dull.*;
	
	/**
	 * ...
	 * @author longying.zhang
	 */
	public class Main extends Sprite 
	{
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
			gameMain = new evoGame(this, stage);
			
			gameMain.changeState(new evoMainMenu());
			
			addEventListener(Event.ENTER_FRAME, mainLoop);
			
		}
		
		
		private function mainLoop(e:Event):void{
			
			gameMain.update(1000/24);
			
			
			
		}
		
		
		public static var gameMain:evoGame;
		
	}
	
}