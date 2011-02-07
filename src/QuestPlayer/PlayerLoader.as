package QuestPlayer 
{
	/**
	 * ...
	 * @author prian
	 */
	 	
	import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.events.*;
    import QuestPlayer.Player;
    
	import com.serialization.json.JSON;
    
	public class PlayerLoader 
	{
		private var _path:String;
		private var _player:Player;
		private var _data:Object;
		
		public function get data():Object {
			return _data;
		}
		
		
		public function get player():Player {
			return _player;
		}
		
		public function set player(playerObj:Player):void {
			_player = playerObj;
		}
		
		public function get path():String {
			return _path;
		}
		
		public function set path(path:String):void {
			_path = path;
			Load( path );
		}
		
		public function Load( path:String ):void {
			var loader:URLLoader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, function( event:Event ):void{
            	var dataStr:String = loader.data;
            	_data = JSON.deserialize(loader.data);
				if( _player ){
					 _player.Load( _data );
					 _player.Play();
				}
            	
            	
            	
            });
            loader.load(new URLRequest(path));
		}
		
		public function PlayerLoader(path:String = "") 
		{
			_path = path;
			if( path )
				Load( path );
		}
		
	}

}
