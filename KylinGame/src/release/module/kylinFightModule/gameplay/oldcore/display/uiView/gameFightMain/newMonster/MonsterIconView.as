package release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.newMonster
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.getDefinitionByName;
	
	import mainModule.service.loadServices.IconConst;
	import mainModule.service.loadServices.interfaces.IIconService;
	
	import release.module.kylinFightModule.gameplay.oldcore.core.BasicView;
	
	/**
	 * 新怪图标 
	 * @author Jiao Zhongxiao
	 * 
	 */	
	public class MonsterIconView extends BasicView
	{
		[Inject]
		public var iconService:IIconService;
		
		public function MonsterIconView()
		{
			super();
		}
		
		override public function dispose():void
		{
			removeChild( _bg );
			_bg.bitmapData = null;
			_bg = null;
			
			removeChild( _effect );
			_effect.stop();
			_effect = null;
			
			removeChild( _fg );
			_fg.bitmapData = null;
			_fg = null;
			
			removeChild( _icon );
			while ( _icon.numChildren > 0 )
			{
				_icon.removeChildAt( 0 );
			}
			_icon = null;
		}
		
		/**
		 * 设置图标的位图 
		 * @param value
		 * 
		 */		
		public function set icon( value:BitmapData ):void
		{
			throw new Error( "Enabled at 20130130 by Jiao Zhongxiao!" );
		}
		
		/**
		 * 设置怪物ID 
		 * @param value
		 * 
		 */		
		public function set monID( value:int ):void
		{
			if ( _monID == value )
			{
				return;
			}
			
			_monID = value;
			iconService.loadIcon(_icon, IconConst.ICON_TYPE_MONSTER_2, _monID, IconConst.ICON_SIZE_NEW );
		}
		public function get monID():int
		{
			return _monID;
		}
		
		//-----------------------------------------------------
		//私有函数
		//-----------------------------------------------------
		
		override protected function onAddToStage():void
		{
			_effect.gotoAndPlay( 1 );
		}
		
		override protected function onRemoveFromStage():void
		{
			_effect.stop();
		}
		
		override protected function onInitialize():void
		{
			_bg = new _iconBg() as Bitmap;
			_bg.x = -37;
			_bg.y = -40;
			addChild( _bg );
			
			
			_effect = new (getDefinitionByName("NewMonsterEffect") as Class);
			_effect.x = -3.4;
			_effect.y = 7.8;
			addChild( _effect );
			_effect.mouseChildren = _effect.mouseEnabled = false;
			_effect.stop();
			
			_icon = new Sprite();
			addChild( _icon );
			
			_fg = new _iconFg()  as Bitmap;
			_fg.x = -37;
			_fg.y = -40;
			addChild( _fg );
			
			this.mouseChildren = false;
			this.buttonMode = true;
		}
		
		//-----------------------------------------------------
		//私有变量
		//-----------------------------------------------------
		
		private var _bg:Bitmap = null;
		
		private var _fg:Bitmap = null;
		
		private var _icon:Sprite = null;
		
		private var _effect:MovieClip = null;
		
		private var _monID:int = -1;
		
		[Embed(source="Fight_bg.png")]
		private var _iconBg:Class;
		
		[Embed(source="Fight_fg.png")]
		private var _iconFg:Class;
	}
}