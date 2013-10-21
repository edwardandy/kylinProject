package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.mouseCursorReleaseLogices
{
	import flash.events.MouseEvent;
	
	import mainModule.model.gameData.sheetData.skill.magic.IMagicSkillSheetItem;
	
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.identify.MagicID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.BasicMagicSkillEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.GoblinThunderMagicSkill;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.WenYiManYanMagicSkill;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.ZiRanZhiRuMagicSkill;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.model.interfaces.IFightViewLayersModel;
	import release.module.kylinFightModule.model.roads.MapRoadVO;
	import release.module.kylinFightModule.utili.structure.PointVO;

	public final class MagicMouseCursorReleaseLogic extends BasicMouseCursorReleaseLogic
	{
		[Inject]
		public var objPoolMgr:ObjectPoolManager;
		[Inject]
		public var fightViewModel:IFightViewLayersModel;
		
		override public function excute(mouseCursorReleaseValidateResult:Object, 
							   myCurrentValidMouseClickEvent:MouseEvent,
							   parameters:Object = null):void
		{
			var magicSkillTypeId:int = IMagicSkillSheetItem(parameters).configId;
			
			//GameAGlobalManager.getInstance().gameFightInfoRecorder.addBattleOPRecord( GameFightInfoRecorder.BATTLE_OP_TYPE_USE_SKILL, magicSkillTypeId );
			var parseId:int = magicSkillTypeId*0.01;
			switch(parseId)
			{
				case int(MagicID.NaturalAngry*0.01):
					excuteZiRanZhiRuMagicSkillMouseCursorReleaseLogic(mouseCursorReleaseValidateResult, 
						IMagicSkillSheetItem(parameters), myCurrentValidMouseClickEvent);
					break;
				
				case int(MagicID.PlagueSpread*0.01):
					excuteWenYiManYanMagicSkillMouseCursorReleaseLogic(mouseCursorReleaseValidateResult, 
						IMagicSkillSheetItem(parameters), myCurrentValidMouseClickEvent);
					break;
				case int(MagicID.GoblinThunder*0.01):
				case int(MagicID.GoblinThunder1*0.01):
				case int(MagicID.GoblinThunder2*0.01):
					excuteGoblinThunderMagicSkillMouseCursorReleaseLogic(mouseCursorReleaseValidateResult, 
						IMagicSkillSheetItem(parameters), myCurrentValidMouseClickEvent);
					break;
				
				default:
					excuteDefaultMagicSkillMouseCursorReleaseLogic(mouseCursorReleaseValidateResult, 
						IMagicSkillSheetItem(parameters), myCurrentValidMouseClickEvent);
					break;
			}
		}
		
		private function excuteZiRanZhiRuMagicSkillMouseCursorReleaseLogic(mouseCursorReleaseValidateResult:Object, 
																   magicSkillTemplateInfo:IMagicSkillSheetItem, 
																   myCurrentValidMouseClickEvent:MouseEvent):void
		{
			var results:Array = mouseCursorReleaseValidateResult as Array//[roadIndex, roadVO, roadPathStepIndex]
		
			var roadIndex:int = -1;
			var roadVO:MapRoadVO = null;
			var roadPathStepIndex:int = -1;
			
			var roadPathPointVOs:Vector.<PointVO> = null;
			
			var n:uint = results.length;
			for(var j:uint = 0; j < n; j++)
			{
				var ziRanZhiRuMagicSkill:ZiRanZhiRuMagicSkill = objPoolMgr
					.createSceneElementObject(GameObjectCategoryType.MAGIC_SKILL, magicSkillTemplateInfo.configId, false) as ZiRanZhiRuMagicSkill;
				
				roadIndex = results[j][0];
				roadVO = results[j][1];
				roadPathStepIndex = results[j][2];
				
				roadPathPointVOs = roadVO.lineVOs[1].points;
				var pt:PointVO = GameMathUtil.convertStagePtToGame(myCurrentValidMouseClickEvent.stageX, myCurrentValidMouseClickEvent.stageY,fightViewModel.groundLayer);
				ziRanZhiRuMagicSkill.x = pt.x;
				ziRanZhiRuMagicSkill.y = pt.y;
				ziRanZhiRuMagicSkill.startEscapeByPath(roadIndex, roadPathPointVOs, roadPathStepIndex);
				
				ziRanZhiRuMagicSkill.notifyLifecycleActive();
			}
		}
		
		private function excuteWenYiManYanMagicSkillMouseCursorReleaseLogic(mouseCursorReleaseValidateResult:Object, 
																		   magicSkillTemplateInfo:IMagicSkillSheetItem, 
																		   myCurrentValidMouseClickEvent:MouseEvent):void
		{
			var targetEnemy:BasicOrganismElement = BasicOrganismElement(mouseCursorReleaseValidateResult);
			
			var magicSkillEffect:WenYiManYanMagicSkill = objPoolMgr
				.createSceneElementObject(GameObjectCategoryType.MAGIC_SKILL, 
					magicSkillTemplateInfo.configId, false) as WenYiManYanMagicSkill;
			
			magicSkillEffect.setMonomerMagicTarget(targetEnemy);
			
			magicSkillEffect.notifyLifecycleActive();
		}
		
		private function excuteGoblinThunderMagicSkillMouseCursorReleaseLogic(mouseCursorReleaseValidateResult:Object, 
																		   magicSkillTemplateInfo:IMagicSkillSheetItem, 
																		   myCurrentValidMouseClickEvent:MouseEvent):void
		{
			var targetEnemy:BasicOrganismElement = BasicOrganismElement(mouseCursorReleaseValidateResult);
			
			var magicSkillEffect:GoblinThunderMagicSkill = objPoolMgr
				.createSceneElementObject(GameObjectCategoryType.MAGIC_SKILL, 
					magicSkillTemplateInfo.configId, false) as GoblinThunderMagicSkill;
			
			magicSkillEffect.setMonomerMagicTarget(targetEnemy);
			
			magicSkillEffect.notifyLifecycleActive();
		}
		
		private function excuteDefaultMagicSkillMouseCursorReleaseLogic(mouseCursorReleaseValidateResult:Object, 
																   magicSkillTemplateInfo:IMagicSkillSheetItem, 
																   myCurrentValidMouseClickEvent:MouseEvent):void
		{
			var magicSkillEffect:BasicMagicSkillEffect = objPoolMgr
				.createSceneElementObject(GameObjectCategoryType.MAGIC_SKILL, 
					magicSkillTemplateInfo.configId, false) as BasicMagicSkillEffect;
			if(null == magicSkillEffect)
				return;
			var pt:PointVO = GameMathUtil.convertStagePtToGame(myCurrentValidMouseClickEvent.stageX
				,myCurrentValidMouseClickEvent.stageY,fightViewModel.groundLayer);
			magicSkillEffect.x = pt.x;
			magicSkillEffect.y = pt.y;
			
			magicSkillEffect.notifyLifecycleActive();
		}
	}
}