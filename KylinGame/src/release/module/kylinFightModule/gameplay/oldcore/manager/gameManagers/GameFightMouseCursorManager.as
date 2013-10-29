package release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers
{
	
	
	import flash.utils.Dictionary;
	
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.BarrackTowersMeetingPointMouseCursor;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.BasicMouseCursor;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.HeroMoveMouseCursor;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.IMouseCursorSponsor;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.MonomerMagicMouseCursor;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.RangeMagicMouseCursor;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.WizardTowersMeetingPointMouseCursor;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.mouse.MouseCursorManager;
	
	import robotlegs.bender.framework.api.IInjector;

	public final class GameFightMouseCursorManager extends BasicGameManager
	{
		public static const BARRACK_TOWERS_MEETING_POINT_MOUSE_CURSOR:String = "BarrackTowersMeetingPointMouseCursor";
		public static const WIZARD_TOWERS_MEETING_POINT_MOUSE_CURSOR:String = "WizardTowersMeetingPointMouseCursor";
		public static const MONOMER_MAGIC_MOUSE_CURSOR:String = "MonomerMagicMouseCursor";
		public static const RANGE_MAGIC_MOUSE_CURSOR:String = "RangeMagicMouseCursor";
		public static const HERO_MOVE_MOUSE_CURSOR:String = "HeroMoveMouseCursor";
		
		[Inject]
		public var mouseCursorMgr:MouseCursorManager;
		[Inject]
		public var injector:IInjector;
		
		private var _registedMouseCursorMap:Dictionary = new Dictionary;//name->BasicMouseCursor
		private var _currentMouseCursor:BasicMouseCursor;

		public function GameFightMouseCursorManager()
		{
			super();
		}
		
		override public function onFightStart():void
		{
			//兵营
			registMouseCursor(BARRACK_TOWERS_MEETING_POINT_MOUSE_CURSOR, injector.instantiateUnmapped(BarrackTowersMeetingPointMouseCursor));
			registMouseCursor(HERO_MOVE_MOUSE_CURSOR, injector.instantiateUnmapped(HeroMoveMouseCursor));
			registMouseCursor(WIZARD_TOWERS_MEETING_POINT_MOUSE_CURSOR, injector.instantiateUnmapped(WizardTowersMeetingPointMouseCursor));
			registMouseCursor(MONOMER_MAGIC_MOUSE_CURSOR, injector.instantiateUnmapped(MonomerMagicMouseCursor));
			registMouseCursor(RANGE_MAGIC_MOUSE_CURSOR, injector.instantiateUnmapped(RangeMagicMouseCursor));
		}
		
		override public function onFightEnd():void
		{
			deactiveCurrentMouseCursor();
			unRegistAllMouseCursors();
			_registedMouseCursorMap = new Dictionary;
		}
		
		override public function dispose():void
		{
			super.dispose();
			_registedMouseCursorMap = null; 
		}
		
		//API Regist
		private function registMouseCursor(mouseCursorName:String, mouseCursor:BasicMouseCursor):void
		{
			if(!hasRegistMouseCursor(mouseCursorName))
			{
				_registedMouseCursorMap[mouseCursorName] = mouseCursor;
			}
		}

		private function unRegistMouseCursor(mouseCursorName:String):void
		{
			if(hasRegistMouseCursor(mouseCursorName))
			{
				delete _registedMouseCursorMap[mouseCursorName];
			}
		}
		
		private function hasRegistMouseCursor(mouseCursorName:String):Boolean
		{
			return _registedMouseCursorMap[mouseCursorName] != undefined;
		}
		
		private function getRegistedMouseCursorByName(mouseCursorName:String):BasicMouseCursor
		{
			return _registedMouseCursorMap[mouseCursorName] as BasicMouseCursor;
		}
		
		private function unRegistAllMouseCursors():void
		{
			for each(var mouseCursor:BasicMouseCursor in _registedMouseCursorMap)
			{
				mouseCursor.dispose();
			}
		}
		
		public function activeMouseCursorByName(mouseCursorName:String, mouseCursorSponsor:IMouseCursorSponsor = null):void
		{
			deactiveCurrentMouseCursor();
			
			if(hasRegistMouseCursor(mouseCursorName))
			{
				_currentMouseCursor = getRegistedMouseCursorByName(mouseCursorName);
				mouseCursorMgr.setCurrentMouseCursor(_currentMouseCursor);
				
				_currentMouseCursor.setMouseCursorSponsor(mouseCursorSponsor);
				_currentMouseCursor.notifyIsActive(true);
			}
		}

		public function deactiveCurrentMouseCursor():void
		{
			if(_currentMouseCursor != null)
			{
				_currentMouseCursor.notifyIsActive(false);
				mouseCursorMgr.clearCurrentMouseCursor();
				_currentMouseCursor = null;
			}
		}
		
		public function deactiveTargetCurrentMouseCursor(targtMouseCursor:BasicMouseCursor):void
		{
			if(_currentMouseCursor == targtMouseCursor)
			{
				deactiveCurrentMouseCursor();
			}
		}
		
		public function getCurrentMouseCursor():BasicMouseCursor
		{
			return _currentMouseCursor;
		}
	}
}