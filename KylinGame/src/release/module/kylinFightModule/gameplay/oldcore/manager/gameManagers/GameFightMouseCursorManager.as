package release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers
{
	import com.shinezone.towerDefense.fight.constants.TowerDefenseGameState;
	import release.module.kylinFightModule.gameplay.oldcore.core.ISceneFocusElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.BarrackTowersMeetingPointMouseCursor;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.BasicMouseCursor;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.HeroMoveMouseCursor;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.IMouseCursorSponsor;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.MonomerMagicMouseCursor;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.RangeMagicMouseCursor;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.WizardTowersMeetingPointMouseCursor;
	
	import framecore.tools.mouse.MouseCursorManager;

	public final class GameFightMouseCursorManager extends BasicGameManager
	{
		public static const BARRACK_TOWERS_MEETING_POINT_MOUSE_CURSOR:String = "BarrackTowersMeetingPointMouseCursor";
		public static const WIZARD_TOWERS_MEETING_POINT_MOUSE_CURSOR:String = "WizardTowersMeetingPointMouseCursor";
		public static const MONOMER_MAGIC_MOUSE_CURSOR:String = "MonomerMagicMouseCursor";
		public static const RANGE_MAGIC_MOUSE_CURSOR:String = "RangeMagicMouseCursor";
		public static const HERO_MOVE_MOUSE_CURSOR:String = "HeroMoveMouseCursor";
		
		private var _registedMouseCursorMap:Array = [];//name->BasicMouseCursor
		private var _currentMouseCursor:BasicMouseCursor;

		public function GameFightMouseCursorManager()
		{
			super();
		}
		
		override public function onGameStart():void
		{
			//兵营
			registMouseCursor(BARRACK_TOWERS_MEETING_POINT_MOUSE_CURSOR, new BarrackTowersMeetingPointMouseCursor());
			registMouseCursor(HERO_MOVE_MOUSE_CURSOR, new HeroMoveMouseCursor());
			registMouseCursor(WIZARD_TOWERS_MEETING_POINT_MOUSE_CURSOR, new WizardTowersMeetingPointMouseCursor());
			registMouseCursor(MONOMER_MAGIC_MOUSE_CURSOR, new MonomerMagicMouseCursor());
			registMouseCursor(RANGE_MAGIC_MOUSE_CURSOR, new RangeMagicMouseCursor());
		}
		
		override public function onGameEnd():void
		{
			deactiveCurrentMouseCursor();
			unRegistAllMouseCursors();
		}
		
		//API Regist
		public function registMouseCursor(mouseCursorName:String, mouseCursor:BasicMouseCursor):void
		{
			if(!hasRegistMouseCursor(mouseCursorName))
			{
				_registedMouseCursorMap[mouseCursorName] = mouseCursor;
			}
		}

		public function unRegistMouseCursor(mouseCursorName:String):void
		{
			if(hasRegistMouseCursor(mouseCursorName))
			{
				delete _registedMouseCursorMap[mouseCursorName];
			}
		}
		
		public function hasRegistMouseCursor(mouseCursorName:String):Boolean
		{
			return _registedMouseCursorMap[mouseCursorName] != undefined;
		}
		
		public function getRegistedMouseCursorByName(mouseCursorName:String):BasicMouseCursor
		{
			return _registedMouseCursorMap[mouseCursorName] as BasicMouseCursor;
		}
		
		public function unRegistAllMouseCursors():void
		{
			for each(var mouseCursor:BasicMouseCursor in _registedMouseCursorMap)
			{
				mouseCursor.dispose();
			}
			
			_registedMouseCursorMap = []; 
		}
		
		public function activeMouseCursorByName(mouseCursorName:String, mouseCursorSponsor:IMouseCursorSponsor = null):void
		{
			deactiveCurrentMouseCursor();
			
			if(hasRegistMouseCursor(mouseCursorName))
			{
				_currentMouseCursor = getRegistedMouseCursorByName(mouseCursorName);
				MouseCursorManager.getInstance().setCurrentMouseCursor(_currentMouseCursor);
				
				_currentMouseCursor.setMouseCursorSponsor(mouseCursorSponsor);
				_currentMouseCursor.notifyIsActive(true);
			}
		}

		public function deactiveCurrentMouseCursor():void
		{
			if(_currentMouseCursor != null)
			{
				_currentMouseCursor.notifyIsActive(false);
				MouseCursorManager.getInstance().clearCurrentMouseCursor();
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