package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.barrackTowers
{
	import kylin.echo.edward.utilities.datastructures.HashMap;
	
	import release.module.kylinFightModule.gameplay.constant.FocusTargetType;
	import release.module.kylinFightModule.gameplay.constant.GameFightConstant;
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.SceneType;
	import release.module.kylinFightModule.gameplay.constant.SoundFields;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.ToftElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.TowerBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.BarrackSoldierElement;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;
	import release.module.kylinFightModule.utili.structure.PointVO;

	//士兵塔中的3个士兵的生命周期实际是有该塔一直控制的，直到该塔对象被移除，才会交还给缓存系统
	public class BarrackTowerElement extends BasicTowerElement
	{
		protected var myBarrackMeetingCenterPoint:PointVO = new PointVO();//本地
		protected var myTowerSoldiers:Vector.<BarrackSoldierElement>;
		private var _mySoldierSkills:HashMap;
		
		//士兵开门出去是排队出去的
		private var _awayFromHomeSoldiersQueue:Array = [];//[0->soidler, 1->data]
		
		private var _lockFocusCDTimer:SimpleCDTimer;
		private var _lastMoveSoundIdx:int = -1;
		
		public function BarrackTowerElement(typeId:int)
		{
			super(typeId);
		}
		
		public final function get meetingCenterPoint():PointVO
		{
			return myBarrackMeetingCenterPoint.clone();
		}
		
		public final function getAllTowerSoldiers():Vector.<BarrackSoldierElement>
		{
			return myTowerSoldiers.concat();
		}
		
		public final function moveAllSoldierToMeetingCenterPoint(gloabalPoint:PointVO):void
		{
			myBarrackMeetingCenterPoint.x = gloabalPoint.x - this.x;
			myBarrackMeetingCenterPoint.y = gloabalPoint.y - this.y;
			
			var soldier:BarrackSoldierElement = null;
			for(var i:uint = 0; i < 3; i++)
			{
				soldier = myTowerSoldiers[i];

				if(soldier.isAlive)
				{
					/*var currentSoldierMeetingLocalPoint:PointVO = GameFightConstant.MYBARRACK_SOLDIERS_MEETING_LOCALPOINTS[i];
					
					var mySoldierMoveRadian:Number = GameMathUtil
						.caculateDirectionRadianByTwoPoint2(0, 0, myBarrackMeetingCenterPoint.x, myBarrackMeetingCenterPoint.y);
					
					//计算相对位置
					var soldierMeetingPoint:PointVO = GameMathUtil.caculateSourceAxeLocalPointInNewAxePoint(myBarrackMeetingCenterPoint.x + this.x, 
						myBarrackMeetingCenterPoint.y + this.y, 
						mySoldierMoveRadian, 
						currentSoldierMeetingLocalPoint.x, currentSoldierMeetingLocalPoint.y);*/
					
					var soldierMeetingPoint:PointVO = GameMathUtil.
						caculatePointOnCircle(gloabalPoint.x,gloabalPoint.y,GameFightConstant.MYBARRACK_SOLDIERS_DEGREE[i],20,true);
					soldier.setShareSearchCenter(gloabalPoint);
					soldier.moveToAppointPoint(soldierMeetingPoint);
				}
			}
		}
		
		override public function buildedByToft(t:ToftElement):void
		{
			super.buildedByToft(t);

			myBarrackMeetingCenterPoint.x = t.meetingCenterPoint.x;
			myBarrackMeetingCenterPoint.y = t.meetingCenterPoint.y;
			moveAllSoldiersFomTowerToCurrentMeetinglPoint();
		}
		
		override public function buildedByTower(t:BasicTowerElement, additionalCostGold:uint):void
		{
			super.buildedByTower(t, additionalCostGold);
			
			myBarrackMeetingCenterPoint.x = BarrackTowerElement(t).meetingCenterPoint.x;
			myBarrackMeetingCenterPoint.y = BarrackTowerElement(t).meetingCenterPoint.y;
			
			var targetTowerSoldiers:Vector.<BarrackSoldierElement> = BarrackTowerElement(t).getAllTowerSoldiers();
			
			var soldier:BarrackSoldierElement = null;
			for(var i:uint = 0; i < 3; i++)
			{
				soldier = myTowerSoldiers[i];
				soldier.visible = true;
				soldier.updateByBarrackSoldierElement(targetTowerSoldiers[i]);
			}
		}
		
		override protected function onRenderWhenIdelState():void {};
		
		private function moveAllSoldiersFomTowerToCurrentMeetinglPoint():void
		{
			for(var i:uint = 0; i < 3; i++)
			{
				moveSoldierFomTowerToCurrentTowerMeetinPoint(myTowerSoldiers[i], i);
			}
		}
		
		//ISoldierOnwer Interface
		public function notifySoldierIsResurrectionComplete(soldier:BarrackSoldierElement):void
		{
			soldier.visible = false;
			moveSoldierFomTowerToCurrentTowerMeetinPoint(soldier, soldier.soldierIndex);
		}

		private function moveSoldierFomTowerToCurrentTowerMeetinPoint(soldier:BarrackSoldierElement, soldierIndex:int):void
		{
			myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.DOOR_OPEN + 
								GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
									GameMovieClipFrameNameType.DOOR_OPEN + 
								GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 
								1, 
								onTowerDoorOpenEndHandler);
			
			/*var currentSoldierMeetingLocalPoint:PointVO = GameFightConstant.MYBARRACK_SOLDIERS_MEETING_LOCALPOINTS[soldierIndex];
			
			var mySoldierMoveRadian:Number = GameMathUtil
					.caculateDirectionRadianByTwoPoint2(0, 0, myBarrackMeetingCenterPoint.x, myBarrackMeetingCenterPoint.y);

			//计算相对位置
			var soldierMeetingPoint:PointVO = GameMathUtil.caculateSourceAxeLocalPointInNewAxePoint(myBarrackMeetingCenterPoint.x + this.x, 
				myBarrackMeetingCenterPoint.y + this.y, 
				mySoldierMoveRadian, 
				currentSoldierMeetingLocalPoint.x, currentSoldierMeetingLocalPoint.y);*/
			
			var soldierMeetingPoint:PointVO = GameMathUtil.
				caculatePointOnCircle(myBarrackMeetingCenterPoint.x + this.x,myBarrackMeetingCenterPoint.y + this.y
					,GameFightConstant.MYBARRACK_SOLDIERS_DEGREE[soldierIndex],20,true);
			
			var awayFromHomeItem:Array = [soldier, soldierMeetingPoint]; 
			_awayFromHomeSoldiersQueue.push(awayFromHomeItem);
		}
		
		private function onTowerDoorOpenEndHandler():void
		{
			while(_awayFromHomeSoldiersQueue.length)
			{
				var awayFromHomeItem:Array = _awayFromHomeSoldiersQueue.pop();
				
				var soldier:BarrackSoldierElement = awayFromHomeItem[0];
				soldier.x = this.x;
				soldier.y = this.y;
				soldier.visible = true;
				soldier.setShareSearchCenter(new PointVO(myBarrackMeetingCenterPoint.x + this.x,myBarrackMeetingCenterPoint.y + this.y));
				soldier.moveToAppointPointFromDoor(awayFromHomeItem[1]);
			}

			myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.DOOR_CLOSE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				GameMovieClipFrameNameType.DOOR_CLOSE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1);
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			myTowerSoldiers = new Vector.<BarrackSoldierElement>(3, true);
			
			_lockFocusCDTimer = new SimpleCDTimer(800);
			injector.injectInto(_lockFocusCDTimer);
			
//			_s = new Shape();
//			addChild(_s);
		}
		
		override protected function createBuildingCircleMenu():void
		{
			if(myTowerTemplateInfo.level < 2)
			{
				myBuildingCircleMenu = new BarrackTowerSingleUpdateLevelMenu(this, myTowerTemplateInfo);
			}
			else if(myTowerTemplateInfo.level == 2)//这里会有多个
			{
				myBuildingCircleMenu = new BarrackTowerMutiUpdateLevelMenu(this, myTowerTemplateInfo);
			}
			else if(myTowerTemplateInfo.level == 3)
			{
				myBuildingCircleMenu = new BarrackTowerSkillUpdateLevelMenu(this, myTowerTemplateInfo);
			}
			
			if(myBuildingCircleMenu != null)
			{
				injector.injectInto(myBuildingCircleMenu);
				addChild(myBuildingCircleMenu);
			}
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			
			//lock first
			myFocusEnable = false;
			_lockFocusCDTimer.resetCDTime();
			
			var soldier:BarrackSoldierElement;
			//这里去缓存系统去申请士兵
			for(var i:uint = 0; i < 3; i++)
			{
				soldier = objPoolMgr.createSceneElementObject(GameObjectCategoryType.SOLDIER
					, myTowerTemplateInfo.soldierId, false) as BarrackSoldierElement;
				soldier.soldierIndex = i;
				soldier.ownerTower = this;		
				myTowerSoldiers[i] = soldier;
				soldier.notifyLifecycleActive();
				soldier.visible = false;
			}
			
//			myAttackArea = soldier.attackArea;
			
			//test
//			_s.graphics.beginFill(0xFF0000, 0.3);
//			_s.graphics.drawCircle(myBarrackMeetingCenterPoint.x, myBarrackMeetingCenterPoint.y, 2);
//			_s.graphics.drawCircle(myBarrackMeetingCenterPoint.x, myBarrackMeetingCenterPoint.y, myAttackArea);
		}
		
		override protected function getCanUseSkills():void
		{
			
		}
		
		override protected function processPassiveSkills():void
		{
			
		}
		
		override protected function genSKillUseUnits():void
		{
			
		}
		
		override public function notifyCircleMenuOnSkillUp(skillId:uint,iLvl:int):void
		{
			soldierSkills.put(skillId,iLvl);
			var soldier:BarrackSoldierElement;
			for(var i:uint = 0; i < 3; i++)
			{
				soldier = myTowerSoldiers[i];
				if(soldier)
					soldier.notifySkillUp(skillId,iLvl);
			}
		}
		
		public function get soldierSkills():HashMap
		{
			return _mySoldierSkills ||= new HashMap;
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();

			_awayFromHomeSoldiersQueue = [];
			_lastMoveSoundIdx = -1;
			//这里将士兵交还给缓存系统
			var soldier:BarrackSoldierElement = null;
			for(var i:uint = 0; i < 3; i++)
			{
				soldier = myTowerSoldiers[i];
				soldier.destorySelf();
				myTowerSoldiers[i] = null;
			}
			
			if(null != _mySoldierSkills)
			{
				_mySoldierSkills.clear();
				_mySoldierSkills = null;
			}
		}
		
		override public function addEndlessBuff(atkPct:Number,atkSpdPct:int):void
		{
			for each(var soldier:BarrackSoldierElement in myTowerSoldiers)
			{
				soldier.addEndlessBuff(atkPct,atkSpdPct);
			}
		}
		
		override public function render(iElapse:int):void
		{
			if(!myFocusEnable)
			{
				//_lockFocusCDTimer.tick();
				if(_lockFocusCDTimer.getIsCDEnd())
				{
					myFocusEnable = true;
				}
			}
			
			super.render(iElapse);
			
//			mySearchedEnemy = GameAGlobalManager
//				.getInstance()
//				.groundSceneHelper
//				.searchOrganismElementEnemy(myBarrackMeetingGlobalCenterPoint.x, 
//					myBarrackMeetingGlobalCenterPoint.y, myAttackArea, 
//					FightElementCampType.ENEMY_CAMP,
//					soldierNecessarySearchConditionFilter);
//
//			if(mySearchedEnemy != null)
//			{
//				var soldier:BasicSoldierElement = null;
//				for(var i:uint = 0; i < 3; i++)
//				{
//					soldier = myTowerSoldiers[i];
//					soldier.assignTowerSearchedEnemy(mySearchedEnemy);
//				}
//			}
//			
//			myBodySkin.render();
		}

		private function soldierNecessarySearchConditionFilter(target:BasicOrganismElement):Boolean
		{
			return !target.fightState.isFlyUnit && !target.hasTargetEnemy();
		}
		
		override protected function onBehaviorStateChanged():void
		{
			super.onBehaviorStateChanged();

			switch(currentBehaviorState)
			{
				case TowerBehaviorState.IDEL:
					myBodySkin.gotoAndStop2(2);
					break;
			}
		}

		override public function dispose():void
		{
			super.dispose();

			myTowerSoldiers = null;
		}
		
		override protected function onFocusShowTowerRange(bShow:Boolean):void
		{
			
		}
		
		override protected function getRangeColor():uint
		{
			switch(sceneModel.sceneType)
			{
				case SceneType.Grassland:
					return 0xfff1bb;
					break;
				case SceneType.Snowland:
					return 0xffffff;
					break;
				case SceneType.Lavaland:
					return 0xc4b6ad;
					break;
				case SceneType.Desert:
					return 0xffefbf;
					break;
				case SceneType.Swamp:
					return 0xdbdfbd;
					break;
			}
			return 0x7db69c;
		}
		
		override protected function getRangeBorderColor():uint
		{
			return 0x448a05;
		}
		
		override protected function onMouseInAndOut2FocusChanged():void
		{
			super.onMouseInAndOut2FocusChanged();
			var soldier:BarrackSoldierElement;
			if(myIsInFocus || myIsMouseOver) 
			{
				for(var i:uint = 0; i < 3; i++)
				{
					soldier = myTowerSoldiers[i];
					soldier.setBodyFilter([filterMgr.yellowGlowFilter]);
				}
				
			}
			else
			{
				for(var j:uint = 0; j < 3; j++)
				{
					soldier = myTowerSoldiers[j];
					soldier.setBodyFilter(null);
				}
			}
		}
		
		override public function get type():int
		{
			return FocusTargetType.DEFENSE_TOWER_TYPE;
		}
		
		override public function get maxLife():int
		{
			var soldier:BarrackSoldierElement = myTowerSoldiers[0];
			if(soldier)
				return soldier.fightState.maxlife;
			return 0;
		}
		
		override public function get minAttack():int
		{
			var soldier:BarrackSoldierElement = myTowerSoldiers[0];
			if(soldier)
				return soldier.fightState.minAtk;
			return 0;
		}
		
		override public function get maxAttack():int
		{
			var soldier:BarrackSoldierElement = myTowerSoldiers[0];
			if(soldier)
				return soldier.fightState.maxAtk;
			return 0;
		}
		
		override public function get defense():int
		{
			var soldier:BarrackSoldierElement = myTowerSoldiers[0];
			if(soldier)
				return soldier.defense;
			return 0;	
		}
		
		override public function get defenseType():Boolean
		{
			var soldier:BarrackSoldierElement = myTowerSoldiers[0];
			if(soldier)
				return soldier.defenseType;
			return false;
		}
		
		override public function get rebirthTime():int
		{
			var soldier:BarrackSoldierElement = myTowerSoldiers[0];
			if(soldier)
				return soldier.rebirthTime;
			return 0;
		}
		
		public function playMoveSound():void
		{
			var arrSounds:Array = getSoundIdArray(SoundFields.Move);
			if(!arrSounds || 0 == arrSounds.length)
				return;
			var idx:int;
			do
			{
				idx = GameMathUtil.randomIndexByLength(arrSounds.length);
			}
			while(_lastMoveSoundIdx == idx);
			playSound(arrSounds[idx]);
		}
	}
}