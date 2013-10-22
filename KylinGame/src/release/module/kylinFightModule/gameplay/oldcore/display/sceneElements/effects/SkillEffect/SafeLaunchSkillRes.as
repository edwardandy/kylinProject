package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect
{
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	
	public class SafeLaunchSkillRes extends BasicSkillEffectRes
	{
		private var _skillFireFunc:Function;
		
		public function SafeLaunchSkillRes(typeId:int)
		{
			super(typeId);
			myObjectTypeId = typeId;
		}
		
		override protected function get bodySkinResourceURL():String
		{
			return GameObjectCategoryType.SPECIAL + "_" + myObjectTypeId;
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
			_skillFireFunc = null;
		}
		
		override protected function onSkillEffFireTimeHandler():void
		{
			if(_skillFireFunc != null)
				_skillFireFunc();
		}
		
		public function setSkillFireFunc(xPos:int,yPos:int,func:Function):void
		{
			this.x = xPos;
			this.y = yPos;	
			_skillFireFunc = func;
		}
		
	}
}