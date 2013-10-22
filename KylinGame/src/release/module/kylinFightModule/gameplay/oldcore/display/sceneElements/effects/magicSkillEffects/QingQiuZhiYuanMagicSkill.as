package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects
{
	import release.module.kylinFightModule.gameplay.constant.GameFightConstant;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.SupportSoldier;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.utili.structure.PointVO;

	//请求支援
	public class QingQiuZhiYuanMagicSkill extends BasicMagicSkillEffect
	{
		public function QingQiuZhiYuanMagicSkill(typeId:int)
		{
			super(typeId);
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			var ptShare:PointVO = new PointVO(this.x,this.y);
			
			var arrParam:Array = (myEffectParameters.summon as String).split("-");
			var id:int = arrParam[0];
			var num:int = 1;
			if(arrParam.length>1)
				num = arrParam[1];
			//num = 7;
			for(var i:int=0;i<num;++i)
			{
				
				var soldier:SupportSoldier = objPoolMgr
					.createSceneElementObject(GameObjectCategoryType.SUPPORT_SOLDIER, id, false) as SupportSoldier;
				soldier.lifeDuration = this.myMagicSkillTemplateInfo.duration;
				soldier.visible = true;
				if(1 == num)
				{
					soldier.x = this.x;
					soldier.y = this.y;
				}
				else
				{
					var soldierMeetingPoint:PointVO = GameMathUtil.
						caculatePointOnCircle(this.x,this.y,GameFightConstant.MYBARRACK_SOLDIERS_DEGREE[i%3],15*(1+int(i/3)),true);
					soldier.x = soldierMeetingPoint.x;
					soldier.y = soldierMeetingPoint.y;
				}
				
				soldier.setShareSearchCenter(ptShare);
				soldier.notifyLifecycleActive();
			}
			
			destorySelf();
		}
	}
}