package input 
{
	import flash.display.DisplayObject;
	import input.Key;
	/**
	 * Controller handler. Handles controller settings. 
	 * @author Psycho
	 */
	public final class Gamepad extends Object
	{
		private const _LOGID:String = "Gamepad";
		
		static public const NULL_CONTROLS:Object = { LEFT: 0, UP: 0, RIGHT: 0, DOWN: 0, C_LEFT: 0, C_UP: 0, C_RIGHT: 0, C_DOWN: 0, CROSS: 0, SQUARE: 0, CIRCLE: 0, TRIANGLE: 0, L1: 0, L2: 0, L3: 0, R1: 0, R2: 0, R3: 0, START: 0, SELECT: 0, HOME: 0 };
		static public const P1_DEFAULT:Object = { LEFT: Key.LEFT, UP: Key.UP, RIGHT: Key.RIGHT, DOWN: Key.DOWN, C_LEFT: 0, C_UP: 0, C_RIGHT: 0, C_DOWN: 0, CROSS: Key.A, SQUARE: Key.S, CIRCLE: Key.D, TRIANGLE: Key.F, L1: Key.Q, L2: Key.W, L3: Key.E, R1: Key.Z, R2: Key.X, R3: Key.C, START: Key.ENTER, SELECT: Key.SPACEBAR, HOME: Key.ONE };
		
		public var CONTROLLER_ID:String = "";
		public var LEFT:uint;
		public var UP:uint;
		public var RIGHT:uint;
		public var DOWN:uint;
		public var C_LEFT:uint;
		public var C_UP:uint;
		public var C_RIGHT:uint;
		public var C_DOWN:uint;
		public var CROSS:uint;
		public var SQUARE:uint;
		public var CIRCLE:uint;
		public var TRIANGLE:uint;
		public var L1:uint;
		public var L2:uint;
		public var L3:uint;
		public var R1:uint;
		public var R2:uint;
		public var R3:uint;
		public var START:uint;
		public var SELECT:uint;
		public var HOME:uint;
		public var controlObj:Object = new Object();
		
		/**
		 * Creates a new controller object, and saves it.
		 * @param	controls the new Object{} that holds the new controller's settings.
		 */
		public function Gamepad(controls:Object, id:String) 
		{
			setControls(controls);
			CONTROLLER_ID = id;
		}
		
		/**
		 * Changes a key's mapping to whatever the user inputs.
		 * @param	key The controller object to change.
		 * @param	num The key that is pressed.
		 */
		public function setKey(key:String, num:uint) :void
		{
			this[key] = num;
		}
		
		/**
		 * returns the referenced controller object.
		 * @return
		 */
		public function getControls() :Object
		{
			controlObj.LEFT = LEFT;
			controlObj.UP = UP;
			controlObj.RIGHT = RIGHT;
			controlObj.DOWN = DOWN;
			controlObj.C_LEFT = C_LEFT;
			controlObj.C_UP = C_UP;
			controlObj.C_RIGHT = C_RIGHT;
			controlObj.C_DOWN = C_DOWN;
			controlObj.CROSS = CROSS;
			controlObj.SQUARE = SQUARE;
			controlObj.CIRCLE = CIRCLE;
			controlObj.TRIANGLE = TRIANGLE;
			controlObj.L1 = L1;
			controlObj.L2 = L2;
			controlObj.L3 = L3;
			controlObj.R1 = R1;
			controlObj.R2 = R2;
			controlObj.R3 = R3;
			controlObj.START = START;
			controlObj.SELECT = SELECT;
			controlObj.HOME = HOME;
			
			return (controlObj);
		}
		
		/**
		 * saves/compiles controller settings as an object, for organization.
		 * @param	controls the controller object to be saved.
		 */
		public function setControls(controls:Object) :void
		{
			for (var prop:Object in controls)
			{
				this[prop] = controls[prop];
				
				if (this[prop] != null)
				{
				}
				else
				{
				}
			}
		}
		
		static public function plugIn():void
		{
			if (!Key.m_initialized) 
			{
				Key.init();
				Key.beginCapture(Main.STAGE);
				
			}
		}
		
		static public function unplug():void
		{
			if (Key.m_initialized)
			{
				Key.endCapture();
			}
		}
		
		public function reconnect(stage:DisplayObject):void
		{
			Key.endCapture();
			Key.init();
			Key.beginCapture(stage);
		}
		
		public function getKeyAlias(currentButtonDown:int, facingDirection:uint = 3):* 
		{
			if (facingDirection == 1)
			{
				if (currentButtonDown == LEFT) return "f";
				else if (currentButtonDown == RIGHT) return "b";
			}
			else if (facingDirection == 0)
			{
				if (currentButtonDown == LEFT) return "b";
				else if (currentButtonDown == RIGHT) return "f";
			}
			
			if (currentButtonDown == UP) return "u";
			else if (currentButtonDown == DOWN) return "d";
			else if (currentButtonDown == CROSS) return "lk";
			else if (currentButtonDown == CIRCLE) return "mk";
			else if (currentButtonDown == TRIANGLE) return "mp";
			else if (currentButtonDown == SQUARE) return "lp";
			else if (currentButtonDown == L1) return "hk";
			else if (currentButtonDown == L2) return "k3";
			else if (currentButtonDown == R1) return "hp";
			else if (currentButtonDown == R2) return "p3";
			else if (currentButtonDown == C_UP) return "cu";
			else if (currentButtonDown == C_DOWN) return "cd";
			else return "key pressed does not have an alias";
		}
		
		public function get isPressingAnyButton():Boolean
		{
			return Key.Any();
		}
		
		public function get currentButtonDown():int
		{
			return Key.currentKeyDown();
		}
		
		public function get isPressingLeft():Boolean
		{
			return Key.isDown(LEFT);
		}
		
		public function get isPressingUp():Boolean
		{
			return Key.isDown(UP);
		}
		
		public function get isPressingRight():Boolean
		{
			return Key.isDown(RIGHT);
		}
		
		public function get isPressingDown():Boolean
		{
			return Key.isDown(DOWN);
		}
		
		public function get isPressingCLeft():Boolean
		{
			return Key.isDown(C_LEFT);
		}
		
		public function get isPressingCUp():Boolean
		{
			return Key.isDown(C_UP);
		}
		
		public function get isPressingCRight():Boolean
		{
			return Key.isDown(C_RIGHT);
		}
		
		public function get isPressingCDown():Boolean
		{
			return Key.isDown(C_DOWN);
		}
		
		public function get isPressingCross():Boolean
		{
			return Key.isDown(CROSS);
		}
		
		public function get isPressingSquare():Boolean
		{
			return Key.isDown(SQUARE);
		}
		
		public function get isPressingCircle():Boolean
		{
			return Key.isDown(CIRCLE);
		}
		
		public function get isPressingTriangle():Boolean
		{
			return Key.isDown(TRIANGLE);
		}
		
		public function get isPressingL1():Boolean
		{
			return Key.isDown(L1);
		}
		
		public function get isPressingL2():Boolean
		{
			return Key.isDown(L2);
		}
		
		public function get isPressingL3():Boolean
		{
			return Key.isDown(L3);
		}
		
		public function get isPressingR1():Boolean
		{
			return Key.isDown(R1);
		}
		
		public function get isPressingR2():Boolean
		{
			return Key.isDown(R2);
		}
		
		public function get isPressingR3():Boolean
		{
			return Key.isDown(R3);
		}
		
		public function get isPressingStart():Boolean
		{
			return Key.isDown(START);
		}
		
		public function get isPressingSelect():Boolean
		{
			return Key.isDown(SELECT);
		}
		
		public function get isPressingHome():Boolean
		{
			return Key.isDown(HOME);
		}
	}
}