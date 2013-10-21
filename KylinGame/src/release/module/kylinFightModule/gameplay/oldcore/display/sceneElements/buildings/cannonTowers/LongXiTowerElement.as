package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.cannonTowers
{
	import com.shinezone.towerDefense.fight.constants.GameFightConstant;
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.identify.SkillID;
	import release.module.kylinFightModule.gameplay.oldcore.display.render.BitmapFrameInfo;
	import release.module.kylinFightModule.gameplay.oldcore.display.render.BitmapMovieClip;
	import release.module.kylinFightModule.gameplay.oldcore.display.render.NewBitmapMovieClip;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.TowerBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.BasicBulletEffect;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;
	import com.shinezone.towerDefense.fight.vo.PointVO;

	public class LongXiTowerElement extends CannonTowerElement
	{
		protected var myTowerBarSkin:NewBitmapMovieClip;
		protected var myTowerSoldierSkin:NewBitmapMovieClip;
		
		private var _bAngry:Boolean = false;
		private var _cdAngry:SimpleCDTimer = new SimpleCDTimer(3000);
		
		public function LongXiTowerElement(typeId:int)
		{
			super(typeId);
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
		
			/*var soldierBitmapFrameInfos:Vector.<BitmapFrameInfo> = ObjectPoolManager.getInstance().getBitmapFrameInfos(
				bodySkinResourceURL + GameMovieClipFrameNameType.SOLDIER_NAME_SUFFIX) as Vector.<BitmapFrameInfo>;*/
			
			myTowerSoldierSkin = new NewBitmapMovieClip([bodySkinResourceURL + GameMovieClipFrameNameType.SOLDIER_NAME_SUFFIX]);
			injector.injectInto(myTowerSoldierSkin);
			addChild(myTowerSoldierSkin);
			myTowerSoldierSkin.render(0);
			
			/*var barBitmapFrameInfos:Vector.<BitmapFrameInfo> = ObjectPoolManager.getInstance().getBitmapFrameInfos(
				bodySkinResourceURL + GameMovieClipFrameNameType.BAR_NAME_SUFFIX) as Vector.<BitmapFrameInfo>;*/
			myTowerBarSkin = new NewBitmapMovieClip([bodySkinResourceURL + GameMovieClipFrameNameType.BAR_NAME_SUFFIX]);
			injector.injectInto(myTowerBarSkin);
			addChild(myTowerBarSkin);
			myTowerBarSkin.render(0);
			addChild(_mySkillBufferBottomLayer);
			addChild(_mySkillBufferEffecstLayer);
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			_bAngry = false;
			_cdAngry.clearCDTime();
		}
		
		override protected function onNotSearchedEnemy():void
		{
			super.onNotSearchedEnemy();
			if(myTowerSoldierSkin.currentFrame>8 && myTowerSoldierSkin.currentFrame<17)
			{
				myTowerSoldierSkin.gotoAndStop2(myTowerSoldierSkin.currentFrame - 8);
				myTowerSoldierSkin.render(0);
			}
		}
		
		//这里没有动画，而是直接开火
		override protected function fireToTargetEnemy():void
		{
			var r:Number = GameMathUtil.caculateDirectionRadianByTwoPoint2(this.x, this.y, mySearchedEnemy.x, mySearchedEnemy.y);
			
			adjustAngle(r);
			
			onFireAnimationTimeHandler();
			onFireAnimationEndHandler();
		}
		
		private function adjustAngle(radian:Number):void
		{
			//这里有8个方向
			var soldierFireAngleIndex:int = GameMathUtil.toSpecialAngleIndexByAngle(radian);
			
			var renFrame:String;
			switch(soldierFireAngleIndex)
			{
				case 1:
					renFrame = "down_right_idle";
					break;
				
				case 2:
					renFrame = "down_idle";
					break;
				
				case 3:
					renFrame = "down_left_idle";
					break;
				
				case 4:
					renFrame = "left_idle";
					break;
				
				case 5:
					renFrame = "top_left_idle";
					break;
				
				case 6:
					renFrame = "top_idle";
					break;
				
				case 7:
					renFrame = "top_right_idle";
					break;
				
				default:
					renFrame = "right_idle";
					break;
			}
			if(_bAngry)
			{
				renFrame += "_1";
				if(_cdAngry.getIsCDEnd())
					_bAngry = false;
			}
			myTowerSoldierSkin.gotoAndStop2(renFrame);
			
			myTowerSoldierSkin.render(0);
		}
		
		override protected function onBehaviorChangeToUseSkill():void
		{
			super.onBehaviorChangeToUseSkill();
			if(SkillID.DragonAngry == myFightState.curUseSkillId)
			{
				_bAngry = true;
				_cdAngry.resetCDTime();
			}
		}
		
		override protected function adjustUseSkillAngle():void
		{
			var state:SkillState = mySkillStates.get(myFightState.curUseSkillId) as SkillState;
			var target:ISkillTarget = state.mainTarget;
			if(!target)
				target = state.vecTargets[0];
			if(!target || target == this)
				return;
			adjustAngle(GameMathUtil.caculateDirectionRadianByTwoPoint2(this.x, this.y, target.x, target.y));
		}
				
		override public function getGlobalFirePoint():PointVO
		{
			var r:Number = GameMathUtil.caculateDirectionRadianByTwoPoint2(this.x, this.y, mySearchedEnemy.x, mySearchedEnemy.y);
			//这里有8个方向
			var soldierFireAngleIndex:int = GameMathUtil.toSpecialAngleIndexByAngle(r);
			
			var renFrame:String;
			var ptFire:PointVO = new PointVO;
			switch(soldierFireAngleIndex)
			{
				case 1:
					ptFire.x = 12.6;
					ptFire.y = -35.55;
					break;
				
				case 2:
					ptFire.x = -7.9;
					ptFire.y = -33.15;
					break;
				
				case 3:
					ptFire.x = -27.3;
					ptFire.y = -36.95;
					break;
				
				case 4:
					ptFire.x = -39.55;
					ptFire.y = -39.95;
					break;
				
				case 5:
					ptFire.x = -29.45;
					ptFire.y = -44.2;
					break;
				
				case 6:
					ptFire.x = -8;
					ptFire.y = -59.2;
					break;
				
				case 7:
					ptFire.x = 13.3;
					ptFire.y = -43.45;
					break;
				
				default:
					ptFire.x = 19.65;
					ptFire.y = -39.85;
					break;
			}
			return new PointVO(this.x + ptFire.x, this.y + ptFire.y);
		}
	}
}