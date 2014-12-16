package enums 
{
	/**
	 * ...
	 * @author Psycho
	 */
	public class CState extends Object
	{
		public static const IDLE:uint = 0;
        public static const ENTRANCE:uint = 1;
        public static const WALK:uint = 2;
        public static const RUN:uint = 3;
        public static const JUMP_DOUBLE:uint = 4;
        public static const JUMP_RISING:uint = 5;
        public static const JUMP_FALLING:uint = 6;
        public static const LAND:uint = 7;
        public static const ATTACKING:uint = 8;
        public static const ROLL:uint = 9;
        public static const CROUCH:uint = 10;
        public static const GRABBING:uint = 11;
        public static const INJURED:uint = 12;
        public static const FLYING:uint = 13;
        public static const AIR_DODGE:uint = 14;
        public static const AIR_DASH:uint = 15;
        public static const GUARDING:uint = 16;
        public static const STUNNED:uint = 17;
        public static const DIZZY:uint = 18;
        public static const KNOCKBACK_FALL:uint = 19;
        public static const CRASH_LAND:uint = 20;
        public static const GET_UP:uint = 21;
        public static const WALL_CLING:uint = 22;
        public static const PARALYZED:uint = 23;
        public static const TAUNT:uint = 24;
        public static const GRABBED:uint = 25;
        public static const SLEEP:uint = 26;
        public static const LYING_DOWN:uint = 27;
        public static const SKID:uint = 28;
        public static const JUMP_MIDAIR:uint = 29;
        public static const TECH_GROUND:uint = 30;
        public static const TECH_ROLL:uint = 31;
        public static const SHIELD_DROP:uint = 32;
        public static const DASH_INIT:uint = 33;
		public static const GET_UP_ATTACK:uint = 34;
		private static var _stateArr:Array = [];
		
		static public function toString(stateID:int) : String
        {
			return (_stateArr[stateID] != null) ? (_stateArr[stateID]) : ("null");
        }
		
		_stateArr.push("IDLE");
        _stateArr.push("ENTRANCE");
        _stateArr.push("WALK");
        _stateArr.push("RUN");
        _stateArr.push("JUMP_DOUBLE");
        _stateArr.push("JUMP_RISING");
        _stateArr.push("JUMP_FALLING");
        _stateArr.push("LAND");
        _stateArr.push("ATTACKING");
        _stateArr.push("ROLL");
        _stateArr.push("CROUCH");
        _stateArr.push("GRABBING");
        _stateArr.push("INJURED");
        _stateArr.push("FLYING");
        _stateArr.push("AIR_DODGE");
        _stateArr.push("AIR_DASH");
        _stateArr.push("GUARDING");
        _stateArr.push("STUNNED");
        _stateArr.push("DIZZY");
        _stateArr.push("KNOCKBACK_FALL");
        _stateArr.push("CRASH_LAND");
        _stateArr.push("GET_UP");
        _stateArr.push("WALL_CLING");
        _stateArr.push("PARALYZED");
        _stateArr.push("TAUNT");
        _stateArr.push("GRABBED");
        _stateArr.push("SLEEP");
        _stateArr.push("LYING_DOWN");
        _stateArr.push("SKID");
        _stateArr.push("JUMP_MIDAIR");
        _stateArr.push("TECH_GROUND");
        _stateArr.push("TECH_ROLL");
        _stateArr.push("SHIELD_DROP");
        _stateArr.push("DASH_INIT");
		_stateArr.push("GET_UP_ATTACK");
		
	}

}