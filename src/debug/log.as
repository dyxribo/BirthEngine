package debug 
{
	/**
	 * ...
	 * @author Psycho
	 */
	public final class log 
	{
		static public var sessionLog:String = "";
		
		public function log():void 
		{			
		}
		
		static public function it(caller:String, ...rest):String 
		{
			var restStr:String = "";
			
			for each(var item:* in rest)
			{
				restStr += ("[" + caller + "] :: " + item + "\n");
			}
			
			var L:String = restStr;
			trace(L);
			
			sessionLog = sessionLog + L;
			return L;
		}
	}

}