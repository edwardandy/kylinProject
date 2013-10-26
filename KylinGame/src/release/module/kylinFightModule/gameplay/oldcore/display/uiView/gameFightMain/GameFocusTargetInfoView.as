package release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain
{
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	import flash.text.TextField;
	
	import avmplus.getQualifiedClassName;
	
	import kylin.echo.edward.utilities.font.FontMgr;
	
	import mainModule.service.loadServices.IconConst;
	import mainModule.service.loadServices.interfaces.IIconService;
	
	import release.module.kylinFightModule.gameplay.constant.FocusTargetType;
	import release.module.kylinFightModule.gameplay.constant.GameFightConstant;
	import release.module.kylinFightModule.gameplay.oldcore.core.BasicView;
	import release.module.kylinFightModule.gameplay.oldcore.core.ISceneFocusElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.HeroElement;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.TimeTaskManager;
	import release.module.kylinFightModule.model.state.FightState;
	
	import utili.font.FontClsName;

	public class GameFocusTargetInfoView extends BasicView
	{
		private static const AUTO_HIDE_TIME:uint = 5000;
		
		[Inject]
		public var fightState:FightState;
		[Inject]
		public var timeTaskMgr:TimeTaskManager;
		[Inject]
		public var iconService:IIconService;
		
		private var _isShowed:Boolean = false;
		
		private var _curTargetInfo:IFocusTargetInfo = null;	//当前对象的数据
		
		private var _background:GameFocusTargetInfoBGView;
		
		private const TEXT_MARGIN:int = 5;
		
		public function GameFocusTargetInfoView()
		{
			super();
			
			this.mouseEnabled = false;
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			_background = new GameFocusTargetInfoBGView();
			_background.mouseEnabled = false;
			_background.mouseChildren = false;
			addChild(_background);
			FontMgr.instance.setTextStyle(_background["nameLabel"],FontClsName.NormalFont);
			for ( var i:int=0; i<7; i++ )
			{
				FontMgr.instance.setTextStyle( _background["label" + i], FontClsName.NormalFont );
				_background["label" + i].width = 100;
				_background["label" + i].mouseEnabled = false;
			}
						
			this.alpha = 0;
			this.mouseChildren = false;
		}
		
		public function show(element:ISceneFocusElement):void
		{
			_curTargetInfo = element as IFocusTargetInfo;
			
			if ( _curTargetInfo )
			{
				refreshIcons();
				refreshData( null );
				
				if(!_isShowed)
				{
					this.x = GameFightConstant.SCENE_MAP_WIDTH;
					this.alpha = 1;

					_isShowed = true;
					this.mouseChildren = false;
					TweenLite.to(this, 0.4,
						{
							x:(GameFightConstant.SCENE_MAP_WIDTH - this.width),
							onComplete:onTweenAnimationEndHandler
						});
				}
			}
		}
		
		/**
		 * 动态更新数据 
		 * @param e
		 * 
		 */		
		private function refreshData( e:Event ):void
		{
			if ( FightState.PauseFight == fightState.state )
				return;
			
			var i:int = 0;
			for ( i=0; i<7; i++ )
			{
				_background["label" + i].width = 100;
			}
			
			switch ( _curTargetInfo.type )
			{
				case FocusTargetType.DEFENSE_TOWER_TYPE:
				{
					_background["label0"].text = _curTargetInfo.maxLife + "";
					_background["label1"].text = _curTargetInfo.minAttack + "-" + _curTargetInfo.maxAttack;
					_background["label2"].text = _curTargetInfo.defense >= 81 ? "Beefy"
						: _curTargetInfo.defense >= 51 ? "Heavy"
						: _curTargetInfo.defense >= 21 ? "Medium"
						: _curTargetInfo.defense >= 1 ? "Light" : "No Armor";
					_background["label3"].text = Math.ceil(_curTargetInfo.rebirthTime * 0.001) + "";
					break;
				}
				case FocusTargetType.ATTACK_TOWER_TYPE:
				{
					_background["label4"].text = _curTargetInfo.minAttack + "-" + _curTargetInfo.maxAttack;
					_background["label5"].text = _curTargetInfo.attackGap >= 2001 ? "Very Slow"
						: _curTargetInfo.attackGap >= 1501 ? "Slow"
						: _curTargetInfo.attackGap >= 801 ? "Average"
						: _curTargetInfo.attackGap >= 501 ? "Fast" : "Very Fast";
					_background["label6"].text = _curTargetInfo.attackArea + "";
					break;
				}
				case FocusTargetType.MONSTER_TYPE:
				{
					_background["label0"].text = _curTargetInfo.curLife + "/" + _curTargetInfo.maxLife;
					_background["label1"].text = _curTargetInfo.minAttack + "-" + _curTargetInfo.maxAttack;
					_background["label2"].text = _curTargetInfo.defense >= 81 ? "Beefy"
						: _curTargetInfo.defense >= 51 ? "Heavy"
						: _curTargetInfo.defense >= 21 ? "Medium"
						: _curTargetInfo.defense >= 1 ? "Light" : "No Armor";
					_background["label3"].text = _curTargetInfo.hurt + "";
					break;
				}
				case FocusTargetType.HERO_TYPE:
				{
					_background["label0"].text = Math.ceil(HeroElement(_curTargetInfo).rebirthCd.getCDCoolDownLeftTime() * 0.001) + "";
					break;
				}
				case FocusTargetType.SOLDIER_TYPE:
				{
					_background["label0"].text = _curTargetInfo.curLife + "/" + _curTargetInfo.maxLife;
					_background["label1"].text = _curTargetInfo.minAttack + "-" + _curTargetInfo.maxAttack;
					_background["label2"].text = _curTargetInfo.defense >= 81 ? "Beefy"
						: _curTargetInfo.defense >= 51 ? "Heavy"
						: _curTargetInfo.defense >= 21 ? "Medium"
						: _curTargetInfo.defense >= 1 ? "Light" : "No Armor";
					_background["label3"].text = Math.ceil(_curTargetInfo.rebirthTime * 0.001) + "";
					break;
				}
				default:
				{
					return;
				}
			}
			for ( i=0; i<7; i++ )
			{
				_background["label" + i].width = TextField(_background["label" + i]).textWidth + TEXT_MARGIN;
			}
			repositionUI();
			
			if ( e )
			{
				this.x = GameFightConstant.SCENE_MAP_WIDTH - this.width;
			}
		}
		
		/**
		 * 动态调整UI元素位置 
		 * 
		 */		
		private function repositionUI():void
		{
			var iconWidth:int = _background["lifeIcon"].width;
			var posx:int = _background["lifeIcon"].x + iconWidth;
			_background["label4"].x = _background["label0"].x = posx;
			
			if ( _curTargetInfo.type == FocusTargetType.ATTACK_TOWER_TYPE )
			{
				posx += _background["label4"].width;
				_background["jianGeIcon"].x = posx;
				posx += iconWidth;
				_background["label5"].x = posx;
				posx += _background["label5"].width;
				_background["areaIcon"].x = posx;
				posx += iconWidth;
				_background["label6"].x = posx;
				posx += _background["label6"].width;
			}
			else if ( _curTargetInfo.type == FocusTargetType.HERO_TYPE )
			{
				posx += _background["label0"].width;
			}
			else
			{
				posx += _background["label0"].width;
				_background["wuGongIcon"].x = _background["moGongIcon"].x = posx;
				posx += iconWidth;
				_background["label1"].x = posx;
				posx += _background["label1"].width;
				_background["wuFangIcon"].x = _background["moFangIcon"].x = posx;
				posx += iconWidth;
				_background["label2"].x = posx;
				posx += _background["label2"].width;
				_background["hurtIcon"].x = _background["rebirthIcon"].x = posx;
				posx += iconWidth;
				_background["label3"].x = posx;
				posx += _background["label3"].width;
			}
			
			_background["midBg"].width = posx - _background["lifeIcon"].x;
			_background["leftBg"].x = _background["midBg"].x + _background["midBg"].width;
		}
		
		/**
		 * 刷新图标显示 
		 * 
		 */		
		private function refreshIcons():void
		{
			while ( _background.iconContainer.numChildren > 0 )
			{
				_background.iconContainer.removeChildAt( 0 );
			}
			
			_background["lifeIcon"].x = _background["wuGongIcon"].x = _background["moGongIcon"].x = 0;
			_background["wuFangIcon"].x = _background["moFangIcon"].x = _background["hurtIcon"].x = 0;
			_background["rebirthIcon"].x = _background["areaIcon"].x = _background["jianGeIcon"].x = 0;
			
			var type:String = _curTargetInfo.type == FocusTargetType.HERO_TYPE ? IconConst.ICON_TYPE_HERO
				: _curTargetInfo.type == FocusTargetType.SOLDIER_TYPE ? IconConst.ICON_TYPE_SOLDIER
				: _curTargetInfo.type == FocusTargetType.MONSTER_TYPE ? IconConst.ICON_TYPE_MONSTER_2 : IconConst.ICON_TYPE_RESEARCH;
			
			iconService.loadIcon(_background.iconContainer,type,_curTargetInfo.resourceID, IconConst.ICON_SIZE_50 );
			
			_background["nameLabel"].width = 100;
			_background["nameLabel"].text = _curTargetInfo.targetName;
			_background["nameLabel"].width = _background["nameLabel"].textWidth + TEXT_MARGIN;
			_background["nameMidBg"].width = _background["nameLabel"].width;
			_background["nameLeftBg"].x = _background["nameMidBg"].x + _background["nameLabel"].width;
			var posx:Number = _background["nameLeftBg"].x + _background["nameLeftBg"].width;
			_background["rebirthIcon"].x = _background["midBg"].x = _background["lifeIcon"].x = _background["wuGongIcon"].x = _background["moGongIcon"].x = posx;
			_background["lifeIcon"].visible = _curTargetInfo.type != FocusTargetType.ATTACK_TOWER_TYPE 
				&& _curTargetInfo.type != FocusTargetType.HERO_TYPE;
			
			_background["wuGongIcon"].visible = _curTargetInfo.type != FocusTargetType.HERO_TYPE && !_curTargetInfo.attackType;
			_background["moGongIcon"].visible = _curTargetInfo.type != FocusTargetType.HERO_TYPE && _curTargetInfo.attackType;
			
			_background["moFangIcon"].visible = _curTargetInfo.type != FocusTargetType.HERO_TYPE
				&& _curTargetInfo.type != FocusTargetType.ATTACK_TOWER_TYPE
				&& _curTargetInfo.defenseType;
			_background["wuFangIcon"].visible = _curTargetInfo.type != FocusTargetType.HERO_TYPE
				&& _curTargetInfo.type != FocusTargetType.ATTACK_TOWER_TYPE
				&& !_curTargetInfo.defenseType;
			
			_background["hurtIcon"].visible = _curTargetInfo.type == FocusTargetType.MONSTER_TYPE;
			
			_background["rebirthIcon"].visible = !(_curTargetInfo.type == FocusTargetType.ATTACK_TOWER_TYPE || _curTargetInfo.type == FocusTargetType.MONSTER_TYPE);
			
			_background["areaIcon"].visible = _curTargetInfo.type == FocusTargetType.ATTACK_TOWER_TYPE;
			
			_background["jianGeIcon"].visible = _curTargetInfo.type == FocusTargetType.ATTACK_TOWER_TYPE;
			
			for ( var i:int=0; i<7; i++ )
			{
				_background["label" + i].text = "";
				_background["label" + i].x = 0;
			}
		}
		
		public function hide():void
		{
			if(_isShowed)
			{
				_background.removeEventListener( Event.ENTER_FRAME, refreshData );
				_isShowed = false;
				this.mouseChildren = false;
				TweenLite.to( this, 0.4,
					{
						x:GameFightConstant.SCENE_MAP_WIDTH,
						onComplete:onTweenReverseAniamtionEndHandler
					}
				);
			}
		}
		
		public function setFocusedTarget(target:ISceneFocusElement):void
		{
			if(target == null) return;
			_background.textField.text = getQualifiedClassName(target);
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
		
		private function onTweenAnimationEndHandler():void
		{
			this.mouseChildren = true;
			
			_background.addEventListener( Event.ENTER_FRAME, refreshData );

			//这里需要记录一个关闭计时
			//20130107不再自动隐藏焦中肖
//			_autoHideTimeHandler = TimeTaskManager.getInstance().createTimeTask(AUTO_HIDE_TIME, onAutoHideTimerEndHandler, null, 1);
		}
		
		private function onAutoHideTimerEndHandler():void
		{
//			hide();
		}
		
		private function onTweenReverseAniamtionEndHandler():void
		{
			this.mouseChildren = false;
		}
	}
}