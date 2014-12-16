package enums 
{
	/**
	 * ...
	 * @author Psycho
	 */
	public class Stats 
	{
		static public function get DUMMY():Object
		{
			var p:Object = { };
			p.name = "DUMMY";
			p.hp = 300;
			p.ki = 100;
			p.weight = 0.8;
			p.jumpspeed = 20;
			p.walkspeed = 5;
			p.runspeed = 15;
			p.attackpower = 50;
			p.specattack = 50;
			p.defense = 50;
			p.specdefense = 50;
			p.endurance = 20;
			p.specendurance = 20;
			p.modifier = 1.5;
			
			return p;
		}
		
		static public function get PSYCHO():Object
		{
			var p:Object = { };
			p.name = "PSYCHO";
			p.hp = 300;
			p.ki = 100;
			p.weight = 1.5;
			p.jumpspeed = 15;
			p.walkspeed = 12;
			p.runspeed = 18;
			p.attackpower = 65;
			p.specattack = 50;
			p.defense = 60;
			p.specdefense = 50;
			p.endurance = 20;
			p.specendurance = 20;
			p.modifier = 1.5;
			
			return p;
		}
	}

}