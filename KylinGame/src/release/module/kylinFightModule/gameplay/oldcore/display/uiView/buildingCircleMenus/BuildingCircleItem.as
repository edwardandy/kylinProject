package release.module.kylinFightModule.gameplay.oldcore.display.uiView.buildingCircleMenus
{
	import flash.text.TextField;
	
	import mainModule.model.gameData.dynamicData.fight.IFightDynamicDataModel;
	import mainModule.model.gameData.dynamicData.tower.ITowerDynamicDataModel;
	import mainModule.model.gameData.dynamicData.tower.ITowerDynamicItem;
	import mainModule.model.gameData.sheetData.tollgate.ITollgateSheetDataModel;
	import mainModule.model.gameData.sheetData.tower.ITowerSheetDataModel;
	import mainModule.model.gameData.sheetData.tower.ITowerSheetItem;
	import mainModule.service.gameDataServices.helpServices.ITollgateService;
	
	import release.module.kylinFightModule.model.interfaces.ISceneDataModel;

	public class BuildingCircleItem extends BasicBuildingCircleItem
	{
		[Inject]
		public var towerModel:ITowerSheetDataModel;
		[Inject]
		public var towerData:ITowerDynamicDataModel;
		[Inject]
		public var sceneModel:ISceneDataModel;
		[Inject]
		public var tollgateModel:ITollgateSheetDataModel;
		[Inject]
		public var tollgateService:ITollgateService;
		[Inject]
		public var fightData:IFightDynamicDataModel;
		
		protected var myTargetTowerTypeId:int = -1;
		protected var myUpdatedCostMoney:uint = 0;
		protected var myTowerTemplateInfo:ITowerSheetItem;
		protected var myIsOnlyUpdateMode:Boolean = false;
				
		private var _unLockFrameKey:String;
		
		public function BuildingCircleItem(targetTowerTypeId:int, 
										   clickCallback:Function,
										   buildingCircleMenu:BasicBuildingCircleMenu,
										   isOnlyUpdateMode:Boolean = false)
		{
			super(clickCallback, buildingCircleMenu);
			myTargetTowerTypeId = targetTowerTypeId;
			myIsOnlyUpdateMode = isOnlyUpdateMode;
		}
		
		[PostConstruct]
		public function onPostConstruct():void
		{
			myTowerTemplateInfo  = towerModel.getTowerSheetById(myTargetTowerTypeId);
			myUpdatedCostMoney = myTowerTemplateInfo.buyGold;
		}
		
		//API
		public function notifySceneGoldUpdate():void
		{
			checkIsValideByMoney();
			//checkIsValideByLock();
		}

		override protected function onInitialize():void
		{
			super.onInitialize();

			_unLockFrameKey = myIsOnlyUpdateMode ? "update" : "T_" + myTargetTowerTypeId;
			myItemBGView.gotoAndStop(_unLockFrameKey);
			
			myItemBGView.itemTextSkin.goldTextField.text = myTowerTemplateInfo.buyGold.toString();
		}
		
		override protected function onShow():void
		{
			super.onShow();
			checkIsValideByMoney();
			checkIsValideByLock();
		}
		
		override public function setIsLock(value:Boolean):void
		{
			super.setIsLock(value);
			
			if(myIsLock)
			{
				myItemBGView.gotoAndStop("lock");
				myItemBGView.itemTextSkin.visible = false;
			}
			else
			{
				myItemBGView.gotoAndStop(_unLockFrameKey);
				myItemBGView.itemTextSkin.visible = true;
			}
		}

		private function checkIsValideByMoney():void
		{
			var towerInfo:ITowerDynamicItem = towerData.getTowerDataById(myTargetTowerTypeId)
			if(!towerInfo || myIsLock)
				myItemBGView.itemTextSkin.visible = false;
			else
				myItemBGView.itemTextSkin.visible = true;
			
			this.setIsEnable(sceneModel.sceneGoods >= myUpdatedCostMoney && towerInfo);
		}

		private function checkIsValideByLock():void
		{			
			const resultIsLocked:Boolean = tollgateService.canTowerBuildInTollgate(fightData.tollgateId,myTowerTemplateInfo.configId)	
			this.setIsLock(!resultIsLocked);
		}
		
		override protected function excuteClickCallback():void
		{
			myClickCallback(myTargetTowerTypeId);
			//GameAGlobalManager.getInstance().gameFightInfoRecorder.addBuildTower( myTargetTowerTypeId );
			
			/*if ( myBuildingCircleItemOwner is TowerMultiUpdateLevelMenu )
			{
				GameAGlobalManager.getInstance().gameFightInfoRecorder.addBattleOPRecord( GameFightInfoRecorder.BATTLE_OP_TYPE_UPGRADE_TOWER, myTargetTowerTypeId );
			}*/

			sceneModel.updateSceneGold(-myTowerTemplateInfo.buyGold);
		}
		
		override protected function updateUIByCurrentState():void
		{
			super.updateUIByCurrentState();
			
			if(myIsEnable)
			{
				TextField(myItemBGView.itemTextSkin.goldTextField).textColor = 0xFFFF00;
			}
			else
			{
				TextField(myItemBGView.itemTextSkin.goldTextField).textColor = 0x999999;
			}
		}
		
		override protected function onMouseOverCallback(bOver:Boolean):void
		{
			myBuildingCircleItemOwner.notifyCircleMenuItemMouseOver(myTargetTowerTypeId,bOver);
		}
		
		/*override protected function onShowToolTipHandler(event:ToolTipEvent):void
		{
			var data:TowerMenuToolTipDataVO = new TowerMenuToolTipDataVO();
			if ( myIsLock )
			{
				data.status = TowerMenuToolTip.STATUS_LOCKED;
			}
			else
			{
				data.status = myIsEnable ? TowerMenuToolTip.STATUS_BUILD
					: TowerData.getInstance().getTowerisLockByTypeId( myTargetTowerTypeId ) ? TowerMenuToolTip.STATUS_MATERIALS_NOT_ENOUGH
					: TowerMenuToolTip.STATUS_NOT_RESEARCH;
				
				var towerTemplate:TowerTemplateInfo = myTowerTemplateInfo;
				
				data.towerName = towerTemplate.getName();
				data.desText = towerTemplate.getDesc();
				
				if ( towerTemplate.level >= 3 )
				{
					var skills:Array = towerTemplate.getskillIds().slice( 0, 2 );
					
					if ( skills.length > 0 )
					{
						data.extraText = "Unlock:";
						
						for each ( var skillID:int in skills )
						{
							data.extraText += "\n" + TemplateDataFactory.getInstance().getSkillTemplateById( skillID ).getName();
						}
					}
				}
				
				var lv:TowerLevelVo = TowerData.getInstance().getTowerLevelVoByTowerType(myTowerTemplateInfo.type);
				var addAtk:Number = 0;
				
				if( lv )
				{
					addAtk = TowerData.getInstance().getTowerAtkByTypeAndLevel( myTowerTemplateInfo.type,lv.level );
					addAtk *= 0.01;
				}
				
				addAtk += 1;
				
				switch ( towerTemplate.type )
				{
					case TowerType.Barrack:
					{
						var soldier:SoldierTemplateInfo = TemplateDataFactory.getInstance().getSoldierTemplateById( towerTemplate.soldierId );
//						data.props[TowerPropItem.PROP_LIFE] = soldier.life;
						data.props.push( TowerPropItem.PROP_LIFE, (lv ? soldier.life + TowerData.getInstance().getBarrackLifeByTypeAndLevel(TowerType.Barrack, lv.level) : soldier.life) + "" );
//						data.props[TowerPropItem.PROP_PHY_ATTACK] = soldier.baseAtk + "-" + soldier.maxAtk;
						data.props.push( TowerPropItem.PROP_PHY_ATTACK, int(soldier.baseAtk * (addAtk+GlobalTemp.spiritTowerAttackAddition*0.01) *(1 + EndlessBattleMgr.instance.addAtkPct*0.01)) + "-" + int(soldier.maxAtk * (addAtk+GlobalTemp.spiritTowerAttackAddition*0.01)*(1 + EndlessBattleMgr.instance.addAtkPct*0.01)) );
//						data.props[TowerPropItem.PROP_REBIRTH] = soldier.rebirthTime * 0.001;
						data.props.push( TowerPropItem.PROP_REBIRTH, (soldier.rebirthTime * 0.001) + "s" );
						break;
					}
					case TowerType.Arrow:
					case TowerType.Cannon:
					case TowerType.Magic:
					{	
						if ( towerTemplate.type == TowerType.Magic )
						{
//							data.props[TowerPropItem.PROP_MAG_ATTACK] = towerTemplate.baseAtk + "-" + towerTemplate.maxAtk;
							data.props.push( TowerPropItem.PROP_MAG_ATTACK, int(towerTemplate.baseAtk * (addAtk+GlobalTemp.spiritTowerAttackAddition*0.01) *(1 + EndlessBattleMgr.instance.addAtkPct*0.01)) + "-" + int(towerTemplate.maxAtk * (addAtk+GlobalTemp.spiritTowerAttackAddition*0.01) *(1 + EndlessBattleMgr.instance.addAtkPct*0.01)) );
						}
						else
						{
//							data.props[TowerPropItem.PROP_PHY_ATTACK] = towerTemplate.baseAtk + "-" + towerTemplate.maxAtk;
							data.props.push( TowerPropItem.PROP_PHY_ATTACK, int(towerTemplate.baseAtk * (addAtk+GlobalTemp.spiritTowerAttackAddition*0.01) *(1 + EndlessBattleMgr.instance.addAtkPct*0.01)) + "-" + int(towerTemplate.maxAtk * (addAtk+GlobalTemp.spiritTowerAttackAddition*0.01) *(1 + EndlessBattleMgr.instance.addAtkPct*0.01)) );
						}
						var speed:String = towerTemplate.cdTime >= 2001 ? "Very Slow"
							: towerTemplate.cdTime >= 1501 ? "Slow"
							: towerTemplate.cdTime >= 801 ? "Average"
							: towerTemplate.cdTime >= 501 ? "Fast" : "Very Fast";
						
						data.props.push( TowerPropItem.PROP_ATTACK_SPEED, speed );
						break;
					}
					default:
					{
						break;
					}
				}
			}
			
			event.toolTip.data = data;
		}*/
	}
}