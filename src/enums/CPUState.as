package enums 
{
	/**
	 * ...
	 * @author Psycho
	 */
	public class CPUState extends Object
	{
		public static const IDLE:int = 0;
		public static const CHASE:int = 1;
		public static const EVADE:int = 2;
		public static const ATTACK:int = 3;
		public static const GUARD:int = 4;
		public static const GRAB:int = 5;
		public static const FORCE_JUMP:int = 6;
		public static const FORCE_WALK:int = 7;
		public static const FORCE_RUN:int = 8;
		public static const FORCE_CROUCH:int = 9;
		private static var statesArr:Array = new Array();
		
		public static function toString(stateID:int) : String
        {
			return (statesArr[stateID] != null) ? (statesArr[stateID]) : ("NULL");
        }
		
        statesArr.push("IDLE");
        statesArr.push("CHASE");
        statesArr.push("EVADE");
        statesArr.push("ATTACK");
        statesArr.push("GUARD");
        statesArr.push("GRAB");
        statesArr.push("FORCE_JUMP");
        statesArr.push("FORCE_WALK");
        statesArr.push("FORCE_RUN");
        statesArr.push("FORCE_CROUCH");
	}

}