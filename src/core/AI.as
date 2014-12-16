package core 
{
	import enums.CPUState;
	import enums.CState;
	/**
	 * ...
	 * @author Psycho
	 */
	public class AI extends Object
	{
		private const MAX_LAYDOWN_TIME:uint = 500;
		private const RIGHT:uint = 0;
		private const LEFT:uint = 1;
		
		private var _enemy:Character;
		private var _character:Character;
		private var _level:uint;
		private var _hesitation:uint;
		private var _action:uint;
		private var _cpuState:int;
		private var _actionHistory:Vector.<uint>;
		private var _actionQueue:Vector.<uint>;
		
		// Physics, States, & Logic
		private var _layDownDelay:uint;
		private var _layDownTime:uint;
		
		public function AI(target:Character)
		{
			_enemy = (_character == GameState.playerOne) ? GameState.playerTwo : GameState.playerOne;
			trace("enemy is CPU: " +_enemy.isCPU);
			_character = target;
			_layDownDelay = 250;
			_layDownTime = 0;
			_hesitation = 5;
			
			trace("CPU present!");
		}
		
		public function updateVisuals():void 
		{
			if (GameState.matchStarted) checkState();
		}
		
		private function checkState():void 
		{
			if (_character.isOnGround)
			{
				if (_action == CState.JUMP_FALLING) setState(CState.LAND);
				if (_action == CState.LAND) setState(CState.IDLE); 
				if (_action == CState.IDLE) setCPUState(CPUState.FORCE_CROUCH);
			}
			else // if (!_character.isOnGround)
			{
				if (_character.gravity > 0 && _action == CState.JUMP_RISING) setState(CState.JUMP_FALLING);
			}
		}
		
		public function updateLogic():void 
		{
			if (_cpuState == CPUState.IDLE)
			{
				
			}
			else if (_cpuState == CPUState.CHASE)
			{
				
			}
			else if (_cpuState == CPUState.EVADE)
			{
				
			}
			else if (_cpuState == CPUState.ATTACK)
			{
				
			}
			else if (_cpuState == CPUState.GUARD)
			{
				
			}
			else if (_cpuState == CPUState.GRAB)
			{
				
			}
			else if (_cpuState == CPUState.FORCE_JUMP)
			{
				if (_character.isOnGround) jump();
			}
			else if (_cpuState == CPUState.FORCE_WALK)
			{
				if (_character.isOnGround) walk();
			}
			else if (_cpuState == CPUState.FORCE_RUN)
			{
				if (_character.isOnGround) run();
			}
			else if (_cpuState == CPUState.FORCE_CROUCH)
			{
				if (_character.isOnGround) crouch();
			}
		}
		
		private function crouch():void 
		{
			_character.playAnimation("crouch");
		}
		
		private function run():void 
		{
			
		}
		
		private function walk():void 
		{
			if (_character.facingDirection == 0)
			{
				_character.playAnimation("walk");
				_character.x += _character.walkSpeed;
			}
			else
			{
				_character.playAnimation("walk_back");
				_character.x -= _character.walkSpeed;
			}
		}
		
		private function jump():void 
		{
			_character.gravity = -_character.jumpSpeed;
			_character.y -= _character.jumpSpeed;
			
			_character.isOnGround = false;
			setState(CState.JUMP_RISING);
		}
		
		private function setState(stateID:uint):void
		{
			_action = stateID;
			trace("CPU_" + CState.toString(_action));
		}
		
		private function setCPUState(stateID:int):void 
		{
			_cpuState = stateID;
			trace("CPU_" + CPUState.toString(_cpuState));
		}
	}

}