package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects
{
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.identify.GroundEffectID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.groundEffect.BasicGroundEffect;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;

	/**
	 * 让子弹飞的子弹要带烟圈 
	 */	
	public class LetBulletFlyBulletEffect extends BasicBulletEffect
	{
		public function LetBulletFlyBulletEffect(typeId:int)
		{
			super(typeId);
		}
		
		override protected function onRenderWhenRunning():void
		{
			super.onRenderWhenRunning();
			//if(0 == _myCurrentRendTimes%2)
			{
				var ground:BasicGroundEffect = addGroundEff(GroundEffectID.FlyBulletFog,0,null,myHurtEffectFirer);
				if(ground)
					ground.updateAngle(myBulletTrajectory.getRunTimeTrajectoryAngle());
			}
		}
	}
}