package release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain
{
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	import fl.text.TLFTextField;
	
	import io.smash.time.TimeManager;
	
	import kylin.echo.edward.ui.McButton;
	import kylin.echo.edward.utilities.datastructures.HashMap;
	import kylin.echo.edward.utilities.font.FontMgr;
	
	import mainModule.model.gameData.sheetData.monster.IMonsterSheetDataModel;
	import mainModule.model.gameData.sheetData.monster.IMonsterSheetItem;
	import mainModule.service.soundServices.ISoundService;
	import mainModule.service.soundServices.SoundGroupType;
	
	import release.module.kylinFightModule.controller.fightInitSteps.FightInitStepsEvent;
	import release.module.kylinFightModule.controller.fightState.FightStateEvent;
	import release.module.kylinFightModule.gameplay.constant.BattleEffectType;
	import release.module.kylinFightModule.gameplay.constant.GameFightConstant;
	import release.module.kylinFightModule.gameplay.constant.identify.SoundID;
	import release.module.kylinFightModule.gameplay.oldcore.core.BasicView;
	import release.module.kylinFightModule.gameplay.oldcore.core.IFightLifecycle;
	import release.module.kylinFightModule.gameplay.oldcore.core.ISceneFocusElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.ShortCutKeyResponser.MarchMonsterShortCutRespon;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.newMonster.NewMonsterIconContainerView;
	import release.module.kylinFightModule.gameplay.oldcore.events.GameDataInfoEvent;
	import release.module.kylinFightModule.gameplay.oldcore.events.GameMarchMonsterEvent;
	import release.module.kylinFightModule.gameplay.oldcore.events.SceneElementFocusEvent;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.GameFilterManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.eventsMgr.EndlessBattleMgr;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightInfoRecorder;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightInteractiveManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightMonsterMarchManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.gameplay.oldcore.vo.GlobalTemp;
	import release.module.kylinFightModule.model.interfaces.IFightViewLayersModel;
	import release.module.kylinFightModule.model.interfaces.IMapRoadModel;
	import release.module.kylinFightModule.model.interfaces.IMonsterWaveModel;
	import release.module.kylinFightModule.model.interfaces.ISceneDataModel;
	import release.module.kylinFightModule.model.marchWave.MonsterWaveVO;
	import release.module.kylinFightModule.model.roads.MapRoadVO;
	import release.module.kylinFightModule.utili.structure.PointVO;
	
	import robotlegs.bender.framework.api.IInjector;
	
	import utili.font.FontClsName;

	public class GameFightMainUIView extends BasicView implements IFightLifecycle
	{
		private static const MARCH_MONSTER_FLAG_SIZE:Number = 60;
		private static const MAX_MARCH_MONSTER_FLAG_COUNT:Number = 5;
		
		[Inject]
		public var soundService:ISoundService;
		[Inject]
		public var injector:IInjector;
		[Inject]
		public var fightViewLayers:IFightViewLayersModel;
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		[Inject]
		public var recorder:GameFightInfoRecorder;
		[Inject]
		public var monsterWaveModel:IMonsterWaveModel;
		[Inject]
		public var mapRoadModel:IMapRoadModel;
		[Inject]
		public var monsterModel:IMonsterSheetDataModel;
		[Inject]
		public var globalTemp:GlobalTemp;
		[Inject]
		public var interactiveMgr:GameFightInteractiveManager;
		[Inject]
		public var filterMgr:GameFilterManager;
		[Inject]
		public var monsterMarchMgr:GameFightMonsterMarchManager;
		[Inject]
		public var sceneModel:ISceneDataModel;
		[Inject]
		public var timeMgr:TimeManager;
		
		private var _userInfoView:CurrentUserInfoView;
		private var _fightPauseBtn:McButton;
		private var _fightSettingBtn:McButton;
		private var _fightControllBarView:FightControllBarView;
		
		private var _currentFocusInfoView:GameFocusTargetInfoView;

		private var _marchMonstersFlagLayer:Sprite;
		private var _marchMonstersFlagPool:Array = [];
		private var _marchMonsterShortCut:MarchMonsterShortCutRespon;
		
		//新怪展示
		private var _newMonsterIconsView:NewMonsterIconContainerView = null;
		
		private var _effects:Vector.<MovieClip> = new Vector.<MovieClip>();
				
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
			if(!fightViewLayers.UIEffectLayer.contains(effect))
				fightViewLayers.UIEffectLayer.addChild(effect);
			effect.addFrameScript(effect.totalFrames-1,function():void{
				effect.stop();
				effect.visible = false;
				if(fightViewLayers.UIEffectLayer.contains(effect))
					fightViewLayers.UIEffectLayer.removeChild(effect);
				
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
			var curWave:int = monsterWaveModel.curWaveCount+1;
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

		private function showMarchMonsterFlag(waveMonsterSumInfos:HashMap):void
		{
			removeAllMarchMonsterFlags();
			soundService.play(SoundID.Warn,SoundGroupType.Effect,1,true);
			
			for(var roadIndex:int in waveMonsterSumInfos.keys())
			{
				var marchMonsterFlag:MarchMonsterFlag = _marchMonstersFlagPool.length > 0 ? _marchMonstersFlagPool.pop() : new MarchMonsterFlag();
				marchMonsterFlag.roadIdx = int(roadIndex);
				
				var roadVO:MapRoadVO = mapRoadModel.getMapRoad(roadIndex);
				var roadStartPoint:PointVO = roadVO.lineVOs[1].points[0];
				
				var x:Number = roadStartPoint.x;
				var y:Number = roadStartPoint.y;

				if(x < MARCH_MONSTER_FLAG_SIZE / 2) x = MARCH_MONSTER_FLAG_SIZE / 2;
				else if(x > GameFightConstant.SCENE_MAP_WIDTH - MARCH_MONSTER_FLAG_SIZE / 2) x = GameFightConstant.SCENE_MAP_WIDTH - MARCH_MONSTER_FLAG_SIZE / 2;
				
				if(y < MARCH_MONSTER_FLAG_SIZE / 2) y = MARCH_MONSTER_FLAG_SIZE / 2;
				else if(y > GameFightConstant.SCENE_MAP_HEIGHT - MARCH_MONSTER_FLAG_SIZE / 2) y = GameFightConstant.SCENE_MAP_HEIGHT - MARCH_MONSTER_FLAG_SIZE / 2;
				
				var bFly:Boolean = false;
				for(var id:uint in waveMonsterSumInfos.get(roadIndex))
				{
					var info:IMonsterSheetItem = monsterModel.getMonsterSheetById(id);
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
			
			_currentFocusInfoView = injector.instantiateUnmapped(GameFocusTargetInfoView);
			
			_currentFocusInfoView.x = 180;
			_currentFocusInfoView.y = 550;
			addChild(_currentFocusInfoView);
			
			_fightControllBarView = injector.instantiateUnmapped(FightControllBarView);
			addChild(_fightControllBarView);
			
			_userInfoView = new CurrentUserInfoView();
			FontMgr.instance.setTextStyle( _userInfoView.lifeTextField.lifeTextField, FontClsName.ButtonFont );
			FontMgr.instance.setTextStyle( _userInfoView.goldTextField, FontClsName.ButtonFont );
			FontMgr.instance.setTextStyle( _userInfoView.waveTextField, FontClsName.ButtonFont );
			FontMgr.instance.setTextStyle( _userInfoView.waveLabel, FontClsName.ButtonFont );
			FontMgr.instance.setTextStyle( _userInfoView.txtScore.txtScore, FontClsName.ButtonFont );
			
			_userInfoView.lifeTextField.mouseChildren = false;
			
			_userInfoView.goldTextField.mouseEnabled = true;
			_userInfoView.goldTextField.selectable = false;
			
			_newMonsterIconsView = injector.instantiateUnmapped(NewMonsterIconContainerView);
			_newMonsterIconsView.y = 80;
			_newMonsterIconsView.x = 10;
			addChild( _newMonsterIconsView );
			
			addChild(_userInfoView);
			_userInfoView.x += 10;
			_userInfoView.y += 8;
			
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
			
			_userInfoView.endlessIcon.mouseChildren = false;
			_userInfoView.endlessIcon.mouseEnabled = false;
			_userInfoView.endlessIcon.cacheAsBitmap = true;
			_userInfoView.waveIcon.mouseChildren = false;
			_userInfoView.waveIcon.mouseEnabled = false;
			_userInfoView.waveIcon.cacheAsBitmap = true;
			
			_marchMonsterShortCut = injector.instantiateUnmapped(MarchMonsterShortCutRespon);
			
			var effect:MovieClip = new HurtWarnEffect();
			effect.mouseChildren = effect.mouseEnabled = false;
			effect.gotoAndStop( 1 );
			effect.visible = false;
			var posX:int = GameFightConstant.SCENE_MAP_WIDTH >> 1;
			var posY:int = GameFightConstant.SCENE_MAP_HEIGHT >> 1;
			effect.x = posX;
			effect.y = posY;
			_effects.push( effect );
			
			effect = new FinalWaveEffect();
			effect.mouseChildren = effect.mouseEnabled = false;
			effect.gotoAndStop( 1 );
			effect.visible = false;
			effect.x = posX;
			effect.y = posY;
			_effects.push( effect );
			
			
		}
		
		override protected function onInitializedComplete():void
		{
			eventDispatcher.addEventListener(GameDataInfoEvent.INITIALIZE_DATA_INFO, gameDataInfoUpdateHandler);	
			eventDispatcher.addEventListener(GameDataInfoEvent.UPDATE_SCENE_LIFE, gameDataInfoUpdateHandler);	
			eventDispatcher.addEventListener(GameDataInfoEvent.UPDATE_SCENE_GOLD, gameDataInfoUpdateHandler);	
			eventDispatcher.addEventListener(GameDataInfoEvent.UPDATE_SCENE_WAVE, gameDataInfoUpdateHandler);	
			eventDispatcher.addEventListener(GameDataInfoEvent.UPDATE_SCENE_SCORE, gameDataInfoUpdateHandler);	
			eventDispatcher.addEventListener(SceneElementFocusEvent.SCENE_ELEMENT_FOCUSED, sceneElementFocusedHandler);
			eventDispatcher.addEventListener(GameMarchMonsterEvent.WAIT_AND_READ_TO_MARCH_NEXT_WAVE, waitAndReadyToMarchNExtWaveHandler);
			eventDispatcher.addEventListener(GameMarchMonsterEvent.MARCH_NEXT_WAVE, marchNextWaveHandler);
		}
		
		override public function dispose():void
		{	
			removeChildren();

			_currentFocusInfoView.dispose();
			//removeChild(_currentFocusInfoView);
			_currentFocusInfoView = null;

			_fightControllBarView.dispose();
			//removeChild(_fightControllBarView);
			_fightControllBarView = null;
			
			//_userInfoView.userImgLoader.removeEventListener(IOErrorEvent.IO_ERROR, userImgLoaderErrorHandler);
			//_userInfoView.userImgLoader.source = null;
			//removeChild(_userInfoView);
			_userInfoView = null;
			
			_effects = null;
			
			//removeChild(_fightPauseBtn.getSkin());
			_fightPauseBtn.removeActionEventListener();
			_fightPauseBtn = null;
			
			//removeChild(_fightSettingBtn.getSkin());
			_fightSettingBtn.removeActionEventListener();
			_fightSettingBtn = null;
			
			//removeChild(_marchMonstersFlagLayer);
			_marchMonstersFlagLayer.removeEventListener(MouseEvent.CLICK, marchMonstersFlagLayerMouseClickHandler);
			_marchMonstersFlagLayer = null;
			
			if(_marchMonstersFlagPool && _marchMonstersFlagPool.length>0)
			{
				for each(var flag:MarchMonsterFlag in _marchMonstersFlagPool)
				{
					flag.dispose();
				}
			}
			_marchMonstersFlagPool = null;
			
			//removeChild(_newMonsterIconsView);
			_newMonsterIconsView.dispose();
			_newMonsterIconsView = null;

			eventDispatcher.removeEventListener(GameDataInfoEvent.INITIALIZE_DATA_INFO, gameDataInfoUpdateHandler);
			eventDispatcher.removeEventListener(GameDataInfoEvent.UPDATE_SCENE_LIFE, gameDataInfoUpdateHandler);	
			eventDispatcher.removeEventListener(GameDataInfoEvent.UPDATE_SCENE_GOLD, gameDataInfoUpdateHandler);
			eventDispatcher.removeEventListener(GameDataInfoEvent.UPDATE_SCENE_WAVE, gameDataInfoUpdateHandler);
			eventDispatcher.removeEventListener(SceneElementFocusEvent.SCENE_ELEMENT_FOCUSED, sceneElementFocusedHandler);
			eventDispatcher.removeEventListener(GameMarchMonsterEvent.WAIT_AND_READ_TO_MARCH_NEXT_WAVE, waitAndReadyToMarchNExtWaveHandler);
			eventDispatcher.removeEventListener(GameMarchMonsterEvent.MARCH_NEXT_WAVE, marchNextWaveHandler);
			
			_marchMonsterShortCut = null;
			
			super.dispose();
		}
		
		//IGameLifecycleNotifyer
		public function onFightStart():void
		{
			_fightControllBarView.onFightStart();
						
			_userInfoView.endlessIcon.visible = EndlessBattleMgr.instance.isEndless;
			_userInfoView.waveIcon.visible = !EndlessBattleMgr.instance.isEndless;
			_userInfoView.drumsBuff.visible = false;
			_userInfoView.retrievedBuff.visible = false;
			
			if(EndlessBattleMgr.instance.isEndless)
			{
				/*if(!_battleDrumsBtn)
				{
					_battleDrumsBtn = new McButton;
					_battleDrumsBtn.setSkin(new BattleDrumsBtn as MovieClip);
					_battleDrumsBtn.getSkin().x = 27;
					_battleDrumsBtn.getSkin().y = 102;
					addChild(_battleDrumsBtn.getSkin());
					_battleDrumsBtn.addActionEventListener(onBattleDrumsClick);
				}
				_battleDrumsBtn.visible = true;
				_battleDrumsBtn.enabled = true;*/

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
				/*if(_battleDrumsBtn)
				{
					_battleDrumsBtn.visible = false;
				}*/
				_userInfoView.waveLabel.visible = true;
				_userInfoView.waveTextField.visible = true;
				_userInfoView.txtScore.visible = false;
			}
		}
		
		public function onFightPause():void
		{
			_fightControllBarView.onFightPause();
			
			_currentFocusInfoView.hide();	//游戏暂停的时候不会抛出焦事件，故手动隐藏掉
		}

		public function onFightResume():void
		{
			_fightControllBarView.onFightResume();
		}

		public function onFightEnd():void
		{
			this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			_newMonsterIconsView.clearAll();
			
			removeAllMarchMonsterFlags();
			_fightControllBarView.onFightEnd();
			_currentFocusInfoView.hide();
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
		
		private function fightPauseBtnClickHandler(/*event:MouseEvent*/):void
		{
			soundService.play(SoundID.ClickButton,SoundGroupType.Effect,1,true);
			eventDispatcher.dispatchEvent(new FightStateEvent(FightStateEvent.FightPause,true));
		}
		
		private function marchMonstersFlagLayerMouseClickHandler(event:MouseEvent):void
		{
			monsterMarchMgr.marchNextWave();
			var flag:MarchMonsterFlag = event.target as MarchMonsterFlag;
			/*if(flag && goods>0)
			{
				GameAGlobalManager.getInstance().gameFightInfoRecorder.taskOpData.marchMonsterCount++;
				playAddGoodsAnim(flag.x,flag.y+20,goods,this);
			}*/
			
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
			
			FontMgr.instance.setTextStyle( text, FontClsName.ButtonFont );
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
			soundService.play(SoundID.ClickButton,SoundGroupType.Effect,1,true);
			eventDispatcher.dispatchEvent(new FightInitStepsEvent(FightInitStepsEvent.FightGameOver,true));
			//eventDispatcher.dispatchEvent(new FightInitStepsEvent(FightInitStepsEvent.FightRestart));
		}
		
		private function gameDataInfoUpdateHandler(event:GameDataInfoEvent):void
		{
			//var gameDataInfoManager:GameFightDataInfoManager = GameAGlobalManager.getInstance().gameDataInfoManager;
			
			var sceneLifeText:String = sceneModel.sceneLife <= 0 ? "0" : sceneModel.sceneLife.toString();
			var sceneGoldText:String = sceneModel.sceneGoods <= 0 ? "0" : sceneModel.sceneGoods.toString();
			var sceneWaveText:String =  monsterWaveModel.curWaveCount.toString() + "/" + monsterWaveModel.curWaveCount.toString();
			var sceneScore:String = recorder.getCurrentSceneResultScore().toString();
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
							if(_userInfoView)
							{
								_userInfoView.txtScore.filters = null;
								_userInfoView.txtScore.txtScore.text = sceneScore;
							}
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
			var monsterVo:MonsterWaveVO = monsterWaveModel.getMonsterWave(monsterWaveModel.curWaveCount+1);
			if(monsterVo)
				showMarchMonsterFlag(monsterVo.waveMonsterSumInfos);
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
			
			var currentWave:int = monsterWaveModel.curWaveCount;
			if(currentWave == 1 ||(EndlessBattleMgr.instance.isEndless && EndlessBattleMgr.instance.recordWave+1 == currentWave))
			{
				globalTemp.useTime = 0;				//从出第一波怪开始进行游戏过关计时
				globalTemp.tempTime = timeMgr.virtualTime;

				_fightControllBarView.notifyAllIconsIsUseable();
			}
			
			/*if(DateUtil.isInDuration(GameSettingVar.collectTypeRewardDuration) && 1 == currentWave && !EndlessBattleMgr.instance.isEndless)
			{
				_iShowTreasureTick = setTimeout(showTreasureHunterTip,15000);
			}*/
		}
		
		/*private function showTreasureHunterTip():void
		{
			if(_iShowTreasureTick>0)
			{
				clearTimeout(_iShowTreasureTick);
				_iShowTreasureTick = 0;
			}
			_fightControllBarView.showTreasureHunterTip();
		}*/
		
		private function enterFrameHandler(event:Event):void
		{
			var n:uint = _marchMonstersFlagLayer.numChildren;
			for(var i:uint = 0; i < n; i++)
			{
				var marchMonsterFlag:MarchMonsterFlag = _marchMonstersFlagLayer.getChildAt(i) as MarchMonsterFlag;
				
				marchMonsterFlag.visible = !globalTemp.newGuideMockTollgateFlag || globalTemp.enableMonsterMarchFlag;
				
				marchMonsterFlag.setProgress(monsterMarchMgr.getWaitNextWaveProgress());
			}
		}
		
	}
}