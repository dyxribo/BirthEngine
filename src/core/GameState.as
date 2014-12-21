package core 
{
	import core.Arena;
	import core.Character;
	import core.RecLoader;
	import debug.printf;
	import enums.MatchObject;
	import enums.Resources;
	import enums.ResourceType;
	import enums.Stats;
	import events.UMIBEvent;
	import events.UMIBEventManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import input.Gamepad;
	import utils.PsychoUtils;
	import utils.VirtualCamera;

	/**
	 * ...
	 * @author Psycho
	 */
	public class GameState extends Sprite 
	{
		private const CHAR_DIRECTORY:String = "res/chars/";
		private const STAGE_DIRECTORY:String = "res/stages/";
		static public var HITSTUN:uint;
		static public var matchStarted:Boolean;
		static public var playerOne:Character;
		static public var playerTwo:Character;
		
		private var _parent:Sprite;
		private var _playerOneTeam:Array;
		private var _playerTwoTeam:Array;
		private var _playerOneCharacter:uint;
		private var _playerTwoCharacter:uint;
		private var _playerOneData:Object;
		private var _playerTwoData:Object;
		private var _gameArenaName:String;
		private var _gameArena:Arena;
		private var _vCam:VirtualCamera;
		
		private var _resourceLoader:RecLoader;
		private var _countdownTimer:Timer;
		private var _countdownTime:uint;
		
		public function GameState(parent:Sprite) 
		{
			super();
			
			// INIT
			_parent = parent;
			//HITSTUN = 20;
			_countdownTimer = new Timer(1000);
			_countdownTime = 4;
			_gameArenaName = MatchObject.gameArena;
			_playerOneTeam = MatchObject.playerOneTeam;
			_playerTwoTeam = MatchObject.playerTwoTeam;
			_playerOneCharacter = 0;
			_playerTwoCharacter = 0;
			
			_playerOneData = { };
			_playerOneData.isCPU = (!MatchObject.playerOneHuman) ?  (true) : (false);
			_playerOneData.controller = MatchObject.gamepadOne;
			_playerOneData.teamLength = _playerOneTeam.length;
			for (var i:int = 0; i < _playerOneTeam.length; i++)
			{
				_playerOneData["c" + i] = { };
				_playerOneData["c" + i].name = _playerOneTeam[i];
				_playerOneData["c" + i].stats = Stats[_playerOneData["c" + i].name];
			}
			
			_playerTwoData = { };
			_playerTwoData.isCPU = (!MatchObject.playerTwoHuman) ?  (true) : (false);
			_playerTwoData.controller = MatchObject.gamepadTwo;
			_playerTwoData.teamLength = _playerTwoTeam.length;
			for (var j:int = 0; j < _playerTwoTeam.length; j++)
			{
				_playerTwoData["c" + j] = { };
				_playerTwoData["c" + j].name = _playerTwoTeam[j];
				_playerTwoData["c" + j].stats = Stats[_playerTwoData["c" + j].name];
			}
			// END INIT
			
			addEventListener(Event.ADDED_TO_STAGE, loadMatch);
		}
		
		private function loadMatch(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, loadMatch);
			_resourceLoader = new RecLoader();
			
			// ENTRY POINT
			_resourceLoader.addResource( { name: _gameArenaName, url: STAGE_DIRECTORY + _gameArenaName + ".png" }, ResourceType.DISPLAY_OBJECT);
			//_resourceLoader.addResource( { name: _gameArenaName+"JSON", url: STAGE_DIRECTORY + _gameArenaName + ".js" }, ResourceType.PLAIN_TEXT);
			
			for (var i:uint = 0; i < _playerOneTeam.length; i++ )
			{
				_resourceLoader.addResource( {name: "team1Char"+i, url: CHAR_DIRECTORY + _playerOneTeam[i] + ".png" }, ResourceType.DISPLAY_OBJECT);
				_resourceLoader.addResource( {name: "team1Char"+i+"JSON", url: CHAR_DIRECTORY + _playerOneTeam[i] + ".js" }, ResourceType.PLAIN_TEXT);
			}
			for (var j:uint = 0; j < _playerTwoTeam.length; j++ )
			{
				_resourceLoader.addResource( { name: "team2Char" + j, url: CHAR_DIRECTORY + _playerTwoTeam[j] + ".png" }, ResourceType.DISPLAY_OBJECT);
				_resourceLoader.addResource( {name: "team2Char"+j+"JSON", url: CHAR_DIRECTORY + _playerTwoTeam[j] + ".js" }, ResourceType.PLAIN_TEXT);
			}
			_resourceLoader.loadResources();
			UMIBEventManager.addEventListener(UMIBEvent.LOAD_COMPLETE, loadArena);
			
			//loadArena();
			//loadCharacters();
			//loadCamera();
		}
		
		private function loadArena(e:UMIBEvent):void 
		{
			Resources.addBitmapData( { name: _gameArenaName, data: e.data[_gameArenaName] } );
			//Resources.addAnimData( {name: _gameArenaName, data: e.data[_gameArenaName+"JSON"]});
			
			for (var i:int = 0; i < _playerOneTeam.length; i++)
			{
				Resources.addBitmapData( {name: _playerOneTeam[i], data: e.data["team1Char"+i] } );
			}
			for (var j:int = 0; j < _playerTwoTeam.length; j++)
			{
				Resources.addBitmapData( {name: _playerOneTeam[j], data: e.data["team2Char"+j] } );
			}
			for (var k:int = 0; k < _playerOneTeam.length; k++)
			{
				Resources.addAnimData( {name: _playerOneTeam[k], data: e.data["team1Char"+k+"JSON"] } );
			}
			for (var l:int = 0; l < _playerTwoTeam.length; l++)
			{
				Resources.addAnimData( {name: _playerOneTeam[l], data: e.data["team2Char"+l+"JSON"] } );
			}
			
			_gameArena = new Arena(_gameArenaName, Resources.spriteSheets[_gameArenaName]);
			addChildAt(_gameArena, numChildren);
			loadCharacters();
		}
		
		private function loadCharacters():void 
		{
			var _p1Data:Object = PsychoUtils.mergeObjects(Stats[(_playerOneTeam[_playerOneCharacter] as String).toUpperCase()], { controller: MatchObject.gamepadOne }, _playerOneData );
			playerOne = new Character(Resources.spriteSheets[_playerOneTeam[_playerOneCharacter]], _p1Data , Resources.animationData[_playerOneTeam[_playerOneCharacter]]);
			playerOne.addAnimation("idle", 6, 10, true);
			playerOne.addAnimation("walk", 12, 10, true);
			playerOne.addAnimation("crouch", 3, 30, false);
			playerOne.registerCombo("superJump", ["d", "u"])
			playerOne.registerCombo("dashFwd", ["f", "f"])
			playerOne.registerCombo("dashBack", ["b", "b"])
			addChild(playerOne);
			playerOne.playAnimation("idle");
			
			var _p2Data:Object = PsychoUtils.mergeObjects(Stats[(_playerTwoTeam[_playerTwoCharacter] as String).toUpperCase()], { controller: MatchObject.gamepadTwo }, _playerTwoData );
			playerTwo = new Character(Resources.spriteSheets[_playerTwoTeam[_playerTwoCharacter]], _p2Data, Resources.animationData[_playerTwoTeam[_playerTwoCharacter]]);
			playerTwo.addAnimation("idle", 7, 10, true);
			playerTwo.addAnimation("walk", 12, 10, true);
			playerTwo.addAnimation("crouch", 3, 30, false);
			addChild(playerTwo);
			playerTwo.playAnimation("idle");
			playerTwo.scaleX = -1;
			playerTwo.x = (stage.stageWidth - playerTwo.width);
			
			loadCamera();
		}
		
		public function swapCharacters(player:Character, keyPresses:uint):void
		{
			if (keyPresses)
			{
				if (player.facingDirection == 1)
				{
					
				}
			}
			else
			{
				
			}
		}
		
		private function loadCamera():void 
		{
			_vCam = new VirtualCamera( { root: _parent, parent: this, width: stage.stageWidth, height: stage.stageHeight, bounds: new Rectangle(0, 0, _gameArena.terrainRect.width, this.height * 3), stageBounds: _gameArena.terrainRect, xSpeed: 1, ySpeed: .5, zoomSpeed: .5, playerOne: playerOne, playerTwo: playerTwo } );
			_vCam.CAMERA_MODE = _vCam.NORMAL_MODE;
			printf("camera mode after it was set to normal is %s.", _vCam.CAMERA_MODE);
			addChild(_vCam);
			setupControllers();
		}
		
		private function setupControllers():void 
		{
			Gamepad.plugIn();
			
			UMIBEventManager.dispatchEvent(new UMIBEvent(UMIBEvent.MATCH_LOAD_COMPLETE, { } ));
			UMIBEventManager.removeAllEvents();
			
			addEventListener(Event.ENTER_FRAME, update);
			_countdownTimer.addEventListener(TimerEvent.TIMER, countdown);
			_countdownTimer.start();
		}
		
		private function countdown(e:TimerEvent):void 
		{
			--_countdownTime
			if (_countdownTime == 3) printf("ready???");
			
			if (!_countdownTime) 
			{
				printf("GO!!");
				matchStarted = true;
				
				if (Main.DEBUG) Main.CONSOLE.setCamera(_vCam);
				_countdownTimer.stop();
				_countdownTimer.removeEventListener(TimerEvent.TIMER, countdown);
			}
		}
		
		private function update(e:Event):void 
		{
			if (!HITSTUN)
			{
				playerOne.update();
				playerTwo.update();
				_vCam.PERFORMALL();
				updatePhysics();
				Main.CONSOLE.update();
			}
			else 
			{
				if (_vCam.CAMERA_MODE == _vCam.NORMAL_MODE) _vCam.CAMERA_MODE = _vCam.ZOOM_MODE;
				_vCam.hitStunShake();
				HITSTUN--;
			}
		}
		
		private function updatePhysics():void 
		{
			while (PsychoUtils.rectContainsPoint(_gameArena.terrainRect, new Point((playerOne.x + (playerOne.width / 2)), playerOne.y + playerOne.height)) 
			|| PsychoUtils.rectContainsPoint(_gameArena.terrainRect, new Point((playerTwo.x + (playerTwo.width/2)), playerTwo.y + playerTwo.height)))
			{ 
				if (PsychoUtils.rectContainsPoint(_gameArena.terrainRect, new Point((playerOne.x + (playerOne.width / 2)), playerOne.y + playerOne.height)))
				{
					playerOne.y--;
					playerOne.gravity = 0;
					playerOne.isOnGround = true;
				}
				if (PsychoUtils.rectContainsPoint(_gameArena.terrainRect, new Point((playerTwo.x + (playerTwo.width / 2)), playerTwo.y + playerTwo.height)))
				{
					playerTwo.y--;
					playerTwo.gravity = 0
					playerTwo.isOnGround = true;
				}
			}
			if (!playerOne.isOnGround || !playerTwo.isOnGround)
			{
				if (!playerOne.isOnGround)
				{
					playerOne.gravity += playerOne.weight;
					playerOne.y += playerOne.gravity;
				}
				if (!playerTwo.isOnGround)
				{
					playerTwo.gravity += playerTwo.weight;
					playerTwo.y += playerTwo.gravity;
				}
			}
		}
	}
}