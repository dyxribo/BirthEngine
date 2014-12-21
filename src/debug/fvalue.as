package debug
{
	/**
	 * ...
	 * @author Psycho
	 */
	public class fvalue 
	{
		static public function evaluate(specifier:String, val:*):*
		{
			switch (specifier)
			{
				case "%i":
				case "%d":
					return int(val);
					
				case "%u":
					return uint(val);
					
				case "%U":
					return uint(val).toString().toUpperCase();
					
				case "%o":
					return fvalue.toOctal(val);
					
				case "%O": 
					return fvalue.toOctal(val).toUpperCase();
					
				case "%x":
					return fvalue.toHex(val);
					
				case "%X":
					return fvalue.toHex(val).toUpperCase();
					
				case "%c":
					return fvalue.toCharacter(val);
					
				case "%C":
					return fvalue.toCharacter(val).toUpperCase();
					
				case "%s":
					return String(val);
					
				case "%S":
					return String(val).toUpperCase();
					
				case "%n":
					return (val as Number);
					
				case "%N":
					return (val as Number);
					
				case "%l":
					return fvalue.toFloat(val);
					
				case "%L":
					return fvalue.toFloat(val).toUpperCase();
					
				case "%b":
					return val;
					
				case "%B":
					return (val == true) ? "TRUE" : "FALSE";
					
				case "%%":
					return "%";
					
				default: 
					return "<invalid specifier>";
			}
		}
		
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