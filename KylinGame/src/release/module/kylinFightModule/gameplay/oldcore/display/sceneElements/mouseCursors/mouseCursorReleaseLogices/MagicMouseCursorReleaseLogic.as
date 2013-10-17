package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.mouseCursorReleaseLogices
{
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.identify.MagicID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.BasicMagicSkillEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.DaDiZhenchanMagicSkill;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.GoblinThunderMagicSkill;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.WenYiManYanMagicSkill;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.ZiRanZhiRuMagicSkill;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightInfoRecorder;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	import com.shinezone.towerDefense.fight.vo.map.RoadVO;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import framecore.structure.model.user.magicSkill.MagicSkillTemplateInfo;

	public final class MagicMouseCursorReleaseLogic extends BasicMouseCursorReleaseLogic
	{
		private static var _instance:MagicMouseCursorReleaseLogic;
		
		public static function getInstance():MagicMouseCursorReleaseLogic
		{
			return 	_instance ||= new MagicMouseCursorReleaseLogic();
		}
		
		override public function excute(mouseCursorReleaseValidateResult:Object, 
							   myCurrentValidMouseClickEvent:MouseEvent,
							   parameters:Object = null):void
		{
			var magicSkillTypeId:int = MagicSkillTemplateInfo(parameters).configId;
			
			GameAGlobalManager.getInstance().gameFightInfoRecorder.addBattleOPRecord( GameFightInfoRecorder.BATTLE_OP_TYPE_USE_SKILL, magicSkillTypeId );
			var parseId:int = magicSkillTypeId*0.01;
			switch(parseId)
			{
				case int(MagicID.NaturalAngry*0.01):
					excuteZiRanZhiRuMagicSkillMouseCursorReleaseLogic(mouseCursorReleaseValidateResult, 
						MagicSkillTemplateInfo(parameters), myCurrentValidMouseClickEvent);
					break;
				
				case int(MagicID.PlagueSpread*0.01):
					excuteWenYiManYanMagicSkillMouseCursorReleaseLogic(mouseCursorReleaseValidateResult, 
						MagicSkillTemplateInfo(parameters), myCurrentValidMouseClickEvent);
					break;
				case int(MagicID.GoblinThunder*0.01):
				case int(MagicID.GoblinThunder1*0.01):
				case int(MagicID.GoblinThunder2*0.01):
					excuteGoblinThunderMagicSkillMouseCursorReleaseLogic(mouseCursorReleaseValidateResult, 
						MagicSkillTemplateInfo(parameters), myCurrentValidMouseClickEvent);
					break;
				
				default:
					excuteDefaultMagicSkillMouseCursorReleaseLogic(mouseCursorReleaseValidateResult, 
						MagicSkillTemplateInfo(parameters), myCurrentValidMouseClickEvent);
					break;
			}
		}
		
		private function excuteZiRanZhiRuMagicSkillMouseCursorReleaseLogic(mouseCursorReleaseValidateResult:Object, 
																   magicSkillTemplateInfo:MagicSkillTemplateInfo, 
																   myCurrentValidMouseClickEvent:MouseEvent):void
		{
			var results:Array = mouseCursorReleaseValidateResult as Array//[roadIndex, roadVO, roadPathStepIndex]
		
			var roadIndex:int = -1;
			var roadVO:RoadVO = null;
			var roadPathStepIndex:int = -1;
			
			var roadPathPointVOs:Vector.<PointVO> = null;
			
			var n:uint = results.length;
			for(var j:uint = 0; j < n; j++)
			{
				var ziRanZhiRuMagicSkill:ZiRanZhiRuMagicSkill = ObjectPoolManager
					.getInstance().createSceneElementObject(GameObjectCategoryType.MAGIC_SKILL, magicSkillTemplateInfo.configId, false) as ZiRanZhiRuMagicSkill;
				
				roadIndex = results[j][0];
				roadVO = results[j][1];
				roadPathStepIndex = results[j][2];
				
				roadPathPointVOs = roadVO.lineVOs[1].points;
				var pt:PointVO = GameMathUtil.convertStagePtToGame(myCurrentValidMouseClickEvent.stageX, myCurrentValidMouseClickEvent.stageY,GameAGlobalManager.getInstance().game);
				ziRanZhiRuMagicSkill.x = pt.x;
				ziRanZhiRuMagicSkill.y = pt.y;
				ziRanZhiRuMagicSkill.startEscapeByPath(roadIndex, roadPathPointVOs, roadPathStepIndex);
				
				ziRanZhiRuMagicSkill.notifyLifecycleActive();
			}
		}
		
		private function excuteWenYiManYanMagicSkillMouseCursorReleaseLogic(mouseCursorReleaseValidateResult:Object, 
																		   magicSkillTemplateInfo:MagicSkillTemplateInfo, 
																		   myCurrentValidMouseClickEvent:MouseEvent):void
		{
			var targetEnemy:BasicOrganismElement = BasicOrganismElement(mouseCursorReleaseValidateResult);
			
			var magicSkillEffect:WenYiManYanMagicSkill = ObjectPoolManager.getInstance()
				.createSceneElementObject(GameObjectCategoryType.MAGIC_SKILL, 
					magicSkillTemplateInfo.configId, false) as WenYiManYanMagicSkill;
			
			magicSkillEffect.setMonomerMagicTarget(targetEnemy);
			
			magicSkillEffect.notifyLifecycleActive();
		}
		
		private function excuteGoblinThunderMagicSkillMouseCursorReleaseLogic(mouseCursorReleaseValidateResult:Object, 
																		   magicSkillTemplateInfo:MagicSkillTemplateInfo, 
																		   myCurrentValidMouseClickEvent:MouseEvent):void
		{
			var targetEnemy:BasicOrganismElement = BasicOrganismElement(mouseCursorReleaseValidateResult);
			
			var magicSkillEffect:GoblinThunderMagicSkill = ObjectPoolManager.getInstance()
				.createSceneElementObject(GameObjectCategoryType.MAGIC_SKILL, 
					magicSkillTemplateInfo.configId, false) as GoblinThunderMagicSkill;
			
			magicSkillEffect.setMonomerMagicTarget(targetEnemy);
			
			magicSkillEffect.notifyLifecycleActive();
		}
		
		private function excuteDefaultMagicSkillMouseCursorReleaseLogic(mouseCursorReleaseValidateResult:Object, 
																   magicSkillTemplateInfo:MagicSkillTemplateInfo, 
																   myCurrentValidMouseClickEvent:MouseEvent):void
		{
			var magicSkillEffect:BasicMagicSkillEffect = ObjectPoolManager.getInstance()
				.createSceneElementObject(GameObjectCategoryType.MAGIC_SKILL, 
					magicSkillTemplateInfo.configId, false) as BasicMagicSkillEffect;
			if(null == magicSkillEffect)
				return;
			var pt:PointVO = GameMathUtil.convertStagePtToGame(myCurrentValidMouseClickEvent.stageX
				,myCurrentValidMouseClickEvent.stageY,GameAGlobalManager.getInstance().game);
			magicSkillEffect.x = pt.x;
			magicSkillEffect.y = pt.y;
			
			magicSkillEffect.notifyLifecycleActive();
		}
	}
}