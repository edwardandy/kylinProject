package mainModule.model
{
	import mainModule.model.gameConstAndVar.ConfigDataModel;
	import mainModule.model.gameConstAndVar.interfaces.IConfigDataModel;
	import mainModule.model.gameData.dynamicData.DynamicDataDictionaryModel;
	import mainModule.model.gameData.dynamicData.fight.FightDynamicDataModel;
	import mainModule.model.gameData.dynamicData.fight.IFightDynamicDataModel;
	import mainModule.model.gameData.dynamicData.hero.HeroDynamicDataModel;
	import mainModule.model.gameData.dynamicData.hero.IHeroDynamicDataModel;
	import mainModule.model.gameData.dynamicData.heroSkill.HeroSkillDynamicDataModel;
	import mainModule.model.gameData.dynamicData.heroSkill.IHeroSkillDynamicDataModel;
	import mainModule.model.gameData.dynamicData.interfaces.IDynamicDataDictionaryModel;
	import mainModule.model.gameData.dynamicData.item.IItemDynamicDataModel;
	import mainModule.model.gameData.dynamicData.item.ItemDynamicDataModel;
	import mainModule.model.gameData.dynamicData.magicSkill.IMagicSkillDynamicDataModel;
	import mainModule.model.gameData.dynamicData.magicSkill.MagicSkillDynamicDataModel;
	import mainModule.model.gameData.dynamicData.tower.ITowerDynamicDataModel;
	import mainModule.model.gameData.dynamicData.tower.TowerDynamicDataModel;
	import mainModule.model.gameData.dynamicData.user.IUserDynamicDataModel;
	import mainModule.model.gameData.dynamicData.user.UserDynamicDataModel;
	import mainModule.model.gameData.sheetData.SheetDataCacheModel;
	import mainModule.model.gameData.sheetData.buff.BuffSheetDataModel;
	import mainModule.model.gameData.sheetData.buff.IBuffSheetDataModel;
	import mainModule.model.gameData.sheetData.drop.DropSheetDataModel;
	import mainModule.model.gameData.sheetData.drop.IDropSheetDataModel;
	import mainModule.model.gameData.sheetData.groundEff.GroundEffSheetDataModel;
	import mainModule.model.gameData.sheetData.groundEff.IGroundEffSheetDataModel;
	import mainModule.model.gameData.sheetData.hero.HeroSheetDataModel;
	import mainModule.model.gameData.sheetData.hero.IHeroSheetDataModel;
	import mainModule.model.gameData.sheetData.interfaces.ISheetDataCacheModel;
	import mainModule.model.gameData.sheetData.item.IItemSheetDataModel;
	import mainModule.model.gameData.sheetData.item.ItemSheetDataModel;
	import mainModule.model.gameData.sheetData.lang.ILangSheetDataModel;
	import mainModule.model.gameData.sheetData.lang.LangSheetDataModel;
	import mainModule.model.gameData.sheetData.monster.IMonsterSheetDataModel;
	import mainModule.model.gameData.sheetData.monster.MonsterSheetDataModel;
	import mainModule.model.gameData.sheetData.skill.heroSkill.HeroSkillSheetDataModel;
	import mainModule.model.gameData.sheetData.skill.heroSkill.IHeroSkillSheetDataModel;
	import mainModule.model.gameData.sheetData.skill.magic.IMagicSkillSheetDataModel;
	import mainModule.model.gameData.sheetData.skill.magic.MagicSkillSheetDataModel;
	import mainModule.model.gameData.sheetData.skill.monsterSkill.IMonsterSkillSheetDataModel;
	import mainModule.model.gameData.sheetData.skill.monsterSkill.MonsterSkillSheetDataModel;
	import mainModule.model.gameData.sheetData.skill.towerSkill.ITowerSkillSheetDataModel;
	import mainModule.model.gameData.sheetData.skill.towerSkill.TowerSkillSheetDataModel;
	import mainModule.model.gameData.sheetData.soldier.ISoldierSheetDataModel;
	import mainModule.model.gameData.sheetData.soldier.SoldierSheetDataModel;
	import mainModule.model.gameData.sheetData.subwave.ISubwaveSheetDataModel;
	import mainModule.model.gameData.sheetData.subwave.SubwaveSheetDataModel;
	import mainModule.model.gameData.sheetData.summonerGrowth.ISummonerGrowthSheetDataModel;
	import mainModule.model.gameData.sheetData.summonerGrowth.SummonerGrowthSheetDataModel;
	import mainModule.model.gameData.sheetData.tollgate.ITollgateSheetDataModel;
	import mainModule.model.gameData.sheetData.tollgate.TollgateSheetDataModel;
	import mainModule.model.gameData.sheetData.tower.ITowerSheetDataModel;
	import mainModule.model.gameData.sheetData.tower.TowerSheetDataModel;
	import mainModule.model.gameData.sheetData.towerLevelup.ITowerLevelupSheetDataModel;
	import mainModule.model.gameData.sheetData.towerLevelup.TowerLevelupSheetDataModel;
	import mainModule.model.gameData.sheetData.wave.IWaveSheetDataModel;
	import mainModule.model.gameData.sheetData.wave.WaveSheetDataModel;
	import mainModule.model.gameData.sheetData.weapon.IWeaponSheetDataModel;
	import mainModule.model.gameData.sheetData.weapon.WeaponSheetDataModel;
	import mainModule.model.gameInitSteps.GameCfgModel;
	import mainModule.model.gameInitSteps.interfaces.IGameCfgModel;
	import mainModule.model.panelData.PanelCfgModel;
	import mainModule.model.panelData.PanelDeclareModel;
	import mainModule.model.panelData.PanelInstancesModel;
	import mainModule.model.panelData.interfaces.IPanelCfgModel;
	import mainModule.model.panelData.interfaces.IPanelDeclareModel;
	import mainModule.model.preLoadData.PreLoadCfgModel;
	import mainModule.model.preLoadData.interfaces.IPreLoadCfgModel;
	import mainModule.model.textData.TextCfgModel;
	import mainModule.model.textData.interfaces.ITextCfgModel;
	
	import robotlegs.bender.framework.api.IInjector;
	

	public final class MainModuleModelsStartUp
	{
		public function MainModuleModelsStartUp(inject:IInjector)
		{
			inject.map(IGameCfgModel).toSingleton(GameCfgModel);
			inject.map(IConfigDataModel).toSingleton(ConfigDataModel);
			inject.map(IPanelCfgModel).toSingleton(PanelCfgModel);
			inject.map(ITextCfgModel).toSingleton(TextCfgModel);
			inject.map(IPanelDeclareModel).toSingleton(PanelDeclareModel);
			inject.map(PanelInstancesModel).asSingleton();
			inject.map(IPreLoadCfgModel).toSingleton(PreLoadCfgModel);
			
			injectGameData(inject);
		}
		
		private function injectGameData(inject:IInjector):void
		{
			inject.map(ISheetDataCacheModel).toSingleton(SheetDataCacheModel);
			//配置表数据映射
			inject.map(IHeroSheetDataModel).toSingleton(HeroSheetDataModel);
			inject.map(ILangSheetDataModel).toSingleton(LangSheetDataModel);
			inject.map(IMonsterSheetDataModel).toSingleton(MonsterSheetDataModel);
			inject.map(ITowerSheetDataModel).toSingleton(TowerSheetDataModel);
			inject.map(ISoldierSheetDataModel).toSingleton(SoldierSheetDataModel);
			inject.map(IMagicSkillSheetDataModel).toSingleton(MagicSkillSheetDataModel);
			inject.map(IHeroSkillSheetDataModel).toSingleton(HeroSkillSheetDataModel);
			inject.map(IMonsterSkillSheetDataModel).toSingleton(MonsterSkillSheetDataModel);
			inject.map(IWeaponSheetDataModel).toSingleton(WeaponSheetDataModel);
			inject.map(ITowerSkillSheetDataModel).toSingleton(TowerSkillSheetDataModel);
			inject.map(IBuffSheetDataModel).toSingleton(BuffSheetDataModel);
			inject.map(IItemSheetDataModel).toSingleton(ItemSheetDataModel);
			inject.map(ITollgateSheetDataModel).toSingleton(TollgateSheetDataModel);
			inject.map(IWaveSheetDataModel).toSingleton(WaveSheetDataModel);
			inject.map(ISubwaveSheetDataModel).toSingleton(SubwaveSheetDataModel);
			inject.map(IDropSheetDataModel).toSingleton(DropSheetDataModel);
			inject.map(IGroundEffSheetDataModel).toSingleton(GroundEffSheetDataModel);
			inject.map(ISummonerGrowthSheetDataModel).toSingleton(SummonerGrowthSheetDataModel);
			inject.map(ITowerLevelupSheetDataModel).toSingleton(TowerLevelupSheetDataModel);
			//动态数据映射
			inject.map(IDynamicDataDictionaryModel).toSingleton(DynamicDataDictionaryModel);
			inject.map(IHeroDynamicDataModel).toSingleton(HeroDynamicDataModel);
			inject.map(IFightDynamicDataModel).toSingleton(FightDynamicDataModel);
			inject.map(IHeroSkillDynamicDataModel).toSingleton(HeroSkillDynamicDataModel);
			inject.map(IMagicSkillDynamicDataModel).toSingleton(MagicSkillDynamicDataModel);
			inject.map(ITowerDynamicDataModel).toSingleton(TowerDynamicDataModel);
			inject.map(IUserDynamicDataModel).toSingleton(UserDynamicDataModel);
			inject.map(IItemDynamicDataModel).toSingleton(ItemDynamicDataModel);
		}	
	}
}