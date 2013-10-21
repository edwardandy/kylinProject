package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers
{
	import com.shinezone.core.datastructures.HashMap;
	import com.shinezone.towerDefense.fight.constants.BufferFields;
	import com.shinezone.towerDefense.fight.constants.FightElementCampType;
	import com.shinezone.towerDefense.fight.constants.FocusTargetType;
	import com.shinezone.towerDefense.fight.constants.GameFightConstant;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.SubjectCategory;
	import com.shinezone.towerDefense.fight.constants.TowerType;
	import com.shinezone.towerDefense.fight.constants.Skill.SkillResultTyps;
	import com.shinezone.towerDefense.fight.constants.Skill.SkillType;
	import com.shinezone.towerDefense.fight.constants.identify.BufferID;
	import com.shinezone.towerDefense.fight.constants.identify.SkillID;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	
	import framecore.structure.model.constdata.TowerSoundEffectsConst;
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.base.BaseSkillInfo;
	import framecore.structure.model.user.soldier.SoldierTemplateInfo;
	import framecore.structure.model.user.tower.TowerData;
	import framecore.structure.model.user.tower.TowerLevelVo;
	import framecore.tools.media.TowerMediaPlayer;
	
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.barrackTowers.BarrackTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.OrganismBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;
	import release.module.kylinFightModule.gameplay.oldcore.manager.eventsMgr.EndlessBattleMgr;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.gameplay.oldcore.vo.GlobalTemp;
	
	public class BarrackSoldierElement extends BasicOrganismElement
	{
		protected var mySoldierIndex:int = -1;
		protected var myShareCenterPt:PointVO = new PointVO;
		protected var myOwnerTower:BarrackTowerElement;
		
		public function BarrackSoldierElement(typeId:int)
		{
			myMoveFighterInfo = TemplateDataFactory.getInstance().getSoldierTemplateById(typeId);
			
			super(typeId);
			
			this.myElemeCategory = GameObjectCategoryType.SOLDIER;
			this.myCampType = FightElementCampType.FRIENDLY_CAMP;	
		}
		
		public function get soldierIndex():int
		{
			return mySoldierIndex;
		}
		
		public function set soldierIndex(value:int):void
		{
			mySoldierIndex = value;
		}
		
		public function setShareSearchCenter(ptCenter:PointVO):void
		{
			myShareCenterPt.x = ptCenter.x;
			myShareCenterPt.y = ptCenter.y;
		}
		
		public function set ownerTower(value:BarrackTowerElement):void
		{
			myOwnerTower = value;
		}
		
		override public function get subjectCategory():int
		{
			return SubjectCategory.BARRACK_TOWER;
		}
		
		public function updateByBarrackSoldierElement(targetBarrackSoldierElement:BarrackSoldierElement):void
		{
			this.x =  targetBarrackSoldierElement.x;/*myAppointPoint.x =*/
			this.y =  targetBarrackSoldierElement.y;/*myAppointPoint.y =*/
			myAppointPoint.x = targetBarrackSoldierElement.myAppointPoint.x;
			myAppointPoint.y = targetBarrackSoldierElement.myAppointPoint.y;
			myShareCenterPt.x = targetBarrackSoldierElement.searchCenterX;
			myShareCenterPt.y = targetBarrackSoldierElement.searchCenterY;
			//changeToTargetBehaviorState(OrganismBehaviorState.IDLE);
			if(!targetBarrackSoldierElement.isAlive)
			{
				myOwnerTower.notifySoldierIsResurrectionComplete(this);
				return;
			}
			
			if(null == targetBarrackSoldierElement.currentSearchedEnemy)
				moveToAppointPoint(myAppointPoint);
			else
			{
				setSearchedEnemy(targetBarrackSoldierElement.currentSearchedEnemy);
				changeToTargetBehaviorState(OrganismBehaviorState.IDLE);
			}
		}
		
		public function moveToAppointPointFromDoor(appointPoint:PointVO):void
		{
			if(myCampType == FightElementCampType.FRIENDLY_CAMP && !myFightState.bStun)
			{		
				myAppointPoint.x = appointPoint.x;
				myAppointPoint.y = appointPoint.y;
				resetSearchState();
				changeToTargetBehaviorState(OrganismBehaviorState.MOVE_TO_APPOINTED_POINT);
				onDoDefaultBehavior();
				if(OrganismBehaviorState.MOVE_TO_APPOINTED_POINT == currentBehaviorState)
					_isRecieverdersMoveMode = true;
			}
		}
		
		override protected function onRenderWhenResurrectionState():void
		{
			if(myOwnerTower.fightState.bStun)
				return;
			super.onRenderWhenResurrectionState();
		}
		
		//士兵要从兵营里面走出来
		override protected function onResurrectionComplete():void
		{
			ResurrectNow();
		}
		
		private function ResurrectNow():void
		{
			if(1 == _iRebirthType)
			{
				super.onResurrectionComplete();
			}
			else if(0 == _iRebirthType)
			{
				showBufferLayer(true);
				changeToTargetBehaviorState(OrganismBehaviorState.SOLDIER_STAY_AT_HOME);
				initStateWhenActive();
				myOwnerTower.notifySoldierIsResurrectionComplete(this);
			}
			_iRebirthType = 0;
		}
		
		override protected function onLifecycleActivate():void
		{		
			super.onLifecycleActivate();		
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
			myOwnerTower = null;
			mySoldierIndex = -1;
			myShareCenterPt.x = 0;
			myShareCenterPt.y = 0;
		}
		
		override protected function initStateWhenActive():void
		{
			this.myCampType = FightElementCampType.FRIENDLY_CAMP;
			super.initStateWhenActive();
			myFightState.rebirthTime =  SoldierTemplateInfo(myMoveFighterInfo).rebirthTime;
			myResurrectionCDTimer.setDurationTime(myFightState.rebirthTime);
			changeToTargetBehaviorState(OrganismBehaviorState.SOLDIER_STAY_AT_HOME);
		}
		
		override protected function initFightState():void
		{		
			super.initFightState();
			myFightState.cdTime *= (1 - EndlessBattleMgr.instance.addAtkSpdPct*0.01);
			
			var lv:TowerLevelVo = TowerData.getInstance().getTowerLevelVoByTowerType(TowerType.Barrack);
			var addAtk:Number = 1;
			if(lv)
			{
				myFightState.maxlife += TowerData.getInstance().getBarrackLifeByTypeAndLevel(TowerType.Barrack,lv.level);
				addAtk += TowerData.getInstance().getTowerAtkByTypeAndLevel(TowerType.Barrack,lv.level)*0.01;
			}
			addAtk += GlobalTemp.spiritTowerAttackAddition*0.01;
			var addAtk2:Number = 1+EndlessBattleMgr.instance.addAtkPct*0.01;
			myFightState.minAtk *= addAtk * addAtk2;
			myFightState.maxAtk *= addAtk * addAtk2;
		}
		/**
		 * 无极幻境增加攻击力和攻速 
		 * @param atkPct
		 * @param atkSpdPct
		 * 
		 */		
		public function addEndlessBuff(atkPct:int,atkSpdPct:int):void
		{
			if(0 != atkPct)
			{
				var lvAtk:int = 0;
				var lv:TowerLevelVo = TowerData.getInstance().getTowerLevelVoByTowerType(TowerType.Barrack);
				if(lv)
					lvAtk = TowerData.getInstance().getTowerAtkByTypeAndLevel(TowerType.Barrack,lv.level);
				var addAkt:Number = 1+EndlessBattleMgr.instance.addAtkPct*0.01;
				myFightState.minAtk = myMoveFighterInfo.baseAtk*(1 + (lvAtk+GlobalTemp.spiritTowerAttackAddition) * 0.01) * addAkt;
				myFightState.maxAtk = myMoveFighterInfo.maxAtk*(1 + (lvAtk+GlobalTemp.spiritTowerAttackAddition) * 0.01) * addAkt;
			}
			
			if(0 != atkSpdPct)
			{
				myAttackCDTimer.setDurationTime(myAttackCDTimer.duration - (myMoveFighterInfo.cdTime * atkSpdPct*0.01));
			}
		}
		
		/*override protected function onRenderWhenMoveToAppointPoint():void
		{
			if(null == currentSearchedEnemy)
			{
				//重生时如果有敌人从身边经过则进行拦截
				var tempEnemy:BasicOrganismElement = GameAGlobalManager.getInstance().groundSceneHelper
					.searchOrganismElementEnemy(this.x, this.y, myFightState.searchArea, 
						oppositeCampType, searchCanInterceptOtherEnemy);
				if(tempEnemy)
				{
					setSearchedEnemy(tempEnemy);
					moveToCurrentFindedEnemyNearby();		
				}
			}
		}*/
		
		override protected function checkHasAbilityToResurrection():Boolean
		{
			return true;
		}
		
		override protected function get searchCenterX():Number
		{
			return myShareCenterPt.x;
		}
		
		override protected function get searchCenterY():Number
		{
			return myShareCenterPt.y;
		}
		
		override public function processSkillState(state:SkillState):void
		{
			if(SkillID.Provoke == state.id)
			{
				var param:Object = {};
				param[BufferFields.BUFF] = BufferID.ReduceDmgPct;
				param[BufferFields.DURATION] = 5000;
				param[SkillResultTyps.DMG_PCT] = -50;
				notifyAttachBuffer(BufferID.ReduceDmgPct,param,this);
			}
			super.processSkillState(state);
		}
		
		/**
		 * -1为在范围外， 1 在远程范围内， 0表示近战范围,2表示在拦截范围内
		 */
		override protected function caculateTargetEnemyDistanceType(targetEnemy:BasicOrganismElement):int
		{
			var distance:Number = GameMathUtil.distance(this.x,this.y/GameFightConstant.Y_X_RATIO, targetEnemy.x, targetEnemy.y/GameFightConstant.Y_X_RATIO);
			var temp:Number = GameMathUtil.distance(searchCenterX,searchCenterY/GameFightConstant.Y_X_RATIO, targetEnemy.x, targetEnemy.y/GameFightConstant.Y_X_RATIO);
			if(distance <= GameFightConstant.NEAR_ATTACK_RANGE+5) 
				return 0;
			
			if(isFarAttackable)
			{
				if(temp > myFightState.atkArea) 
					return -1;
				else if(temp <= myFightState.atkArea && temp > myFightState.searchArea)
					return 1;
				else if(temp <= myFightState.searchArea && temp > GameFightConstant.NEAR_ATTACK_RANGE)
					return 2;
			}
			else
			{
				if(temp > myFightState.searchArea)
					return -1;
				else if(temp <= myFightState.searchArea && temp > GameFightConstant.NEAR_ATTACK_RANGE)
					return 2;
			}
			return -1;
		}
		
		override protected function getCanUseSkills():void
		{
			updateSkill(SkillID.CureSlef,1);
			
			if(myOwnerTower.soldierSkills.isEmpty())
				return;
			var skills:HashMap = myOwnerTower.soldierSkills;
			for each(var id:uint in skills.keys())
			{
				var info:BaseSkillInfo = getBaseSkillInfo(id);
				if(SkillType.PASSIVITY == info.type)
				{
					var maxLvl:int = skills.get(id);
					for(var i:int=1; i<=maxLvl; ++i)
					{
						var curId:uint = getCurSkillIdByLvl(id,i);
						processSinglePassiveSkill(curId);
					}
				}
				else
					updateSkill(id,skills.get(id));
			}
		}
		
		override protected function processPassiveSkills():void
		{
			
		}
		
		override protected function genSKillUseUnits():void
		{
			
		}
		
		public function notifySkillUp(skillId:uint,iLvl:int):void
		{
			updateSkill(skillId,iLvl);
		}
		
		override public function get type():int
		{
			return FocusTargetType.SOLDIER_TYPE;
		}
		
		override protected function getDefaultSoundString():String
		{
			return myMoveFighterInfo?myMoveFighterInfo.sound:null;
		}
		
		override public function get resourceID():int
		{
			return (myMoveFighterInfo as SoldierTemplateInfo).resId || myObjectTypeId;
		}
	}
}