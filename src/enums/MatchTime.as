package enums 
{
	/**
	 * ...
	 * @author Psycho
	 */
	public class MatchTime 
	{
		
		public function MatchTime() 
		{
		}
		
		public static function minutes(numMins:uint):uint
		{
			return ((Main.FRAMERATE * Main.FRAMERATE) * numMins);
		}
	}

}