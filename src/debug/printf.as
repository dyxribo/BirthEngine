package debug 
{
	/**
	 * Writes the sdebug.printfrmat to the standard output (flash debugger). If format includes format specifiers (subsequences beginning with %), the additional arguments following format are formatted and inserted in the resulting string replacing their respective specifiers.
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
		var finalString:String = format;
		var firstString:String = "";
		var secondString:String = "";
		var currentSpecifier:String = "";
		var remainingSpecifiers:String = "";
		var currentSpecifierIndex:uint = 0;
		var specifierType:Class;
		var isUpperCase:Boolean;
		
		for (var i:int = 0; i < rest.length; i++)
		{
			var currentArg:* = rest[i];
			isUpperCase = false;
			currentSpecifierIndex = format.indexOf("%");
			firstString = format.slice(0, currentSpecifierIndex);
			secondString = format.slice(currentSpecifierIndex + 2);
			remainingSpecifiers = format.slice(currentSpecifierIndex, currentSpecifierIndex + 2);
			currentSpecifier = format.slice(currentSpecifierIndex, currentSpecifierIndex + 2);
			
			
			if (currentSpecifier == "%i") specifierType = int;
			else if (currentSpecifier == "%d") specifierType = int;
			else if (currentSpecifier == "%u") specifierType = uint;
			else if (currentSpecifier == "%U") 
			{
				isUpperCase = true;
				specifierType = uint;
			}
			else if (currentSpecifier == "%o") specifierType = String;
			else if (currentSpecifier == "%O") 
			{
				isUpperCase = true;
				specifierType = String;
			}
			else if (currentSpecifier == "%x") specifierType = Number;
			else if (currentSpecifier == "%X") 
			{
				isUpperCase = true;
				specifierType = Number;
			}
			else if (currentSpecifier == "%c") specifierType = String;
			else if (currentSpecifier == "%C") 
			{
				isUpperCase = true;
				specifierType = String;
			}
			else if (currentSpecifier == "%s") specifierType = String;
			else if (currentSpecifier == "%S") 
			{
				isUpperCase = true;
				specifierType = String;
			}
			else if (currentSpecifier == "%f") specifierType = Number;
			else if (currentSpecifier == "%F") 
			{
				isUpperCase = true;
				specifierType = Number;
			}
			else if (currentSpecifier == "%n") specifierType = Number;
			else if (currentSpecifier == "%N") 
			{
				isUpperCase = true;
				specifierType = Number;
			}
			else if (currentSpecifier == "%l") specifierType = Number;
			else if (currentSpecifier == "%L") 
			{
				isUpperCase = true;
				specifierType = Number;
			}
			else if (currentSpecifier == "%b") specifierType = Boolean;
			else if (currentSpecifier == "%B") 
			{
				isUpperCase = true;
				specifierType = Boolean;
			}
			else if (currentSpecifier == "%%") specifierType = String;
			
			
			finalString = format.replace(remainingSpecifiers, currentArg);
			
			
			if (!isUpperCase) 
			{	
				if (currentSpecifier == "%i") finalString = firstString + parseInt(currentArg) + secondString;
				else if (currentSpecifier == "%d") finalString = firstString + parseInt(currentArg) + secondString;
				else if (currentSpecifier == "%u") finalString = firstString + parseInt(currentArg) + secondString;
				else if (currentSpecifier == "%o") finalString = firstString + fnumber.toOctal(currentArg) + secondString;
				else if (currentSpecifier == "%x") finalString = firstString + fnumber.toHex(currentArg) + secondString;
				else if (currentSpecifier == "%c") finalString = firstString + specifierType(fnumber.toCharacter(currentArg)) + secondString;
				else if (currentSpecifier == "%s") finalString = firstString + specifierType(currentArg) + secondString;
				else if (currentSpecifier == "%n") finalString = firstString + specifierType(currentArg) + secondString;
				else if (currentSpecifier == "%l") finalString = firstString + fnumber.toFloat(currentArg) + secondString;
				else if (currentSpecifier == "%b") finalString = firstString + currentArg + secondString;
				else if (currentSpecifier == "%%") 
				{
					finalString = firstString + "modulo" + secondString;
					rest.unshift("");
					format = finalString;
					continue;
				}
				else 
				{
					finalString = firstString + "<Invalid specifier character>" + secondString;
					rest.unshift("");
					format = finalString
				}
			}
			else 
			{
				if (currentSpecifier == "%i") finalString = firstString + parseInt(fnumber.toUpperCase(currentArg)) + secondString;
				else if (currentSpecifier == "%d") finalString = firstString + parseInt(fnumber.toUpperCase(currentArg)) + secondString;
				else if (currentSpecifier == "%U") finalString = firstString + parseInt(fnumber.toUpperCase(currentArg)) + secondString;
				else if (currentSpecifier == "%O") finalString = firstString + parseFloat(fnumber.toOctal(currentArg).toUpperCase()) + secondString;
				else if (currentSpecifier == "%X") finalString = firstString + fnumber.toHex(currentArg).toUpperCase() + secondString;
				else if (currentSpecifier == "%C") finalString = firstString + specifierType(fnumber.toCharacter(currentArg)).toUpperCase() + secondString;
				else if (currentSpecifier == "%S") finalString = firstString + specifierType(currentArg).toUpperCase() + secondString;
				else if (currentSpecifier == "%N") finalString = firstString + fnumber.toUpperCase(specifierType(currentArg)) + secondString;
				else if (currentSpecifier == "%L") finalString = firstString + fnumber.toUpperCase(fnumber.toFloat(currentArg)) + secondString;
				else if (currentSpecifier == "%B") finalString = firstString + ((currentArg == false) ? "FALSE" : "TRUE") + secondString;
				else if (currentSpecifier == "%%") 
				{
					finalString = firstString + "modulo" + secondString;
					rest.unshift("");
					format = finalString
					continue;
				}
				else 
				{
					finalString = firstString + "<Invalid specifier character>" + secondString;
					rest.unshift("");
					format = finalString
					continue;
				}
			}
			format = finalString;
		}
		format = format.replace("modulo", "%");
		Main.CONSOLE.appendOutput(format);
	}
}