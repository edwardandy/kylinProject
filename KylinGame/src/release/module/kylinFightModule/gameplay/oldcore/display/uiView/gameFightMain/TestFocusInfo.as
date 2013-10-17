package release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain
{
	public class TestFocusInfo implements IFocusTargetInfo
	{
		private var _type:int = 0;
		
		private var _defenseType:Boolean = false;
		
		private var _attackType:Boolean = false;
		
		public function TestFocusInfo()
		{
			_type = int(Math.random() * 5);
			_attackType = Math.random() > 0.5;
			_defenseType = Math.random() > 0.5;
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function get targetName():String
		{
			return "Some" + int(Math.random() * 10);
		}
		
		public function get resourceID():int
		{
			return 113013;
		}
		
		public function get curLife():int
		{
			return int(Math.random() * 20);
		}
		
		public function get maxLife():int
		{
			return 20;
		}
		
		public function get minAttack():int
		{
			return 2;
		}
		
		public function get maxAttack():int
		{
			return 8;
		}
		
		public function get attackType():Boolean
		{
			return _attackType;
		}
		
		public function get defense():int
		{
			return 8;
		}
		
		public function get defenseType():Boolean
		{
			return _defenseType;
		}
		
		public function get hurt():int
		{
			return 1;
		}
		
		public function get attackArea():uint
		{
			return 20;
		}
		
		public function get attackGap():int
		{
			return 10;
		}
		
		public function get rebirthTime():int
		{
			return 8;
		}
	}
}