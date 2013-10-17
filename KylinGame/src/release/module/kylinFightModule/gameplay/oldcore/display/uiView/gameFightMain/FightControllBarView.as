package release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain
{
	import com.shinezone.towerDefense.fight.constants.GameFightConstant;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.oldcore.core.BasicView;
	import release.module.kylinFightModule.gameplay.oldcore.core.IGameLifecycleBeNotifyer;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.DaDiZhenchanMagicSkill;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.ShengGuangPuZhaoMagicSkill;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.YiCiYuanZhiMenMagicSkill;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.ZiRanZhiRuMagicSkill;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.HeroElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.controllBarFightIcons.BasicIconView;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.controllBarFightIcons.CDAbleIconView;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.controllBarFightIcons.HeroIconView;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.controllBarFightIcons.MagicSkillIconView;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.controllBarFightIcons.MonsterWarnTip;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.controllBarFightIcons.PropIconView;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	import com.shinezone.towerDefense.fight.vo.map.RoadLineVOHelperUtil;
	import com.shinezone.towerDefense.fight.vo.map.RoadVO;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.magicSkill.MagicSkillTemplateInfo;
	import framecore.tools.getText;

	public final class FightControllBarView extends BasicView implements IGameLifecycleBeNotifyer
	{
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
				var magicSkillTemplateInfo:MagicSkillTemplateInfo = magicSkillIconView.getMagicSkillInfo();
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
		
		private var _treasureTip:MonsterWarnTip;
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
			if(GameAGlobalManager.getInstance().treasureList.hasTreasure())
			{
				_treasureTip.tip = getText("hasTreasureHunter");
				_treasureTip.visible = true;
				_treasureTip.show();
			}
			/*else
			{
				_treasureTip.tip = getText("hasnotTreasureHunter");
			}*/
		}
		
		//IGameLifecycleNotifyer
		public function onGameStart():void
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
			
			//--set value
//			var i:uint = 0;
//			var n:uint = 3;
//			var dataN:uint = 0;
//			
//			dataN = towerDefenseFight.heroes.length;
//			for(i = 0; i < n; i++)
//			{
//				//这里需要修改
//				var heroTypeId:int = i > dataN - 1 ? -1 : towerDefenseFight.heroes[i];
//				var heroElement:HeroElement = heroTypeId == -1 ? null :
//						ObjectPoolManager.getInstance().createSceneElementObject(GameObjectCategoryType.HERO, heroTypeId, false) as HeroElement;
//				
//				if(heroElement != null)
//				{
//					heroElement.notifyLifecycleActive();
//					heroElement.x = 300;
//					heroElement.y = 400;
//				}
//
//				getHeroIconViewByIndex(i).setHeroElement(heroElement);
//			}
//			
//			dataN = towerDefenseFight.magics.length;
//			for(i = 0; i < n; i++)
//			{
//				var magicSkillTypeId:int = i > dataN - 1 ? -1 : towerDefenseFight.magics[i];
//				var magicSkill:MagicSkillTemplateInfo = magicSkillTypeId == -1 ? null :
//					TemplateDataFactory.getInstance().getMagicSkillTemplateById(magicSkillTypeId);
//				
//				getMagicSkillIconViewByIndex(i).setMagicSkillInfo(magicSkill);
//			}
		}
		
		public function onGamePause():void
		{
		}
		
		public function onGameResume():void
		{
		}
		
		public function onGameEnd():void
		{
			if(_treasureTip && contains(_treasureTip))
				removeChild(_treasureTip);
			_treasureTip = null;
			
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
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			_background = new FightControllBarBGView();
			_background.mouseChildren = false;
			addChild(_background);
			this.y = GameFightConstant.SCENE_MAP_HEIGHT - _background.height;
			
			//hero
			var heroIconView0:HeroIconView = new HeroIconView();
			heroIconView0.setIconIndex(0);
			heroIconView0.x = 4;
			heroIconView0.y = 3;
			_heroIconViews[0] = heroIconView0;
			addChild(heroIconView0);
			
			var heroIconView1:HeroIconView = new HeroIconView();
			heroIconView1.setIconIndex(1);
			heroIconView1.x = 84;
			heroIconView1.y = 3;
			_heroIconViews[1] = heroIconView1;
			addChild(heroIconView1);
			
			var heroIconView2:HeroIconView = new HeroIconView();
			heroIconView2.setIconIndex(2);
			heroIconView2.x = 164;
			heroIconView2.y = 3;
			_heroIconViews[2] = heroIconView2;
			addChild(heroIconView2);
			
			//Prop
			var propIconView0:PropIconView = new PropIconView();
			propIconView0.setIconIndex(0);
			propIconView0.x = 245;
			propIconView0.y = 26;
			_propIconViews[0] = propIconView0;
			addChild(propIconView0);
			
			var propIconView1:PropIconView = new PropIconView();
			propIconView1.setIconIndex(1);
			propIconView1.x = 301;
			propIconView1.y = 26;
			_propIconViews[1] = propIconView1;
			addChild(propIconView1);
			
			var propIconView2:PropIconView = new PropIconView();
			propIconView2.setIconIndex(2);
			propIconView2.x = 357;
			propIconView2.y = 26;
			_propIconViews[2] = propIconView2;
			addChild(propIconView2);
			
			var propIconView3:PropIconView = new PropIconView();
			propIconView3.setIconIndex(3);
			propIconView3.x = 413;
			propIconView3.y = 26;
			_propIconViews[3] = propIconView3;
			addChild(propIconView3);
			
			//magic
			var magicSkillIconView0:MagicSkillIconView = new MagicSkillIconView();
			magicSkillIconView0.setIconIndex(0);
			magicSkillIconView0.x = 590;
			magicSkillIconView0.y = 25;
			_magicSkillIconViews[0] = magicSkillIconView0;
			addChild(magicSkillIconView0);
			
			var magicSkillIconView1:MagicSkillIconView = new MagicSkillIconView();
			magicSkillIconView1.setIconIndex(1);
			magicSkillIconView1.x = 647;
			magicSkillIconView1.y = 25;
			_magicSkillIconViews[1] = magicSkillIconView1;
			addChild(magicSkillIconView1);
			
			var magicSkillIconView2:MagicSkillIconView = new MagicSkillIconView();
			magicSkillIconView2.setIconIndex(2);
			magicSkillIconView2.x = 703;
			magicSkillIconView2.y = 25;
			_magicSkillIconViews[2] = magicSkillIconView2;
			addChild(magicSkillIconView2);
		}
	}
}