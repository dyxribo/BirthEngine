package 
{
	import com.greensock.TweenLite;
	import core.GameState;
	import enums.MatchObject;
	import enums.MatchTime;
	import enums.MatchType;
	import events.UMIBEvent;
	import events.UMIBEventManager;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import input.Gamepad;
	
	/**
	 * ...
	 * @author Psycho
	 */
	public class Main extends Sprite 
	{
		static public const FRAMERATE:uint = 60;
		static public var STAGE:Stage;
		
		private var _gameState:GameState;
		private var _loadingScreen:Sprite;
		
		public function Main():void 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			STAGE = stage;
			// ENTRY POINT
			synthesizeMatchData();
			_gameState = new GameState();
			addChild(_gameState);
			drawLoadScreen();
			UMIBEventManager.addEventListener(UMIBEvent.MATCH_LOAD_COMPLETE, removeLoadingScreen);
		}	
		
		private function synthesizeMatchData():void 
		{
			MatchObject.playerOneTeam = ["dummy", "dummy", "dummy"];
			MatchObject.playerTwoTeam = ["dummy", "dummy", "dummy"];
			MatchObject.gameArena = "darena";
			MatchObject.matchType = MatchType.TRAINING;
			MatchObject.timeLimit = MatchTime.minutes(3);
			MatchObject.infinite = false;
			MatchObject.showHUD = true;
			MatchObject.playerOneHuman = true;
			MatchObject.playerTwoHuman = false;
			MatchObject.gamepadOne = new Gamepad(Gamepad.P1_DEFAULT, "1");
			MatchObject.gamepadTwo = new Gamepad(Gamepad.NULL_CONTROLS, "1");
		}
		
		private function drawLoadScreen():void 
		{
			_loadingScreen = new Sprite();
			_loadingScreen.graphics.beginFill(0x000000);
			_loadingScreen.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			_loadingScreen.graphics.endFill();
			
			addChild(_loadingScreen);
			TweenLite.to(_loadingScreen, 1, { alpha: 1 } );
		}
		
		private function removeLoadingScreen(e:UMIBEvent):void 
		{
			TweenLite.to(_loadingScreen, .7, { alpha: 0, delay: 1, onComplete: removeChild, onCompleteParams: [_loadingScreen] } );
		}
	}
}