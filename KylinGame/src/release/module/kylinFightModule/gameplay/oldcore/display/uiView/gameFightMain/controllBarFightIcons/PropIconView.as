package release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.controllBarFightIcons
{
	import com.shinezone.core.structure.controls.GameEvent;
	import com.shinezone.towerDefense.fight.constants.BattleEffectType;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.SoundFields;
	import com.shinezone.towerDefense.fight.constants.identify.MagicID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.BasicMagicSkillEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.BasicMouseCursor;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.GameMouseCursorFactory;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.ShortCutKeyResponser.IShortCutKeyResponser;
	import release.module.kylinFightModule.gameplay.oldcore.events.ExternalUseItemEvent;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.GameFilterManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightInfoRecorder;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightInteractiveManager;
	import release.module.kylinFightModule.gameplay.oldcore.vo.GlobalTemp;
	import com.shinezone.utils.Reflection;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import framecore.structure.controls.battleCommand.Battle_CMD_Const;
	import framecore.structure.controls.shopCommand.Shop_CMD_Const;
	import framecore.structure.controls.uiCommand.UI_CMD_Const;
	import framecore.structure.model.constdata.HttpConst;
	import framecore.structure.model.constdata.IconConst;
	import framecore.structure.model.constdata.NewbieConst;
	import framecore.structure.model.constdata.PopConst;
	import framecore.structure.model.constdata.TowerFeatures;
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.UserData;
	import framecore.structure.model.user.commonLog.CommonLog;
	import framecore.structure.model.user.item.ItemData;
	import framecore.structure.model.user.item.ItemInfo;
	import framecore.structure.model.user.item.ItemTemplateInfo;
	import framecore.structure.views.newguidPanel.NewbieGuideManager;
	import framecore.tools.GameStringUtil;
	import framecore.tools.alert.Alert;
	import framecore.tools.alert.AlertConst;
	import framecore.tools.externalMgr.ExternalInterfaceMgr;
	import framecore.tools.font.FontUtil;
	import framecore.tools.getText;
	import framecore.tools.icon.IconUtil;
	import framecore.tools.loadmgr.LoadMgr;
	import framecore.tools.media.TowerMediaPlayer;
	import framecore.tools.tips.ToolTipConst;
	import framecore.tools.tips.ToolTipEvent;
	import framecore.tools.tips.ToolTipManager;
	import framecore.tools.txts.translate;

	public class PropIconView extends CDAbleIconView implements IShortCutKeyResponser
	{
		private static const ITEM_PROP_CD_TIME:int = 1000;
		public static const ITEMIDS:Array = [131063,131127,131124,131125];

		//private var _itemInfo:ItemInfo;
		private var _itemTemp:ItemTemplateInfo;
		
		private var _itemCountTextField:PropNumText;
		private var _itemPriceText:PropPriceText;
		
		private var _effectParameters:Object;
		private var _ptPos:Point;
		
		private var _mockFlag:Boolean = false;
		
		private var _disableIconA:Sprite = new PropIconDisableA();
		private var _disableIconB:Sprite = new PropIconDisableB();
		
		public function PropIconView()
		{
			super();
		}
	
		override public function notifyTargetMouseCursorSuccessRealsed(mouseClickEvent:MouseEvent):void
		{
			super.notifyTargetMouseCursorSuccessRealsed(mouseClickEvent);
			
			NewbieGuideManager.getInstance().endCondition(NewbieConst.CONDITION_END_USED_OR_CANCEL_MAGIC,{"param":[_itemTemp.configId]});
			
			GameAGlobalManager.getInstance()
				.game.gameFightMainUIView.fightControllBarView
				.notifyOtherPropItemResetCDAbleIconViewCDTime(this);
			
			onUseItemSuccess();
		}
		
		private function onExternalUseItemHandler( e:ExternalUseItemEvent ):void
		{
			if ( _itemTemp && _itemTemp.configId == e.id )
			{
				updateItemCount();
			}
		}
		
		private function get _itemInfo():ItemInfo
		{
			return ItemData.getInstance().getOwnInfoById(_itemTemp.configId) as ItemInfo;
		}
		
		private function updateItemCount():void
		{
			_itemCountTextField.visible = false;
			_itemPriceText.visible = false;
			if(_itemInfo && _itemInfo.number > 0)
			{
				if ( uint(_itemCountTextField.txtNum.text) < _itemInfo.number )//战斗中购买了道具
				{
					playCDResetEff();	//播放一个特效提示一下
				}
				_itemCountTextField.txtNum.text = _itemInfo.number.toString();
				if(myIconBitmap && myIconBitmap.visible)
				{
					_itemCountTextField.visible = true;
				}
			}
			else
			{
				if(myIconBitmap && myIconBitmap.visible)
				{
					_itemPriceText.visible = true;
				}
				_itemPriceText.txtNum.text = _itemTemp.buyPriceMoney.toString();
				_itemCountTextField.txtNum.text = uint.MAX_VALUE + "";//特用此值以做上面的战斗中购买了道具的判断
			}
		}
		
		private function onUseItemSuccess():void
		{
			GameAGlobalManager.getInstance().gameFightInfoRecorder.addBattleOPRecord( GameFightInfoRecorder.BATTLE_OP_TYPE_USE_ITEM, _itemTemp.configId );
			GameAGlobalManager.getInstance()
				.gameFightInfoRecorder
				.addPropItemUse(_itemTemp.configId, _itemTemp.rewardScore);
			
			ItemData.getInstance().useItem(_itemInfo,1);
			GameEvent.getInstance().sendEvent(Battle_CMD_Const.CMD_USEITEM_INBATTLE, [HttpConst.HTTP_REQUEST,_itemTemp.configId,1,GameAGlobalManager.getInstance().gameDataInfoManager.gameFightId]);
			
			if(!_itemInfo || _itemInfo.number == 0)
			{
				stateChanged();
			}
			
			updateItemCount();
			
			playUseItemSound();
		}
		
		private function playUseItemSound():void
		{
			var sounds:Array = GameStringUtil.deserializeSoundString(SoundFields.Use,_itemTemp.sound);
			if(sounds && sounds.length>0)
				TowerMediaPlayer.getInstance().playEffect(sounds[0]);
		}
		
		override public function notifyOnGameStart():void
		{
			//var currentItemIds:Array = UserData.getInstance().userExtendInfo.currentItemIds;

			if ( CommonLog.instance.getValue( TowerFeatures.FEATURE_SHOP + TowerFeatures.FEATURE_UNLOCK_STATUS ) )
			{
				myIconUseCDTime = ITEM_PROP_CD_TIME;
				
				_effectParameters = GameStringUtil.deserializeString(_itemTemp.effectValue);
				
				var resId:uint = _itemTemp.resourceId;
				if(0 == resId)
					resId = _itemTemp.configId;
				
				//setIconBitmapData(Reflection.createBitmapData("Item_" + resId + "_" + IconConst.ICON_SIZE_CIRCLE + ".png"));
				setIconBitmapData(LoadMgr.instance.getIconBitmapData("Item_" + resId + "_" + IconConst.ICON_SIZE_CIRCLE));
				
				var arr:Array = ["Q","W","E","R"];
				GameAGlobalManager.getInstance().gameInteractiveManager.registerShortCutKeyResponser(arr[myIconIndex].charCodeAt(),this);				
			}
			
			super.notifyOnGameStart();
			
			if ( myIconBitmap.bitmapData )
			{
				/*if ( !CommonLog.instance.getValue( CommonLog.BATTLE_FIRST_ITEM_GUIDE ) )
				{
					NewbieGuideManager.getInstance().startCondition( NewbieConst.CONDITION_START_FIRST_ITEM );
					CommonLog.instance.updateValue( CommonLog.BATTLE_FIRST_ITEM_GUIDE, true );
				}*/
				_mockFlag = GlobalTemp.newGuideMockTollgateFlag;
				myIconBitmap.visible = !_mockFlag;
				updateItemCount();
				_disableIconA.visible = _itemCountTextField.visible;
				_disableIconB.visible = _itemPriceText.visible;
				this.mouseEnabled = this.mouseChildren = false;		
			}
			
			GameEvent.eventBus.addEventListener( ExternalUseItemEvent.USE_ITEM, onExternalUseItemHandler );
		}
		
		override public function notifyOnGameEnd():void
		{
			GameEvent.eventBus.removeEventListener( ExternalUseItemEvent.USE_ITEM, onExternalUseItemHandler );
			super.notifyOnGameEnd();
			
			_effectParameters = null;
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			_itemTemp = TemplateDataFactory.getInstance().getItemTemplateById(ITEMIDS[myIconIndex]);
			
			myIconBitmapBackground.bitmapData = new PropNormalIconBackgroundBitmapData();
			myIconBitmapBackground.visible = false;
			myDisableBackgroundBitmap.bitmapData = new PropAndMagicDisableIconBackgroundBitmapData();
			myDisableBackgroundBitmap.visible = false;
			
			_itemCountTextField = new PropNumText;
			_itemCountTextField.x = myIconBitmapBackground.width>>1;
			_itemCountTextField.y = myIconBitmapBackground.height - (_itemCountTextField.height>>1);
			_itemCountTextField.visible = false;
			addChild(_itemCountTextField);	
			FontUtil.useFont( _itemCountTextField.txtNum, FontUtil.FONT_TYPE_BUTTON );
			
			_itemPriceText = new PropPriceText;
			_itemPriceText.x = myIconBitmapBackground.width>>1;
			_itemPriceText.y = myIconBitmapBackground.height - (_itemPriceText.height>>1);
			_itemPriceText.visible = false;
			addChild(_itemPriceText);	
			FontUtil.useFont( _itemPriceText.txtNum, FontUtil.FONT_TYPE_BUTTON );
			
			_ptPos = GameAGlobalManager.getInstance().game.globalToLocal(localToGlobal(new Point(0,0)));	
			
			addChild( _disableIconA );
			_disableIconA.visible = _disableIconB.visible = false;
			addChild( _disableIconB );
			_disableIconA.x = _disableIconB.x = myIconBitmapBackground.width * 0.5;
			_disableIconA.y = _disableIconB.y = myIconBitmapBackground.height * 0.5;
		}
		
		override public function get focusTips():String
		{
			if ( _itemTemp )
			{
				return _itemTemp.getName() + " [" + ["Q", "W", "E","R"][myIconIndex] + "]";
			}
			
			return null;
		}

		override protected function onDisableChanged():void
		{
			super.onDisableChanged();
			if ( !myIsDisable && myIconBitmap.visible)
			{
				_disableIconA.visible = _disableIconB.visible = false;
				playCDResetEff();
			}
			this.mouseChildren = this.mouseEnabled = false;
		}
		
		override protected function stateChanged():void
		{
			super.stateChanged();
			
			//_itemPriceText.visible = _itemCountTextField.visible = myIconBitmap.visible;
			updateItemCount();
			
			/*myIconBitmap.filters = myIconBitmap.visible ? 
				(_itemInfo.number > 0 ? null : [GameFilterManager.getInstance().colorNessMatrixFilter]) :
				null;*/
		}
		
		/*override protected function getIsInValidIconMouseClick():Boolean
		{
			return _itemInfo == null || 
				_itemInfo.number <= 0 || 
				super.getIsInValidIconMouseClick()
		}*/
		
		override protected function needMouseCursor():Boolean
		{
			return _itemInfo && _itemInfo.number>0 && _itemTemp.effectType == 1 /*法术类*/ && _effectParameters && int(_effectParameters.magic) != MagicID.Magic_Vortex/*魔力漩涡*/
				&& int(_effectParameters.magic) != MagicID.NuclearWeapon && int(_effectParameters.magic) != MagicID.IceMagicWand;
		}
		
		override protected function createMouseCursor():BasicMouseCursor
		{
			var effectType:int = _itemTemp.effectType;
			return GameMouseCursorFactory.getInstance().createGameMouseCursor(effectType, _effectParameters, this);
		}
		
		/*override public function get focusTips():String
		{
			return _itemTemp.getName();// + _itemTemp.getDesc();
		}*/
		
		public function notifyShortCutKeyDown():void
		{
			if(!getIsInValidIconMouseClick() && myIconBitmap.visible )
			{
				if ( GameAGlobalManager.getInstance().gameInteractiveManager.currentFocusdSceneElement == this )
				{
					GameAGlobalManager.getInstance().gameInteractiveManager.setCurrentFocusdElement( null );
				}
				else
				{
					onIconMouseClick();
				}
				ToolTipManager.getInstance().hide();
			}
		}
		
		override protected function onIconMouseClick():void
		{
			super.onIconMouseClick();
			//如果没有道具，弹出购买窗口
			if(!_itemInfo || _itemInfo.number <=0)
			{
				if ( GameAGlobalManager.getInstance().gameInteractiveManager.currentFocusdSceneElement == this )
				{
					GameAGlobalManager.getInstance().gameInteractiveManager.setCurrentFocusdElement( null );
				}
				buyItem();
				return;
			}
			
			var bUsed:Boolean = false;
			if(_effectParameters)
			{
				if(MagicID.Magic_Vortex == int(_effectParameters.magic)/*魔力漩涡*/)
				{
					GameAGlobalManager.getInstance().game.gameFightMainUIView.fightControllBarView.clearAllMagicIconCD(true);
					bUsed = true;
				}	
				else if(MagicID.NuclearWeapon == int(_effectParameters.magic) || MagicID.IceMagicWand == int(_effectParameters.magic))
				{
					ObjectPoolManager.getInstance().createSceneElementObject(GameObjectCategoryType.MAGIC_SKILL,int(_effectParameters.magic));
					bUsed = true;
				}
			}
			
			if(_itemTemp.effectType == 3 /*增加战场物资类*/)
			{
				GameAGlobalManager.getInstance().gameDataInfoManager.updateSceneGold(_effectParameters["goods"]);
				GameAGlobalManager.getInstance().game.gameFightMainUIView.playAddGoodsAnim(200,20,_effectParameters["goods"],GameAGlobalManager.getInstance().game.gameFightMainUIView);
				bUsed = true;
			}
			else if(_itemTemp.effectType == 15 /*增加战场生命值*/)
			{
				GameAGlobalManager.getInstance().gameDataInfoManager.updateSceneLife(_effectParameters["life"]);
				GameAGlobalManager.getInstance().game.gameFightMainUIView.tweenLifeIcon();
				bUsed = true;
			}
			
			if(bUsed)
			{
				onUseItemSuccess();
				resetCDAbleIconViewCDTime();
				GameAGlobalManager.getInstance()
					.game.gameFightMainUIView.fightControllBarView
					.notifyOtherPropItemResetCDAbleIconViewCDTime(this);
				if ( GameAGlobalManager.getInstance().gameInteractiveManager.currentFocusdSceneElement == this )
				{
					GameAGlobalManager.getInstance().gameInteractiveManager.setCurrentFocusdElement( null );
				}
			}
			
			NewbieGuideManager.getInstance().endCondition(NewbieConst.CONDITION_END_USE_ITEM_MAGIC,{"param":[_itemTemp.configId],"target":this});
		}
		
		override public function render(iElapse:int):void
		{
			super.render( iElapse );
			
			if ( myIconBitmap.bitmapData && !CommonLog.instance.getValue( CommonLog.BATTLE_FIRST_ITEM_GUIDE ) && !myIsDisable )
			{
				NewbieGuideManager.getInstance().startCondition( NewbieConst.CONDITION_START_FIRST_ITEM );
				CommonLog.instance.updateValue( CommonLog.BATTLE_FIRST_ITEM_GUIDE, true );
			}
			
			var str:String = null;
			switch( myIconIndex )
			{
				case 0:
				{
					str = translate( "+ 200 goods" );
					break;
				}
				case 1:
				{
					str = translate( "+ 5 lives" );
					break;
				}
				case 2:
				{
					str = translate( "Full freeze" );
					break;
				}
				case 3:
				{
					str = translate( "Full blast" );
					break;
				}
				default:
				{
					break;
				}
			}
			
			if(myIconUseCDTimer.getIsCDEnd())	//动态更新TIPS
			{
				if ( _itemTemp && _iconTip && _iconTip.visible )
				{
					_iconTip.showLine = true;
					_iconTip.tip = _itemTemp.getName() + " [" + ["Q", "W", "E","R"][myIconIndex] + "]\n" + str;
				}
			}
			else
			{
				if ( _itemTemp && _iconTip && _iconTip.visible )
				{
					var time:int = Math.ceil(myIconUseCDTimer.getCDCoolDownLeftTime() * 0.001);
					var m:int = time / 60;
					
					str += "\n" + (m > 9 ? m : "0" + m) + ":";
					m = time % 60;
					str += m > 9 ? m : "0" + m;
					_iconTip.showLine = true;
					_iconTip.tip = _itemTemp.getName() + " [" + ["Q", "W", "E","R"][myIconIndex] + "]\n" + str; 
				}
			}
			
			if ( _mockFlag && !GlobalTemp.enableMockItemFlag )
			{
				myIconBitmapBackground.visible = myIconBitmap.visible = false;
				updateItemCount();
				this.mouseEnabled = this.mouseChildren = false;
			}
			else
			{
				myIconBitmapBackground.visible = myIconBitmap.visible = true;
				updateItemCount();
				this.mouseEnabled = this.mouseChildren = !myIsDisable && myIconBitmap.bitmapData;
			}
		}
		
		override protected function onFocusChanged():void
		{
			super.onFocusChanged();
			
			if(!myIsInFocus)
			{
				NewbieGuideManager.getInstance().endCondition(NewbieConst.CONDITION_END_USED_OR_CANCEL_MAGIC,{"param":[_itemTemp.configId]});
			}
		}
		
		private function buyItem():void
		{
			GameAGlobalManager.getInstance().game.pause( false, false );
			
			var title:String = getText("Buy")+" "+_itemTemp.getName();
			var alert:Alert;
			//直接购买
			if(UserData.getInstance().userBaseInfo.uMoney >= _itemTemp.buyPriceMoney)
			{
				alert = Alert.show( title, onAlertBuyItemHandle, AlertConst.ALERT_FIGHT_BUY_ITEM_STYLE, Alert.DIA_AMOUNT_BTN );
				alert.getDiaBtn().label = _itemTemp.buyPriceMoney.toString();
				IconUtil.loadIcon(alert.getStyle()["mcItemIcon"],IconConst.ICON_TYPE_ITEM,_itemTemp.resourceId || _itemTemp.configId
					,IconConst.ICON_SIZE_CIRCLE);
				
				FontUtil.useFont( alert.getStyle()["txt1"], FontUtil.FONT_TYPE_NORMAL );
				FontUtil.useFont( alert.getStyle()["txt2"], FontUtil.FONT_TYPE_BUTTON );
				FontUtil.useFont( alert.getStyle()["txt3"], FontUtil.FONT_TYPE_BUTTON );
			}
			//提示充值
			else
			{
				GameEvent.eventBus.addEventListener(ExternalInterfaceMgr.CHARGE_BACK,onChargeBack);
				GameEvent.getInstance().sendEvent( UI_CMD_Const.OPEN_POP, [UI_CMD_Const.OPEN_POP, "popPanel", PopConst.DIAMOND_ALERT_POP
					, [_itemTemp.buyPriceMoney-UserData.getInstance().userBaseInfo.uMoney, _itemTemp.configId]] );
			}
		}
		
		private function onAlertBuyItemHandle( detail:int ):void
		{
			if(detail == Alert.OK )
			{
				GameEvent.getInstance().sendEvent( Shop_CMD_Const.CMD_BUYITEM, [HttpConst.HTTP_REQUEST, _itemTemp.configId, 1, _itemTemp.buyPriceMoney] );
				updateItemCount();
			}
			GameAGlobalManager.getInstance().game.resume();
		}
		
		private function onChargeBack(e:Event):void
		{
			GameEvent.eventBus.removeEventListener(ExternalInterfaceMgr.CHARGE_BACK,onChargeBack);
			GameAGlobalManager.getInstance().game.resume();
			if(UserData.getInstance().userBaseInfo.uMoney >= _itemTemp.buyPriceMoney)
			{
				GameEvent.getInstance().sendEvent( Shop_CMD_Const.CMD_BUYITEM, [HttpConst.HTTP_REQUEST, _itemTemp.configId, 1, _itemTemp.buyPriceMoney] );
				GameAGlobalManager.getInstance().game.pause( false, true );
				updateItemCount();
			}
		}
	}
}