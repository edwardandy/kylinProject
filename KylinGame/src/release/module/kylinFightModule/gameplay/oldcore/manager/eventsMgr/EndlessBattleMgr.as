package release.module.kylinFightModule.gameplay.oldcore.manager.eventsMgr
{
	import flash.utils.Dictionary;
	
	import release.module.kylinFightModule.gameplay.constant.EndlessBattleConst;
	import release.module.kylinFightModule.gameplay.constant.identify.ItemID;

	public class EndlessBattleMgr
	{
		private static var _instance:EndlessBattleMgr;
		
		private var _isEndless:Boolean;
		
		private var _recordWave:int;
		private var _recordScore:int;
				
		/**
		 * 增加塔和士兵攻击力的buff 
		 */		
		private var _addAtkPct:Number;
		private var _addAtkSpdPct:int;
		/**
		 * 失败挽救时所处的波次 
		 */		
		private var _failedWave:int;
		private var _iCanRebirthTime:int;
		
		private var _arrSavePoints:Array = [];
		private var _arrAddBuffGoldPrice:Array = [];
		private var _arrAddBuffDiamondPrice:Array = [];
		private var _iRebirthPrice:int;
		
		private var _bWaitForCostGoldAddBuff:Boolean;
		private var _bWaitForCostDiamondAddBuff:Boolean;
		private var _bWaitForRebirth:Boolean;
		
		
		private var _iTotalMoney:int;
		private var _iTotalExp:int;
		private var _iTotalItem:int;
		//private var _iLastItemIdx:uint;
		private var _iBonusCnt:int;
		/**
		 * 每一波有多少个怪物 
		 */		
		private var _dicWaveOwnMonsterCnts:Dictionary = new Dictionary(true);
		
		public function EndlessBattleMgr()
		{
		}

		/**
		 * 发几倍奖励 
		 */
		public function get iBonusCnt():int
		{
			return _iBonusCnt;
		}

		/**
		 * 等待从失败挽回的充值钻石页面返回 
		 */
		public function get bWaitForRebirth():Boolean
		{
			return _bWaitForRebirth;
		}

		/**
		 * @private
		 */
		public function set bWaitForRebirth(value:Boolean):void
		{
			_bWaitForRebirth = value;
		}

		/**
		 * 等待从增加攻击buff的充值钻石页面返回 
		 */
		public function get bWaitForCostDiamondAddBuff():Boolean
		{
			return _bWaitForCostDiamondAddBuff;
		}

		/**
		 * @private
		 */
		public function set bWaitForCostDiamondAddBuff(value:Boolean):void
		{
			_bWaitForCostDiamondAddBuff = value;
		}

		/**
		 * 等待从增加攻击buff的充值金币页面返回 
		 */
		public function get bWaitForCostGoldAddBuff():Boolean
		{
			return _bWaitForCostGoldAddBuff;
		}

		/**
		 * @private
		 */
		public function set bWaitForCostGoldAddBuff(value:Boolean):void
		{
			_bWaitForCostGoldAddBuff = value;
		}

		/**
		 * 失败复活所需要的钻石 
		 */
		public function get iRebirthPrice():int
		{
			return _iRebirthPrice;
		}

		/**
		 * 加战斗buff需要的钻石价格数组 
		 */
		public function get arrAddBuffDiamondPrice():Array
		{
			return _arrAddBuffDiamondPrice;
		}
		/**
		 * 升级某一级buff需要花费的钻石数量 
		 * @param iLvl
		 * @return 
		 * 
		 */		
		public function getAddBuffDiamondPriceByLvl(iLvl:int = 1):int
		{
			if(iLvl > EndlessBattleConst.MAX_ATKBUFF_LVL)
				iLvl = EndlessBattleConst.MAX_ATKBUFF_LVL;
			return _arrAddBuffDiamondPrice.length>1 ? _arrAddBuffDiamondPrice[iLvl-1] : _arrAddBuffDiamondPrice[0];
		}

		/**
		 * 加战斗buff需要的金币价格数组 
		 */
		public function get arrAddBuffGoldPrice():Array
		{
			return _arrAddBuffGoldPrice;
		}
		
		/**
		 * 升级某一级buff需要花费的金币数量 
		 * @param iLvl
		 * @return 
		 * 
		 */		
		public function getAddBuffGoldPriceByLvl(iLvl:int):int
		{
			if(iLvl > EndlessBattleConst.MAX_ATKBUFF_LVL)
				iLvl = EndlessBattleConst.MAX_ATKBUFF_LVL;
			return _arrAddBuffGoldPrice.length>1 ? _arrAddBuffGoldPrice[iLvl-1] : _arrAddBuffGoldPrice[0];
		}

		/**
		 * 失败挽救后2波怪中提升塔攻击速度30% 
		 */
		public function get addAtkSpdPct():int
		{
			return _addAtkSpdPct;
		}

		/**
		 * @private
		 */
		public function set addAtkSpdPct(value:int):void
		{
			_addAtkSpdPct = value;
		}

		public function get addAtkPct():Number
		{
			return _addAtkPct;
		}

		public function set addAtkPct(value:Number):void
		{
			_addAtkPct = value;
		}

		public static function get instance():EndlessBattleMgr
		{
			return _instance ||= new EndlessBattleMgr;
		}
		
		public function get isEndless():Boolean
		{
			return _isEndless;
		}
		
		public function get recordWave():int
		{
			return _recordWave;
		}
		
		public function get recordScore():int
		{
			return _recordScore;
		}
				
		public function init(data:Array):void
		{
			/*dispose();
			if(!data)
				return;
			_isEndless = true;
			DreamLandData.getInstance().setIsPause(0);
			_recordWave = data[0];
			_recordScore = data[1];
			GameAGlobalManager.getInstance().gameFightInfoRecorder.initializeFightInfo();
			GameAGlobalManager.getInstance().gameDataInfoManager.updateSceneScore();
			//_lastSavePointWave = _recordWave;
			//_lastSavePointScore = _recordScore;

			DreamLandData.getInstance().setNode(new DreamLandNode(_recordScore,_recordWave));
			_arrSavePoints = data[2];
			for each(var arrSub:Array in data[3])
			{
				_arrAddBuffGoldPrice.push(arrSub[0]);
				_arrAddBuffDiamondPrice.push(arrSub[1]);
			}
			_iRebirthPrice = data[4];
			_iCanRebirthTime = data[5];
			_iBonusCnt = data[6];*/
			//logch("EndlessData:","initData:",data);
		}
		
		public function saveProgress(iProgress:int,iScore:int):void
		{
			/*GameEvent.getInstance().sendEvent(Battle_CMD_Const.CMD_ENDLESS_BATTLE_SAVE_PROGRESS,[HttpConst.HTTP_REQUEST,iProgress,iScore]);
			//logch("EndlessData:","saveProgress:",iProgress,iScore);
			
			//_lastSavePointScore = iScore;
			//_lastSavePointWave = iProgress;
			var node:DreamLandNode = new DreamLandNode(iScore,iProgress);
			
			DreamLandData.getInstance().setNode(node);
			DreamLandData.getInstance().setCurrent(node);
			var arr:Array = getCurSavePointRewards(iProgress);
			UserData.getInstance().userBaseInfo.uGold += arr[3];
			UserData.getInstance().userBaseInfo.uExp += arr[4];
			
			var itemTmp:ItemTemplateInfo = TemplateDataFactory.getInstance().getItemTemplateById(arr[2]);
			if(!itemTmp)
				return;
			if(itemTmp.effectType == 9)
			{
				//卡牌
				var heroId:int = int(itemTmp.effectValue);
				PubData.getInstance().addHeroInfluence(heroId,1);
			}
			else
				ItemData.getInstance().putItemIds([arr[2]],arr[5]);
			
			_iTotalMoney += arr[3];
			_iTotalExp += arr[4];
			_iTotalItem += arr[5];*/	
		}
		
		public function upgradeAtkBuff(iLvl:int):Boolean
		{
			/*if(iLvl > EndlessBattleConst.MAX_ATKBUFF_LVL)
				iLvl = EndlessBattleConst.MAX_ATKBUFF_LVL;
			
			if(_addAtkPct >= (EndlessBattleConst.EACH_ATKBUFF_NUM * EndlessBattleConst.MAX_ATKBUFF_LVL))
				return false;
			_addAtkPct += EndlessBattleConst.EACH_ATKBUFF_NUM * iLvl;
			GameAGlobalManager.getInstance().groundSceneHelper.addAllTowerEndlessAtkBuff(EndlessBattleConst.EACH_ATKBUFF_NUM);
			GameAGlobalManager.getInstance().game.gameFightMainUIView.updateEndlessDrumsBuff(true,curAtkBuffLevel);*/
			return true;
		}
		/**
		 * 当前增加攻击buff的等级 
		 * @return 
		 * 
		 */		
		public function get curAtkBuffLevel():int
		{
			return int(_addAtkPct/EndlessBattleConst.EACH_ATKBUFF_NUM);
		}
		
		public function get reachMaxAtkBuff():Boolean
		{
			return curAtkBuffLevel >= EndlessBattleConst.MAX_ATKBUFF_LVL;
		}
		/**
		 * 物资升级buff不会失败了 
		 * @return 
		 * 
		 */		
		public function get canUpgradeAtkBuff():Boolean
		{
			return true;
			return Math.random() <= (EndlessBattleConst.MAX_ATKBUFF_LVL - curAtkBuffLevel)*(1.0/EndlessBattleConst.MAX_ATKBUFF_LVL);	
		}
		
		public function canRebirth():Boolean
		{
			return _iCanRebirthTime > 0;
		}
		/**
		 * 失败挽救 
		 */		
		public function retrieveFromFail():void
		{
			_iCanRebirthTime--;
			/*var bHasKill:Boolean = GameAGlobalManager.getInstance().groundSceneHelper.killAllEnemies();
			GameAGlobalManager.getInstance().groundSceneHelper.disappearAllSummonDoor();
			GameAGlobalManager.getInstance().gameDataInfoManager.updateSceneLife(1);
			addAtkSpdPct = 30;
			GameAGlobalManager.getInstance().groundSceneHelper.addAllTowerEndlessAtkSpdBuff(addAtkSpdPct);
			_failedWave = GameAGlobalManager.getInstance().gameDataInfoManager.sceneWaveCurrentCount;
			GameAGlobalManager.getInstance().game.gameFightMainUIView.updateEndlessRebirthBuff(true);	
			if(!bHasKill && GameAGlobalManager.getInstance().gameMonsterMarchManager.isNotMarching())
			{
				GameAGlobalManager.getInstance().gameSuccessAndFailedDetector.onClearCurWaveMonsters();
			}
			GameEvent.getInstance().sendEvent(Battle_CMD_Const.CMD_ENDLESS_BATTLE_REBIRTH, [HttpConst.HTTP_REQUEST,[]]);*/
		}
		
		public function checkRetrieveBuffEnd():void
		{
			/*if(addAtkSpdPct>0 && GameAGlobalManager.getInstance().gameDataInfoManager.sceneWaveCurrentCount - _failedWave>1)
			{
				disableRetrieveBuff();
			}*/
		}
		
		public function checkRetrieveFromFail():void
		{
			/*bWaitForRebirth = false;
			var cost:int = iRebirthPrice;
			if(cost <= UserData.getInstance().userBaseInfo.uMoney)
			{
				UserData.getInstance().userBaseInfo.uMoney -= cost;
				retrieveFromFail();
				//GameEvent.getInstance().sendEvent(Battle_CMD_Const.CMD_ENDLESS_BATTLE_REBIRTH,[HttpConst.HTTP_REQUEST]);
				logch("EndlessData:","retrieveFromFail");
			}
			else
				GameAGlobalManager.getInstance().game.notifyToGameOver(false);
			
			GameEvent.getInstance().sendEvent(UI_CMD_Const.OPEN_POP , [UI_CMD_Const.CLOSE_POP , "popPanel",PopConst.WRATH_OF_GOD ]);*/
		}
		
		/**
		 *  检查是否可以升级
		 * @param iType 1为钻石，2为金币
		 * 
		 */		
		public function checkAddAtkBuffByType(iType:int = 1):void
		{
			/*var cost:int;
			var curBuffLvl:int = curAtkBuffLevel;
			if(1 == iType)
			{
				bWaitForCostDiamondAddBuff = false;
				cost =getAddBuffDiamondPriceByLvl(curBuffLvl+EndlessBattleConst.EACH_DIAMOND_ATKBUFF_LVL);
				if(cost <= UserData.getInstance().userBaseInfo.uMoney)
				{
					UserData.getInstance().userBaseInfo.uMoney -= cost;
					upgradeAtkBuff(EndlessBattleConst.EACH_DIAMOND_ATKBUFF_LVL);
					var data:Array = [];
					data.push(curAtkBuffLevel);
					data.push(getAddBuffDiamondPriceByLvl(data[0]+1));
					data.push(getAddBuffGoldPriceByLvl(data[0]+1));
					data.push(Math.ceil((EndlessBattleConst.MAX_ATKBUFF_LVL-data[0])/EndlessBattleConst.EACH_DIAMOND_ATKBUFF_LVL).toString()
						+"/"+(Math.ceil(EndlessBattleConst.MAX_ATKBUFF_LVL/EndlessBattleConst.EACH_DIAMOND_ATKBUFF_LVL)).toString());
					data.push(Math.ceil((EndlessBattleConst.MAX_ATKBUFF_LVL-data[0])/EndlessBattleConst.EACH_GOOD_ATKBUFF_LVL).toString()
						+"/"+(Math.ceil(EndlessBattleConst.MAX_ATKBUFF_LVL/EndlessBattleConst.EACH_GOOD_ATKBUFF_LVL)).toString());
					PanelData.panelInteraction("popPanel","updatePopInfo",[PopConst.BATTLE_DRUMS,data]);
					if(reachMaxAtkBuff)
					{
						GameAGlobalManager.getInstance().game.gameFightMainUIView.InvisibleBattleDrumsBtn();
						GameEvent.getInstance().sendEvent(UI_CMD_Const.OPEN_POP , [UI_CMD_Const.CLOSE_POP , "popPanel",PopConst.BATTLE_DRUMS ]);
					}
					GameEvent.getInstance().sendEvent(Battle_CMD_Const.CMD_ENDLESS_BATTLE_DRUMS,[HttpConst.HTTP_REQUEST,1,1,curAtkBuffLevel]);
					logch("EndlessData:","AddAtkBuff",1,1,curAtkBuffLevel);
					//new TextFlyEffect("UPGRADE SUCCESS",GameConst.stage,400,365);
					var pt:Point = GameAGlobalManager.getInstance().game.localToGlobal(new Point(400,365));
					TextFlyEffectMgr.instance.genTextFlyEffect("UPGRADE SUCCESS",GameConst.stage,pt.x,pt.y);
				}
			}
			else
			{
				bWaitForCostGoldAddBuff = false;
				cost = getAddBuffGoldPriceByLvl(curBuffLvl+EndlessBattleConst.EACH_GOOD_ATKBUFF_LVL);
				if( cost <= GameAGlobalManager.getInstance().gameDataInfoManager.sceneGold)
				{
					GameAGlobalManager.getInstance().gameDataInfoManager.updateSceneGold(-cost);
					var iSuccess:int = 0;
					if(canUpgradeAtkBuff)
					{
						iSuccess = 1;
						upgradeAtkBuff(EndlessBattleConst.EACH_GOOD_ATKBUFF_LVL);
						data = [];
						data.push(curAtkBuffLevel);
						data.push(getAddBuffDiamondPriceByLvl(data[0]+1));
						data.push(getAddBuffGoldPriceByLvl(data[0]+1));
						data.push(Math.ceil((EndlessBattleConst.MAX_ATKBUFF_LVL-data[0])/EndlessBattleConst.EACH_DIAMOND_ATKBUFF_LVL).toString()
							+"/"+(Math.ceil(EndlessBattleConst.MAX_ATKBUFF_LVL/EndlessBattleConst.EACH_DIAMOND_ATKBUFF_LVL)).toString());
						data.push(Math.ceil((EndlessBattleConst.MAX_ATKBUFF_LVL-data[0])/EndlessBattleConst.EACH_GOOD_ATKBUFF_LVL).toString()
							+"/"+(Math.ceil(EndlessBattleConst.MAX_ATKBUFF_LVL/EndlessBattleConst.EACH_GOOD_ATKBUFF_LVL)).toString());
						PanelData.panelInteraction("popPanel","updatePopInfo",[PopConst.BATTLE_DRUMS,data]);
						if(reachMaxAtkBuff)
						{
							GameAGlobalManager.getInstance().game.gameFightMainUIView.InvisibleBattleDrumsBtn();
							GameEvent.getInstance().sendEvent(UI_CMD_Const.OPEN_POP , [UI_CMD_Const.CLOSE_POP , "popPanel",PopConst.BATTLE_DRUMS ]);
						}
					}
					GameEvent.getInstance().sendEvent(Battle_CMD_Const.CMD_ENDLESS_BATTLE_DRUMS,[HttpConst.HTTP_REQUEST,2,iSuccess,curAtkBuffLevel]);
					logch("EndlessData:","AddAtkBuff",2,iSuccess,curAtkBuffLevel);
					//new TextFlyEffect(1 == iSuccess?"UPGRADE SUCCESS":"UPGRADE FAILED",GameConst.stage,400,365);
					pt = GameAGlobalManager.getInstance().game.localToGlobal(new Point(400,365));
					TextFlyEffectMgr.instance.genTextFlyEffect(1 == iSuccess?"UPGRADE SUCCESS":"UPGRADE FAILED",GameConst.stage,pt.x,pt.y);
				}
			}*/
			
			//GameEvent.getInstance().sendEvent(UI_CMD_Const.OPEN_POP , [UI_CMD_Const.CLOSE_POP , "popPanel",PopConst.BATTLE_DRUMS ]);
		}
		
		public function setCurWaveMonsterCnts(iWave:int,iCnts:int):void
		{
			_dicWaveOwnMonsterCnts[iWave] = iCnts;
		}
		
		public function checkCurWaveIsEnd(iWave:int,iMinus:int = 1):Boolean
		{
			if(_dicWaveOwnMonsterCnts[iWave] != null && iMinus>0)
			{
				_dicWaveOwnMonsterCnts[iWave] -= iMinus;
			}
			
			if(_dicWaveOwnMonsterCnts[iWave] <= 0)
				return true;
			return false;
		}
		
		private function disableRetrieveBuff():void
		{
			/*GameAGlobalManager.getInstance().groundSceneHelper.addAllTowerEndlessAtkSpdBuff(-addAtkSpdPct);
			GameAGlobalManager.getInstance().game.gameFightMainUIView.updateEndlessRebirthBuff(false);*/
			addAtkSpdPct = 0;
			_failedWave = -1;
		}
		
		public function isSavePointWave(iWave:int):Boolean
		{
			return -1 != _arrSavePoints.indexOf(iWave);
		}
		
		public function get totalRewards():Array
		{
			return [ItemID.Gold,ItemID.EXP,ItemID.EndlessBox,
			_iTotalMoney,_iTotalExp,_iTotalItem];
		}
		
		public function getCurSavePointRewards(iWave:int):Array
		{
			if(!isSavePointWave(iWave))
				return null;
			
			return null /*[ItemID.Gold,ItemID.EXP,DreamLandData.getInstance().getRewardItemIdByWave(iWave),
				DreamLandData.getInstance().getRewardGoldByWave(iWave)*_iBonusCnt,DreamLandData.getInstance().getRewardExpByWave(iWave)*_iBonusCnt,
				DreamLandData.getInstance().getRewardItemCountByWave(iWave)*_iBonusCnt]*/;
		}
		
		public function dispose():void
		{
			_isEndless = false;
			_recordWave = 0;
			_recordScore = 0;
			_addAtkPct = 0;
			addAtkSpdPct = 0;
			_failedWave = 0;
			_iCanRebirthTime = 0;
			_arrSavePoints.length = 0;
			_arrAddBuffGoldPrice.length = 0;
			_arrAddBuffDiamondPrice.length = 0;
			_iRebirthPrice = -1;
			_bWaitForCostGoldAddBuff = false;
			_bWaitForCostDiamondAddBuff = false;
			_bWaitForRebirth = false;
			_dicWaveOwnMonsterCnts = new Dictionary(true);
			_iTotalMoney = 0;
			_iTotalExp = 0;
			_iTotalItem = 0;
			_iBonusCnt = 0;
		}
	}
}