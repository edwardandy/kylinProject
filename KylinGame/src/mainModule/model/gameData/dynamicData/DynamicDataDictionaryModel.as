package mainModule.model.gameData.dynamicData
{
	import flash.utils.Dictionary;
	
	import kylin.echo.edward.framwork.model.KylinActor;
	
	import mainModule.model.gameData.dynamicData.fight.IFightDynamicDataModel;
	import mainModule.model.gameData.dynamicData.hero.IHeroDynamicDataModel;
	import mainModule.model.gameData.dynamicData.heroSkill.IHeroSkillDynamicDataModel;
	import mainModule.model.gameData.dynamicData.interfaces.IDynamicDataDictionaryModel;
	import mainModule.model.gameData.dynamicData.item.IItemDynamicDataModel;
	import mainModule.model.gameData.dynamicData.magicSkill.IMagicSkillDynamicDataModel;
	import mainModule.model.gameData.dynamicData.tower.ITowerDynamicDataModel;
	import mainModule.model.gameData.dynamicData.user.IUserDynamicDataModel;
	
	public class DynamicDataDictionaryModel extends KylinActor implements IDynamicDataDictionaryModel
	{
		[Inject]
		public var heroData:IHeroDynamicDataModel;
		[Inject]
		public var fightData:IFightDynamicDataModel;
		[Inject]
		public var heroSkillData:IHeroSkillDynamicDataModel;
		[Inject]
		public var itemData:IItemDynamicDataModel;
		[Inject]
		public var magicSkillData:IMagicSkillDynamicDataModel;
		[Inject]
		public var towerData:ITowerDynamicDataModel;
		[Inject]
		public var userData:IUserDynamicDataModel;
		
		private var _dicModels:Dictionary;
		public function DynamicDataDictionaryModel()
		{
			super();
		}
		
		[PostConstruct]
		public function mapDynamicModels():void
		{
			_dicModels ||= new Dictionary;
			
			_dicModels[DynamicDataNameConst.HeroData] = heroData;
			_dicModels[DynamicDataNameConst.FightData] = fightData;
			_dicModels[DynamicDataNameConst.HeroSkillData] = heroSkillData;
			_dicModels[DynamicDataNameConst.ItemData] = itemData;
			_dicModels[DynamicDataNameConst.MagicSkillData] = magicSkillData;
			_dicModels[DynamicDataNameConst.TowerData] = towerData;
			_dicModels[DynamicDataNameConst.UserData] = userData;
		}
		
		public function updateModels(data:Object):void
		{
			if(!data)
				return;
			for(var idx:* in data)
			{
				if(null != (_dicModels[idx] as BaseDynamicDataModel))
					(_dicModels[idx] as BaseDynamicDataModel).beFilled(data[idx]);
			}
		}
	}
}