package QuestPlayer 
{
	import flash.events.Event;
	import QuestPlayer.Quest.Location;
	import QuestPlayer.Quest.Path;
	/**
	 * ...
	 * @author prian
	 */
	public class PlayerActionEvent extends Event 
	{
		public static const ACTION:String = "PLAYER_ACTION";
		
		private var _action:PlayerAction;
		public function PlayerActionEvent(type:String, action:PlayerAction, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			_action = action;
		} 
		
		
		public override function clone():Event 
		{ 
			return new PlayerActionEvent(type, _action, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("PlayerActionEvent", "type", "bubbles", "cancelable", "eventPhase", "action"); 
		}
		
		public function get action():PlayerAction 
		{
			return _action;
		}
		

		
	}
	
}
