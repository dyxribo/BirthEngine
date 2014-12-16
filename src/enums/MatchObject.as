package enums 
{
	import input.Gamepad;
	/**
	 * ...
	 * @author Psycho
	 */
	public class MatchObject
	{
		static private var _matchType:String;
		static private var _gameArena:String;
		static private var _p1Team:Array;
		static private var _p2Team:Array;
		static private var _p1Human:Boolean;
		static private var _p2Human:Boolean;
		static private var _p1Gamepad:Gamepad;
		static private var _p2Gamepad:Gamepad;
		static private var _showHUD:Boolean;
		static private var _infinite:Boolean;
		static private var _timeLimit:uint;
		
		public function MatchObject() 
		{
		}
		
		static public function get matchType():String
		{
			return _matchType;
		}
		static public function set matchType(val:String):void
		{
			_matchType = val;
		}
		
		static public function get gameArena():String
		{
			return _gameArena;
		}
		static public function set gameArena(val:String):void
		{
			_gameArena = val;
		}
		
		static public function get playerOneTeam():Array
		{
			return _p1Team;
		}
		static public function set playerOneTeam(val:Array):void
		{
			_p1Team = val;
		}
		
		static public function get playerTwoTeam():Array
		{
			return _p2Team;
		}
		static public function set playerTwoTeam(val:Array):void
		{
			_p2Team = val;
		}
		
		static public function get playerOneHuman():Boolean
		{
			return _p1Human;
		}
		static public function set playerOneHuman(val:Boolean):void
		{
			_p1Human = val;
		}
		
		static public function get playerTwoHuman():Boolean
		{
			return _p2Human;
		}
		static public function set playerTwoHuman(val:Boolean):void
		{
			_p2Human = val;
		}
		
		static public function get showHUD():Boolean
		{
			return _showHUD;
		}
		static public function set showHUD(val:Boolean):void
		{
			_showHUD = val;
		}
		
		static public function get infinite():Boolean
		{
			return _infinite;
		}
		static public function set infinite(val:Boolean):void
		{
			_infinite = val;
		}
		
		static public function get timeLimit():uint
		{
			return _timeLimit;
		}
		static public function set timeLimit(val:uint):void
		{
			_timeLimit = val;
		}
		
		static public function get gamepadOne():Gamepad
		{
			return _p1Gamepad;
		}
		static public function set gamepadOne(val:Gamepad):void
		{
			_p1Gamepad = val;
		}
		
		static public function get gamepadTwo():Gamepad
		{
			return _p2Gamepad;
		}
		static public function set gamepadTwo(val:Gamepad):void
		{
			_p2Gamepad = val;
		}
	}

}