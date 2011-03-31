package QuestPlayer 
{
	import QuestPlayer.PlayerAction;
	import QuestPlayer.Quest.Quest;
    import QuestPlayer.Quest.Path;
    import QuestPlayer.Quest.Location;
	/**
	 * ...
	 * @author prian
	 */
	public dynamic class PlayerContext  
	{
		private var _player:Player;
		private var _text:String;
		private var _stateText:String;
		private var _triggers:Array = new Array();
        
//         public var locationPaths:* = function( loc:Location ):*{
//             return loc.paths;
//         }
        
		public function PlayerContext( player:Player ) 
		{
			_player = player;
		}
		
// 		public function locationPaths( loc:Location ):*{
//             return loc.paths;
//         }
        
		public function get text():String 
		{
			return _text;
		}
		
		public function set text(str:String):void 
		{
			_text = str;
		}
		
		public function get stateText():String 
		{
			return _stateText;
		}
		
		public function set stateText(str:String):void 
		{
			_stateText = str;
		}

		public function get state():String 
		{
			return stateText;
		}
		
		public function set state(str:String):void 
		{
			stateText = str;
		}
		
		public function get triggers():Array 
		{
			return _triggers;
		}
		
		//public function set triggers(value:Array):void 
		//{
			//_triggers = value;
		//}
		
// 		public function AddTrigger(f:* , name:String = null):void {
// 			_triggers.push( {
// 				func:f,
// 				name:String(name)
// 			});
// 		}
/*		public function PlayTriggers():void {
			for ( var i in _triggers ) {
				_triggers[i].func();
			}
		}
*/		
	}

}
