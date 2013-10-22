package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect
{
	import release.module.kylinFightModule.gameplay.constant.FightElementCampType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.process.BasicSkillProcessor;

	/**
	 * 火焰雨特效
	 */
	public class FlameRainSkillRes extends BasicSkillEffectRes
	{
		private static const SearchEnemyArea:int = 100;
		private static const SearchTowerArea:int = 200;
		
		
		public function FlameRainSkillRes(typeId:int)
		{
			super(typeId);
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
		}
		
		override protected function onSkillEffFireTimeHandler():void
		{
			var state:SkillState = new SkillState;
			var processor:BasicSkillProcessor = skillProcessorMgr.getSkillProcessorById(myObjectTypeId);
			var vecEnemy:Vector.<BasicOrganismElement> = sceneElementsService.searchOrganismElementsBySearchArea(this.x,this.y
				,SearchEnemyArea,FightElementCampType.FRIENDLY_CAMP);
			if(vecEnemy && vecEnemy.length>0 && processor)
			{
				state.id = myObjectTypeId;
				state.owner = mySkillOwner;
				for each(var enemy:BasicOrganismElement in vecEnemy)
				{
					state.vecTargets.push(enemy);
				}
				processor.processResults(state);
			}
			
			var vecTower:Vector.<BasicTowerElement> = sceneElementsService.searchTowersBySearchArea(this.x,this.y
				,SearchTowerArea);
			if(vecTower && vecTower.length>0 && processor)
			{
				state.id = myObjectTypeId;
				state.owner = mySkillOwner;
				state.vecTargets.length = 0;
				for each(var tower:BasicTowerElement in vecTower)
				{
					state.vecTargets.push(tower);
				}
				processor.processBuffers(state);
			}
		}
	}
}