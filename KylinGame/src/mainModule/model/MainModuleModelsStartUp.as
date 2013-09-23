package mainModule.model
{
	import mainModule.model.gameConstAndVar.ConfigDataModel;
	import mainModule.model.gameConstAndVar.interfaces.IConfigDataModel;
	import mainModule.model.gameData.dynamicData.DynamicDataDictionaryModel;
	import mainModule.model.gameData.dynamicData.fight.FightDynamicDataModel;
	import mainModule.model.gameData.dynamicData.hero.HeroDynamicDataModel;
	import mainModule.model.gameData.dynamicData.interfaces.IDynamicDataDictionaryModel;
	import mainModule.model.gameData.dynamicData.interfaces.IFightDynamicDataModel;
	import mainModule.model.gameData.sheetData.SheetDataCacheModel;
	import mainModule.model.gameData.sheetData.buff.BuffSheetDataModel;
	import mainModule.model.gameData.sheetData.hero.HeroSheetDataModel;
	import mainModule.model.gameData.sheetData.interfaces.IBuffSheetDataModel;
	import mainModule.model.gameData.sheetData.interfaces.IHeroSheetDataModel;
	import mainModule.model.gameData.sheetData.interfaces.IHeroSkillSheetDataModel;
	import mainModule.model.gameData.sheetData.interfaces.IItemSheetDataModel;
	import mainModule.model.gameData.sheetData.interfaces.ILangSheetDataModel;
	import mainModule.model.gameData.sheetData.interfaces.IMagicSkillSheetDataModel;
	import mainModule.model.gameData.sheetData.interfaces.IMonsterSheetDataModel;
	import mainModule.model.gameData.sheetData.interfaces.IMonsterSkillSheetDataModel;
	import mainModule.model.gameData.sheetData.interfaces.ISheetDataCacheModel;
	import mainModule.model.gameData.sheetData.interfaces.ISoldierSheetDataModel;
	import mainModule.model.gameData.sheetData.interfaces.ISubwaveSheetDataModel;
	import mainModule.model.gameData.sheetData.interfaces.ITollgateSheetDataModel;
	import mainModule.model.gameData.sheetData.interfaces.ITowerSheetDataModel;
	import mainModule.model.gameData.sheetData.interfaces.ITowerSkillSheetDataModel;
	import mainModule.model.gameData.sheetData.interfaces.IWaveSheetDataModel;
	import mainModule.model.gameData.sheetData.interfaces.IWeaponSheetDataModel;
	import mainModule.model.gameData.sheetData.item.ItemSheetDataModel;
	import mainModule.model.gameData.sheetData.lang.LangSheetDataModel;
	import mainModule.model.gameData.sheetData.monster.MonsterSheetDataModel;
	import mainModule.model.gameData.sheetData.skill.heroSkill.HeroSkillSheetDataModel;
	import mainModule.model.gameData.sheetData.skill.magic.MagicSkillSheetDataModel;
	import mainModule.model.gameData.sheetData.skill.monsterSkill.MonsterSkillSheetDataModel;
	import mainModule.model.gameData.sheetData.skill.towerSkill.TowerSkillSheetDataModel;
	import mainModule.model.gameData.sheetData.soldier.SoldierSheetDataModel;
	import mainModule.model.gameData.sheetData.subwave.SubwaveSheetDataModel;
	import mainModule.model.gameData.sheetData.tollgate.TollgateSheetDataModel;
	import mainModule.model.gameData.sheetData.tower.TowerSheetDataModel;
	import mainModule.model.gameData.sheetData.wave.WaveSheetDataModel;
	import mainModule.model.gameData.sheetData.weapon.WeaponSheetDataModel;
	import mainModule.model.gameInitSteps.GameCfgModel;
	import mainModule.model.gameInitSteps.interfaces.IGameCfgModel;
	import mainModule.model.panelData.PanelCfgModel;
	import mainModule.model.panelData.PanelDeclareModel;
	import mainModule.model.panelData.PanelInstancesModel;
	import mainModule.model.panelData.ViewLayersModel;
	import mainModule.model.panelData.interfaces.IPanelCfgModel;
	import mainModule.model.panelData.interfaces.IPanelDeclareModel;
	import mainModule.model.preLoadData.PreLoadCfgModel;
	import mainModule.model.preLoadData.interfaces.IPreLoadCfgModel;
	import mainModule.model.textData.TextCfgModel;
	import mainModule.model.textData.interfaces.ITextCfgModel;
	
	import org.robotlegs.core.IInjector;

	public final class MainModuleModelsStartUp
	{
		public function MainModuleModelsStartUp(inject:IInjector)
		{
			inject.mapSingletonOf(IGameCfgModel,GameCfgModel);
			//inject.mapSingleton(FlashVarsModel);
			inject.mapSingletonOf(IConfigDataModel,ConfigDataModel);
			inject.mapSingletonOf(IPanelCfgModel,PanelCfgModel);
			inject.mapSingletonOf(ITextCfgModel,TextCfgModel);
			inject.mapSingletonOf(IPanelDeclareModel,PanelDeclareModel);
			inject.mapSingleton(ViewLayersModel);
			inject.mapSingleton(PanelInstancesModel);
			inject.mapSingletonOf(IPreLoadCfgModel,PreLoadCfgModel);
			
			injectGameData(inject);
		}
		
		private function injectGameData(inject:IInjector):void
		{
			inject.mapSingletonOf(ISheetDataCacheModel,SheetDataCacheModel);
			//配置表数据映射
			inject.mapSingletonOf(IHeroSheetDataModel,HeroSheetDataModel);
			inject.mapSingletonOf(ILangSheetDataModel,LangSheetDataModel);
			inject.mapSingletonOf(IMonsterSheetDataModel,MonsterSheetDataModel);
			inject.mapSingletonOf(ITowerSheetDataModel,TowerSheetDataModel);
			inject.mapSingletonOf(ISoldierSheetDataModel,SoldierSheetDataModel);
			inject.mapSingletonOf(IMagicSkillSheetDataModel,MagicSkillSheetDataModel);
			inject.mapSingletonOf(IHeroSkillSheetDataModel,HeroSkillSheetDataModel);
			inject.mapSingletonOf(IMonsterSkillSheetDataModel,MonsterSkillSheetDataModel);
			inject.mapSingletonOf(IWeaponSheetDataModel,WeaponSheetDataModel);
			inject.mapSingletonOf(ITowerSkillSheetDataModel,TowerSkillSheetDataModel);
			inject.mapSingletonOf(IBuffSheetDataModel,BuffSheetDataModel);
			inject.mapSingletonOf(IItemSheetDataModel,ItemSheetDataModel);
			inject.mapSingletonOf(ITollgateSheetDataModel,TollgateSheetDataModel);
			inject.mapSingletonOf(IWaveSheetDataModel,WaveSheetDataModel);
			inject.mapSingletonOf(ISubwaveSheetDataModel,SubwaveSheetDataModel);
			//动态数据映射
			inject.mapSingletonOf(IDynamicDataDictionaryModel,DynamicDataDictionaryModel);
			inject.mapSingleton(HeroDynamicDataModel);
			inject.mapSingletonOf(IFightDynamicDataModel,FightDynamicDataModel);
		}	
	}
}