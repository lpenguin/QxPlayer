package QuestPlayer.Quest 
{
	/**
	 * ...
	 * @author prian
	 */
	
	import QuestPlayer.Quest.Location;
	import QuestPlayer.Quest.Path;
	
	public class Quest 
	{
		private var _locations:Array;
		private var _actions:String;
		private var _name:String;
		private var _description:String;
		
		public function Quest( jsonObject:Object = null ) 
		{
			if( jsonObject )
				Load( jsonObject );
		}
		
		public function Load( jsonObject:Object ):void {
			Reset();
			
			var locationsArray:Array = jsonObject["vers"] as Array;
			LoadLocations( locationsArray );
			LoadPaths( locationsArray );
			_name = jsonObject["name"];
			_description = jsonObject["description"];
			_actions = jsonObject["actions"];
		}
		
		private function LoadLocations( locationsArray:Array ):void {
			for ( var i:String in locationsArray ) {
				_locations.push( LoadLocation( locationsArray[i] ) );
			}
		}
		
		private function LoadLocation( jsonObject:Object ):Location{
			return new Location( jsonObject['id'], jsonObject['question'], jsonObject['text'], jsonObject['type'], jsonObject['actions'] );
		}
		
		private function LoadPaths( locationsArray:Array ):void{
			var loc:Location;
			for( var i:String in locationsArray ){
				loc = _locations[i] as Location;
				var pathsArray:Array = locationsArray[i]["edges"] as Array;
				for( var j:String in pathsArray ){
					loc.addPath( LoadPath( pathsArray[j] ) );
				}
			}
		}
		
		private function LoadPath( jsonObject:Object):Path {
			var locId:String = jsonObject["nextVer"];
			var loc:Location = findLocation( locId );
			if( loc == null)
				throw Error("Location '"+locId+"' not found");
			//id:String, question:String, text:String, actions:String, conditions:String, nextLocation:Location
			return new Path(jsonObject["id"], jsonObject["question"], jsonObject['text'], jsonObject['actions'], jsonObject['conditions'], loc);
		}
		
		public function Reset():void {
			_locations = new Array();
		}
		
		public function findLocation( id:String ):Location{
			var loc:Location;
			for( var i:String in _locations ){
				loc = _locations[i] as Location;
				if( loc.id == id )
					return loc;
			}
			return null;
		}
		
		public function findStartLocation():Location{
			var loc:Location;
			for( var i:String in _locations ){
				loc = _locations[i] as Location;
				if( loc.type == 'start' )
					return loc;
			}
			return null;
		}
		
		public function get locations():Array 
		{
			return _locations;
		}
		
		public function get actions():String 
		{
			return _actions;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get description():String 
		{
			return _description;
		}

	}

}
