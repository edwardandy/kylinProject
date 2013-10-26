package release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain
{
	import mainModule.model.gameData.sheetData.skill.magic.IMagicSkillSheetDataModel;
	import mainModule.model.gameData.sheetData.skill.magic.IMagicSkillSheetItem;
	import mainModule.service.textService.ITextTranslateService;
	
	import release.module.kylinFightModule.gameplay.constant.GameFightConstant;
	import release.module.kylinFightModule.gameplay.oldcore.core.BasicView;
	import release.module.kylinFightModule.gameplay.oldcore.core.IFightLifecycle;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.controllBarFightIcons.BasicIconView;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.controllBarFightIcons.CDAbleIconView;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.controllBarFightIcons.HeroIconView;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.controllBarFightIcons.MagicSkillIconView;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.controllBarFightIcons.PropIconView;
	import release.module.kylinFightModule.gameplay.oldcore.vo.treasureData.TreasureDataList;
	
	import robotlegs.bender.framework.api.IInjector;

	public final class FightControllBarView extends BasicView implements IFightLifecycle
	{
		[Inject]
		public var treasureList:TreasureDataList;
		[Inject]
		public var magicModel:IMagicSkillSheetDataModel;
		[Inject]
		public var textMgr:ITextTranslateService;
		[Inject]
		public var injector:IInjector;
		
		private var _background:FightControllBarBGView;
		
		private var _heroIconViews:Vector.<HeroIconView> = new Vector.<HeroIconView>(3);
		private var _propIconViews:Vector.<PropIconView> = new Vector.<PropIconView>(4);
		private var _magicSkillIconViews:Vector.<MagicSkillIconView> = new Vector.<MagicSkillIconView>(3);
		
		public function FightControllBarView()
		{
			super();
		}

		//API
		//减少某法术的CD时间
		//type == 0 所有， type  = 1， 其中一 个 type -1 除了某个的其他法术
		public function reduceMagicSkillCDTime(magicSkillTypeId:int, time:uint, type:int = 0,bPlayAnim:Boolean = false):void
		{
			var strMagicTypeId:String = magicSkillTypeId.toString().substr(0,magicSkillTypeId.toString().length-1);
			for each(var magicSkillIconView:MagicSkillIconView in _magicSkillIconViews)
			{
				var magicSkillTemplateInfo:IMagicSkillSheetItem = magicSkillIconView.getMagicSkillInfo();
				if(magicSkillTemplateInfo != null)
				{
					if(type != 0)
					{
						var isTargetMagicSkill:Boolean = (magicSkillTemplateInfo.configId.toString().substr
							(0,magicSkillTemplateInfo.configId.toString().length-1)) == strMagicTypeId;
						if(type == -1)
						{
							if(!isTargetMagicSkill)
							{
								magicSkillIconView.decreaseCDCoolDownRunTime(time,bPlayAnim);
							}
						}
						else if(type == 1)
						{
							if(isTargetMagicSkill)
							{
								magicSkillIconView.decreaseCDCoolDownRunTime(time,bPlayAnim);
								break;
							}
						}
					}
					else
					{
						magicSkillIconView.decreaseCDCoolDownRunTime(time,bPlayAnim);
					}
				}
			}
		}
		
		/**
		 * 重置所有法术icon的cd，道具魔法漩涡的效果
		 */
		public function clearAllMagicIconCD(bPlayEff:Boolean = false):void
		{
			for each(var magicSkillIconView:MagicSkillIconView in _magicSkillIconViews)
			{
				magicSkillIconView.clearCDAbleIconViewCDTime(bPlayEff);
			}
		}
		
		public function notifyOtherPropItemResetCDAbleIconViewCDTime(target:CDAbleIconView):void
		{
			if(target == null) return;
			
			var iconView:CDAbleIconView = null;
			for each(iconView in _propIconViews)
			{
				if(iconView == target) continue;
				
				iconView.resetCDAbleIconViewCDTime();
			}
		}
		
		/*private var _treasureTip:MonsterWarnTip;
		public function showTreasureHunterTip():void
		{
			var pt:Point = new Point(_heroIconViews[0].width>>1,0);
			pt = this.globalToLocal(_heroIconViews[0].localToGlobal(pt));
			if(_treasureTip == null )
			{
				_treasureTip = new MonsterWarnTip();
				_treasureTip.y = pt.y;
				_treasureTip.x = pt.x;
				this.addChild( _treasureTip );
			}
			_treasureTip.visible = false;
			//注册点是小三角指的点
			if(treasureList.hasTreasure())
			{
				_treasureTip.tip = textMgr.translateText("hasTreasureHunter");
				_treasureTip.visible = true;
				_treasureTip.show();
			}
		}*/
		
		//IGameLifecycleNotifyer
		public function onFightStart():void
		{
			var iconView:BasicIconView = null;
			for each(iconView in _heroIconViews)
			{
				iconView.notifyOnGameStart();
			}
			
			notifyAllHeroIconsIsUseable();
			
			for each(iconView in _propIconViews)
			{
				iconView.notifyOnGameStart();
			}
			
			for each(iconView in _magicSkillIconViews)
			{
				iconView.notifyOnGameStart();
			}
		}
		
		public function onFightPause():void
		{
		}
		
		public function onFightResume():void
		{
		}
		
		public function onFightEnd():void
		{
			/*if(_treasureTip && contains(_treasureTip))
				removeChild(_treasureTip);
			_treasureTip = null;*/
			
			var iconView:BasicIconView = null;
			for each(iconView in _heroIconViews)
			{
				iconView.notifyOnGameEnd();
			}
			
			for each(iconView in _propIconViews)
			{
				iconView.notifyOnGameEnd();
			}
			
			for each(iconView in _magicSkillIconViews)
			{
				iconView.notifyOnGameEnd();
			}
		}
		
		public function notifyMagicSilent(duration:int):void
		{
			for each(var icon:MagicSkillIconView in _magicSkillIconViews)
			{
				icon.notifyBeSilent(duration);
			}	
		}
		
		public function notifyAllIconsIsUseable():void
		{
//			notifyAllHeroIconsIsUseable();
			notifyAllPropIconsIsUseable();
			notifyAllMagicSkillIconsIsUseable();
		}
		
		private function notifyAllHeroIconsIsUseable():void
		{
			for each(var iconView:BasicIconView in _heroIconViews)
			{
				iconView.notifyOnIconIsUseable();
			}
		}
		
		private function notifyAllPropIconsIsUseable():void
		{
			for each(var iconView:BasicIconView in _propIconViews)
			{
				iconView.notifyOnIconIsUseable();
			}
		}
		
		private function notifyAllMagicSkillIconsIsUseable():void
		{
			for each(var iconView:BasicIconView in _magicSkillIconViews)
			{
				iconView.notifyOnIconIsUseable();
			}
		}
		
		
		private function getMagicSkillIconViews():Vector.<MagicSkillIconView>
		{
			return _magicSkillIconViews.concat();
		}
		
		private function getHeroIconViewByIndex(index:int):HeroIconView
		{
			return _heroIconViews[index];
		}
		
		private function getPropIconViewByIndex(index:int):PropIconView
		{
			return _propIconViews[index];
		}
		
		private function getMagicSkillIconViewByIndex(index:int):MagicSkillIconView
		{
			return _magicSkillIconViews[index];
		}
		
		override public function dispose():void
		{
			removeChildren();
			
			var iconView:BasicIconView = null;
			for each(iconView in _heroIconViews)
			{
				iconView.dispose();
			}
			
			for each(iconView in _propIconViews)
			{
				iconView.dispose();
			}
			
			for each(iconView in _magicSkillIconViews)
			{
				iconView.dispose();
			}
			
			super.dispose();
		}
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			_background = new FightControllBarBGView();
			_background.mouseChildren = false;
			addChild(_background);
			this.y = GameFightConstant.SCENE_MAP_HEIGHT - _background.height;
			
			//hero
			var heroIconView0:HeroIconView = injector.instantiateUnmapped(HeroIconView);
			heroIconView0.setIconIndex(0);
			heroIconView0.x = 4;
			heroIconView0.y = 3;
			_heroIconViews[0] = heroIconView0;
			addChild(heroIconView0);
			
			var heroIconView1:HeroIconView = injector.instantiateUnmapped(HeroIconView);
			heroIconView1.setIconIndex(1);
			heroIconView1.x = 84;
			heroIconView1.y = 3;
			_heroIconViews[1] = heroIconView1;
			addChild(heroIconView1);
			
			var heroIconView2:HeroIconView = injector.instantiateUnmapped(HeroIconView);
			heroIconView2.setIconIndex(2);
			heroIconView2.x = 164;
			heroIconView2.y = 3;
			_heroIconViews[2] = heroIconView2;
			addChild(heroIconView2);
			
			//Prop
			var propIconView0:PropIconView = injector.instantiateUnmapped(PropIconView);
			propIconView0.setIconIndex(0);
			propIconView0.x = 245;
			propIconView0.y = 26;
			_propIconViews[0] = propIconView0;
			addChild(propIconView0);
			
			var propIconView1:PropIconView = injector.instantiateUnmapped(PropIconView);
			propIconView1.setIconIndex(1);
			propIconView1.x = 301;
			propIconView1.y = 26;
			_propIconViews[1] = propIconView1;
			addChild(propIconView1);
			
			var propIconView2:PropIconView = injector.instantiateUnmapped(PropIconView);
			propIconView2.setIconIndex(2);
			propIconView2.x = 357;
			propIconView2.y = 26;
			_propIconViews[2] = propIconView2;
			addChild(propIconView2);
			
			var propIconView3:PropIconView = injector.instantiateUnmapped(PropIconView);
			propIconView3.setIconIndex(3);
			propIconView3.x = 413;
			propIconView3.y = 26;
			_propIconViews[3] = propIconView3;
			addChild(propIconView3);
			
			//magic
			var magicSkillIconView0:MagicSkillIconView = injector.instantiateUnmapped(MagicSkillIconView);
			magicSkillIconView0.setIconIndex(0);
			magicSkillIconView0.x = 590;
			magicSkillIconView0.y = 25;
			_magicSkillIconViews[0] = magicSkillIconView0;
			addChild(magicSkillIconView0);
			
			var magicSkillIconView1:MagicSkillIconView = injector.instantiateUnmapped(MagicSkillIconView);
			magicSkillIconView1.setIconIndex(1);
			magicSkillIconView1.x = 647;
			magicSkillIconView1.y = 25;
			_magicSkillIconViews[1] = magicSkillIconView1;
			addChild(magicSkillIconView1);
			
			var magicSkillIconView2:MagicSkillIconView = injector.instantiateUnmapped(MagicSkillIconView);
			magicSkillIconView2.setIconIndex(2);
			magicSkillIconView2.x = 703;
			magicSkillIconView2.y = 25;
			_magicSkillIconViews[2] = magicSkillIconView2;
			addChild(magicSkillIconView2);
		}
	}
}