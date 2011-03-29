package QuestPlayer.Quest 
{
	/**
	 * ...
	 * @author prian
	 */
	import QuestPlayer.Quest.Location;
	 
	public class Path 
	{
		private var _id:String;
		private var _question:String;
		private var _text:String;
		private var _actions:String;
		private var _conditions:String;
		private var _nextLocation:Location;
		private var _initActions:String;

		public function Path(id:String, question:String, text:String, actions:String, initActions:String, conditions:String, nextLocation:Location) 
		{
			_nextLocation = nextLocation;
			_conditions = conditions;
			_actions = actions;
			_text = text;
			_question = question;
			_id = id;
			_initActions = initActions;
		}
		
		public function get initActions():String{
          return _initActions;
        }
        
//         public function set initActions( value:String ):void{
//           _initActions = value;
//         }
        
		public function get id():String 
		{
			return _id;
		}
		
		
		public function get question():String 
		{
			return _question;
		}
		
		public function get text():String 
		{
			return _text;
		}
		
		public function get actions():String 
		{
			return _actions;
		}
		
		public function get conditions():String 
		{
			return _conditions;
		}
		
		public function get nextLocation():Location 
		{
			return _nextLocation;
		}
		
		
	}

}
