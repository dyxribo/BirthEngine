package core 
{
	import core.AI;
	import core.Animation;
	import debug.log;
	import debug.println;
	import enums.CState;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import input.Gamepad;
	/**
	 * ...
	 * @author Psycho
	 */
	public class Character extends Sprite
	{
		private const LOG_ID:String = "Character";
		
		private const RIGHT:uint = 0;
		private const LEFT:uint = 1;
		private const MAX_COMBO_INTERVAL:uint = 250;
		private const MAX_LAYDOWN_TIME:uint = 500;
		
		private var _playerID:uint;
		private var _name:String;
		private var _initialHealth:uint;
		
		// Stats
		private var _health:Number;
		private var _ki:Number;
		private var _defaultGravity:Number;
		private var _gravity:Number;
		private var _weight:Number;
		private var _jumpSpeed:Number;
		private var _walkSpeed:Number;
		private var _runSpeed:Number;
		private var _attackPwr:Number;
		private var _specAttack:Number;
		private var _defense:Number;
		private var _specDefense:Number;
		private var _endurance:Number;
		private var _specEndurance:Number;
		private var _modifier:Number;
		
		// Animations
		private var _comboDictionary:Dictionary;
		private var _comboInterval:uint;
		private var _pressedKeys:Array;
		private var _currentAnimation:Animation;
		private var _numAnimations:uint;
		private var _animations:Object;
		private var _animationData:Object;
		private var _spriteSheet:BitmapData;
		
		// Physics, States, & Logic
		private var _CPU:AI;
		private var _isCPU:Boolean;
		private var _cpuLevel:uint;
		private var _currentState:uint;
		private var _isOnGround:Boolean;
		private var _layDownDelay:uint;
		private var _layDownTime:uint;
		private var _canJump:Boolean;
		private var _canAirDash:Boolean;
		private var _canAttack:Boolean;
		private var _isAttacking:Boolean;
		private var _facingDirection:uint;
		private var _matchStarted:Boolean;
		
		// Gamepad
		private var _keyDelay:uint;
		private var _gamepad:Gamepad;
		private var _pressingAny:Boolean;
		private var _pressingLeft:Boolean;
		private var _pressingUp:Boolean;
		private var _pressingRight:Boolean;
		private var _pressingDown:Boolean;
		private var _pressingCLeft:Boolean;
		private var _pressingCUp:Boolean;
		private var _pressingCRight:Boolean;
		private var _pressingCDown:Boolean;
		private var _pressingCross:Boolean;
		private var _pressingSquare:Boolean;
		private var _pressingCircle:Boolean;
		private var _pressingTriangle:Boolean;
		private var _pressingL1:Boolean;
		private var _pressingL2:Boolean;
		private var _pressingL3:Boolean;
		private var _pressingR1:Boolean;
		private var _pressingR2:Boolean;
		private var _pressingR3:Boolean;
		private var _pressingStart:Boolean;
		private var _pressingSelect:Boolean;
		private var _pressingHome:Boolean;
		
		
		/**
		 * Creates a new character object.
		 * @param	spriteSheet The character's spritesheet image data.
		 * @param	spriteWidth The sprite width of this character.
		 * @param	spriteHeight The sprite height of this character.
		 * @param	information The character's stats.
		 */
		public function Character(spriteSheet:BitmapData, information:Object, animationData:Object)
		{
			_gravity = 1;
			_spriteSheet = spriteSheet;
			_animationData = animationData;
			_playerID = information.playerID;
			_gamepad = information.controller;
			_isCPU = information.isCPU;
			_cpuLevel = information.cpuLevel;
			_name = information.name;
			_health = information.hp;
			_ki = information.ki;
			_defaultGravity = _gravity;
			_weight = information.weight;
			_jumpSpeed = information.jumpspeed;
			_walkSpeed = information.walkspeed;
			_runSpeed = information.runspeed;
			_attackPwr = information.attackpower;
			_specAttack = information.specattack;
			_defense = information.defense;
			_specDefense = information.specdefense;
			_endurance = information.endurance;
			_specEndurance = information.specendurance;
			_modifier = information.modifier;
			_currentState = CState.IDLE;
			_facingDirection = 1 * _playerID;
			_numAnimations = 0;
			_comboInterval = 0;
			_layDownDelay = 250;
			_layDownTime = 0;
			_keyDelay = 5;
			_comboDictionary = new Dictionary();
			_pressedKeys = [];
			
			if (_isCPU)
			{
				_CPU = new AI(this);
			}
			
			super();
		}
		
		/**
		 * Updates the logic and visuals of the character.
		 */
		public function update():void
		{
			updateVisuals();
			if (GameState.matchStarted) updateLogic();
		}
		
		public function updateVisuals():void 
		{	
			if (_currentAnimation && !_currentAnimation.isFinished) _currentAnimation.play();
			if (!_CPU) checkState();
			else _CPU.updateVisuals();
		}
		
		private function updateLogic():void 
		{
			if (_isCPU) _CPU.updateLogic();
			else
			{
				checkGamepadPresses();
				checkGamepad();
			}
		}
		
		private function checkState():void 
		{
			if (_isOnGround)
			{
				if (_currentState == CState.IDLE) 
				{
					if (_currentAnimation != _animations.idle) playAnimation("idle");
				}
				else if (_currentState == CState.CROUCH) 
				{
					if (_currentAnimation != _animations.crouch) playAnimation("crouch");
				}
				else if (_currentState == CState.LYING_DOWN) 
				{
					if (_layDownTime < _layDownDelay) 
					{
						//if (_currentAnimation != _animations.lie_down) playAnimation("lie_down");
						++_layDownTime;
						return;
					}
					
					if (_layDownTime >= MAX_LAYDOWN_TIME)
					{
						_layDownTime = 0;
						setState(CState.GET_UP);
					}
				}
			}
			else // if (!_isOnGround)
			{
				if (_currentState == CState.JUMP_RISING)
				{
					if (_gravity > 0) 
					{
						if (_currentState != CState.JUMP_FALLING) setState(CState.JUMP_FALLING);
					}
				}
			}
		}
		
		private function setState(state:uint):void 
		{
			_currentState = state;
			println(CState.toString(_currentState));
			//UMIBEventManager.dispatchEvent(new UMIBEvent(UMIBEvent.STATE_CHANGE));
		}
		
		private function checkGamepadPresses():void 
		{
			_pressingAny = _gamepad.isPressingAnyButton;
			_pressingLeft = _gamepad.isPressingLeft;
			_pressingUp = _gamepad.isPressingUp;
			_pressingRight = _gamepad.isPressingRight;
			_pressingDown = _gamepad.isPressingDown;
			_pressingCLeft = _gamepad.isPressingCLeft;
			_pressingCUp = _gamepad.isPressingCUp;
			_pressingCRight = _gamepad.isPressingCRight;
			_pressingCDown = _gamepad.isPressingCDown;
			_pressingCross = _gamepad.isPressingCross;
			_pressingSquare = _gamepad.isPressingSquare;
			_pressingCircle = _gamepad.isPressingCircle;
			_pressingTriangle = _gamepad.isPressingTriangle;
			_pressingL1 = _gamepad.isPressingL1;
			_pressingL2 = _gamepad.isPressingL2;
			_pressingL3 = _gamepad.isPressingL3;
			_pressingR1 = _gamepad.isPressingR1;
			_pressingR2 = _gamepad.isPressingR2;
			_pressingR3 = _gamepad.isPressingR3;
			_pressingStart = _gamepad.isPressingStart;
			_pressingSelect = _gamepad.isPressingSelect;
			_pressingHome = _gamepad.isPressingHome;
		}
		
		private function checkGamepad():void 
		{
			if (_pressingAny)
			{
				if (getTimer() - _comboInterval > MAX_COMBO_INTERVAL) 
				{
					_pressedKeys = [];
					println( "input array cleared");
				}
				if (!_keyDelay) 
				{
					_comboInterval = getTimer();
					_pressedKeys.push(_gamepad.getKeyAlias(_gamepad.currentButtonDown, _facingDirection));
					println( _gamepad.getKeyAlias(_gamepad.currentButtonDown, _facingDirection));
					_keyDelay = 5;
					checkForCombo();
				}
				else --_keyDelay;
			}
			
			if (_isOnGround)
			{
				if (_currentState == CState.JUMP_FALLING) 
				{
					setState(CState.LAND);
				}
				if (_currentState == CState.LAND)
				{
					setState(CState.IDLE);
				}
				if (_currentState == CState.CROUCH)
				{
					if (!_pressingDown) 
					{
						_currentAnimation.restart();
						setState(CState.IDLE);
					}
				}
				if (_currentState == CState.IDLE)
				{
					if (_facingDirection == LEFT)
					{
						if (_pressingLeft) 
						{
							playAnimation("walk");
							x -= _walkSpeed;
						}
						if (_pressingRight)
						{
							//playAnimation("walk_backward");
							x += _walkSpeed;
						}
					}
					if (_facingDirection == RIGHT)
					{
						if (_pressingLeft) 
						{
							//playAnimation("walk_backward");
							x -= _walkSpeed;
						}
						else if (_pressingRight)
						{
							playAnimation("walk");
							x += _walkSpeed;
						}
					}
					if (_pressingDown)
					{
						setState(CState.CROUCH);
					}
					if (_pressingUp)
					{
						jump();
					}
				}
				
				if (_currentState == CState.LYING_DOWN && !_layDownDelay)
				{
					if (_facingDirection == LEFT)
					{
						if (_pressingLeft) 
						{
							//playAnimation("walk");
							//x -= _walkSpeed;
						}
						if (_pressingRight)
						{
							//playAnimation("walk_backward");
							//x -= _walkSpeed;
						}
					}
					if (_facingDirection == RIGHT)
					{
						if (_pressingLeft) 
						{
							//playAnimation("walk_backward");
							//x += _walkSpeed;
						}
						else if (_pressingRight)
						{
							//playAnimation("walk");
							//x += _walkSpeed;
						}
					}
					if (_pressingUp)
					{
						setState(CState.GET_UP);
					}
					if (_pressingCross)
					{
						setState(CState.GET_UP_ATTACK);
					}
					if (!_pressingAny && !_layDownTime > MAX_LAYDOWN_TIME)
					{
						setState(CState.GET_UP);
					}
				}
			}
			else // if (!_isOnGround)
			{
				if (_currentState == CState.JUMP_RISING)
				{
					if (_currentAnimation != _animations.idle) playAnimation("idle");
				}
			}
		}
		
		private function jump():void 
		{
			_gravity = -_jumpSpeed;
			y -= _jumpSpeed;
			
			_isOnGround = false;
			setState(CState.JUMP_RISING);
		}
		
		private function checkForCombo():void 
		{
			var comboFound:String = "";
			for (var comboName:String in _comboDictionary)
			{
				if (_pressedKeys.join(" ").indexOf((_comboDictionary[comboName] as Array).join(" ")) > -1)
				{
					comboFound = comboName;
					println( comboName);
					break;
				}
			}
			
			if (comboFound != "") _pressedKeys = [];
		}
		
		public function registerCombo(comboName:String, comboKeys:Array):void
		{
			if (_comboDictionary[comboName])
			{
				println( "Can not register the combo \"" +  comboName + "\"; it already exists in the character's combo dictionary.\nCheck your registerCombo() calls.");
				return;
			}
			
			_comboDictionary[comboName] = comboKeys;
			println("The combo \"" + comboName + "\" was registered.");
		}
		
		public function addAnimation(name:String, numFrames:uint, fps:Number = 30, isLoop:Boolean = false):void
		{
			if (!_animations) _animations = new Object();
			
			if (_animations[name])
			{
				println( "An attempt to add the animation '" + name + "' to " + _name + "'s animation list (multiple times) was made! please check " + _name + "'s character.addAnimation() function list.");
				return;
			}
			
			var n_Animation:Animation = new Animation(name, this, numFrames, fps, isLoop);
			_animations[name] = n_Animation;
			++_numAnimations;
		}
		
		public function playAnimation(name:String):*
		{
			if (!_animations) 
			{
				println( "There are no animations present in " + _name + "'s character. please check " + _name + "'s character.addAnimation() function list.");
				return;
			}
			if (!_animations[name]) 
			{
				println( "An animation named " + name + " was not found in " + _name + "'s animation object. Please check " + _name + "'s character.addAnimation() function list.");
				return;
			}
			
			if (_currentAnimation)
			{
				if (_currentAnimation.name != name)
				{
					while (numChildren) removeChildAt(0);
					_currentAnimation = _animations[name];
					addChild(_currentAnimation);
					_currentAnimation.nextFrame();
					return;
				}
				else return _animations[name];
			}
			else
			{
				_currentAnimation = _animations[name];
				addChild(_currentAnimation);
			}
		}
		
		public function changeCharacter(spriteSheet:BitmapData, information:Object):void
		{
			
		}
		
		public function get matchStarted():Boolean
		{
			return _matchStarted;
		}
		
		public function set matchStarted(val:Boolean):void
		{
			_matchStarted = val;
		}
		
		public function get NAME():String
		{
			return _name;
		}
		
		public function set NAME(val:String):void
		{
			_name = val;
		}
		
		public function get isCPU():Boolean
		{
			return _isCPU;
		}
		
		public function set isCPU(val:Boolean):void
		{
			_isCPU = val;
		}
		
		public function get facingDirection():uint
		{
			return _facingDirection;
		}
		
		public function set facingDirection(val:uint):void
		{
			_facingDirection = val;
		}
		
		public function get isOnGround():Boolean
		{
			return _isOnGround;
		}
		
		public function set isOnGround(val:Boolean):void
		{
			_isOnGround = val;
		}
		
		public function get canJump():Boolean
		{
			return _canJump;
		}
		
		public function set canJump(val:Boolean):void
		{
			_canJump = val;
		}
		
		public function get canAirDash():Boolean
		{
			return _canAirDash;
		}
		
		public function set canAirDash(val:Boolean):void
		{
			_canAirDash = val;
		}
		
		public function get canAttack():Boolean
		{
			return _canAttack;
		}
		
		public function set canAttack(val:Boolean):void
		{
			_canAttack = val;
		}
		
		public function get isAttacking():Boolean
		{
			return _currentState == CState.ATTACKING;
		}
		
		public function get isDizzy():Boolean
		{
			return _currentState == CState.DIZZY;
		}
		
		public function get isParalyzed():Boolean
		{
			return _currentState == CState.PARALYZED;
		}
		
		public function get isGuarding():Boolean
		{
			return _currentState == CState.GUARDING;
		}
		
		public function get health():Number
		{
			return _health;
		}
		
		public function set health(val:Number):void
		{
			_health = val;
		}
		
		public function get ki():Number
		{
			return _ki;
		}
		
		public function set ki(val:Number):void
		{
			_ki = val;
		}
		
		public function get gravity():Number
		{
			return _gravity;
		}
		
		public function set gravity(val:Number):void
		{
			_gravity = val;
		}
		
		public function get weight():Number
		{
			return _weight;
		}
		
		public function set weight(val:Number):void
		{
			_weight = val;
		}
		
		public function get jumpSpeed():Number
		{
			return _jumpSpeed;
		}
		
		public function set jumpSpeed(val:Number):void
		{
			_jumpSpeed = val;
		}
		
		public function get walkSpeed():Number
		{
			return _walkSpeed;
		}
		
		public function set walkSpeed(val:Number):void
		{
			_walkSpeed = val;
		}
		
		public function get runSpeed():Number
		{
			return _runSpeed;
		}
		
		public function set runSpeed(val:Number):void
		{
			_runSpeed = val;
		}
		
		public function get attackPwr():Number
		{
			return _attackPwr;
		}
		
		public function set attackPwr(val:Number):void
		{
			_attackPwr = val;
		}
		
		public function get specAttack():Number
		{
			return _specAttack;
		}
		
		public function set specAttack(val:Number):void
		{
			_specAttack = val;
		}
		
		public function get defense():Number
		{
			return _defense;
		}
		
		public function set defense(val:Number):void
		{
			_defense = val;
		}
		
		public function get specDefense():Number
		{
			return _specDefense;
		}
		
		public function set specDefense(val:Number):void
		{
			_specDefense = val;
		}
		
		public function get endurance():Number
		{
			return _endurance;
		}
		
		public function set endurance(val:Number):void
		{
			_endurance = val;
		}
		
		public function get specEndurance():Number
		{
			return _specEndurance;
		}
		
		public function set specEndurance(val:Number):void
		{
			_specEndurance = val;
		}
		
		public function get modifier():Number
		{
			return _modifier;
		}
		
		public function set modifier(val:Number):void
		{
			_modifier = val;
		}
		
		public function get comboDictionary():Dictionary
		{
			return _comboDictionary;
		}
		
		public function set comboDictionary(val:Dictionary):void
		{
			_comboDictionary = val;
		}
		
		public function get currentAnimation():Animation
		{
			return _currentAnimation;
		}
		
		public function set currentAnimation(val:Animation):void
		{
			_currentAnimation = val;
		}
		
		public function get numAnimations():uint
		{
			return _numAnimations;
		}
		
		public function set numAnimations(val:uint):void
		{
			_numAnimations = val;
		}
		
		public function get animations():Object
		{
			return _animations;
		}
		
		public function set animations(val:Object):void
		{
			_animations = val;
		}
		
		public function get animationData():Object
		{
			return _animationData;
		}
		
		public function set animationData(val:Object):void
		{
			_animationData = val;
		}
		
		public function get spriteSheet():BitmapData
		{
			return _spriteSheet;
		}
		
		public function set spriteSheet(val:BitmapData):void
		{
			_spriteSheet = val;
		}
	}
}