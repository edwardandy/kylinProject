package release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain
{
	import avmplus.getQualifiedClassName;
	
	import com.greensock.TweenLite;
	import com.shinezone.core.structure.controls.GameEvent;
	import com.shinezone.towerDefense.fight.constants.BattleEffectType;
	import com.shinezone.towerDefense.fight.constants.EndlessBattleConst;
	import com.shinezone.towerDefense.fight.constants.GameFightConstant;
	import com.shinezone.towerDefense.fight.constants.TowerDefenseGameState;
	import release.module.kylinFightModule.gameplay.oldcore.core.BasicView;
	import release.module.kylinFightModule.gameplay.oldcore.core.IGameLifecycleBeNotifyer;
	import release.module.kylinFightModule.gameplay.oldcore.core.ISceneFocusElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics.BasicSceneElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.ShortCutKeyResponser.MarchMonsterShortCutRespon;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.newMonster.NewMonsterIconContainerView;
	import release.module.kylinFightModule.gameplay.oldcore.events.GameDataInfoEvent;
	import release.module.kylinFightModule.gameplay.oldcore.events.GameMarchMonsterEvent;
	import release.module.kylinFightModule.gameplay.oldcore.events.SceneElementFocusEvent;
	import release.module.kylinFightModule.gameplay.oldcore.manager.eventsMgr.EndlessBattleMgr;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightDataInfoManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightInfoRecorder;
	import release.module.kylinFightModule.gameplay.oldcore.utils.CommonAnimationEffects;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.gameplay.oldcore.vo.GlobalTemp;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	import com.shinezone.towerDefense.fight.vo.map.MonsterMarchSubWaveVO;
	import com.shinezone.towerDefense.fight.vo.map.MonsterMarchWaveVO;
	import com.shinezone.towerDefense.fight.vo.map.RoadVO;
	
	import fl.text.TLFTextField;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import framecore.structure.controls.uiCommand.UI_CMD_Const;
	import framecore.structure.model.constdata.GameConst;
	import framecore.structure.model.constdata.PopConst;
	import framecore.structure.model.constdata.TowerSoundEffectsConst;
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.UserData;
	import framecore.structure.model.user.monster.MonsterTemplateInfo;
	import framecore.structure.model.user.spiritBless.SpiritBlessData;
	import framecore.structure.model.varMoudle.GameSettingVar;
	import framecore.structure.views.newguidPanel.NewbieGuideManager;
	import framecore.structure.views.pubpanel.components.MovieBtn;
	import framecore.structure.views.spiritBlessPanel.components.SpiritIconManager;
	import framecore.tools.button.McButton;
	import framecore.tools.events.BasicEvent;
	import framecore.tools.font.FontUtil;
	import framecore.tools.media.TowerMediaPlayer;
	import framecore.tools.time.DateUtil;
	import framecore.tools.tips.ToolTipConst;
	import framecore.tools.tips.ToolTipEvent;
	import framecore.tools.tips.ToolTipManager;
	
	import io.smash.time.TimeManager;

	public class GameFightMainUIView extends BasicView implements IGameLifecycleBeNotifyer
	{
		private static const MARCH_MONSTER_FLAG_SIZE:Number = 60;
		private static const MAX_MARCH_MONSTER_FLAG_COUNT:Number = 5;
		
		private var _gameSceneElementFocusView:DisplayObject;
		private var _userInfoView:CurrentUserInfoView;
		private var _fightBookBtn:McButton;
		private var _fightPauseBtn:McButton;
		private var _fightSettingBtn:McButton;
		private var _fightControllBarView:FightControllBarView;
		
		private var _currentFocusInfoView:GameFocusTargetInfoView;

		private var _marchMonstersFlagLayer:Sprite;
		private var _marchMonstersFlagPool:Array = [];
		private var _marchMonsterShortCut:MarchMonsterShortCutRespon;
		
		//祝福系统图标容器
		private var _spiritBlessIconContainer:Sprite = null;
		
		//新怪展示
		private var _newMonsterIconsView:NewMonsterIconContainerView = null;
		
		private var _effects:Vector.<MovieClip> = new Vector.<MovieClip>();
		
		//无极幻境加战场buff按钮
		private var _battleDrumsBtn:McButton;
		
		private var _iShowTreasureTick:int;
		
		public function GameFightMainUIView()
		{
			super();
			mouseEnabled = false;
		}
		
		public function playBattleEffect( type:int,param:Array = null ):void
		{
			var effect:MovieClip = _effects[type];
			effect.gotoAndPlay( 1 );
			effect.visible = true;
			if(!GameAGlobalManager.getInstance().game.contains(effect))
				GameAGlobalManager.getInstance().game.addChild(effect);
			effect.addFrameScript(effect.totalFrames-1,function():void{
				effect.stop();
				if(GameAGlobalManager.getInstance().game.contains(effect))
					GameAGlobalManager.getInstance().game.removeChild(effect);
				
				if(type == BattleEffectType.ENDLESS_WAVE_NUM_EFFECT)
				{
					//effect.removeEventListener(Event.ENTER_FRAME,onEnterEndlessWaveNum);
					playBattleEffect(BattleEffectType.ENDLESS_WAVE_EFFECT);
				}
			}
			);
			
			if ( type == BattleEffectType.HURT_WARN_EFFECT )
			{
				tweenLifeIcon();
			}
			else if(BattleEffectType.ENDLESS_WAVE_NUM_EFFECT == type)
			{
				//effect.addEventListener(Event.ENTER_FRAME,onEnterEndlessWaveNum);
				(((effect as EndlessWaveNumEff).mcTxt.getChildByName("txtBack") as MovieClip).getChildByName("txtNum") as TLFTextField).text = param[0].toString();
				(((effect as EndlessWaveNumEff).mcTxt.getChildByName("txtMC") as MovieClip).getChildByName("txtNum") as TLFTextField).text = param[0].toString();
			}
		}
		
		public function tweenLifeIcon():void
		{
			TweenLite.killTweensOf( _userInfoView.lifeIcon );
			TweenLite.killTweensOf( _userInfoView.lifeTextField );
			_userInfoView.lifeIcon.scaleX = _userInfoView.lifeIcon.scaleY = _userInfoView.lifeTextField.scaleX = _userInfoView.lifeTextField.scaleY = 1;
			
			TweenLite.to( _userInfoView.lifeIcon, 0.2, {scaleX:1.75, scaleY:1.75} );
			TweenLite.to( _userInfoView.lifeIcon, 0.2, {scaleX:1, scaleY:1, delay:0.2, overwrite:0} );
			
			//文本
			TweenLite.to( _userInfoView.lifeTextField, 0.2, {scaleX:1.75, scaleY:1.75} );
			TweenLite.to( _userInfoView.lifeTextField, 0.2, {scaleX:1, scaleY:1, delay:0.2, overwrite:0} );
		}
		
		private function onEnterEndlessWaveNum(e:Event):void
		{
			var mc:EndlessWaveNumEff = e.currentTarget as EndlessWaveNumEff;
			var curWave:int = GameAGlobalManager.getInstance().gameDataInfoManager.sceneWaveCurrentCount+1;
			((mc.mcTxt.getChildByName("txtBack") as MovieClip).getChildByName("txtNum") as TLFTextField).text = curWave.toString();
			((mc.mcTxt.getChildByName("txtMc") as MovieClip).getChildByName("txtNum") as TLFTextField).text = curWave.toString();
		}
		
		/**
		 * 新怪展示窗口 
		 * @return 
		 * 
		 */		
		public function get newMonsterIconView():NewMonsterIconContainerView
		{
			return _newMonsterIconsView;
		}
		
		public function get fightControllBarView():FightControllBarView
		{
			return _fightControllBarView;
		}

		private function showMarchMonsterFlag(waveMonsterSumInfos:Array):void
		{
			removeAllMarchMonsterFlags();
			
			TowerMediaPlayer.getInstance().playEffect( TowerSoundEffectsConst.WARN );
			
			for(var roadIndex:String in waveMonsterSumInfos)
			{
				var marchMonsterFlag:MarchMonsterFlag = _marchMonstersFlagPool.length > 0 ? _marchMonstersFlagPool.pop() : new MarchMonsterFlag();
				marchMonsterFlag.roadIdx = int(roadIndex);
				
				var roadVOs:Vector.<RoadVO> = GameAGlobalManager.getInstance().gameDataInfoManager.currentSceneMapInfo.roadVOs;
				var roadVO:RoadVO = roadVOs[int(roadIndex)];
				var roadStartPoint:PointVO = roadVO.lineVOs[1].points[0];
				
				var x:Number = roadStartPoint.x;
				var y:Number = roadStartPoint.y;

				if(x < MARCH_MONSTER_FLAG_SIZE / 2) x = MARCH_MONSTER_FLAG_SIZE / 2;
				else if(x > GameFightConstant.SCENE_MAP_WIDTH - MARCH_MONSTER_FLAG_SIZE / 2) x = GameFightConstant.SCENE_MAP_WIDTH - MARCH_MONSTER_FLAG_SIZE / 2;
				
				if(y < MARCH_MONSTER_FLAG_SIZE / 2) y = MARCH_MONSTER_FLAG_SIZE / 2;
				else if(y > GameFightConstant.SCENE_MAP_HEIGHT - MARCH_MONSTER_FLAG_SIZE / 2) y = GameFightConstant.SCENE_MAP_HEIGHT - MARCH_MONSTER_FLAG_SIZE / 2;
				
				var bFly:Boolean = false;
				for(var id:String in waveMonsterSumInfos[roadIndex])
				{
					var info:MonsterTemplateInfo = TemplateDataFactory.getInstance().getMonsterTemplateById(uint(id));
					if(info && 2 == info.type)
					{
						bFly = true;
						break;
					}
				}
				
				marchMonsterFlag.flyable = bFly;
				marchMonsterFlag.x = x;
				marchMonsterFlag.y = y;
				marchMonsterFlag.setArrowRotation(GameMathUtil.radianToDegree(GameMathUtil.caculateDirectionRadianByTwoPoint2(x, y, roadStartPoint.x, roadStartPoint.y)));
				_marchMonstersFlagLayer.addChild(marchMonsterFlag);
				
			}
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			_spiritBlessIconContainer = new Sprite();
			_spiritBlessIconContainer.mouseEnabled = false;
			addChild( _spiritBlessIconContainer );
			
			_currentFocusInfoView = new GameFocusTargetInfoView();
			_currentFocusInfoView.x = 180;
			_currentFocusInfoView.y = 550;
			addChild(_currentFocusInfoView);
			
			_fightControllBarView = new FightControllBarView();
			addChild(_fightControllBarView);
			
			_userInfoView = new CurrentUserInfoView();
			//_userInfoView.userImgLoader.source = UserData.getInstance().userBaseInfo.getUserHeadImageUrl();
			//_userInfoView.userImgLoader.addEventListener(IOErrorEvent.IO_ERROR, userImgLoaderErrorHandler);
			/*_userInfoView.lifeTextField.text = sceneLifeText;
			_userInfoView.goldTextField.text = sceneGoldText;
			_userInfoView.waveTextField.text = sceneWaveText;*/
			FontUtil.useFont( _userInfoView.lifeTextField.lifeTextField, FontUtil.FONT_TYPE_BUTTON );
			FontUtil.useFont( _userInfoView.goldTextField, FontUtil.FONT_TYPE_BUTTON );
			FontUtil.useFont( _userInfoView.waveTextField, FontUtil.FONT_TYPE_BUTTON );
			FontUtil.useFont( _userInfoView.waveLabel, FontUtil.FONT_TYPE_BUTTON );
			FontUtil.useFont( _userInfoView.txtScore.txtScore, FontUtil.FONT_TYPE_BUTTON );
			
			_userInfoView.lifeTextField.mouseChildren = false;
			
			_userInfoView.goldTextField.mouseEnabled = true;
			_userInfoView.goldTextField.selectable = false;
			
			_newMonsterIconsView = new NewMonsterIconContainerView();
			_newMonsterIconsView.y = 80;
			_newMonsterIconsView.x = 10;
			addChild( _newMonsterIconsView );
			
			addChild(_userInfoView);
			_userInfoView.x += 10;
			_userInfoView.y += 8;

			_fightBookBtn = new McButton;
			var mc:FightBookBtn = new FightBookBtn();
			_fightBookBtn.setSkin(new FightBookBtn() as MovieClip);
			_fightBookBtn.addActionEventListener(fightBookBtnClickHandler);
			_fightBookBtn.getSkin().x = 540+60;
//			addChild(_fightBookBtn);
			
			_fightPauseBtn = new McButton;
			_fightPauseBtn.setSkin(new FightPauseBtn() as MovieClip);
			_fightPauseBtn.getSkin().x = 590+60;
			_fightPauseBtn.addActionEventListener(fightPauseBtnClickHandler);
			addChild(_fightPauseBtn.getSkin());
			
			_fightSettingBtn = new McButton;
			_fightSettingBtn.setSkin(new FightSettingBtn() as MovieClip);
			_fightSettingBtn.getSkin().x = 640+60;
			_fightSettingBtn.addActionEventListener(fightSettingBtnClickHandler);
			addChild(_fightSettingBtn.getSkin());
			
			_marchMonstersFlagLayer = new Sprite();
			_marchMonstersFlagLayer.mouseEnabled = false;
			_marchMonstersFlagLayer.addEventListener(MouseEvent.CLICK, marchMonstersFlagLayerMouseClickHandler);
			addChild(_marchMonstersFlagLayer);
			
			ToolTipManager.getInstance().registGameToolTipTarget( _userInfoView.lifeIcon, ToolTipConst.DEFAULT_TEXT_TOOL );
			_userInfoView.lifeIcon.addEventListener( ToolTipEvent.GAME_TOOL_TIP_SHOW, showTipHandler );
			ToolTipManager.getInstance().registGameToolTipTarget( _userInfoView.lifeTextField, ToolTipConst.DEFAULT_TEXT_TOOL );
			_userInfoView.lifeTextField.addEventListener( ToolTipEvent.GAME_TOOL_TIP_SHOW, showTipHandler );
			
			ToolTipManager.getInstance().registGameToolTipTarget( _userInfoView.boxIcon, ToolTipConst.DEFAULT_TEXT_TOOL );
			_userInfoView.boxIcon.addEventListener( ToolTipEvent.GAME_TOOL_TIP_SHOW, showTipHandler );
			ToolTipManager.getInstance().registGameToolTipTarget( _userInfoView.goldTextField, ToolTipConst.DEFAULT_TEXT_TOOL );
			_userInfoView.goldTextField.addEventListener( ToolTipEvent.GAME_TOOL_TIP_SHOW, showTipHandler );
			
			ToolTipManager.getInstance().registGameToolTipTarget( _fightPauseBtn.getSkin(), ToolTipConst.DEFAULT_TEXT_TOOL );
			ToolTipManager.getInstance().registGameToolTipTarget( _fightSettingBtn.getSkin(), ToolTipConst.DEFAULT_TEXT_TOOL );
			_fightPauseBtn.addEventListener( ToolTipEvent.GAME_TOOL_TIP_SHOW, showTipHandler );
			_fightSettingBtn.addEventListener( ToolTipEvent.GAME_TOOL_TIP_SHOW, showTipHandler );
			
			_userInfoView.drumsBuff.visible = false;
			_userInfoView.drumsBuff.mouseChildren = false;
			//_userInfoView.drumsBuff.mouseEnabled = false;
			_userInfoView.drumsBuff.cacheAsBitmap = true;
			
			_userInfoView.retrievedBuff.visible = false;
			_userInfoView.retrievedBuff.mouseChildren = false;
			//_userInfoView.retrievedBuff.mouseEnabled = false;
			_userInfoView.retrievedBuff.cacheAsBitmap = true;
			
			ToolTipManager.getInstance().registGameToolTipTarget( _userInfoView.drumsBuff, ToolTipConst.DEFAULT_TEXT_TOOL );
			_userInfoView.drumsBuff.addEventListener( ToolTipEvent.GAME_TOOL_TIP_SHOW, showTipHandler );
			ToolTipManager.getInstance().registGameToolTipTarget( _userInfoView.retrievedBuff, ToolTipConst.DEFAULT_TEXT_TOOL );
			_userInfoView.retrievedBuff.addEventListener( ToolTipEvent.GAME_TOOL_TIP_SHOW, showTipHandler );
			
			FontUtil.useFont( _userInfoView.drumsBuff.buffNum, FontUtil.FONT_TYPE_NORMAL );
			
			
			_userInfoView.endlessIcon.mouseChildren = false;
			_userInfoView.endlessIcon.mouseEnabled = false;
			_userInfoView.endlessIcon.cacheAsBitmap = true;
			_userInfoView.waveIcon.mouseChildren = false;
			_userInfoView.waveIcon.mouseEnabled = false;
			_userInfoView.waveIcon.cacheAsBitmap = true;
			
			_marchMonsterShortCut = new MarchMonsterShortCutRespon;
			
			var effect:MovieClip = new HurtWarnEffect();
			effect.mouseChildren = effect.mouseEnabled = false;
			effect.gotoAndStop( 1 );
			effect.visible = false;
			var posX:int = GameFightConstant.SCENE_MAP_WIDTH >> 1;
			var posY:int = GameFightConstant.SCENE_MAP_HEIGHT >> 1;
			effect.x = posX;
			effect.y = posY;
			//addChild( effect );
			_effects.push( effect );
			
			effect = new FinalWaveEffect();
			effect.mouseChildren = effect.mouseEnabled = false;
			effect.gotoAndStop( 1 );
			effect.visible = false;
			effect.x = posX;
			effect.y = posY;
			//addChild( effect );
			_effects.push( effect );
			
			
		}
		
		private function showTipHandler( e:ToolTipEvent ):void
		{
			switch ( e.target )
			{
				case _userInfoView.goldTextField:
				case _userInfoView.boxIcon:
				{
					e.toolTip.data = "Goods: Resources needed to build your towers. Collected by killing enemies and selling towers.";
					break;
				}
				case _userInfoView.lifeTextField:
				case _userInfoView.lifeIcon:
				{
					e.toolTip.data = "Lives: Enemies that get through your defenses will deduct lives; if your lives reach 0, you are defeated.";
					break;
				}
				case _fightSettingBtn.getSkin():
				{
					e.toolTip.data = "Options";
					break;
				}
				case _fightPauseBtn.getSkin():
				{
					e.toolTip.data = "Pause";
					break;
				}
				case _userInfoView.drumsBuff:
				{
					
					e.toolTip.data = "Current level:"+ (EndlessBattleMgr.instance.reachMaxAtkBuff?"MAX":EndlessBattleMgr.instance.curAtkBuffLevel)
						+"\nIncreases all towers attack damage by "+EndlessBattleMgr.instance.addAtkPct+"%";
				}
					break;
				case _userInfoView.retrievedBuff:
				{
					e.toolTip.data = "God's Fury\nIncreases all towers attack speed by "+EndlessBattleMgr.instance.addAtkSpdPct+"% for 2 waves";
				}
					break;
				default:
				{
					break;
				}
			}
		}
		
		//ignore
		private function userImgLoaderErrorHandler(event:Event):void
		{
		}
		
		override protected function onInitializedComplete():void
		{
			GameAGlobalManager.getInstance()
				.gameDataInfoManager
				.addEventListener(GameDataInfoEvent.INITIALIZE_DATA_INFO, gameDataInfoUpdateHandler);
			
			GameAGlobalManager.getInstance()
				.gameDataInfoManager
				.addEventListener(GameDataInfoEvent.UPDATE_SCENE_LIFE, gameDataInfoUpdateHandler);
			
			GameAGlobalManager.getInstance()
				.gameDataInfoManager
				.addEventListener(GameDataInfoEvent.UPDATE_SCENE_GOLD, gameDataInfoUpdateHandler);
			
			GameAGlobalManager.getInstance()
				.gameDataInfoManager
				.addEventListener(GameDataInfoEvent.UPDATE_SCENE_WAVE, gameDataInfoUpdateHandler);
			
			GameAGlobalManager.getInstance()
				.gameDataInfoManager
				.addEventListener(GameDataInfoEvent.UPDATE_SCENE_SCORE, gameDataInfoUpdateHandler);
			
			GameAGlobalManager.getInstance()
				.gameInteractiveManager
				.addEventListener(SceneElementFocusEvent.SCENE_ELEMENT_FOCUSED, sceneElementFocusedHandler);
			
			GameAGlobalManager.getInstance()
				.gameMonsterMarchManager
				.addEventListener(GameMarchMonsterEvent.WAIT_AND_READ_TO_MARCH_NEXT_WAVE, waitAndReadyToMarchNExtWaveHandler);
			GameAGlobalManager.getInstance()
				.gameMonsterMarchManager
				.addEventListener(GameMarchMonsterEvent.MARCH_NEXT_WAVE, marchNextWaveHandler);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			removeAllMarchMonsterFlags();
			
			this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			while(numChildren > 0)
			{
				removeChildAt(0);
			}

			_currentFocusInfoView.dispose();
			_currentFocusInfoView = null;

			_fightControllBarView.dispose();
			_fightControllBarView = null;
			
			//_userInfoView.userImgLoader.removeEventListener(IOErrorEvent.IO_ERROR, userImgLoaderErrorHandler);
			//_userInfoView.userImgLoader.source = null;
			_userInfoView = null;

			_fightPauseBtn.removeActionEventListener();
			_fightPauseBtn = null;
			
			_fightSettingBtn.removeActionEventListener();
			_fightSettingBtn = null;
			
			_marchMonstersFlagLayer.removeEventListener(MouseEvent.CLICK, marchMonstersFlagLayerMouseClickHandler);
			_marchMonstersFlagLayer = null;

			GameAGlobalManager.getInstance()
				.gameDataInfoManager
				.removeEventListener(GameDataInfoEvent.INITIALIZE_DATA_INFO, gameDataInfoUpdateHandler);

			GameAGlobalManager.getInstance()
				.gameDataInfoManager
				.removeEventListener(GameDataInfoEvent.UPDATE_SCENE_LIFE, gameDataInfoUpdateHandler);
			
			GameAGlobalManager.getInstance()
				.gameDataInfoManager
				.removeEventListener(GameDataInfoEvent.UPDATE_SCENE_GOLD, gameDataInfoUpdateHandler);
			
			GameAGlobalManager.getInstance()
				.gameDataInfoManager
				.removeEventListener(GameDataInfoEvent.UPDATE_SCENE_WAVE, gameDataInfoUpdateHandler);
			
			GameAGlobalManager.getInstance()
				.gameInteractiveManager
				.removeEventListener(SceneElementFocusEvent.SCENE_ELEMENT_FOCUSED, sceneElementFocusedHandler);
			
			GameAGlobalManager.getInstance()
				.gameMonsterMarchManager
				.removeEventListener(GameMarchMonsterEvent.WAIT_AND_READ_TO_MARCH_NEXT_WAVE, waitAndReadyToMarchNExtWaveHandler);
			GameAGlobalManager.getInstance()
				.gameMonsterMarchManager
				.removeEventListener(GameMarchMonsterEvent.MARCH_NEXT_WAVE, marchNextWaveHandler);
		}
		
		//IGameLifecycleNotifyer
		public function onGameStart():void
		{
			_fightControllBarView.onGameStart();
			
			_fightPauseBtn.visible = (!GlobalTemp.newGuideMockTollgateFlag || GameAGlobalManager.bTest );
			_fightSettingBtn.visible = _fightPauseBtn.visible;
			
			_newMonsterIconsView.clearAll();
			
			GameAGlobalManager.getInstance().gameInteractiveManager.registerShortCutKeyResponser(("z").charCodeAt(),_marchMonsterShortCut);
			GameAGlobalManager.getInstance().gameInteractiveManager.registerShortCutKeyResponser(("Z").charCodeAt(),_marchMonsterShortCut);
			
			SpiritIconManager.getInstance().displayMode = SpiritIconManager.HORIZONTAL;
			SpiritIconManager.getInstance().showIcons( _spiritBlessIconContainer, 175, 24, false, SpiritBlessData.SPIRITBLESS_ADDGOODS, SpiritBlessData.SPIRITBLESS_HEROATK, SpiritBlessData.SPIRITBLESS_TOWERATK);
			

			_userInfoView.endlessIcon.visible = EndlessBattleMgr.instance.isEndless;
			_userInfoView.waveIcon.visible = !EndlessBattleMgr.instance.isEndless;
			_userInfoView.drumsBuff.visible = false;
			_userInfoView.retrievedBuff.visible = false;
			
			if(EndlessBattleMgr.instance.isEndless)
			{
				if(!_battleDrumsBtn)
				{
					_battleDrumsBtn = new McButton;
					_battleDrumsBtn.setSkin(new BattleDrumsBtn as MovieClip);
					_battleDrumsBtn.getSkin().x = 27;
					_battleDrumsBtn.getSkin().y = 102;
					addChild(_battleDrumsBtn.getSkin());
					_battleDrumsBtn.addActionEventListener(onBattleDrumsClick);
				}
				_battleDrumsBtn.visible = true;
				_battleDrumsBtn.enabled = true;

				_userInfoView.waveLabel.visible = false;
				_userInfoView.waveTextField.visible = false;
				_userInfoView.txtScore.visible = true;
				
				var posX:int = GameFightConstant.SCENE_MAP_WIDTH >> 1;
				var posY:int = GameFightConstant.SCENE_MAP_HEIGHT >> 1;
				var effect:MovieClip = new EndlessWaveEff();
				effect.mouseChildren = effect.mouseEnabled = false;
				effect.gotoAndStop( 1 );
				effect.visible = false;
				effect.x = posX;
				effect.y = posY;
				//addChild( effect );
				_effects.push( effect );
				
				effect = new EndlessWaveNumEff();
				effect.mouseChildren = effect.mouseEnabled = false;
				effect.gotoAndStop( 1 );
				effect.visible = false;
				effect.x = posX;
				effect.y = posY;
				//addChild( effect );
				_effects.push( effect );
				
			}
			else
			{
				if(_battleDrumsBtn)
				{
					_battleDrumsBtn.visible = false;
				}
				_userInfoView.waveLabel.visible = true;
				_userInfoView.waveTextField.visible = true;
				_userInfoView.txtScore.visible = false;
			}
		}
		
		public function onGamePause():void
		{
			_fightControllBarView.onGamePause();
			
			_currentFocusInfoView.hide();	//游戏暂停的时候不会抛出焦事件，故手动隐藏掉
		}

		public function onGameResume():void
		{
			_fightControllBarView.onGameResume();
		}

		public function onGameEnd():void
		{
			this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			removeAllMarchMonsterFlags();
			if(_iShowTreasureTick>0)
			{
				clearTimeout(_iShowTreasureTick);
				_iShowTreasureTick = 0;
			}
			_fightControllBarView.onGameEnd();
			_currentFocusInfoView.hide();
		}
		
		private function onBattleDrumsClick(/*event:MouseEvent*/):void
		{
			//EndlessBattleMgr.instance.retrieveFromFail();
			//return;
			var data:Array = [];
			data.push(EndlessBattleMgr.instance.curAtkBuffLevel);
			data.push(EndlessBattleMgr.instance.getAddBuffDiamondPriceByLvl(data[0]+1));
			data.push(EndlessBattleMgr.instance.getAddBuffGoldPriceByLvl(data[0]+1));
			data.push(Math.ceil((EndlessBattleConst.MAX_ATKBUFF_LVL-data[0])/EndlessBattleConst.EACH_DIAMOND_ATKBUFF_LVL).toString()
				+"/"+(Math.ceil(EndlessBattleConst.MAX_ATKBUFF_LVL/EndlessBattleConst.EACH_DIAMOND_ATKBUFF_LVL)).toString());
			data.push(Math.ceil((EndlessBattleConst.MAX_ATKBUFF_LVL-data[0])/EndlessBattleConst.EACH_GOOD_ATKBUFF_LVL).toString()
				+"/"+(Math.ceil(EndlessBattleConst.MAX_ATKBUFF_LVL/EndlessBattleConst.EACH_GOOD_ATKBUFF_LVL)).toString());
			
			if(!EndlessBattleMgr.instance.reachMaxAtkBuff)
			{
				GameEvent.getInstance().sendEvent(UI_CMD_Const.OPEN_POP , [UI_CMD_Const.OPEN_POP , "popPanel",PopConst.BATTLE_DRUMS,data]);
				GameAGlobalManager.getInstance().game.pause( false, false );
			}
		}
		
		public function InvisibleBattleDrumsBtn():void
		{
			if(_battleDrumsBtn && _battleDrumsBtn.visible)
			{
				_battleDrumsBtn.visible = false;
				_battleDrumsBtn.enabled = false;
			}
		}
		
		public function updateEndlessDrumsBuff(bShow:Boolean,iLvl:int):void
		{
			_userInfoView.drumsBuff.visible = bShow;
			if(bShow)
				_userInfoView.drumsBuff.buffNum.text = iLvl.toString();
		}
		
		public function updateEndlessRebirthBuff(bShow:Boolean):void
		{
			_userInfoView.retrievedBuff.visible = bShow;
		}

		//event handler
		private function fightBookBtnClickHandler(/*event:MouseEvent*/):void
		{
			TowerMediaPlayer.getInstance().playEffect( TowerSoundEffectsConst.CLICK_BUTTON );
			//GameAGlobalManager.getInstance().game.notifyToGameOver(false);
			GameEvent.getInstance().sendEvent(UI_CMD_Const.OPEN_PANEL , [UI_CMD_Const.OPEN_PANEL , "gameBookPanel" ]);
			GameAGlobalManager.getInstance().game.pause(false,false);
		}
		
		private function fightPauseBtnClickHandler(/*event:MouseEvent*/):void
		{
			TowerMediaPlayer.getInstance().playEffect( TowerSoundEffectsConst.CLICK_BUTTON );
			GameAGlobalManager.getInstance().game.pause();
		}
		
		private function marchMonstersFlagLayerMouseClickHandler(event:MouseEvent):void
		{
			GameAGlobalManager.getInstance().gameMonsterMarchManager.marchNextWave();
			var flag:MarchMonsterFlag = event.target as MarchMonsterFlag;
			var goods:int = GameAGlobalManager.getInstance().gameDataInfoManager.earlerGolds;
			if(flag && goods>0)
			{
				GameAGlobalManager.getInstance().gameFightInfoRecorder.taskOpData.marchMonsterCount++;
				playAddGoodsAnim(flag.x,flag.y+20,goods,this);
			}
			
			/*_newMonsterIconsView.pushMonster( 141001 );
			_newMonsterIconsView.show();*/
		}
		
		//private var _addGoodsEff:addGoodsEff;
		public function playAddGoodsAnim(ix:int,iy:int,goods:int,pParent:Sprite,bBig:Boolean = true,txtColor:uint = 0):void
		{
			//if(!_addGoodsEff)
			//{
			var _addGoodsEff:MovieClip;
			if(bBig)
				_addGoodsEff = new addGoodsEff;
			else
				_addGoodsEff = new addSmallGoodsEff;
			_addGoodsEff.x = ix;
			_addGoodsEff.y = iy;
			var mcBox:MovieClip = _addGoodsEff.content.getChildByName("mcBox") as MovieClip;
			//}
			pParent.addChild(_addGoodsEff);
			var text:TextField = (_addGoodsEff.content.getChildByName("txtNum") as TextField);
			
			FontUtil.useFont( text, FontUtil.FONT_TYPE_BUTTON );
			if(text)
			{
				text.width = 100;
				text.text = "+"+goods;
				text.width = text.textWidth + 10;
				if(txtColor>0)
					text.textColor = txtColor;
			}
			_addGoodsEff.gotoAndPlay(1);
			_addGoodsEff.addFrameScript(_addGoodsEff.totalFrames-1,function():void{
				if(_addGoodsEff.parent)
					_addGoodsEff.parent.removeChild(_addGoodsEff);
			});
		}
		
		/*private function onEndAddGoodsEff():void
		{
			if(_addGoodsEff.parent)
				_addGoodsEff.parent.removeChild(_addGoodsEff);	
		}*/
		
		private function fightSettingBtnClickHandler(/*event:MouseEvent*/):void
		{
			TowerMediaPlayer.getInstance().playEffect( TowerSoundEffectsConst.CLICK_BUTTON );
			GameEvent.getInstance().sendEvent(UI_CMD_Const.OPEN_PANEL ,[UI_CMD_Const.OPEN_PANEL , 'systemPanel']);
			GameAGlobalManager.getInstance().game.pause(false, false);
		}
		
		private function gameDataInfoUpdateHandler(event:GameDataInfoEvent):void
		{
			var gameDataInfoManager:GameFightDataInfoManager = GameAGlobalManager.getInstance().gameDataInfoManager;
			
			var sceneLifeText:String = gameDataInfoManager.sceneLife <= 0 ? "0" : gameDataInfoManager.sceneLife.toString();
			var sceneGoldText:String = gameDataInfoManager.sceneGold <= 0 ? "0" : gameDataInfoManager.sceneGold.toString();
			var sceneWaveText:String =  gameDataInfoManager.sceneWaveCurrentCount.toString() + "/" + gameDataInfoManager.sceneWaveTotalCount.toString();
			var sceneScore:String = GameAGlobalManager.getInstance().gameFightInfoRecorder.getCurrentSceneResultScore().toString();
			switch(event.type)
			{
				case GameDataInfoEvent.INITIALIZE_DATA_INFO:
					_userInfoView.lifeTextField.lifeTextField.text = sceneLifeText;
					_userInfoView.goldTextField.text = sceneGoldText;
					_userInfoView.waveTextField.text = sceneWaveText;
					break;

				case GameDataInfoEvent.UPDATE_SCENE_LIFE:
					_userInfoView.lifeTextField.lifeTextField.text = sceneLifeText;
					break;
				
				case GameDataInfoEvent.UPDATE_SCENE_GOLD:
					_userInfoView.goldTextField.text = sceneGoldText;
					break;

				case GameDataInfoEvent.UPDATE_SCENE_WAVE:
					_userInfoView.waveTextField.text = sceneWaveText;
					break;
				case GameDataInfoEvent.UPDATE_SCENE_SCORE:
				{
					if(int(sceneScore)<=0)
					{
						_userInfoView.txtScore.filters = null;
						_userInfoView.txtScore.txtScore.text = sceneScore;
						return;
					}
					TweenLite.killTweensOf( _userInfoView.txtScore );
					_userInfoView.txtScore.scaleX = _userInfoView.txtScore.scaleY = 1;
					_userInfoView.txtScore.filters = [new GlowFilter( 0x00FFFF, 1, 4, 4)];
					TweenLite.to( _userInfoView.txtScore, 0.2, {scaleX:2, scaleY:2} );
					TweenLite.to( _userInfoView.txtScore, 0.2, {scaleX:1, scaleY:1, delay:0.2, overwrite:0, 
						onComplete:function():void
						{
							_userInfoView.txtScore.filters = null;
							_userInfoView.txtScore.txtScore.text = sceneScore;
						}
					} );
					break;
				}
			}
		}
		
		private function sceneElementFocusedHandler(event:SceneElementFocusEvent):void
		{
			var focusedElement:ISceneFocusElement = event.focusedElement;
			
			//test
			var isShowCurrentFocusInfoView:Boolean = focusedElement != null && 
				focusedElement.focusEnable && focusedElement.focusTipEnable;
			
			if(isShowCurrentFocusInfoView)
			{
				_currentFocusInfoView.show(focusedElement);
			}
			else
			{
				_currentFocusInfoView.hide();
			}
		}

		private function waitAndReadyToMarchNExtWaveHandler(event:GameMarchMonsterEvent):void
		{
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			showMarchMonsterFlag(GameAGlobalManager.getInstance().gameDataInfoManager.getNextWaveVO().waveMonsterSumInfos);
		}
		
		private function removeAllMarchMonsterFlags():void
		{
			while(_marchMonstersFlagLayer.numChildren)
			{
				var marchMonsterFlag:MarchMonsterFlag = _marchMonstersFlagLayer.removeChildAt(0) as MarchMonsterFlag;
				if(_marchMonstersFlagPool.length < MAX_MARCH_MONSTER_FLAG_COUNT)
				{
					_marchMonstersFlagPool.push(marchMonsterFlag);
				}
				else
				{
					marchMonsterFlag.dispose();
				}
			}
		}
		
		
		private function marchNextWaveHandler(event:GameMarchMonsterEvent):void
		{
			this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			removeAllMarchMonsterFlags();
			
			var currentWave:int = GameAGlobalManager.getInstance().gameDataInfoManager.sceneWaveCurrentCount;
			if(currentWave == 1 ||(EndlessBattleMgr.instance.isEndless && EndlessBattleMgr.instance.recordWave+1 == currentWave))
			{
				GlobalTemp.useTime = 0;				//从出第一波怪开始进行游戏过关计时
				GlobalTemp.tempTime = TimeManager.instance.virtualTime;

				_fightControllBarView.notifyAllIconsIsUseable();
			}
			
			if(DateUtil.isInDuration(GameSettingVar.collectTypeRewardDuration) && 1 == currentWave && !EndlessBattleMgr.instance.isEndless)
			{
				_iShowTreasureTick = setTimeout(showTreasureHunterTip,15000);
			}
		}
		
		private function showTreasureHunterTip():void
		{
			if(_iShowTreasureTick>0)
			{
				clearTimeout(_iShowTreasureTick);
				_iShowTreasureTick = 0;
			}
			_fightControllBarView.showTreasureHunterTip();
		}
		
		private function enterFrameHandler(event:Event):void
		{
			var n:uint = _marchMonstersFlagLayer.numChildren;
			for(var i:uint = 0; i < n; i++)
			{
				var marchMonsterFlag:MarchMonsterFlag = _marchMonstersFlagLayer.getChildAt(i) as MarchMonsterFlag;
				
				marchMonsterFlag.visible = !GlobalTemp.newGuideMockTollgateFlag || GlobalTemp.enableMonsterMarchFlag;
				
				marchMonsterFlag.setProgress(GameAGlobalManager.getInstance().gameMonsterMarchManager.getWaitNextWaveProgress());
			}
		}
		
	}
}