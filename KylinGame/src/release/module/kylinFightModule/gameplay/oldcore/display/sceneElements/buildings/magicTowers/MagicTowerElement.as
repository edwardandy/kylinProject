package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.magicTowers
{
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.SubjectCategory;
	import release.module.kylinFightModule.gameplay.oldcore.display.render.NewBitmapMovieClip;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.ToftElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.TowerBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SceneTipEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.BasicBulletEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.utili.structure.PointVO;

	public class MagicTowerElement extends BasicTowerElement
	{
		protected var myBarrackMeetingCenterPoint:PointVO = new PointVO();//本地
		
		protected var myTowerSoldierSkin:NewBitmapMovieClip;
		
		protected var myHasTowerSoldier:Boolean = true;
		
		public function MagicTowerElement(typeId:int)
		{
			super(typeId);

			myFireLocalPoint.x = 0;
			myFireLocalPoint.y = -60;
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			if(myHasTowerSoldier)
			{
				myTowerSoldierSkin = new NewBitmapMovieClip([bodySkinResourceURL + GameMovieClipFrameNameType.SOLDIER_NAME_SUFFIX]);
				injector.injectInto(myTowerSoldierSkin);
				myTowerSoldierSkin.x = 4;
				addChild(myTowerSoldierSkin);
				myTowerSoldierSkin.visible = false;
			}
			addChild(_mySkillBufferBottomLayer);
			addChild(_mySkillBufferEffecstLayer);
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
			
			if(myHasTowerSoldier)
			{
				myTowerSoldierSkin.scaleX = 1;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();

			if(myHasTowerSoldier)
			{
				removeChild(myTowerSoldierSkin);
				myTowerSoldierSkin.dispose();
				myTowerSoldierSkin = null;
			}
		}
		
		override public function render(iElapse:int):void
		{
			super.render(iElapse);
			
			if(myHasTowerSoldier)
			{
				myTowerSoldierSkin.render(iElapse);
			}
		}
		
		override protected function onBehaviorStateChanged():void
		{
			super.onBehaviorStateChanged();
			
			if(myHasTowerSoldier)
			{
				myTowerSoldierSkin.visible = currentBehaviorState != TowerBehaviorState.UN_BUILDED;
			}
				
			switch(currentBehaviorState)
			{
				case TowerBehaviorState.IDEL:
					myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START, 
						GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END);
					
					if(myTowerSoldierSkin != null)
					{
						myTowerSoldierSkin.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START, 
							GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END);
					}
					break;
			}
		}
		
		override protected function necessarySearchConditionFilter(taget:BasicOrganismElement):Boolean
		{
			return true;
		}
		
		override protected function fireToTargetEnemy():void
		{
			super.fireToTargetEnemy();
			
			if(myHasTowerSoldier)
			{
				//方向只有左右
				var soldierFireAngleIndex:int = GameMathUtil.caculateHorizontalDirectionByAngleIndex(
					GameMathUtil.toSpecialAngleIndexByAngle(
						GameMathUtil.caculateDirectionRadianByTwoPoint2(this.x, this.y, mySearchedEnemy.x, mySearchedEnemy.y)
					));
				
				myTowerSoldierSkin.scaleX = soldierFireAngleIndex == -1 ? -1 : 1;
				
				playAttackAnim();
				
				//同步动画
				myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START, 
					GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END);
			}
		}
		
		protected function playAttackAnim():void
		{
			myTowerSoldierSkin.gotoAndPlay2(GameMovieClipFrameNameType.ATTACK + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				GameMovieClipFrameNameType.ATTACK + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, onFireAnimationEndHandler,
				GameMovieClipFrameNameType.FIRE_POINT, onFireAnimationTimeHandler);
		}

		override protected function onFireAnimationTimeHandler():void
		{
			if(!mySearchedEnemy)
				return;
			
			var bulletEffect:BasicBulletEffect = objPoolMgr.createSceneElementObject(GameObjectCategoryType.BULLET
				, myFightState.weapon, false) as BasicBulletEffect;
			bulletEffect.fire(mySearchedEnemy, this, getGlobalFirePoint(), 
				getDmgBeforeHurtTarget(false,mySearchedEnemy));

			bulletEffect.notifyLifecycleActive();
		}
		
		override public function get subjectCategory():int
		{
			return SubjectCategory.MAGIC_TOWER;
		}
		
		override protected function get skillActionSkin():NewBitmapMovieClip
		{
			if(myHasTowerSoldier)
			{
				return myTowerSoldierSkin;
			}
			return super.skillActionSkin;
		}
		
		public final function get meetingCenterPoint():PointVO
		{
			return myBarrackMeetingCenterPoint.clone();
		}
		
		override public function buildedByToft(t:ToftElement):void
		{
			super.buildedByToft(t);
			
			myBarrackMeetingCenterPoint.x = t.meetingCenterPoint.x;
			myBarrackMeetingCenterPoint.y = t.meetingCenterPoint.y;
		}
		
		override public function buildedByTower(t:BasicTowerElement, additionalCostGold:uint):void
		{
			super.buildedByTower(t, additionalCostGold);
			
			myBarrackMeetingCenterPoint.x = MagicTowerElement(t).meetingCenterPoint.x;
			myBarrackMeetingCenterPoint.y = MagicTowerElement(t).meetingCenterPoint.y;
		}
		
		override public function notifyHurtTagetOnkill(beHurtTarget:BasicOrganismElement, finalHurtValue:uint):void
		{
			SceneTipEffect.playSceneTipEffect(SceneTipEffect.SCENE_TIPE_BZZT, beHurtTarget.x, beHurtTarget.y);
		}
	}
}