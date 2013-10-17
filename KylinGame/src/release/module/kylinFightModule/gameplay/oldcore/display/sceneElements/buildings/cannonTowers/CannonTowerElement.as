package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.cannonTowers
{
	import com.shinezone.towerDefense.fight.constants.FightElementCampType;
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.SubjectCategory;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.TowerBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SceneTipEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.BasicBulletEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.ShellBulletEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	
	import flash.geom.Point;
	import flash.utils.getTimer;

	public class CannonTowerElement extends BasicTowerElement
	{
		private static const MY_BULLET_PARABOLA_HEIGHT:Number = 150;
		
		public function CannonTowerElement(typeId:int)
		{
			super(typeId);
			
			myFireLocalPoint.x = 0;
			myFireLocalPoint.y = -68;
		}
		
		override protected function onBehaviorStateChanged():void
		{
			super.onBehaviorStateChanged();
			
			switch(currentBehaviorState)
			{
				case TowerBehaviorState.IDEL:
					if(myTowerTemplateInfo.level == 0) 
						myBodySkin.gotoAndStop2(2);
					else if(myBodySkin.hasFrameName(GameMovieClipFrameNameType.IDLE+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START))
					{
						myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.IDLE+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
							GameMovieClipFrameNameType.IDLE+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END);
					}
					else 
						myBodySkin.gotoAndStop2(1);
					break;
			}
		}
		
		override protected function necessarySearchConditionFilter(taget:BasicOrganismElement):Boolean
		{
			return !taget.fightState.isFlyUnit;
		}
		
		private var tick:int = 0;
		override protected function fireToTargetEnemy():void
		{
			super.fireToTargetEnemy();
			tick = getTimer();
			myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.ATTACK + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				GameMovieClipFrameNameType.ATTACK + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, onFireAnimationEndHandler,
				GameMovieClipFrameNameType.FIRE_POINT, onFireAnimationTimeHandler);
		}
		
		override protected function onFireAnimationTimeHandler():void
		{
 			var bulletEffect:BasicBulletEffect = ObjectPoolManager.getInstance()
				.createSceneElementObject(GameObjectCategoryType.BULLET, 
					myFightState.weapon, false) as BasicBulletEffect;
			bulletEffect.fire(mySearchedEnemy, this, 
				getGlobalFirePoint(), 
				getDmgBeforeHurtTarget(false,mySearchedEnemy), 
				MY_BULLET_PARABOLA_HEIGHT);//抛物线高度参数

			bulletEffect.notifyLifecycleActive();
		}
		
		override public function get subjectCategory():int
		{
			return SubjectCategory.CANNON_TOWER;
		}
	}
}