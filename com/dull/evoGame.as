package com.dull 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	/**
	 * ...
	 * @author longying.zhang
	 */
	public class evoGame 
	{
		
		public function evoGame(mc,stg):void 
		{
			_mainContainer = mc;
			_mainStage = stg;
			
		}
		
		public function changeState(state:evoGameState){
			
			var oldState:evoGameState = _currentState;
			
			state.Init();
			_mainContainer.addChild(state);
			_currentState = state;
			
			if (oldState != null) {
				_mainContainer.removeChild(oldState);
				oldState.Destroy();
				
			}
		}
		
		
		public function update(deltaTime:int):void{
			
			
			_currentState.update(deltaTime);
			
		}
		
		
		
		
		
		
		public var _currentState:evoGameState;
		public var _mainContainer:Sprite;
		public var _mainStage:Stage;
		
	}

}