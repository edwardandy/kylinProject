package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.arrowTowers
{
	import com.shinezone.towerDefense.fight.constants.FightElementCampType;
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.SubjectCategory;
	import com.shinezone.towerDefense.fight.constants.identify.BufferID;
	import com.shinezone.towerDefense.fight.constants.identify.SkillID;
	import release.module.kylinFightModule.gameplay.oldcore.display.render.BitmapFrameInfo;
	import release.module.kylinFightModule.gameplay.oldcore.display.render.BitmapMovieClip;
	import release.module.kylinFightModule.gameplay.oldcore.display.render.NewBitmapMovieClip;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.TowerBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SceneTipEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillBufferRes.SpecialBufferRes;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.BasicBulletEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.DeadlyShurikenBullet;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	
	import flash.display.Shape;
	import flash.geom.Point;

	/**
	 * 箭塔 
	 * @author Administrator
	 * 
	 */	
	public class ArrowTowerElement extends BasicTowerElement
	{
		private static const MY_BULLET_PARABOLA_HEIGHT:Number = 100;

		protected var myTowerBarSkin:NewBitmapMovieClip;
		protected var myTowerSoldierLeftSkin:NewBitmapMovieClip;
		protected var myTowerSoldierRightSkin:NewBitmapMovieClip;
		
		protected var myIsLeftSoldierFire:Boolean = false;
		protected var myCurrentFireTowerSoldierSkin:NewBitmapMovieClip;
		

		public function ArrowTowerElement(typeId:int)
		{
			super(typeId);

			myFireLocalPoint.x = 0;
			myFireLocalPoint.y = -45;
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			/*var soldierBitmapFrameInfos:Vector.<BitmapFrameInfo> = ObjectPoolManager.getInstance().getBitmapFrameInfos(
				bodySkinResourceURL + GameMovieClipFrameNameType.SOLDIER_NAME_SUFFIX) as Vector.<BitmapFrameInfo>;*/
			
			myTowerSoldierLeftSkin = new NewBitmapMovieClip([bodySkinResourceURL + GameMovieClipFrameNameType.SOLDIER_NAME_SUFFIX]);
			myTowerSoldierLeftSkin.x = -8;
			addChild(myTowerSoldierLeftSkin);
			
			myTowerSoldierRightSkin = new NewBitmapMovieClip([bodySkinResourceURL + GameMovieClipFrameNameType.SOLDIER_NAME_SUFFIX]);
			myTowerSoldierRightSkin.x = 8;
			addChild(myTowerSoldierRightSkin);
			
			//可能没有
			if(myObjectTypeId != 112012)
			{
				myTowerBarSkin = new NewBitmapMovieClip([bodySkinResourceURL + GameMovieClipFrameNameType.BAR_NAME_SUFFIX]);
				addChild(myTowerBarSkin);
				myTowerBarSkin.render(0);//just rend once
			}
			
			addChild(_mySkillBufferBottomLayer);
			addChild(_mySkillBufferEffecstLayer);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			myCurrentFireTowerSoldierSkin = null;

			if(myTowerBarSkin != null)
			{
				removeChild(myTowerBarSkin);
				myTowerBarSkin.dispose();
				myTowerBarSkin = null;
			}

			removeChild(myTowerSoldierLeftSkin);
			myTowerSoldierLeftSkin.dispose();
			myTowerSoldierLeftSkin = null;
			
			removeChild(myTowerSoldierRightSkin);
			myTowerSoldierRightSkin.dispose();
			myTowerSoldierRightSkin = null;
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();

			myIsLeftSoldierFire = false;
			myCurrentFireTowerSoldierSkin = null;
		}

		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
			
			myTowerSoldierLeftSkin.scaleX = 1;
			myTowerSoldierRightSkin.scaleX = 1;
		}
		
		override public function render(iElapse:int):void
		{
			super.render(iElapse);

			myTowerSoldierLeftSkin.render(iElapse);
			myTowerSoldierRightSkin.render(iElapse);
		}

		override protected function onBehaviorStateChanged():void
		{
			super.onBehaviorStateChanged();
			
			myTowerSoldierLeftSkin.visible = 
				myTowerSoldierRightSkin.visible = 
				currentBehaviorState != TowerBehaviorState.UN_BUILDED;
			
			if(myTowerBarSkin != null)
			{
				myTowerBarSkin.visible = myTowerSoldierLeftSkin.visible;
			}
			
			switch(currentBehaviorState)
			{
				case TowerBehaviorState.IDEL:
					myBodySkin.gotoAndStop2(GameMovieClipFrameNameType.IDLE);
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

			myIsLeftSoldierFire = !myIsLeftSoldierFire;//切换士兵
			myCurrentFireTowerSoldierSkin = myIsLeftSoldierFire ? myTowerSoldierLeftSkin : myTowerSoldierRightSkin;
			//方向只有左右

			var soldierFireAngleIndex:int = GameMathUtil.caculateHorizontalDirectionByAngleIndex(
				GameMathUtil.toSpecialAngleIndexByAngle(
					GameMathUtil.caculateDirectionRadianByTwoPoint2(this.x + myCurrentFireTowerSoldierSkin.x, this.y, mySearchedEnemy.x, mySearchedEnemy.y)
				));
			
			myCurrentFireTowerSoldierSkin.scaleX = soldierFireAngleIndex == -1 ? -1 : 1;

			myCurrentFireTowerSoldierSkin.gotoAndPlay2(GameMovieClipFrameNameType.ATTACK + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				GameMovieClipFrameNameType.ATTACK + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, onFireAnimationEndHandler,
				GameMovieClipFrameNameType.FIRE_POINT, onFireAnimationTimeHandler);
		}
		
		override public function getGlobalFirePoint():PointVO
		{
			var p:PointVO = super.getGlobalFirePoint();
			p.x += myCurrentFireTowerSoldierSkin.x;
			return p;
		}

		override protected function onFireAnimationTimeHandler():void
		{
			//test myTowerTemplateInfo.weapon
			
			if(myCurrentFireTowerSoldierSkin == null) return;
			
			var bulletEffect:BasicBulletEffect = ObjectPoolManager.getInstance()
				.createSceneElementObject(GameObjectCategoryType.BULLET, myFightState.weapon, false) as BasicBulletEffect;
			bulletEffect.fire(mySearchedEnemy, this, 
				getGlobalFirePoint(), 
				getDmgBeforeHurtTarget(false,mySearchedEnemy), 
				MY_BULLET_PARABOLA_HEIGHT);//抛物线高度参数
			
			if(bulletEffect is DeadlyShurikenBullet)
			{
				(bulletEffect as DeadlyShurikenBullet).initShurikenParam(3,120);
			}

			bulletEffect.notifyLifecycleActive();
		}
		
		override protected function getDmgBeforeHurtTarget(bNear:Boolean = true,target:BasicOrganismElement = null):int
		{
			var dmg:int = getRandomDamageValue();
			var resultDmg:int = dmg;
			resultDmg += checkWeaknessAtk(dmg,target);
			resultDmg += myFightState.extraAtk + dmg*myFightState.extraAtkPct/100;
			return resultDmg;
		}
		
		override public function get subjectCategory():int
		{
			return SubjectCategory.ARROW_TOWER;
		}
		
		override protected function get skillActionSkin():NewBitmapMovieClip
		{
			return myCurrentFireTowerSoldierSkin = myIsLeftSoldierFire ? myTowerSoldierLeftSkin : myTowerSoldierRightSkin;
		}
		
		override protected function onBehaviorChangeToUseSkill():void
		{
			var state:SkillState = mySkillStates.get(myFightState.curUseSkillId) as SkillState;
			if(SkillID.LetBulletFly == state.id || SkillID.LetBulletFly1 == state.id || SkillID.LetBulletFly2 == state.id)
			{
				var res:SpecialBufferRes = ObjectPoolManager.getInstance().createSceneElementObject(
					GameObjectCategoryType.ORGANISM_SKILL_BUFFER,BufferID.LetBulletFly,false) as SpecialBufferRes;
				res.initializeByParameters(state.mainTarget);
				res.notifyLifecycleActive();
			}
			super.onBehaviorChangeToUseSkill();
		}
	}
}