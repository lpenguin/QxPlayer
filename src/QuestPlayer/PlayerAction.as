package QuestPlayer 
{
	/**
	 * ...
	 * @author prian
	 */
	import QuestPlayer.Quest.Path;
	public class PlayerAction 
	{
		private var _path:Path;
		public function get path():Path {
			return _path;
		}
		public function PlayerAction(path:Path) 
		{
			_path = path;
		}
		public function toString():String{
			return _path.question;
		}
		
	}

}
