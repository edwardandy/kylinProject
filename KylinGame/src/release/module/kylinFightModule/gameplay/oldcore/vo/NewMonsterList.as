package release.module.kylinFightModule.gameplay.oldcore.vo
{
	import mainModule.model.gameData.dynamicData.fight.IFightDynamicDataModel;
	
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.BasicGameManager;

	public class NewMonsterList extends BasicGameManager
	{		
		[Inject]
		public var fightData:IFightDynamicDataModel;
		
		private var _monsterIds:Array;
		public function NewMonsterList()
		{
		}
		
		override public function onFightStart():void
		{
			_monsterIds = fightData.newMonsterIds.concat();
		}
		
		override public function onFightEnd():void
		{
			_monsterIds.length = 0;
			_monsterIds = null;
		}
		/**
		 * 是否是本关首次出现的新怪物 
		 * @param id
		 * @return 
		 * 
		 */		
		public function isNewMonster(id:uint):Boolean
		{
			return (null != _monsterIds) && (-1 != _monsterIds.indexOf(id));
		}
		/**
		 * 新怪出现后从新怪列表中移除 
		 * @param id
		 * 
		 */		
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