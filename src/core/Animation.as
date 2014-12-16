package core 
{
	import enums.Resources;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * A high performance animation.
	 * @author Psycho
	 */
	public class Animation extends Bitmap
	{
		private var _animationTileSheet:BitmapData;
		
		private var _name:String;
		private var _container:DisplayObjectContainer;
		private var _currentIndex:uint;
		private var _currentFrame:int;
		private var _totalFrames:uint;
		private var _frameDelay:uint;
		private var _frameBounds:Rectangle;
		private var _spriteOriginPoint:Point;
		private var _isLoop:Boolean;
		private var _isFinished:Boolean;
		
		public function Animation(name:String, parent:DisplayObjectContainer, totalFrames:uint, fps:uint, isLoop:Boolean) 
		{
			super();
			
			_name = name;
			_animationTileSheet = Resources.spriteSheets[parent["NAME"].toLowerCase()];
			_container = parent;
			_totalFrames = totalFrames - 1;
			_frameDelay = (Main.FRAMERATE / fps);
			_isLoop = isLoop;
			
			_currentFrame = 0;
			_currentIndex = 0;
			_spriteOriginPoint = new Point(0, 0);
			_frameBounds = new Rectangle(0, 0, 0, 0);
			this.bitmapData = new BitmapData(150, 300, true, 0x000000);
		}
		
		public function prevFrame():void
		{
			_currentIndex = 0;
			
			_frameBounds.width = Resources.animationData[_container["NAME"].toLowerCase()][_name+_currentFrame].w;
			_frameBounds.height = Resources.animationData[_container["NAME"].toLowerCase()][_name+_currentFrame].h;
			_frameBounds.x = Resources.animationData[_container["NAME"].toLowerCase()][_name+_currentFrame].x;
			_frameBounds.y = Resources.animationData[_container["NAME"].toLowerCase()][_name+_currentFrame].y;
			
			
			bitmapData.copyPixels(_animationTileSheet, _frameBounds, _spriteOriginPoint);
		}
		
		public function nextFrame():void
		{
			if (_currentIndex == _frameDelay)
			{
				if (_currentFrame != _totalFrames) 
				{
					++_currentFrame; 
					_currentIndex = 0;
				}
				else
				{
					if (!_isLoop) 
					{
						_isFinished = true;
						return;
					}
					restart();
				}
			}
			else
			{
				++_currentIndex;
			}
			
			bitmapData.lock();
			_frameBounds.width = Resources.animationData[_container["NAME"].toLowerCase()][_name+_currentFrame].w;
			_frameBounds.height = Resources.animationData[_container["NAME"].toLowerCase()][_name+_currentFrame].h;
			_frameBounds.x = Resources.animationData[_container["NAME"].toLowerCase()][_name+_currentFrame].x;
			_frameBounds.y = Resources.animationData[_container["NAME"].toLowerCase()][_name+_currentFrame].y;
			bitmapData.copyPixels(_animationTileSheet, _frameBounds, _spriteOriginPoint);
			bitmapData.unlock();
		}
		
		public function set frames(val:uint):void
		{
			_totalFrames = val;
		}
		
		public function set fps(val:uint):void
		{
			_frameDelay = (Main.FRAMERATE / val);
		}
		
		public function get isLoop():Boolean
		{
			return _isLoop;
		}
		
		public function set isLoop(val:Boolean):void
		{
			_isLoop = val;
		}
		
		public function get isFinished():Boolean
		{
			return _isFinished;
		}
		
		public function set originPoint(val:Point):void
		{
			_spriteOriginPoint = val;
		}
		
		public function play():void 
		{
			nextFrame();
		}
		
		public function restart():void 
		{
			_currentFrame = 0;
			_currentIndex = 0;
			_isFinished = false;
		}
	}

}