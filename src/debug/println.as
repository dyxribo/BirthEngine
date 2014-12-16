package debug 
{
	/**
	 * ...
	 * @author Psycho
	 */

	public function println(...rest):String
	{
		var finalString:String = "";
		for each(var item:* in rest) 
		{
			Main.CONSOLE.appendOutput(item + "\n");
			finalString += item + "\n";
		}
		return finalString;
	}
}