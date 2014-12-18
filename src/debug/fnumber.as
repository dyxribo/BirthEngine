package debug 
{
	/**
	 * ...
	 * @author Psycho
	 */
	public class fnumber 
	{
		static public function toFloat(n:Number):String
		{
			return String(Math.round(n * 100) / 100);
		}
		
		static public function toOctal(n:Number):String
		{
			var retString:String = "";
			retString = n.toString(8);
			
			retString = retString + "0";
			
			return retString;
		}	
		
		static public function toHex(n:Number):String
		{
			var retString:String = "";
			retString = n.toString(16);
			
			while (retString.length < 8) 
			{
				retString = "0" + retString;
			}
			trace("ret: " + n);
			return retString;
		}
		
		static public function toUpperCase(n:*):String
		{
			return String(n).toUpperCase();
		}	
		
		static public function toCharacter(s:String):String
		{
			return s.substr(0, 1);
		}
	}
}