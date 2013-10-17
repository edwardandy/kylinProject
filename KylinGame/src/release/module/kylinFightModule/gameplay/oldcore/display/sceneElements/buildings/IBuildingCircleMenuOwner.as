package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings
{
	public interface IBuildingCircleMenuOwner
	{
		function notifyCircleMenuOnBuild(typeId:int):void;
		function notifyCircleMenuOnSell():void;
		function notifyCircleMenuMouseOver(builderId:uint,bOver:Boolean):void;
		function notifyCircleMenuOnSkillUp(skillId:uint,iLvl:int):void;
	}
}