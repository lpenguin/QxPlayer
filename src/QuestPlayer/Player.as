package QuestPlayer 
{
	/**
	 * ...
	 * @author prian
	 */
	import flash.events.EventDispatcher;
	import QuestPlayer.IPlayerView;
	import QuestPlayer.PlayerActionEvent;
	import QuestPlayer.Quest.Quest;
	import QuestPlayer.Quest.Path;
	import QuestPlayer.Quest.Location;
	import QuestPlayer.PlayerContext;
	import r1.deval.D;
	import r1.deval.rt.RTError;
	

	public class Player extends EventDispatcher
	{
		private var _playerView:IPlayerView;
		private var _context:PlayerContext;
		private var _quest:Quest = new Quest;

		private var _local:Object = new Object;
		
//		public function set quest( :String ):void{
//			_questPath = path;
//			var tempContext:ScriptContext = new ScriptContext();
//			
//			Load( path, function( data:String ):void {
//				Play();
//			} );
//			
//		}
//		public function get questPath( ):String{
//			return _questPath;
//		}
		private function UpdateContext(text:String, stateText:String = null):void{
			if( text != null )
				_context.text = text;
			if( stateText != null)
				_context.stateText = stateText;
		}
		
		private function ReadContext():void{
			_playerView.text = _context.text;
			_playerView.stateText = _context.stateText;
		}
		
		public function set playerView( playerView:IPlayerView ):void {
			_playerView = playerView;
			if( playerView )
				_playerView.addEventListener( PlayerActionEvent.ACTION, actionHandler);
		}
		
		public function get playerView():IPlayerView {
			return _playerView;
		}
		
		private function actionHandler( event:PlayerActionEvent ):void {
			ShowPath( event.action.path );
		}
		
		public function Reset():void{
			_context =  new PlayerContext(this)
			_quest.Reset();
			exposeDefinitions();
		}
		
		public function Load( jsonObject:Object ):void{//path:String, onLoadFunction:Function ):void{
			Reset();
			_quest.Load( jsonObject );
		}
		
		public function Player(playerView:IPlayerView = null, jsonQuest:Object = null) 
		{
			_context =  new PlayerContext(this);
			_playerView = playerView;
			if( playerView )
				_playerView.addEventListener( PlayerActionEvent.ACTION, actionHandler);
		}
		
		public function Play():void {
			//_compiler = new ESCompiler;
			var loc:Location = _quest.findStartLocation();
			if( !loc )
				throw Error("Cannot find start location");
				
			//making global actions
			playGlobalActions( _quest.actions );
			ShowLocation( loc );
			
		}
		
		private function exposeDefinitions():void {
			D.importFunction("trace", myTrace);
//			_context.exposeDefinition(_local, "local");
//			_context.exposeDefinition(myTrace, "trace");
//			_context.exposeDefinition(_playerView.text, "text");
//			_context.exposeDefinition(_playerView.stateText, "state");
		}
		
		private function playGlobalActions(actions:String):void {
			try{
				D.eval( actions, _context);
			}
			catch (e:r1.deval.rt.RTError) {
				trace( e.message );
			}
		}
		
		public function myTrace( str:String ):void {
			trace( str );
		}
		private function playLocalActions( actions:String, thisObject:Object ):void {
			try {
				D.eval( "PlayTriggers();", _context, thisObject );
				D.eval( localSyntax( actions ), _context, thisObject );
			}
			catch (e:Error) {
				trace( e.message );
			}
		}
		private function localSyntax( actions:String ):String {
			return actions;
			return "this.localActions = function(){"+actions+"};\n"+
				   "this.localActions();"
		}

		private function ClearView():void {
			_playerView.text = "";
			_playerView.stateText = "";
			_playerView.clearActions();
		}
		private function ShowLocation( loc:Location ):void{
			ClearView();
			UpdateContext( loc.text );
			
			for( var i:String in loc.paths ){
				_playerView.addAction( new PlayerAction( loc.paths[i] as Path));
			}
			playLocalActions( loc.actions, { "location":loc } );
			ReadContext();
		}
		
		private function ShowPath( path:Path ):void {
//			var oldText:String =  _playerView.text;
			ClearView();
			UpdateContext(path.text);
			playLocalActions( path.actions, { "path":path } );
			ReadContext();
			if ( _context.text ) {
				_playerView.addAction( new PlayerAction( new Path( "tmp", "next>>", "", "", "", path.nextLocation ) ) );
			}else
				ShowLocation( path.nextLocation );
		}
	}

}

