package release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.controllBarFightIcons
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mainModule.model.gameData.dynamicData.magicSkill.IMagicSkillDynamicDataModel;
	import mainModule.model.gameData.dynamicData.magicSkill.IMagicSkillDynamicItem;
	import mainModule.model.gameData.sheetData.skill.magic.IMagicSkillSheetDataModel;
	import mainModule.model.gameData.sheetData.skill.magic.IMagicSkillSheetItem;
	import mainModule.service.loadServices.IconConst;
	
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.BasicMouseCursor;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.GameMouseCursorFactory;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.ShortCutKeyResponser.IShortCutKeyResponser;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightInfoRecorder;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;
	import release.module.kylinFightModule.gameplay.oldcore.vo.GlobalTemp;

	public class MagicSkillIconView extends CDAbleIconView implements IShortCutKeyResponser
	{
		private static var _unlockEffDelay:int = 0;
		
		[Inject]
		public var recorder:GameFightInfoRecorder;
		[Inject]
		public var globalTemp:GlobalTemp;
		[Inject]
		public var magicData:IMagicSkillDynamicDataModel;
		[Inject]
		public var magicModel:IMagicSkillSheetDataModel;
		[Inject]
		public var cursorFactory:GameMouseCursorFactory;
		
		private var _magicSkillTemplateInfo:IMagicSkillSheetItem;
		
		private var _silentCd:int = 0;
		[Inject]
		public var _silentCdTimer:SimpleCDTimer;
		private var _ptPos:Point;
		private var _mockFlag:Boolean = false;
		private var _disableSp:Sprite = null;
		
		public function MagicSkillIconView()
		{
			super();
		}
		
		override public function notifyTargetMouseCursorSuccessRealsed(mouseClickEvent:MouseEvent):void
		{
			super.notifyTargetMouseCursorSuccessRealsed(mouseClickEvent);
			//logch("NewbieGuideManager","MagicSuccessRealsed:"+_magicSkillTemplateInfo.configId);
			//NewbieGuideManager.getInstance().endCondition(NewbieConst.CONDITION_END_USED_OR_CANCEL_MAGIC,{"param":[_magicSkillTemplateInfo.configId]});
			
			recorder.addMagicSkillUseScore(_magicSkillTemplateInfo.rewardScore);
		}
		
		private function sortMagicSkills(info1:IMagicSkillDynamicItem,info2:IMagicSkillDynamicItem):int
		{
			if(info1.id < info2.id)
				return -1;
			else
				return 1;
		}
		
		override protected function onDisableChanged():void
		{
			super.onDisableChanged();
			if ( !myIsDisable )
			{
				_disableSp.visible = false;
				if ( !(_mockFlag && !globalTemp.enableMockMagicFlag) && myIconBitmap.bitmapData )
				{
					playCDResetEff();
				}
			}
		}
		
		//初始化数据
		override public function notifyOnGameStart():void
		{
			if(0 == myIconIndex)
				_unlockEffDelay = 0;
			//var currentMagicSkillIds:Array = UserData.getInstance().userExtendInfo.currentMagicSkillIds;
			
			var currentMagicSkillIds:Vector.<IMagicSkillDynamicItem> = magicData.getAllMagicData().sort(sortMagicSkills);
			if(currentMagicSkillIds && myIconIndex < currentMagicSkillIds.length)
			{
				_magicSkillTemplateInfo = currentMagicSkillIds[myIconIndex];
				var iconId:uint = _magicSkillTemplateInfo.iconId;
				//setIconBitmapData(Reflection.createBitmapData("magic_" + iconId + "_" + IconConst.ICON_SIZE_CIRCLE + ".png"));
				setIconBitmapData(loadService.getIconBitmapData("magic_" + iconId + "_" + IconConst.ICON_SIZE_CIRCLE));
				
				myIconUseCDTime = _magicSkillTemplateInfo.cdTime;
				
				var arr:Array = ["A","S","D"];
				interactiveMgr.registerShortCutKeyResponser(arr[myIconIndex].charCodeAt(),this);
			
				_silentCd = 0;
			}
			
			super.notifyOnGameStart();

			if ( myIconBitmap.bitmapData )
			{
				_mockFlag = globalTemp.newGuideMockTollgateFlag;
				myIconBitmap.visible = !_mockFlag;
				if(myIconBitmap.visible)
					checkUnlockEff();
			}
			_disableSp.visible = true;
			this.mouseChildren = this.mouseEnabled = false;
		}
		
		private function checkUnlockEff():void
		{
			/*if(!_magicSkillTemplateInfo)
				return;
			var arrFlag:Array = CommonLog.instance.getValue(CommonLog.MagicInFightUnlockEff) as Array;
			if(!arrFlag || !arrFlag[_magicSkillTemplateInfo.category])
			{
				TweenLite.delayedCall(_unlockEffDelay,playEffect);
				_unlockEffDelay += 1;
				arrFlag ||= [0,0,0];
				arrFlag[_magicSkillTemplateInfo.category] = 1;
				CommonLog.instance.updateValue(CommonLog.MagicInFightUnlockEff,arrFlag);
			}*/
		}
		
		private function playEffect():void
		{
			/*TweenLite.from(myIconBitmap,1,{alpha:0});
			var mc:MovieClip = new UnlockEffect();
			this.addChild(mc);
			mc.x = myIconBitmap.width>>1;
			mc.y = myIconBitmap.height>>1;
			DisplayUtility.playMcOnce(mc,true);*/
		}
		
		public function getMagicSkillInfo():IMagicSkillSheetItem
		{
			return _magicSkillTemplateInfo;
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			myIconBitmapBackground.bitmapData = new MagicNormalIconBackgroundBitmapData();
			myIconBitmapBackground.visible = false;
			myDisableBackgroundBitmap.bitmapData = new PropAndMagicDisableIconBackgroundBitmapData();
			myDisableBackgroundBitmap.visible = false;
			
			_ptPos = mainUI.globalToLocal(localToGlobal(new Point(0,0)));
			
			_disableSp = new Sprite();
			var g:Graphics = _disableSp.graphics;
			g.beginFill( 0, 0.4 );
			g.drawCircle( 0, 0, myIconBitmapBackground.width * 0.5 );
			g.endFill();
			addChild( _disableSp );
			_disableSp.x = myIconBitmapBackground.width * 0.5;
			_disableSp.y = myIconBitmapBackground.height * 0.5;
		}
		
		override public function get focusTips():String
		{
			if ( _magicSkillTemplateInfo )
			{
				return _magicSkillTemplateInfo.getName() + " [" + ["A", "S", "D"][myIconIndex] + "]";
			}
			
			return null;
		}
		
		override protected function createMouseCursor():BasicMouseCursor
		{
			return cursorFactory.createGameMouseCursor(1, {magic:_magicSkillTemplateInfo.configId}, this);
		}
		
		/*override public function get focusTips():String
		{
			return _magicSkillTemplateInfo.getName() ;//+ _magicSkillTemplateInfo.getDesc();
		}*/
		
		public function notifyShortCutKeyDown():void
		{
			if(!getIsInValidIconMouseClick() && myIconBitmap.visible )
			{
				if (interactiveMgr.currentFocusdSceneElement == this )
				{
					interactiveMgr.setCurrentFocusdElement( null );
				}
				else
				{
					onIconMouseClick();
				}
				//ToolTipManager.getInstance().hide();
			}
		}
		
		override protected function onIconMouseClick():void
		{
			super.onIconMouseClick();
			//NewbieGuideManager.getInstance().endCondition(NewbieConst.CONDITION_END_USE_ITEM_MAGIC,{"param":[_magicSkillTemplateInfo.configId],"target":this});
		}
		
		public function notifyBeSilent(duration:int):void
		{
			if(!_magicSkillTemplateInfo || duration<=0)
				return;
			
			_silentCd = duration;
			_silentCdTimer.setDurationTime(duration);
			_silentCdTimer.resetCDTime();
		}
		
		override public function render(iElapse:int):void
		{
			if(_silentCd > 0)
			{
				//_silentCdTimer.tick();
				if(_silentCdTimer.getIsCDEnd())
				{
					_silentCd = 0;
					
					/*if ( _magicSkillTemplateInfo && _iconTip && _iconTip.visible )
					{
						_iconTip.showLine = false;
						_iconTip.tip = _magicSkillTemplateInfo.getName() + " [" + ["A", "S", "D"][myIconIndex] + "]";
					}*/
				}
				else
				{
					/*if ( _magicSkillTemplateInfo && _iconTip && _iconTip.visible )
					{
						var time1:int = Math.ceil(_silentCdTimer.getCDCoolDownLeftTime() * 0.001);
						var m1:int = time1 / 60;
						var str1:String = (m1 > 9 ? m1 : "0" + m1) + ":";
						m1 = time1 % 60;
						str1 += m1 > 9 ? m1 : "0" + m1;
						_iconTip.showLine = true;
						_iconTip.tip = _magicSkillTemplateInfo.getName() + " [" + ["A", "S", "D"][myIconIndex] + "]\n" + str1; 
					}*/
				}
				drawCurrentCDTimerProgressGraphics(_silentCdTimer);
				return;
			}		
			super.render(iElapse);
			
			if(myIconUseCDTimer.getIsCDEnd())	//动态更新TIPS
			{
				/*if ( _magicSkillTemplateInfo && _iconTip )
				{
					_iconTip.showLine = false;
					_iconTip.tip = _magicSkillTemplateInfo.getName() + " [" + ["A", "S", "D"][myIconIndex] + "]";
				}*/
			}
			else
			{
				/*if ( _magicSkillTemplateInfo && _iconTip && _iconTip.visible )
				{
					var time:int = Math.ceil(myIconUseCDTimer.getCDCoolDownLeftTime() * 0.001);
					var m:int = time / 60;
					var str:String = (m > 9 ? m : "0" + m) + ":";
					m = time % 60;
					str += m > 9 ? m : "0" + m;
					_iconTip.showLine = true;
					_iconTip.tip = _magicSkillTemplateInfo.getName() + " [" + ["A", "S", "D"][myIconIndex] + "]\n" + str; 
				}*/
			}
			
			if ( _mockFlag && !globalTemp.enableMockMagicFlag )
			{
				myIconBitmapBackground.visible = myIconBitmap.visible = false;
				this.mouseEnabled = this.mouseChildren = false;
			}
			else
			{
				myIconBitmapBackground.visible = myIconBitmap.visible = true;
				this.mouseEnabled = this.mouseChildren = !myIsDisable && myIconBitmap.bitmapData;
			}
		}
		
		override protected function getIsInValidIconMouseClick():Boolean
		{				
			return _silentCd > 0 || super.getIsInValidIconMouseClick(); 
		}
		
		override protected function onFocusChanged():void
		{
			super.onFocusChanged();
			
			/*if(!myIsInFocus)
			{
				logch("NewbieGuideManager","MagicRealseCancled:"+_magicSkillTemplateInfo.configId);
				NewbieGuideManager.getInstance().endCondition(NewbieConst.CONDITION_END_USED_OR_CANCEL_MAGIC,{"param":[_magicSkillTemplateInfo.configId]});
			}*/
		}
	}
}