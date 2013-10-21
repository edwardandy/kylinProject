package release.module.kylinFightModule.gameplay.oldcore.logic.move
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.BasicHashMapMgr;
	import release.module.kylinFightModule.gameplay.oldcore.logic.move.Interface.IMoveLogic;
	
	public class GameFightMoveLogicMgr extends BasicHashMapMgr
	{
		private var _defaultMoveLogic:IMoveLogic;
		
		public function GameFightMoveLogicMgr()
		{
			super();
		}
		
		public function getMoveLogicByCategoryAndId(iCategory:String,id:uint):IMoveLogic
		{
			return getDefaultMoveLogic();
		}
		
		private function getDefaultMoveLogic():IMoveLogic
		{
			return _defaultMoveLogic ||= (new BasicMoveLogic as IMoveLogic);
		}
		
		override public function dispose():void
		{
			super.dispose();
			_defaultMoveLogic = null;
		}
	}
}