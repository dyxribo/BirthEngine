package utils 
{
	import core.GameState;
	import com.greensock.TweenLite;
	import core.Character;
	import debug.printf;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Psycho
	 */
	public class VirtualCamera extends Sprite
	{
		public const NORMAL_MODE:String = "normal";
		public const ZOOM_MODE:String = "zoom";
		public const ARENA_MODE:String = "zoom";
		public var CAMERA_MODE:String;
		
		private var _ROOT:Sprite;
		private var _PARENT:Sprite;
		private var _HUD:MovieClip;
		private var _originalWidth:int;
		private var _originalHeight:uint;
		private var _cameraBounds:Rectangle;
		private var _xSpeed:uint;
		private var _ySpeed:uint;
		private var _cameraCenter:Number;
		private var _zoomSpeed:Number;
		private var _players:Vector.<Character>;
		private var _arenaBounds:Rectangle;
		private var _hitBounds:Boolean;
		private var _cameraResized:Boolean;
		
		/**
		 * 
		 * @param	camData { parent, HUD, width, height, bounds, xSpeed, ySpeed, zoomSpeed, playerOne, playerTwo }
		 */
		public function VirtualCamera(camData:Object) 
		{
			_ROOT = camData.root;
			_PARENT = camData.parent;
			_HUD = camData.HUD;
			_originalWidth = camData.width;
			_originalHeight = camData.height;
			_cameraBounds = camData.bounds;
			_arenaBounds = camData.stageBounds;
			_xSpeed = camData.xSpeed;
			_ySpeed = camData.ySpeed;
			_zoomSpeed = camData.zoomSpeed;
			_players = new Vector.<Character>();
			_players.push(camData.playerOne, camData.playerTwo);
			
			x = y = _ROOT.x = _ROOT.y = 0;
			
			//graphics.beginFill(0x000000, .1);
			//graphics.drawRect(0, 0, _originalWidth, _originalHeight);
			//graphics.endFill();
			
			width = _originalWidth;
			height = _originalHeight;
		}
		
		public function PERFORMALL():void
		{
			updateCameraMode();
			updateCameraView();
		}
		
		private function updateCameraMode():void 
		{
			if (CAMERA_MODE == NORMAL_MODE)
			{
				if (width != _originalWidth || height != _originalHeight || _cameraResized)
				{
					TweenLite.to(this, _zoomSpeed, { width: _originalWidth, height: _originalHeight } );
					_cameraResized = false;
				}
			}
			else if (CAMERA_MODE == ZOOM_MODE)
			{
				if (!_cameraResized)
				{
					TweenLite.to(this, _zoomSpeed, { width: _originalWidth / 1.5, height: _originalHeight / 1.5 } );
					_cameraResized = true;
				}
			}
			else if (CAMERA_MODE == ARENA_MODE)
			{
				if (width != _originalWidth || height != _originalHeight || _cameraResized)
				{
					TweenLite.to(this, _zoomSpeed, { width: _arenaBounds.width, height: _arenaBounds.height  } );
					_cameraResized = false;
				}
			}
		}
		
		private function updateCameraView():void 
		{
			if (CAMERA_MODE == ZOOM_MODE)
			{
			}
			else if (CAMERA_MODE == NORMAL_MODE)
			{
				x = (GameState.playerOne.x + GameState.playerTwo.x) / 2;
				y = (GameState.playerOne.y + GameState.playerTwo.y) / 2;
				
				if (!_hitBounds) 
				{
					_PARENT.x = -x + (_originalWidth / 2);
					_PARENT.y = -y + (_originalHeight / 2);
				}
				else
				{
					_PARENT.x = _PARENT.x;
					_PARENT.y = _PARENT.y;
				}
				
				if ((x + (_originalWidth / 2) <= _arenaBounds.x) || (((x + width) - (_originalWidth/2)) >= (_arenaBounds.x + _arenaBounds.width) / 2))
				{
					_hitBounds = true;
				}
				else
				{
					_hitBounds = false;
				}
			
				
			}
		}
		
		public function set xPos(val:Number):void
		{
			x = val;
			_PARENT.x = -x + (_originalWidth / 2);
		}
		
		public function set yPos(val:Number):void
		{
			y = val;
			_PARENT.y = -y + (_originalHeight / 2);
		}
		
		public function destroy():void
		{
			
		}
		
		public function hitStunShake():void 
		{
			var hitstun:int = 20;
			var randPos:Number = Math.round(Math.random() * 2);
			if (hitstun)
			{
				x = x + randPos;
                y = y + randPos;
			}
		}
	}
}