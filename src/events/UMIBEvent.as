package events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Psycho
	 */
	public class UMIBEvent extends Event 
	{
		
		private var _data:Object;
		static public const TEXT_LOAD_COMPLETE:String = "textLoadComplete";
		public static const MATCH_LOAD_COMPLETE:String = "matchLoadComplete";
		public static const LOAD_COMPLETE:String = "loadComplete";
		public static const ARENA_LOADED:String = "arenaLoaded";
		public static const CHARS_LOADED:String = "charsLoaded";
        public static const GAME_START:String = "gameTickStart";
        public static const GAME_END:String = "gameTickEnd";
        public static const STATE_CHANGE:String = "stateChange";
        public static const CAMERA_HIT_WALL:String = "hitWall";
        public static const ATTACK_CONNECT:String = "attackConnect";
        public static const ATTACK_CONNECT_GUARD:String = "attackConnectShield";
        public static const CHAR_ATTACK_COMPLETE:String = "charAttackComplete";
        public static const CHAR_COUNTER:String = "charCounter";
        public static const CHAR_HURT:String = "charHurt";
        public static const CHAR_GRABBED:String = "charGrabbed";
        public static const CHAR_TRANSFORM:String = "charTransform";
        public static const CHAR_KO_DEATH:String = "charKODeath";
        public static const CHAR_KO_POINT:String = "charKOPoint";
        public static const CHAR_GUARD_HIT:String = "charShieldHit";
        public static const CHAR_POWER_GUARD_HIT:String = "charPowerShieldHit";
        public static const PROJ_X_DECAY_COMPLETE:String = "projXDecayComplete";
        public static const PROJ_DESTROYED:String = "projDestroyed";
        public static const PROJ_COLLIDE:String = "projCollide";
        public static const REVERSE:String = "reverse";
		static public const KEY_PRESSED:String = "keyPressed";
		static public const KEY_RELEASED:String = "keyReleased";
		
		public function UMIBEvent(type:String, eventData:Object, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
			_data = (eventData) ? (eventData) : ({ });
		}
		
		public function get data():Object
		{
			return _data;
		}
	}

}