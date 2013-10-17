package release.module.kylinFightModule.gameplay.oldcore.vo
{
	public class NewMonsterList
	{
		private static var _instance:NewMonsterList;
		
		private var _monsterIds:Array;
		public function NewMonsterList()
		{
		}
		
		public static function get instance():NewMonsterList
		{
			return _instance ||= new NewMonsterList;
		}
		
		public function set monsterIds(ids:Array):void
		{
			_monsterIds = ids;
		}
		
		public function isNewMonster(id:uint):Boolean
		{
			return (null != _monsterIds) && (-1 != _monsterIds.indexOf(id));
		}
		
		public function removeNewMonster(id:uint):void
		{
			if(!_monsterIds)
				return;
			var idx:int;
			while(-1 != (idx = _monsterIds.indexOf(id)))
				_monsterIds.splice(idx,1);	
		}
	}
}