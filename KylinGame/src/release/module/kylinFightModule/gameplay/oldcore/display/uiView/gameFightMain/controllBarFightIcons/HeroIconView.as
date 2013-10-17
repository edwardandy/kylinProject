package release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.controllBarFightIcons
{
	import com.shinezone.core.structure.controls.GameEvent;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.HeroElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.ShortCutKeyResponser.IShortCutKeyResponser;
	import release.module.kylinFightModule.gameplay.oldcore.events.SceneElementEvent;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightInteractiveManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GraphicsUtil;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;
	import release.module.kylinFightModule.gameplay.oldcore.vo.GlobalTemp;
	import com.shinezone.utils.Reflection;
	
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.engine.RenderingMode;
	
	import flashx.textLayout.formats.TextAlign;
	
	import framecore.main.TextDataManager;
	import framecore.structure.controls.heroCommand.Hero_CMD_Const;
	import framecore.structure.model.constdata.HttpConst;
	import framecore.structure.model.constdata.IconConst;
	import framecore.structure.model.constdata.NewbieConst;
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.UserData;
	import framecore.structure.model.user.commonLog.CommonLog;
	import framecore.structure.model.user.hero.HeroData;
	import framecore.structure.model.user.hero.HeroInfo;
	import framecore.structure.model.user.item.ItemData;
	import framecore.structure.model.user.item.ItemInfo;
	import framecore.structure.model.user.item.ItemTemplateInfo;
	import framecore.structure.model.user.tollgate.TollgateData;
	import framecore.structure.views.newguidPanel.NewbieGuideManager;
	import framecore.tools.alert.Alert;
	import framecore.tools.alert.AlertConst;
	import framecore.tools.alert.AlertUtil;
	import framecore.tools.font.FontUtil;
	import framecore.tools.icon.IconUtil;
	import framecore.tools.js.callJSFunc;
	import framecore.tools.loadmgr.LoadMgr;
	import framecore.tools.logger.logch;
	import framecore.tools.tips.ToolTipConst;
	import framecore.tools.tips.ToolTipEvent;
	import framecore.tools.tips.ToolTipManager;

	public class HeroIconView extends CDAbleIconView implements IShortCutKeyResponser
	{
		private var _heroInfo:HeroInfo = null;
		private var _heroElement:HeroElement;
		
		private var myGreenBlood:Bitmap;
		private var myRedBlood:Bitmap;
		
		private var myGreenMask:Shape;
		private var myRedMask:Shape;
		
		private var _lastBloodPct:int = 100;
		
		private var _lvTF:TextField = null;
		private var _reviveTip:ReviveTip = null;
		
		private var _lvFilter:GlowFilter = null;
		private var _reviveFilter:GlowFilter = null;
		
		public function HeroIconView()
		{
			super();
			
			myFocusEnable = false;
		}
		
		override public function notifyOnGameStart():void
		{
			super.notifyOnGameStart();
			
			var currentHeroIds:Array = UserData.getInstance().userExtendInfo.currentHeroIds;
			if(currentHeroIds && myIconIndex < currentHeroIds.length)
			{
				_heroInfo = HeroInfo(HeroData.getInstance().getOwnInfoById(currentHeroIds[myIconIndex]));
				_lvTF.text = "Lv." + _heroInfo.level;
				_heroElement = GameAGlobalManager.getInstance().groundSceneHelper.findHeroElementByHeroTypeId(_heroInfo.configId);
				_heroElement.addEventListener(SceneElementEvent.ON_FOCUS, heroElementOnFocusHandler);
				_heroElement.addEventListener(SceneElementEvent.ON_DISFOCUS, heroElementOnDisFocusHandler);
				_heroElement.addEventListener(SceneElementEvent.ON_LIFE_CHANGED, heroElementOnLifeChangedHandler);
				
				//setIconBitmapData(Reflection.createBitmapData("Hero_" + _heroInfo.configId + "_" + IconConst.ICON_SIZE_CIRCLE + ".png"));
				setIconBitmapData(LoadMgr.instance.getIconBitmapData("Hero_" + _heroInfo.configId + "_" + IconConst.ICON_SIZE_CIRCLE));
				
				GameAGlobalManager.getInstance().gameInteractiveManager.registerShortCutKeyResponser((myIconIndex+1).toString().charCodeAt(),this);
				
				_lastBloodPct = 100;
				drawBloodMask(myGreenMask.graphics,1);
			}
			else
			{
				_lvTF.text = "";
			}
		}

		override public function notifyOnGameEnd():void
		{
			super.notifyOnGameEnd();

			_heroInfo = null;
			
			if(_heroElement != null)
			{
				_heroElement.removeEventListener(SceneElementEvent.ON_FOCUS, heroElementOnFocusHandler);
				_heroElement.removeEventListener(SceneElementEvent.ON_DISFOCUS, heroElementOnDisFocusHandler);	
				_heroElement.removeEventListener(SceneElementEvent.ON_LIFE_CHANGED, heroElementOnLifeChangedHandler);
				_heroElement = null;
				
				if(hasEventListener(Event.ENTER_FRAME))
					removeEventListener(Event.ENTER_FRAME,onChangeRedBlood);
			}
		}
		
		override protected function onFocusChanged():void
		{
			super.onFocusChanged();
			
			if(!myIsInFocus)
			{
				logch("NewbieGuideManager","HeroRealseCancled:"+_heroInfo.configId);
				NewbieGuideManager.getInstance().endCondition(NewbieConst.CONDITION_END_USED_OR_CANCEL_MAGIC,{"param":[_heroInfo.configId]});
			}
		}
		
		override public function render(iElapse:int):void
		{
			if ( myIconBitmap.bitmapData && !CommonLog.instance.getValue( CommonLog.BATTLE_FIRST_HERO_GUIDE ) && TollgateData.currentLevelId == 100110311 )
			{
				NewbieGuideManager.getInstance().startCondition( NewbieConst.CONDITION_START_FIRST_HERO );
				CommonLog.instance.updateValue( CommonLog.BATTLE_FIRST_HERO_GUIDE, true );
			}
			super.render( iElapse );
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();			
			
			myIconBitmapBackground.bitmapData = new HeroIconNormalBackgroundBitmapData();
			myDisableBackgroundBitmap.bitmapData = new HeroIconDisablelBackgroundBitmapData();
			
			myRedBlood = new Bitmap();
			addChild(myRedBlood);
			myRedBlood.bitmapData = new HeroIconRedBlood();
			
			myRedMask = new Shape;
			myRedMask.x = myRedBlood.width/2;
			myRedMask.y = myRedBlood.height/2;
			addChild(myRedMask);
			myRedBlood.mask = myRedMask;
			
			myGreenBlood = new Bitmap();
			addChild(myGreenBlood);
			myGreenBlood.bitmapData = new HeroIconGreenBlood();
			
			myGreenMask = new Shape;
			myGreenMask.x = myGreenBlood.width/2;
			myGreenMask.y = myGreenBlood.height/2;
			addChild(myGreenMask);
			myGreenBlood.mask = myGreenMask;
			
			_lvTF = new TextField();
			_lvTF.width = myIconBitmapBackground.width;
			_lvTF.height = 50;
			_lvTF.multiline = true;
			_lvTF.autoSize = TextFieldAutoSize.CENTER;
			_lvTF.y = myIconBitmapBackground.height - 20;
			addChild( _lvTF );
			_lvTF.textColor = 0xFFFFFF;
			var tff:TextFormat = _lvTF.defaultTextFormat;
			tff.size = 14;
			tff.align = TextFormatAlign.CENTER;
			_lvTF.defaultTextFormat = tff;
			_lvFilter = new GlowFilter( 0x44210F, 1, 4, 4, 100 );
			_reviveFilter = new GlowFilter( 0, 1, 2, 2, 100 );
			_lvTF.filters = [_lvFilter];
			FontUtil.useFont( _lvTF, FontUtil.FONT_TYPE_BUTTON );
			
			_reviveTip = new ReviveTip();
			addChild( _reviveTip );
			_reviveTip.x = 42;
			_reviveTip.y = 14;
			_reviveTip.visible = false;
		}
		
		override public function get focusTips():String
		{
			if ( _heroInfo )
			{
				return _heroInfo.heroTemplateInfo.getName() + " [" + ["1", "2", "3"][myIconIndex] + "]";
			}
			
			return null;
		}
		
		override protected function drawCurrentCDTimerProgressGraphics( simpleCd:SimpleCDTimer ):void
		{
			if ( _heroElement )
			{
				var tff:TextFormat = _lvTF.defaultTextFormat;
				if ( _heroElement.rebirthCd.getIsCDEnd() )
				{
					tff.size = 12;
					_lvTF.y = myIconBitmapBackground.height - 11;
					_lvTF.defaultTextFormat = tff;
					_lvTF.filters = [_lvFilter];
					var currentHeroIds:Array = UserData.getInstance().userExtendInfo.currentHeroIds;
					_heroInfo = HeroInfo(HeroData.getInstance().getOwnInfoById(currentHeroIds[myIconIndex]));
					_lvTF.text = "Lv." + _heroInfo.level;
				}
				else
				{
					tff.size = 10;
					_lvTF.filters = [_reviveFilter];
					_lvTF.y = myIconBitmapBackground.height - 23;
					_lvTF.defaultTextFormat = tff;
					_lvTF.text = "Click for\nInstant Revive";
					addChild( _reviveTip );
					_reviveTip.time = Math.ceil(_heroElement.rebirthCd.getCDCoolDownLeftTime() * 0.001);
				}
				super.drawCurrentCDTimerProgressGraphics( _heroElement.rebirthCd );
			}
		}
		
		override protected function onMouseOverHandler(e:Event):void
		{
			if ( _heroElement )
			{
				if ( _heroElement.rebirthCd.getIsCDEnd() )
				{
					super.onMouseOverHandler( e );
				}
				else
				{
					_reviveTip.visible = true;
				}
			}
		}
		
		override protected function onMouseOutHandler(e:Event):void
		{
			_reviveTip.visible = false;
			super.onMouseOutHandler( e );
		}
		
		override protected function stateChanged():void
		{
			super.stateChanged();
			myGreenBlood.visible = myIconBitmap.visible;
			myRedBlood.visible = myIconBitmap.visible;
		}
		
		override protected function onIconMouseClick():void
		{
			NewbieGuideManager.getInstance().endCondition(NewbieConst.CONDITION_END_USE_ITEM_MAGIC,{"param":[_heroInfo.configId],"target":this});
			GameAGlobalManager.getInstance().gameInteractiveManager.setCurrentFocusdElement(_heroElement);
			onMouseOutHandler( null );
			
			if ( !_heroElement.rebirthCd.getIsCDEnd() )
			{
				GameAGlobalManager.getInstance().game.pause( false, false );
				
				var itemInfo:ItemInfo = ItemData.getInstance().getOwnInfoById( 131060 ) as ItemInfo;
				var msg:String = TextDataManager.getInstance().getPanelConfigXML("alertPanel").heroRevive;
				var msgs:Array = msg.split( "@" );
				var alert:Alert;
				if ( itemInfo )
				{
					alert = Alert.show( msgs[0], heroReviveHandler, AlertConst.ALERT_REIVVE_STYLE, Alert.OK_BTN );
					alert.getOKBtn().label = "Revive";
					alert.getStyle()["numTF"].text = itemInfo.number + " / 1";
					
					FontUtil.useFont( alert.getStyle()["numTF"], FontUtil.FONT_TYPE_NORMAL );
				}
				else
				{
					alert = Alert.show( msgs[0], heroReviveHandler, AlertConst.ALERT_REIVVE_STYLE, Alert.DIA_AMOUNT_BTN );
					alert.getDiaBtn().label = TemplateDataFactory.getInstance().getItemTemplateById( 131060 ).buyPriceMoney + "";
					alert.getStyle()["numTF"].text = "0 / 1";
					FontUtil.useFont( alert.getStyle()["numTF"], FontUtil.FONT_TYPE_NORMAL );
				}
			}
		}
		
		private function heroElementOnFocusHandler(event:SceneElementEvent):void
		{
			setIsOnFocus(true);
		}
		
		private function heroReviveHandler( detail:int ):void
		{
			if ( detail == Alert.OK )
			{
				var itemInfo:ItemInfo = ItemData.getInstance().getOwnInfoById( 131060 ) as ItemInfo;
				if ( itemInfo )
				{
					GameAGlobalManager.getInstance()
						.gameFightInfoRecorder
						.addPropItemUse(itemInfo.itemTemplateInfo.configId, itemInfo.itemTemplateInfo.rewardScore);
					ItemData.getInstance().useItemInfo( 131060 );
					_heroElement.forceToResurrection();
					
//					GameAGlobalManager.getInstance().gamePopupManager.open2CloseGamePauseView(false);
					GameAGlobalManager.getInstance().game.resume();
				}
				else
				{
					var _myHave:uint = UserData.getInstance().userBaseInfo.uMoney;
					var value:int = ItemTemplateInfo(TemplateDataFactory.getInstance().getItemTemplateById( 131060 )).buyPriceMoney;

					GlobalTemp.rebirthHero = _heroElement;

					if( _myHave < value)
					{
						var msg:String = TextDataManager.getInstance().getPanelConfigXML("alertPanel").nodiamond;
						var msgs:Array = msg.split(/@/);
						var alert:Alert = Alert.show(msgs[0], confirmCharge, AlertConst.ALERT_MSG_STYLE, Alert.BUY_MORE_BTN);
						if( alert.getMsgTxt() )
						{
							alert.getMsgTxt().text = msgs[1];
						}
					}
					else
					{
						GameEvent.getInstance().sendEvent( Hero_CMD_Const.CMD_HERO_REBIRTH, [HttpConst.HTTP_REQUEST] );
					}
				}
			}
			else
			{
//				GameAGlobalManager.getInstance().gamePopupManager.open2CloseGamePauseView(false);
				GameAGlobalManager.getInstance().game.resume();
			}
		}
				
		private function confirmCharge( detail:int ):void
		{
			if ( detail == Alert.OK )
			{
				callJSFunc("PayDialog", 1);
			}
			else
			{
//				GameAGlobalManager.getInstance().stage.mouseChildren = true;
//				GameAGlobalManager.getInstance().gamePopupManager.open2CloseGamePauseView(false);
				GameAGlobalManager.getInstance().game.resume();
			}
		}
		
		private function heroElementOnDisFocusHandler(event:SceneElementEvent):void
		{
			setIsOnFocus(false);
		}
		
		public function notifyShortCutKeyDown():void
		{
			if ( GameAGlobalManager.getInstance().gameInteractiveManager.currentFocusdSceneElement == _heroElement )
			{
				GameAGlobalManager.getInstance().gameInteractiveManager.setCurrentFocusdElement( null );
			}
			else
			{
				onIconMouseClick();
			}
			ToolTipManager.getInstance().hide();
		}
		//血条要变化
		private function heroElementOnLifeChangedHandler(event:SceneElementEvent):void
		{
			var pct:int = _heroElement.fightState.getCurLifePct();
			drawBloodMask(myGreenMask.graphics,pct*1.0/100);
			if(!hasEventListener(Event.ENTER_FRAME))
				addEventListener(Event.ENTER_FRAME,onChangeRedBlood);
		}
		
		private function onChangeRedBlood(e:Event):void
		{
			var curPct:int = _heroElement.fightState.getCurLifePct();
			if(_lastBloodPct == curPct)
			{
				removeEventListener(Event.ENTER_FRAME,onChangeRedBlood);
				return;
			}
			
			if(_lastBloodPct > curPct)
			{
				--_lastBloodPct;
			}
			else if(_lastBloodPct < curPct)
			{
				++_lastBloodPct;
			}
			drawBloodMask(myRedMask.graphics,_lastBloodPct*1.0/100);
		}
		
		private function drawBloodMask(graphics:Graphics,value:Number):void
		{
			graphics.clear();
			graphics.beginFill(0xffffff);
			if(1 == value)
				graphics.drawCircle(0,0,myGreenBlood.width/2+1);
			else
				GraphicsUtil.drawSector(graphics,0,0,myGreenBlood.width/2+1,360*value,360*(1-value)-90);
			graphics.endFill();
		}
	}
}