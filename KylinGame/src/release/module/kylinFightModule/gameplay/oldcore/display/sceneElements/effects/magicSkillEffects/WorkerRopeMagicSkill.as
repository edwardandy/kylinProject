package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects
{
	import com.shinezone.towerDefense.fight.constants.FightElementCampType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	/**
	 * 工人的绳索
	 */
	public class WorkerRopeMagicSkill extends BasicMagicSkillEffect
	{
		public function WorkerRopeMagicSkill(typeId:int)
		{
			super(typeId);
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			
			bindEnemys();
			
			destorySelf();
		}
		
		private function bindEnemys():void
		{
			if(!myBuffer1Parameters)
				return;
			
			var targets:Vector.<BasicOrganismElement> = GameAGlobalManager.getInstance()
				.groundSceneHelper.searchOrganismElementsBySearchArea(this.x, this.y, 
					myMagicSkillTemplateInfo.range, 
					FightElementCampType.ENEMY_CAMP, necessarySearchConditionFilter);
			
			var n:uint = targets.length;
			for(var i:uint = 0; i < n; i++)
			{
				var target:BasicOrganismElement = targets[i];
				
				target.notifyAttachBuffer(myBuffer1Parameters.buff, myBuffer1Parameters,null);	
			}
		}
			
		
		override protected function get myMagicLevel():int
		{
			return _myMagicLevel;
		}
	}
}