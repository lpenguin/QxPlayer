package QuestPlayer.Quest 
{
	/**
	 * ...
	 * @author prian
	 */
	public class Location 
	{
		private var _id:String;
		private var _question:String;
		private var _text:String;
		private var _type:String;
		private var _actions:String;
		private var _paths:Array;
		private var _initActions:String;
                
		public function Location(id:String = null, question:String = null, text:String = null, type:String = null, actions:String = null, 
          initActions:String = null,
          paths:Array = null) 
		{
			_actions = actions;
			_text = text;
			_question = question;
			_id = id;
			if( paths )
				_paths = paths;
			else	
				_paths = new Array;
			_type = type;
            _initActions = initActions;
		}
		
		public function get initActions():String{
          return _initActions;
        }
        
//         public function set initActions( value:String ):void{
//           _initActions = value;
//         }
        
		public function addPath( path:Path ):void {
			_paths.push( path );
		}
		
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
		
		public function get type():String 
		{
			return _type;
		}

		
		public function get paths():Array 
		{
			return _paths;
		}
		
		
	}

}
