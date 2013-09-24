package mainModule.model.gameData.dynamicData
{
	import flash.utils.Dictionary;
	
	import kylin.echo.edward.framwork.model.KylinActor;
	
	import mainModule.model.gameData.dynamicData.hero.HeroDynamicDataModel;
	import mainModule.model.gameData.dynamicData.interfaces.IDynamicDataDictionaryModel;
	import mainModule.model.gameData.dynamicData.interfaces.IFightDynamicDataModel;
	
	public class DynamicDataDictionaryModel extends KylinActor implements IDynamicDataDictionaryModel
	{
		[Inject]
		public var heroData:HeroDynamicDataModel;
		[Inject]
		public var fightData:IFightDynamicDataModel;
		
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