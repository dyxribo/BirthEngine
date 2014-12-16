package core 
{
	import core.Animation;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import utils.PsychoUtils;
	import enums.Resources;
	
	/**
	 * ...
	 * @author Psycho
	 */
	public class Arena extends Sprite
	{
		private var _name:String;
		private var _backGround:Animation;
		private var _foreGround:Animation;
		private var _terrain:Bitmap;
		private var _terrainRect:Rectangle;
		
		public function Arena(name:String, arenaTileSheet:BitmapData ) 
		{
			super();
			_name = name;
			_terrain = new Bitmap(Resources.spriteSheets[name]);
			//_backGround = new Animation(name+"BG", this, 1, 1, false);
			//_foreGround = new Animation(name+"FG", this, 1, 1, false);
			
			_terrainRect = new Rectangle(0, 0, _terrain.width, (_terrain.height / 4) * 3);
			
			addEventListener(Event.ADDED_TO_STAGE, initStage);
			addEventListener(Event.ADDED_TO_STAGE, updateVisuals);
		}
		
		private function initStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, initStage);
			
			//addChild(_backGround);
			//addChild(_foreGround);
			addChild(_terrain);
			
			PsychoUtils.centerDisplayObject(_terrain, stage);
			//PsychoUtils.centerDisplayObject(_backGround, stage);
			//PsychoUtils.centerDisplayObject(_foreGround, stage);
		}
		
		public function updateVisuals(e:Event = null):void
		{
			//_backGround.play();
			//_foreGround.play();
			
			_terrain.y = stage.stageHeight - _terrain.height;
			_terrainRect.y = _terrain.y;
			//_terrain.play();
		}
		
		public function get NAME():String
		{
			return _name;
		}
		
		public function get BG():Animation
		{
			return _backGround;
		}
		
		public function get FG():Animation
		{
			return _foreGround;
		}
		
		public function get terrainRect():Rectangle
		{
			return _terrainRect;
		}
		
		public function get terrain():Bitmap
		{
			return _terrain;
		}
	}

}