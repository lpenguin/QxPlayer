package QuestPlayer
{
	import flash.events.IEventDispatcher;
	import QuestPlayer.PlayerAction;
	/**
	 * ...
	 * @author prian
	 */
	public interface IPlayerView extends IEventDispatcher
	{
		function get text():String; 
		function set text(str:String):void;
		function get stateText():String;
		function set stateText(str:String):void;
		function clearActions():void;
		function addAction(action:PlayerAction):void;
        function showMsg(str:String):void;
		//function set actionHandler( handler:Function ):void;
	}
	
}
