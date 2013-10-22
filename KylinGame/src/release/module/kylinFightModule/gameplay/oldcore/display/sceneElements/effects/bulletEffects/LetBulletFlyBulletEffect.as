package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects
{
	import release.module.kylinFightModule.gameplay.constant.identify.GroundEffectID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.groundEffect.BasicGroundEffect;

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