package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.skillBullets
{
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.BasicBulletEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.process.BasicSkillProcessor;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	
	public class BasicSkillBulletEffect extends BasicBulletEffect
	{
		private var _skillState:SkillState;
		
		public function BasicSkillBulletEffect(typeId:int)
		{
			super(typeId);
		}
		
		public function skillFire(state:SkillState,targetEnemy:BasicOrganismElement, 
								  firePoint:PointVO,
								  trajectoryParameters:Object = null,
								  emphasizeBulletFallPointPoint:PointVO = null):void
		{
			fire(targetEnemy,state.owner,firePoint,0,trajectoryParameters,emphasizeBulletFallPointPoint);
		}
		
		override public function dispose():void
		{
			super.dispose();
			_skillState = null;
		}
		
		override protected function onHurtedTargetEnemy():void
		{
			if(!_skillState)
				return;
			var processor:BasicSkillProcessor = GameAGlobalManager.getInstance().gameSkillProcessorMgr.getSkillProcessorById(_skillState.id);
			if(processor)
			{
				processor.processSingleEnemy(_skillState,myTargetEnemy);
			}
		}
	}
}