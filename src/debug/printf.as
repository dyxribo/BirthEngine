package debug
{
	
	/**
	 * Writes the string pointed by format to the standard output (flash debugger). If format includes format specifiers (subsequences beginning with %), the additional arguments following format are formatted and inserted in the resulting string replacing their respective specifiers.
	 * @author Psycho
	 * fireman.fg@gmail.com
	 */
	
	 /**
	  * 
	  * @param	format string that contains the text to be written to the flash debugger. It can optionally contain embedded format specifiers that are replaced by the values specified in subsequent additional arguments and formatted as requested. 
	  * @param	...rest additional args
	  */
	public function printf(format:String, ...rest):void
	{
		if (!format) format = "null";
		if (rest)
		{
			var specifiers:Array = format.match(/%[i|d|u|U|o|O|x|X|c|C|s|S|f|F|n|N|l|L|b|B|%]/g);
			
			for (var i:int = 0; i < specifiers.length; i++)
			{
				format = format.replace(specifiers[i], fvalue.evaluate(specifiers[i], rest[i]));
				if (specifiers[i] == "%%") rest.unshift("");
			}
		}
		Main.CONSOLE.appendOutput(format);	
	}
}