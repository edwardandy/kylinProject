package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.boss
{
	import mainModule.model.gameData.sheetData.skill.monsterSkill.IMonsterSkillSheetItem;
	
	import release.module.kylinFightModule.gameplay.constant.identify.SkillID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.BasicMonsterElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.process.BasicSkillProcessor;

	/**
	 * 沼泽之王
	 */
	public class KingOfSwamp extends BasicMonsterElement
	{
		public function KingOfSwamp(typeId:int)
		{
			super(typeId);
		}
		
		override protected function onFireAnimationTimeHandler():void
		{
			//这里防止动画的延时播放会导致这里的bug
			if(mySearchedEnemy == null) 
				return;
			
			var skillTemp:IMonsterSkillSheetItem = monsterSkillModel.getMonsterSkillSheetById(SkillID.CrazyBite);
			var vecTower:Vector.<BasicTowerElement> = sceneElementsService.searchTowersBySearchArea(
				mySearchedEnemy.x,mySearchedEnemy.y,skillTemp.range);
			if(vecTower && vecTower.length>0)
			{
				var processor:BasicSkillProcessor = skillProcessorMgr.getSkillProcessorById(SkillID.CrazyBite);
				var state:SkillState = new SkillState;
				state.id = SkillID.CrazyBite;
				state.mainTarget = mySearchedEnemy;
				state.owner = this;
				state.skillCd.clearCDTime();		
	
				for each(var tower:BasicTowerElement in vecTower)
				{
					state.vecTargets.push(tower);
				}
				processor.processBuffers(state);
			}
			super.onFireAnimationTimeHandler();
		}
	}
}