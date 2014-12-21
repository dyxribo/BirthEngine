package input 
{	
	import debug.printf;
	import events.UMIBEvent;
	import events.UMIBEventManager;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	/**
	 * Tool for AS3 to enable AS2-styled keyboard event behavior. Simply call Key.init() to initialize the class, and Key.beginCapture()/Key.endCapture() to start and end the keyboard event listeners respectively. Also included in this class are also all of the Flash key code values so you don't have to look them up.
	 */
	public class Key
	{
		private static var m_keyDown:Boolean;
		private static var m_currentKeyDown:int;
		private static var m_keyNameArray:Array;
		private static var m_pressedKeys:Array;
		private static var m_disabled:Boolean;
		public static var m_initialized:Boolean = false;
		private static var m_targetObject:DisplayObject;
		private static var m_captureStarted:Boolean;
		
		/**
		 * Initializes the Key class
		 */
		static public function init():void
		{
			m_keyNameArray = new Array();
			m_pressedKeys = new Array();
			m_disabled = false;
			m_initialized = true;
			m_targetObject = null;
			m_captureStarted = false;
		
			nameKeys();
			printf("Key class initialized!");
		}
		
		static public function getKeyName(key:Number):String 
		{
			if (!key) return "NONE";
			else return m_keyNameArray[key];
		}
		
		/**
		 * Starts capturing keyboard inputs within the supplied DisplayObject.
		 * @param	targetObject The object which will trigger the events when it is in focus.
		 */
		static public function beginCapture(targetObject:DisplayObject):void
		{
			if (!m_initialized)
			{
				printf("Error: Key.init() was never called!");
				return;
			}
			if (targetObject != null)
			{
				if (m_captureStarted)
				{
					endCapture();
				}
				m_targetObject = targetObject;
				m_targetObject.addEventListener(KeyboardEvent.KEY_DOWN, Key.keyDown);
				m_targetObject.addEventListener(KeyboardEvent.KEY_UP, Key.keyUp);
				m_targetObject.addEventListener(Event.DEACTIVATE,Key.resetKeys);
				m_targetObject.addEventListener(Event.ACTIVATE, Key.restartKeys);
				m_captureStarted = true;
				printf("Key class activated!");
			} else
			{
				printf("Error: null target passed to Key.as!");
			}
		}
		
		/**
		 * Stops capturing keyboard inputs
		 */
		static public function endCapture():void
		{
			if (!m_initialized)
			{
				printf("Error: Key.init() was never called!");
				return;
			}
			if (m_captureStarted)
			{
				m_targetObject.removeEventListener(KeyboardEvent.KEY_DOWN, Key.keyDown);
				m_targetObject.removeEventListener(KeyboardEvent.KEY_UP, Key.keyUp);
				m_targetObject.removeEventListener(Event.DEACTIVATE,Key.resetKeys);
				m_targetObject.removeEventListener(Event.ACTIVATE, Key.restartKeys);
				m_targetObject = null;
				m_captureStarted = false;
				resetKeys(null);
				printf("Key class deactivated.");
			} else
			{
				printf("Warning: attempt to end capture when it was never started!");
			}
		}
		
		/**
		 * Called when a key is pressed
		 * @param	e
		 */
		private static function keyDown(e:KeyboardEvent):void
		{
			Main.STAGE.dispatchEvent(new UMIBEvent(UMIBEvent.KEY_PRESSED, {key: e.keyCode}))
			m_keyDown = true;
			m_currentKeyDown = e.keyCode;
			if (!m_disabled)
				m_pressedKeys[e.keyCode] = true;
		}
		
		/**
		 * Called when a key is released
		 * @param	e
		 */
		private static function keyUp(e:KeyboardEvent):void
		{
			Main.STAGE.dispatchEvent(new UMIBEvent(UMIBEvent.KEY_RELEASED, {key: e.keyCode}))
			m_keyDown = false;
			if (!m_disabled) m_pressedKeys[e.keyCode] = false;
		}
		
		/**
		 * Forces all keyboard data to false. This is used when the current object listening for key presses loses focus, and prevents keys from getting "stuck".
		 * @param	e
		 */
		private static function resetKeys(e:Event = null):void
		{
			if (!m_initialized)
			{
				printf("Error, Key.init() was never called");
				return;
			}
			//Sets all key states to false
			for (var i:* in m_pressedKeys)
				m_pressedKeys[i] = false;
			m_disabled = true;
			m_keyDown = false;
		}
		
		/**
		 * Removes the disabled flag so that the object listening for key presses can receive events again once it regains focus
		 * @param	e
		 */
		private static function restartKeys(e:Event = null):void
		{
			m_disabled = false;
		}
		
		/**
		 * Returns the state of a key given its key code.
		 * @param	keyCode The the supplied key code.
		 * @return True if the key is pressed, false otherwise.
		 */
		static public function isDown(keyCode:Number):Boolean
		{
			return Boolean(!m_disabled && m_initialized && m_pressedKeys[keyCode] != undefined && m_pressedKeys[keyCode] != null && m_pressedKeys[keyCode] == true);
		}
		
		/**
		 * Returns whether or not any key on the keyboard is being pressed.
		 * @return
		 */
		static public function Any():Boolean
		{
			return m_keyDown;
		}
		
		static public function currentKeyDown():int
		{
			return m_currentKeyDown;
		}
		
		static public function wasReleased():Boolean 
		{
			return (m_keyDown == false);
		}
		
		//Key Code values
		static public const A:int = 65;
		static public const B:int = 66;
		static public const C:int = 67;
		static public const D:int = 68;
		static public const E:int = 69;
		static public const F:int = 70;
		static public const G:int = 71;
		static public const H:int = 72;
		static public const I:int = 73;
		static public const J:int = 74;
		static public const K:int = 75;
		static public const L:int = 76;
		static public const M:int = 77;
		static public const N:int = 78;
		static public const O:int = 79;
		static public const P:int = 80;
		static public const Q:int = 81;
		static public const R:int = 82;
		static public const S:int = 83;
		static public const T:int = 84;
		static public const U:int = 85;
		static public const V:int = 86;
		static public const W:int = 87;
		static public const X:int = 88;
		static public const Y:int = 89;
		static public const Z:int = 90;
		
		//NUMBERS
		static public const ZERO:int = 48;
		static public const ONE:int = 49;
		static public const TWO:int = 50;
		static public const THREE:int = 51;
		static public const FOUR:int = 52;
		static public const FIVE:int = 53;
		static public const SIX:int = 54;
		static public const SEVEN:int = 55;
		static public const EIGHT:int = 56;
		static public const NINE:int = 57;
		
		//NUMPAD
		static public const NUMPAD_0:int = 96;
		static public const NUMPAD_1:int = 97;
		static public const NUMPAD_2:int = 98;
		static public const NUMPAD_3:int = 99;
		static public const NUMPAD_4:int = 100;
		static public const NUMPAD_5:int = 101;
		static public const NUMPAD_6:int = 102;
		static public const NUMPAD_7:int = 103;
		static public const NUMPAD_8:int = 104;
		static public const NUMPAD_9:int = 105;
		static public const NUMPAD_MULTIPLY:int = 106;
		static public const NUMPAD_ADD:int = 107;
		static public const NUMPAD_ENTER:int = 108;
		static public const NUMPAD_SUBTRACT:int = 109;
		static public const NUMPAD_DECIMAL:int = 110;
		static public const NUMPAD_DIVIDE:int = 111;
		
		//FUNCTION KEYS
		static public const F1:int = 112;
		static public const F2:int = 113;
		static public const F3:int = 114;
		static public const F4:int = 115;
		static public const F5:int = 116;
		static public const F6:int = 117;
		static public const F7:int = 118;
		static public const F8:int = 119;
		static public const F9:int = 120;
		static public const F10:int = 121;
		static public const F11:int = 122;
		static public const F12:int = 123;
		static public const F13:int = 124;
		static public const F14:int = 125;
		static public const F15:int = 126;
		
		//SYMBOLS
		static public const COLON:int = 186;
		static public const EQUALS:int = 187;
		static public const UNDERSCORE:int = 189;
		static public const QUESTION_MARK:int = 191;
		static public const TILDE:int = 192;
		static public const OPEN_BRACKET:int = 219;
		static public const BACKWARD_SLASH:int = 220;
		static public const CLOSED_BRACKET:int = 221;
		static public const QUOTES:int = 222;
		static public const LESS_THAN:int = 188;
		static public const GREATER_THAN:int = 190;
		
		//OTHER KEYS		
		static public const BACKSPACE:int = 8;
		static public const TAB:int = 9;
		static public const CLEAR:int = 12;
		static public const ENTER:int = 13;
		static public const SHIFT:int = 16;
		static public const CONTROL:int = 17;
		static public const ALT:int = 18;
		static public const CAPS_LOCK:int = 20;
		static public const ESC:int = 27;
		static public const SPACEBAR:int = 32;
		static public const PAGE_UP:int = 33;
		static public const PAGE_DOWN:int = 34;
		static public const END:int = 35;
		static public const HOME:int = 36;
		static public const LEFT:int = 37;
		static public const UP:int = 38;
		static public const RIGHT:int = 39;
		static public const DOWN:int = 40;
		static public const INSERT:int = 45;
		static public const DELETE:int = 46;
		static public const HELP:int = 47;
		static public const NUM_LOCK:int = 144;
		
		static private function nameKeys():void 
		{
			//Letters
			m_keyNameArray[Key.A] = "A";
			m_keyNameArray[Key.B] = "B";
			m_keyNameArray[Key.C] = "C";
			m_keyNameArray[Key.D] = "D";
			m_keyNameArray[Key.E] = "E";
			m_keyNameArray[Key.F] = "F";
			m_keyNameArray[Key.G] = "G";
			m_keyNameArray[Key.H] = "H";
			m_keyNameArray[Key.I] = "I";
			m_keyNameArray[Key.J] = "J";
			m_keyNameArray[Key.K] = "K";
			m_keyNameArray[Key.L] = "L";
			m_keyNameArray[Key.M] = "M";
			m_keyNameArray[Key.N] = "N";
			m_keyNameArray[Key.O] = "O";
			m_keyNameArray[Key.P] = "P";
			m_keyNameArray[Key.Q] = "Q";
			m_keyNameArray[Key.R] = "R";
			m_keyNameArray[Key.S] = "S";
			m_keyNameArray[Key.T] = "T";
			m_keyNameArray[Key.U] = "U";
			m_keyNameArray[Key.V] = "V";
			m_keyNameArray[Key.W] = "W";
			m_keyNameArray[Key.X] = "X";
			m_keyNameArray[Key.Y] = "Y";
			m_keyNameArray[Key.Z] = "Z";
			
			//Numbers
			m_keyNameArray[Key.ZERO] = "0";
			m_keyNameArray[Key.ONE] = "1";
			m_keyNameArray[Key.TWO] = "2";
			m_keyNameArray[Key.THREE] = "3";
			m_keyNameArray[Key.FOUR] = "4";
			m_keyNameArray[Key.FIVE] = "5";
			m_keyNameArray[Key.SIX] = "6";
			m_keyNameArray[Key.SEVEN] = "7";
			m_keyNameArray[Key.EIGHT] = "8";
			m_keyNameArray[Key.NINE] = "9";
			
			//Numpad
			m_keyNameArray[Key.NUMPAD_0] = "0";
			m_keyNameArray[Key.NUMPAD_1] = "1";
			m_keyNameArray[Key.NUMPAD_2] = "2";
			m_keyNameArray[Key.NUMPAD_3] = "3";
			m_keyNameArray[Key.NUMPAD_4] = "4";
			m_keyNameArray[Key.NUMPAD_5] = "5";
			m_keyNameArray[Key.NUMPAD_6] = "6";
			m_keyNameArray[Key.NUMPAD_7] = "7";
			m_keyNameArray[Key.NUMPAD_8] = "8";
			m_keyNameArray[Key.NUMPAD_9] = "9";
			m_keyNameArray[Key.NUMPAD_MULTIPLY] = "Nmpd. *";
			m_keyNameArray[Key.NUMPAD_ADD] = "Nmpd. +";
			m_keyNameArray[Key.NUMPAD_ENTER] = "Nmpd. Ent.";
			m_keyNameArray[Key.NUMPAD_SUBTRACT] = "Nmpd. -";
			m_keyNameArray[Key.NUMPAD_DECIMAL] = "Nmpd. Deci";
			m_keyNameArray[Key.NUMPAD_DIVIDE] = "Nmpd. Divide";
			
			//Function Keys
			m_keyNameArray[Key.F1] = "F1";
			m_keyNameArray[Key.F2] = "F2";
			m_keyNameArray[Key.F3] = "F3";
			m_keyNameArray[Key.F4] = "F4";
			m_keyNameArray[Key.F5] = "F5";
			m_keyNameArray[Key.F6] = "F6";
			m_keyNameArray[Key.F7] = "F7";
			m_keyNameArray[Key.F8] = "F8";
			m_keyNameArray[Key.F9] = "F9";
			m_keyNameArray[Key.F10] = "F10";
			m_keyNameArray[Key.F11] = "F11";
			m_keyNameArray[Key.F12] = "F12";
			m_keyNameArray[Key.F13] = "F13";
			m_keyNameArray[Key.F14] = "F14";
			m_keyNameArray[Key.F15] = "F15";
			
			//SYMBOLS
			m_keyNameArray[Key.COLON] = ":";
			m_keyNameArray[Key.EQUALS] = "=";
			m_keyNameArray[Key.UNDERSCORE] = "_";
			m_keyNameArray[Key.QUESTION_MARK] = "?";
			m_keyNameArray[Key.TILDE] = "~";
			m_keyNameArray[Key.OPEN_BRACKET] = "[";
			m_keyNameArray[Key.BACKWARD_SLASH] = "\\";
			m_keyNameArray[Key.CLOSED_BRACKET] = "]";
			m_keyNameArray[Key.QUOTES] = "\"";
			m_keyNameArray[Key.LESS_THAN] = "<";
			m_keyNameArray[Key.GREATER_THAN] = ">";
			
			//OTHER KEYS		
			m_keyNameArray[Key.BACKSPACE] = "Backspace";
			m_keyNameArray[Key.TAB] = "Tab";
			m_keyNameArray[Key.CLEAR] = "Clear";
			m_keyNameArray[Key.ENTER] = "Enter";
			m_keyNameArray[Key.SHIFT] = "Shift";
			m_keyNameArray[Key.CONTROL] = "CTRL";
			m_keyNameArray[Key.ALT] = "ALT";
			m_keyNameArray[Key.CAPS_LOCK] = "Caps Lock";
			m_keyNameArray[Key.ESC] = "Esc";
			m_keyNameArray[Key.SPACEBAR] = "Spacebar";
			m_keyNameArray[Key.PAGE_UP] = "Page Up";
			m_keyNameArray[Key.PAGE_DOWN] = "Page Down";
			m_keyNameArray[Key.END] = "End";
			m_keyNameArray[Key.HOME] = "Home";
			m_keyNameArray[Key.LEFT] = "Left Arr.";
			m_keyNameArray[Key.UP] = "Up Arr.";
			m_keyNameArray[Key.RIGHT] = "Right Arr.";
			m_keyNameArray[Key.DOWN] = "Down Arr.";
			m_keyNameArray[Key.INSERT] = "Insert";
			m_keyNameArray[Key.DELETE] = "Delete";
			m_keyNameArray[Key.HELP] = "Help";
			m_keyNameArray[Key.NUM_LOCK] = "Num Lock";
		}
	}
}