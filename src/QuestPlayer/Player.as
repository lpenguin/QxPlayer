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
	import r1.deval.parser.ParseError;

	public class Player extends EventDispatcher
	{
		private var _playerView:IPlayerView;
		private var _context:PlayerContext;
		private var _quest:Quest = new Quest;
        private var _libraries:Array = new Array;
        
		private var _local:Object = new Object;
		
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
			_context = new PlayerContext(this)
            _context.checkConditions = function( path:Path ){
                if( !path.conditions )
                    return true;
                var n = eval( path.conditions, {"path" : path} );
                //myTrace("for path "+path.id+" "+n);
                return n;
            }
			_context.locationPaths = function( location:Location ):* {
				return location.paths;
			};
			_context.triggers = new Array();
			_quest.Reset();
			exposeDefinitions();
		}
		
		public function Load( jsonObject:Object, libraries:Array ):void{//path:String, onLoadFunction:Function ):void{
			Reset();
            _libraries = libraries;
			_quest.Load( jsonObject );
            
		}
		
		public function Player(playerView:IPlayerView = null, jsonQuest:Object = null) 
		{
			_context =  new PlayerContext(this);
			_playerView = playerView;
			if( playerView )
				_playerView.addEventListener( PlayerActionEvent.ACTION, actionHandler);
            exposeDefinitions();
		}
		
		public function Play():void {
			//_compiler = new ESCompiler;
			var loc:Location = _quest.findStartLocation();
			if( !loc )
				throw Error("Cannot find start location");
				
            for( var i in _libraries )
                playGlobalActions( _libraries[i] );
            initQuest();
			playGlobalActions( _quest.actions );
			ShowLocation( loc );
			
		}
		
		
		private function exposeDefinitions():void {
			D.importFunction("trace", myTrace);
            D.importFunction("typeof", function(v){
                return typeof(v);
            });

//			_context.exposeDefinition(_local, "local");
//			_context.exposeDefinition(myTrace, "trace");
//			_context.exposeDefinition(_playerView.text, "text");
//			_context.exposeDefinition(_playerView.stateText, "state");
		}
		

		
		private function initQuest():void{
            playGlobalActions( _quest.initActions );
            for( var i in _quest.locations ){
                var loc:Location = _quest.locations[i];
                playLocalActions( loc.initActions, {"location":loc});
                for( var j in loc.paths ){
                    var path:Path = loc.paths[i];
                    playLocalActions( loc.initActions, {"path":path});
                }
            }
        }
        
		public function myTrace( str:String ):void {
			//s.controls.Alert.show( str );
			_playerView.showMsg( str );
            trace( str );
		}
		private function eval( actions:String, thisObject:Object = null ):*{
//             if( thisObject == null)
//                 thisObject = {};
            try{
                return D.eval( actions, _context, thisObject );
            }
            catch (e:r1.deval.rt.RTError) {
                myTrace( "Error: " + e.lineno+" "+ e.message+"\n"+actions );
            }catch (e:r1.deval.parser.ParseError) {
                myTrace( "Error: " + e.lineno+" "+ e.message+"\n"+actions );
            }catch (e:Error) {
                myTrace( "Error: " + e.message+"\n"+actions );
            }
        }
        private function playGlobalActions(actions:String):void {
            eval( actions, _context );
        }
		private function playLocalActions( actions:String, thisObject:Object ):void {
            eval( "onStartExecActions();", thisObject );
            eval( actions, thisObject );
            eval( "onStopExecActions();", thisObject );
		}
// 		private function localSyntax( actions:String ):String {
// 			return actions;
// 			return "this.localActions = function(){"+actions+"};\n"+
// 				   "this.localActions();"
// 		}

		private function ClearView():void {
			_playerView.text = "";
			_playerView.stateText = "";
			_playerView.clearActions();
		}
		private function ShowLocation( loc:Location ):void{
			myTrace("Location: "+loc.id);
			ClearView();
			UpdateContext( loc.text );
            var paths:Array = eval( "locationPaths( location )", { "location" : loc } ) as Array;
			
            //try{
                //paths = eval( "locationPaths( location );", { "location":loc }) as Array;
            //}catch(e:Error){
                //myTrace(e.message);
            //}
			for( var i:String in paths ){
				_playerView.addAction( new PlayerAction( paths[i] as Path));
			}
			playLocalActions( loc.actions, { "location":loc } );
			ReadContext();
		}
		
		private function ShowPath( path:Path ):void {
//			var oldText:String =  _playerView.text;
			myTrace("selected Path: "+path.id);
			ClearView();
			UpdateContext(path.text);
			playLocalActions( path.actions, { "path":path } );
			ReadContext();
			if ( _context.text ) {
				_playerView.addAction( new PlayerAction( new Path( "tmp", "next>>", "", "", "", "", path.nextLocation ) ) );
			}else
				ShowLocation( path.nextLocation );
		}
	}

}

