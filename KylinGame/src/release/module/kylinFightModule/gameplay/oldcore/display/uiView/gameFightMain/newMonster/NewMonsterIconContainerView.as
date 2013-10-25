package release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.newMonster
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import release.module.kylinFightModule.gameplay.oldcore.core.BasicView;
	
	/**
	 * 新怪头像容器 
	 * @author Jiao Zhongxiao
	 * 
	 */	
	public class NewMonsterIconContainerView extends BasicView
	{
		public function NewMonsterIconContainerView()
		{
			super();
		}
				
		override public function dispose():void
		{
			_monsters = null;
			
			var i:int = _icons.length - 1;
			while ( i > -1 )
			{
				if ( _icons[i].parent )
				{
					removeChild( _icons[i] );
				}
				
				_icons[i].dispose();
				_icons[i] = null;
				i--;
			}
			_icons = null;
			
			_monsters = null;
			
			this.removeEventListener( MouseEvent.CLICK, onMouseClickHandler );
		}
		
		/**
		 * 清理全部怪物ICON 
		 * （直接清除显示列表和数据，没有动画，用于每一波显示前的清理）
		 * 
		 */		
		public function clearAll():void
		{
			while ( this.numChildren > 0 )
			{
				removeChildAt( 0 );
			}
			
			_monsters = new Vector.<int>();
		}
				
		/**
		 * 添加新的怪 
		 * @param monID
		 * 
		 */		
		public function pushMonster( monID:int ):void
		{
			if ( _monsters.length > 3 )		//暂时最多只显示4个
			{
				_monsters.shift();
			}
			_monsters.push( monID );
		}
		
		/**
		 * 带动画的清理全部 
		 * 
		 */		
		public function hideAll():void
		{
			/*var i:int = this.numChildren - 1;
			
			while ( i > -1 )
			{
				var icon:DisplayObject = this.getChildAt( i );
				TweenLite.to( icon, 0.2, { scaleX:0, scaleY:0, onComplete:refreshView } );
				i--;
			}*/
		}
		
		/**
		 * 更新视图 
		 * 
		 */		
		public function show():void
		{
			var len:int = _monsters.length - 1;
			var i:int = 0;
			
			for ( i=0; i<=len; i++ )
			{
				if ( i >= _icons.length )
				{
					_icons.push( new MonsterIconView() );
					_icons[i].x = 30;
					_icons[i].y = 40 + i * 80;
				}
				
				addChild( _icons[i] );
				_icons[i].scaleX = _icons[i].scaleY = 1;
				
				TweenLite.killTweensOf( _icons[i] );
				TweenLite.from( _icons[i], 0.3, { scaleX:0.1, scaleY:0.1, ease:Back.easeOut } );
				
				_icons[i].monID = _monsters[len - i];
			}
		}
		
		//-----------------------------------------------------
		//私有函数
		//-----------------------------------------------------
		
		override protected function onInitialize():void
		{
			_icons = new Vector.<MonsterIconView>();
			_monsters = new Vector.<int>();
			this.mouseEnabled = false;
			this.addEventListener( MouseEvent.CLICK, onMouseClickHandler );
		}
		
		/**
		 * 重新布局 
		 * 
		 */		
		private function refreshView():void
		{
			while ( this.numChildren > 0 )
			{
				removeChildAt( 0 );
			}
			
			var len:int = _monsters.length - 1;
			var i:int = 0;
			
			for ( i=0; i<=len; i++ )
			{
				if ( i >= _icons.length )
				{
					_icons.push( new MonsterIconView() );
					_icons[i].x = 30;
					_icons[i].y = 40 + i * 80;
				}
				
				addChild( _icons[i] );
				_icons[i].scaleX = _icons[i].scaleY = 1;
				
				_icons[i].monID = _monsters[len - i];
			}
		}
		
		/**
		 * 点击按钮 
		 * @param e
		 * 
		 */		
		private function onMouseClickHandler( e:Event ):void
		{
			var icon:MonsterIconView = e.target as MonsterIconView;
			
			if ( icon )
			{
				var i:int = _monsters.indexOf( icon.monID );
				if ( i != -1 )
				{
					_monsters.splice( i, 1 );
//					show();
					TweenLite.to( icon, 0.2, { scaleX:0, scaleY:0, onComplete:refreshView } );
				}
				
				PanelData.panelInteraction( "towerDefenseFight", "setGamePauseStatus", true );
//				GameAGlobalManager.getInstance().gamePopupManager.open2CloseGamePauseView(true);
//				GameAGlobalManager.getInstance().gameDataInfoManager.gameFightId
				GameEvent.getInstance().sendEvent(Battle_CMD_Const.CMD_MONSTER_DEBUT, [HttpConst.HTTP_REQUEST, icon.monID, GameAGlobalManager.getInstance().gameDataInfoManager.gameFightId]);
				GameEvent.getInstance().sendEvent(CMD_NewMonster_Const.CMD_SHOW_NEW_MONSTER , [icon.monID]);
			}
		}
		
		//-----------------------------------------------------
		//私有变量
		//-----------------------------------------------------
		
		/**
		 * 缓存图标实例，重复使用 
		 */		
		private var _icons:Vector.<MonsterIconView> = null;
		
		private var _monsters:Vector.<int> = null;
	}
}