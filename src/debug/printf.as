package debug 
{
	/**
	 * ...
	 * @author Psycho
	 */

	public function printf(...rest):String
	{
		var finalString:String = "";
		for each(var item:* in rest) 
		{
			if (item) Main.CONSOLE.appendOutput(item + "\n");
			finalString += item + "\n";
		}
		return finalString;
	}
}