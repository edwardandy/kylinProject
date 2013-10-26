package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers
{
	import flash.events.MouseEvent;
	
	import io.smash.time.TimeManager;
	
	import mainModule.model.gameData.dynamicData.hero.IHeroDynamicDataModel;
	import mainModule.model.gameData.dynamicData.hero.IHeroDynamicItem;
	import mainModule.model.gameData.dynamicData.heroSkill.IHeroSkillDynamicDataModel;
	import mainModule.model.gameData.dynamicData.heroSkill.IHeroSkillDynamicItem;
	import mainModule.model.gameData.sheetData.hero.IHeroSheetDataModel;
	import mainModule.model.gameData.sheetData.hero.IHeroSheetItem;
	import mainModule.model.gameData.sheetData.skill.IBaseOwnerSkillSheetItem;
	
	import release.module.kylinFightModule.gameplay.constant.FocusTargetType;
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.OrganismDieType;
	import release.module.kylinFightModule.gameplay.constant.SoundFields;
	import release.module.kylinFightModule.gameplay.constant.SubjectCategory;
	import release.module.kylinFightModule.gameplay.constant.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.constant.identify.BufferID;
	import release.module.kylinFightModule.gameplay.constant.identify.SkillID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.BasicMouseCursor;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.IMouseCursorSponsor;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.OrganismBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.BasicMonsterElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.GameFightMainUIView;
	import release.module.kylinFightModule.gameplay.oldcore.events.SceneElementEvent;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightInfoRecorder;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightMouseCursorManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;
	import release.module.kylinFightModule.model.interfaces.IFightViewLayersModel;
	import release.module.kylinFightModule.utili.structure.PointVO;
	
	public class HeroElement extends BasicCondottiereSoldier implements IMouseCursorSponsor
	{
		[Inject]
		public var heroData:IHeroDynamicDataModel;
		[Inject]
		public var heroModel:IHeroSheetDataModel;
		[Inject]
		public var recorderMgr:GameFightInfoRecorder;
		[Inject]
		public var heroSkillData:IHeroSkillDynamicDataModel;
		[Inject]
		public var mouseCursorMgr:GameFightMouseCursorManager;
		[Inject]
		public var fightViewModel:IFightViewLayersModel;
		[Inject]
		public var timeMgr:TimeManager;
		
		protected var myIdelRandomAnimationCDTimer:SimpleCDTimer;
		protected var myHeroIndex:int = -1;
		protected var myHeroInfo:IHeroDynamicItem;
		private var _bChangeFightAction:Boolean = false;
		protected var arrExceptBuffIds:Array;
		
		protected var myMouseCursor:BasicMouseCursor;
		
		private var _lastMoveSoundIdx:int = -1;
		private var _lastMoveTick:int = -1;
		
		public function HeroElement(typeId:int)
		{		
			super(typeId);
		}
		
		[PostConstruct]
		override public function onPostConstruct():void
		{
			this.myElemeCategory = GameObjectCategoryType.HERO;
			
			super.onPostConstruct();
			
			myHeroInfo = heroData.getHeroDataById(myObjectTypeId);
			myMoveFighterInfo = heroModel.getHeroSheetById(myObjectTypeId);
			_bNeedRebirthAnim = true;
			myFocusTipEnable = false;
		}
		
		//API
		override protected function onkillEnemyCampTypeMonster(monster:BasicMonsterElement):void
		{
			sceneModel.updateSceneGold(monster.monsterTemplateInfo.heroRewardGoods*(1+myFightState.addGoodsPct*0.01));
			
			mainUI.playAddGoodsAnim(0,-monster.bodyHeight
				,monster.monsterTemplateInfo.rewardGoods+monster.monsterTemplateInfo.heroRewardGoods,monster,false,0xeb5d3c);
			
			recorderMgr.addHeroKillUintSocre(monster.monsterTemplateInfo.deadScore);
			recorderMgr.addHeroKillUintEXP(objectTypeId, monster.monsterTemplateInfo.rewardExp);
			//recorderMgr.addBattleOPRecord( GameFightInfoRecorder.BATTLE_OP_TYPE_HERO_KILL_MONSTER, objectTypeId );
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			myIdelRandomAnimationCDTimer = new SimpleCDTimer(0);
			injector.injectInto(myIdelRandomAnimationCDTimer);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			myIdelRandomAnimationCDTimer = null;
		}

		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			
		}
		
		override protected function initStateWhenActive():void
		{
			super.initStateWhenActive();	
			myFightState.rebirthTime = IHeroSheetItem(myMoveFighterInfo).rebirthTime*(100 - myFightState.extraRebirthTime)/100.0;
			myResurrectionCDTimer.setDurationTime(myFightState.rebirthTime);
			myIdelRandomAnimationCDTimer.setDurationTime(uint(GameMathUtil.randomFromValues([9000, 12000, 15000])));
			_lastMoveSoundIdx = -1;
			_lastMoveTick = -1;
		}
		
		override protected function onRenderWhenIdelState():void
		{
			super.onRenderWhenIdelState();
			
			//myIdelRandomAnimationCDTimer.tick();
			checkRandomIdelAnim();
		}
		
		protected function checkRandomIdelAnim():void
		{
			if(OrganismBehaviorState.IDLE == currentBehaviorState && myIdelRandomAnimationCDTimer.getIsCDEnd())
			{
				myIdelRandomAnimationCDTimer.resetCDTime();
				myBodySkin.gotoAndPlay2(getIdleTypeStr() + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
					getIdleTypeStr() + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, myIdelRandomAnimationEndHandler);
			}
		}
		
		override protected function onResurrectionComplete():void
		{
			super.onResurrectionComplete();
			myIdelRandomAnimationCDTimer.resetCDTime();
		}
		
		private function myIdelRandomAnimationEndHandler():void
		{
			enforceRecoverToStandState();
		}
		
		//技能相关
		override protected function getCanUseSkills():void
		{
			for each(var info:IHeroSkillDynamicItem in heroSkillData.getHeroAllSkillData(myObjectTypeId))
			{
				mySkillIds.push(info.skillId);
			}	
			
			/*if(myHeroInfo.arrTalents && myHeroInfo.arrTalents.length>0)
			{
				for each(var talentId:uint in myHeroInfo.arrTalents)
				{
					var temp:HeroTalentTemplateInfo = TemplateDataFactory.getInstance().getHeroTalentTemplateById(talentId);
					if(temp && temp.skillId)
						mySkillIds.push(temp.skillId);
				}
			}*/
			
			mySkillIds.push(SkillID.AutoRecoverLife);
		}
		
		override protected function getBaseSkillInfo(id:uint):IBaseOwnerSkillSheetItem
		{
			return heroSkillModel.getHeroSkillSheetById(id);
		}
		
		override protected function initFightState():void
		{
			var heroSheet:IHeroSheetItem = myMoveFighterInfo as IHeroSheetItem;
			
			myFightState.baseAtkArea = myMoveFighterInfo.atkArea;
			myFightState.searchArea = myMoveFighterInfo.searchArea;
			myFightState.range = myMoveFighterInfo.atkRange;
			myFightState.cdTime = myMoveFighterInfo.atkInterval;
			//myFightState.skillAtk = heroSheet.skillAtk + myHeroInfo.level*heroSheet.skillAtkGrowth;
			myFightState.magicDefense = myMoveFighterInfo.magicDef;
			myFightState.maxAtk = myMoveFighterInfo.maxAtk + myHeroInfo.level*heroSheet.maxAtkGrowth + myHeroInfo.level*heroSheet.potencyAtkGrowth;
			myFightState.maxlife = myMoveFighterInfo.life + myHeroInfo.level*heroSheet.lifeGrowth + myHeroInfo.level*heroSheet.potencyLifeGrowth;
			myFightState.minAtk = myMoveFighterInfo.minAtk + myHeroInfo.level*heroSheet.minAtkGrowth + myHeroInfo.level*heroSheet.potencyAtkGrowth;
			myFightState.physicDefense = myMoveFighterInfo.physicDef;
			myFightState.atkType = myMoveFighterInfo.atkType;
			myFightState.weapon = myMoveFighterInfo.weapon;
			
			calcHeroEquipEffect();
			calcHeroJewelryEffect();
			
			//myFightState.minAtk *= (100 + GlobalTemp.spiritHeroAttackAddition)*0.01;
			//myFightState.maxAtk *= (100 + GlobalTemp.spiritHeroAttackAddition)*0.01;
		}
		
		private function calcHeroEquipEffect():void
		{
			/*var equips:Vector.<EquipInfo> = EquipData.instance.getHeroEquips(myHeroInfo.heroTemplateInfo.configId);
			for each(var equip:EquipInfo in equips)
			{
				switch(equip.equipTemplateInfo.equipType)
				{
					case EquipConst.EquipType_Body:
						myFightState.maxlife += equip.getTotalEffectValue1();
						break;
					case EquipConst.EquipType_Head:
						myFightState.skillAtk += equip.getTotalEffectValue1();
						break;
					case EquipConst.EquipType_Decorate:
						myFightState.cdTime -= equip.getTotalEffectValue1();
						break;
					case EquipConst.EquipType_Hand:
						myFightState.minAtk += equip.getTotalEffectValue1();
						myFightState.maxAtk += equip.getTotalEffectValue2();
						break;
				}
				
				if(equip.equipTemplateInfo.equipDefValue >0)
					myFightState.extraPhysicDefense += equip.equipTemplateInfo.equipDefValue;
				if(equip.equipTemplateInfo.equipBloodValue)
					myFightState.equipBloodValuePct = equip.equipTemplateInfo.equipBloodValue;
				if(equip.equipTemplateInfo.equipCritValue)
					myFightState.equipCritValuePct = equip.equipTemplateInfo.equipCritValue;
			}*/
		}
		
		private function calcHeroJewelryEffect():void
		{
			/*for (var iType:int = EquipConst.EquipType_Head;iType<EquipConst.EquipType_Count;++iType)
			{
				var jewelryInfo:ItemInfo = JewelryData.instance.getJewelryOfHero(myHeroInfo.heroTemplateInfo.configId,iType);
				if(!jewelryInfo)
					continue;
				if(jewelryInfo.itemTemplateInfo.effectValue)
				{
					var arrEffect:Array = ((jewelryInfo.itemTemplateInfo.effectValue.split("|")[1]) as String).split(";");
					for each(var strEffect:String in arrEffect)
					{
						var arr:Array = strEffect.split(":");
						var subArr:Array = (arr[1] as String).split(",");
						switch(int(arr[0]))
						{
							case EquipConst.EquipType_Body:
								myFightState.maxlife += int(subArr[0]);
								myFightState.maxlife *= 1+subArr[1]*0.0001;
								break;
							case EquipConst.EquipType_Head:
								myFightState.skillAtk += int(subArr[0]);
								myFightState.skillAtk *= 1+subArr[1]*0.0001;
								break;
							case EquipConst.EquipType_Decorate:
								myFightState.cdTime -= int(subArr[0]);
								myFightState.cdTime *= 1-subArr[1]*0.0001;
								break;
							case EquipConst.EquipType_Hand:
								var arrAtk0:Array = (subArr[0] as String).split("-");
								var arrAtk1:Array = (subArr[1] as String).split("-");
								myFightState.minAtk += int(arrAtk0[0]);
								myFightState.minAtk *= 1+arrAtk1[0]*0.0001;
								myFightState.maxAtk += int(arrAtk0[1]);
								myFightState.maxAtk *= 1+arrAtk1[1]*0.0001;
								break;
						}
					}
				}
			}*/
		}
		
		override public function get subjectCategory():int
		{
			return SubjectCategory.HERO;
		}
		
		override protected function onFocusChanged():void
		{
			if(isAlive)
				myFocusTipEnable = false;
			else
				myFocusTipEnable = true;
			
			super.onFocusChanged();
			
			if(myIsInFocus)
			{
				if(isAlive)
				{
					mouseCursorMgr.activeMouseCursorByName(
							GameFightMouseCursorManager.HERO_MOVE_MOUSE_CURSOR, this);
					myMouseCursor = mouseCursorMgr.getCurrentMouseCursor();
				}
			}
			else if(myMouseCursor)
			{
				mouseCursorMgr.deactiveTargetCurrentMouseCursor(myMouseCursor);
			}
		}
		
		public function notifyTargetMouseCursorSuccessRealsed(mouseClickEvent:MouseEvent):void
		{	
			var path:Vector.<PointVO> = new Vector.<PointVO>;
			path.push(new PointVO(x,y))
			path.push(GameMathUtil.convertStagePtToGame(mouseClickEvent.stageX,mouseClickEvent.stageY,fightViewModel.groundLayer));

			if(isAlive)
				moveToAppointPointByPath(path);
			
			gameInteractiveMgr.setCurrentFocusdElement(null);
		}
		
		public function notifyTargetMouseCursorCanceled():void
		{
			
		}
		
		override public function notifyTriggerSkillAndBuff(condition:int):void
		{
			super.notifyTriggerSkillAndBuff(condition);
			if(condition == TriggerConditionType.LIFE_OR_MAXLIFE_CHANGED)
			{
				dispatchEvent(new SceneElementEvent(SceneElementEvent.ON_LIFE_CHANGED));
			}
		}
		
		/************************************************************************
		 * *********************  动作标签 *****************************************
		 * *********************************************************************/
		protected function get bChangeFightAction():Boolean
		{
			return _bChangeFightAction;
		}
		
		protected function set bChangeFightAction(bChange:Boolean):void
		{
			_bChangeFightAction = bChange;
		}
		
		override protected function fireToTargetEnemy():void
		{
			_bChangeFightAction = GameMathUtil.randomTrueByProbability(0.5);
			super.fireToTargetEnemy();
		}
		
		override protected function getNearAttackTypeStr():String
		{
			if(!isFarAttackable && _bChangeFightAction)
			{
				if(hasBuffer(BufferID.AddAtkSpeed))
					return GameMovieClipFrameNameType.NEAR_ATTACK_3;
				return GameMovieClipFrameNameType.NEAR_ATTACK_1;
			}
			if(hasBuffer(BufferID.AddAtkSpeed))
				return GameMovieClipFrameNameType.NEAR_ATTACK_2;
			return GameMovieClipFrameNameType.NEAR_ATTACK;
		}
		
		override protected function getNearFirePointTypeStr():String
		{
			if(!isFarAttackable && _bChangeFightAction)
			{
				if(hasBuffer(BufferID.AddAtkSpeed))
					return GameMovieClipFrameNameType.NEAR_FIRE_POINT_3;
				return GameMovieClipFrameNameType.NEAR_FIRE_POINT_1;
			}
			if(hasBuffer(BufferID.AddAtkSpeed))
				return GameMovieClipFrameNameType.NEAR_FIRE_POINT_2;
			return GameMovieClipFrameNameType.NEAR_FIRE_POINT;
		}
		
		override protected function getFarAttackTypeStr():String
		{
			if(isFarAttackable && _bChangeFightAction)
			{
				if(hasBuffer(BufferID.AddAtkSpeed))
					return GameMovieClipFrameNameType.FAR_ATTACK_3;
				return GameMovieClipFrameNameType.FAR_ATTACK_1;
			}
			if(hasBuffer(BufferID.AddAtkSpeed))
				return GameMovieClipFrameNameType.FAR_ATTACK_2;
			return GameMovieClipFrameNameType.FAR_ATTACK;
		}
		
		override protected function getFarFirePointTypeStr():String
		{
			if(isFarAttackable && _bChangeFightAction)
			{
				if(hasBuffer(BufferID.AddAtkSpeed))
					return GameMovieClipFrameNameType.FAR_FIRE_POINT_3;
				return GameMovieClipFrameNameType.FAR_FIRE_POINT_1;
			}
			if(hasBuffer(BufferID.AddAtkSpeed))
				return GameMovieClipFrameNameType.FAR_FIRE_POINT_2;
			return GameMovieClipFrameNameType.FAR_FIRE_POINT;
		}
		
		override public function get type():int
		{
			return FocusTargetType.HERO_TYPE;
		}
		
		override protected function checkCanResurrect():Boolean
		{
			var dieAnimationFrameKey:String = getDyingAnimationFrameKeyByDieType(OrganismDieType.NORMAL_DIE);
			myBodySkin.gotoAndStop2(dieAnimationFrameKey + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END);
			return super.checkCanResurrect();
		}
		
		public function get rebirthCd():SimpleCDTimer
		{
			return myResurrectionCDTimer;
		}
		
		override protected function clearBufferStates(bDie:Boolean = false):void
		{
			if(bDie)
				_buffStates.clearExcept(exceptBuffIds);
			else
				super.clearBufferStates(bDie);
		}
		
		protected function get exceptBuffIds():Array
		{
			return arrExceptBuffIds ||= [BufferID.Rebirth];
		}
		
		override public function get curLevel():int
		{
			return myHeroInfo.level;
		}
		
		override protected function getDefaultSoundObj():Object
		{
			return myMoveFighterInfo?myMoveFighterInfo.objSound:null;
		}
		
		override public function addPassiveEquipPct(value:Array,owner:ISkillOwner):Boolean
		{
			/*var equips:Vector.<EquipInfo> = EquipData.instance.getHeroEquips(myHeroInfo.heroTemplateInfo.configId);
			for each(var equip:EquipInfo in equips)
			{
				if(value.length >= equip.equipTemplateInfo.equipType && int(value[equip.equipTemplateInfo.equipType-1]) > 0)
				{
					switch(equip.equipTemplateInfo.equipType)
					{
						case EquipConst.EquipType_Body:
							myFightState.maxlife += equip.getTotalEffectValue1()*int(value[equip.equipTemplateInfo.equipType-1])*0.01;
							break;
						case EquipConst.EquipType_Head:
							myFightState.skillAtk += equip.getTotalEffectValue1()*int(value[equip.equipTemplateInfo.equipType-1])*0.01;
							break;
						case EquipConst.EquipType_Decorate:
							myFightState.cdTime -= equip.getTotalEffectValue1()*(value[equip.equipTemplateInfo.equipType-1]*0.01)
							break;
						case EquipConst.EquipType_Hand:
							myFightState.minAtk += equip.getTotalEffectValue1()*int(value[equip.equipTemplateInfo.equipType-1])*0.01;
							myFightState.maxAtk += equip.getTotalEffectValue2()*int(value[equip.equipTemplateInfo.equipType-1])*0.01;
							break;
					}
				}
			}*/
			return true;
		}
		
		public function playMoveSound():void
		{
			if(_lastMoveTick>0 && (timeMgr.virtualTime-_lastMoveTick)<2000)
				return;
			_lastMoveTick = timeMgr.virtualTime;
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
		
		override protected function playNearAttackSound():void
		{
			playSound(getSoundId(SoundFields.NearAttack,-1));
		}
		
		override protected function playFarAttackSound():void
		{
			playSound(getSoundId(SoundFields.FarAttack,-1));
		}
	}
}