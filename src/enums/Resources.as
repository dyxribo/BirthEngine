package enums 
{
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Psycho
	 */
	public class Resources 
	{
		static public var spriteSheets:Object;
		static public var animationData:Object;
		
		static public function addBitmapData(bitmap:Object):void
		{
			if (!spriteSheets) spriteSheets = { };
			if (!spriteSheets[bitmap.name]) spriteSheets[bitmap.name] = bitmap.data.bitmapData;
		}
		
		static public function addAnimData(animData:Object):void
		{
			if (!animationData) animationData = { };
			if (!animationData[animData.name]) animationData[animData.name] = (JSON.parse(animData.data));
		}
		
		static public function clear():void
		{
			spriteSheets = { };
			spriteSheets = null;
			
			animationData = { };
			animationData = null;
		}
	}
}