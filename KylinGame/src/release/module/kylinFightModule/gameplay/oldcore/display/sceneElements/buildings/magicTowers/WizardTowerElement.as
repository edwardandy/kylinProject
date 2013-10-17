package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.magicTowers
{
	import com.shinezone.towerDefense.fight.constants.GameFightConstant;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.Skill.SkillResultTyps;
	import com.shinezone.towerDefense.fight.constants.identify.SkillID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.ToftElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect.SkillEffectBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.BasicSummonSoldier;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.SummonByTower;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.process.BasicSkillProcessor;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	
	import flash.geom.Point;

	/**
	 * 男巫，女巫塔，可召唤元素
	 */
	public class WizardTowerElement extends MagicTowerElement
	{
		protected var myTowerSoldiers:Vector.<SummonByTower>;
		
		public function WizardTowerElement(typeId:int)
		{
			super(typeId);
		}
		
		override protected function createBuildingCircleMenu():void
		{
			myBuildingCircleMenu = new WizardUpdateLevelMenu(this, myTowerTemplateInfo);
	
			if(myBuildingCircleMenu != null)
			{
				addChild(myBuildingCircleMenu);
			}
		}
		
		public final function moveAllSoldierToMeetingCenterPoint(gloabalPoint:PointVO):void
		{
			myBarrackMeetingCenterPoint.x = gloabalPoint.x - this.x;
			myBarrackMeetingCenterPoint.y = gloabalPoint.y - this.y;
			
			var soldier:SummonByTower = null;
			for each(soldier in myTowerSoldiers)
			{				
				if(soldier.isAlive)
				{
					moveSoldierFomTowerToCurrentTowerMeetinPoint(soldier);
				}
			}
		}
		
		public function notifySoldierIsResurrectionComplete(soldier:SummonByTower):void
		{
			moveSoldierFomTowerToCurrentTowerMeetinPoint(soldier);
		}
		
		private function moveSoldierFomTowerToCurrentTowerMeetinPoint(soldier:SummonByTower):void
		{	
			var soldierIndex:int = myTowerSoldiers.indexOf(soldier);
			if(soldierIndex == -1)
				return;
			var soldierMeetingPoint:PointVO;
			if(myTowerSoldiers.length == 1)
			{
				soldierMeetingPoint = new PointVO(this.x+myBarrackMeetingCenterPoint.x,this.y+myBarrackMeetingCenterPoint.y);
				soldier.moveToAppointPoint(soldierMeetingPoint);
				return;
			}
			
			/*var currentSoldierMeetingLocalPoint:PointVO = GameFightConstant.MYBARRACK_SOLDIERS_MEETING_LOCALPOINTS[soldierIndex];
			if(!currentSoldierMeetingLocalPoint)
			{
				currentSoldierMeetingLocalPoint = new PointVO(GameMathUtil.randomUintBetween(1,40),GameMathUtil.randomUintBetween(1,40));
			}
			
			var mySoldierMoveRadian:Number = GameMathUtil
				.caculateDirectionRadianByTwoPoint2(0, 0, myBarrackMeetingCenterPoint.x, myBarrackMeetingCenterPoint.y);
			
			//计算相对位置
			soldierMeetingPoint = GameMathUtil.caculateSourceAxeLocalPointInNewAxePoint(myBarrackMeetingCenterPoint.x + this.x, 
				myBarrackMeetingCenterPoint.y + this.y, 
				mySoldierMoveRadian, 
				currentSoldierMeetingLocalPoint.x, currentSoldierMeetingLocalPoint.y);*/
			soldierMeetingPoint = GameMathUtil.
				caculatePointOnCircle(myBarrackMeetingCenterPoint.x + this.x,myBarrackMeetingCenterPoint.y + this.y
					,GameFightConstant.MYBARRACK_SOLDIERS_DEGREE[soldierIndex],20,true);
			
			soldier.moveToAppointPoint(soldierMeetingPoint);
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			myTowerSoldiers = new Vector.<SummonByTower>;
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
			clearAllPets();	
		}
		
		private function clearAllPets():void
		{
			//这里将士兵交还给缓存系统
			var soldier:SummonByTower;
			var arrSoldier:Array = [];
			for each(soldier in myTowerSoldiers)
			{
				arrSoldier.push(soldier);
			}
			myTowerSoldiers.length = 0;
			for each(soldier in arrSoldier)
			{
				soldier.destorySelf();
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			myTowerSoldiers = null;
		}
		
		private function getSoldierCountById(uid:uint):int
		{
			var count:int = 0;
			for each(var soldier:SummonByTower in myTowerSoldiers)
			{
				if(uid == soldier.objectTypeId)
					++count;
			}
			return count;
		}
		
		override public function notifyCircleMenuOnSkillUp(skillId:uint,iLvl:int):void
		{
			super.notifyCircleMenuOnSkillUp(skillId,iLvl);
			if(iLvl>1 && (SkillID.SummonEarth == skillId || SkillID.SummonIce == skillId))
			{
				//clearAllPets();
				updateAllPets(getCurSkillIdByLvl(skillId,iLvl));
			}
		}
		
		private function updateAllPets(skillId:uint):void
		{
			var processor:BasicSkillProcessor = GameAGlobalManager.getInstance().gameSkillProcessorMgr.getSkillProcessorById(skillId);
			var strPets:String = processor.effectParam[SkillResultTyps.SUMMON];
			var arrPetData:Array = strPets.split("-");
			var petId:uint = arrPetData[0];
			var maxCnt:int = 1;
			if(arrPetData.length>=3)
				maxCnt = int(arrPetData[2]);
			var soldier:SummonByTower;
			var arrPt:Array = [];
			for each(soldier in myTowerSoldiers)
			{
				arrPt.push(new PointVO(soldier.x,soldier.y));
			}
			clearAllPets();
			summon(petId,arrPt.length,maxCnt,this);
			for each(soldier in myTowerSoldiers)
			{
				var pt:PointVO = arrPt.pop();
				soldier.x = pt.x;
				soldier.y = pt.y;
				soldier.notifyResurrectionCompleteToMaster();
			}
			
		}
		
		override public function canSummon(uid:uint,maxCount:int,owner:ISkillOwner):Boolean
		{
			var nowCount:int = getSoldierCountById(uid);
			if(nowCount >= maxCount)
				return false;
			return true;
		}
		
		override public function summon(uid:uint,count:int,maxCount:int,owner:ISkillOwner):Boolean
		{
			var nowCount:int = getSoldierCountById(uid);
			if(nowCount >= maxCount)
				return false;
			
			if(count > maxCount - nowCount)
				count = maxCount - nowCount;
					
			var offX:int = 0;
			for(var i:int=0;i<count;++i)
			{
				offX += 10;				
				var soldier:SummonByTower = ObjectPoolManager.getInstance().createSceneElementObject(GameObjectCategoryType.SUMMON_BY_TOWER,uid,false) as SummonByTower;
				if(soldier)
				{
					myTowerSoldiers.push(soldier);
					soldier.master = this;
					soldier.visible = true;
					soldier.x = this.x+offX;
					soldier.y = this.y;
					soldier.notifyLifecycleActive();	
				}

			}
			return false;
		}
		
		override public function notifyPetDisappear(uid:uint,pet:BasicSummonSoldier):void
		{
			var idx:int;
			if((idx = myTowerSoldiers.indexOf(pet as SummonByTower)) != -1)
			{
				myTowerSoldiers.splice(idx,1);
			}
		}
	}
}