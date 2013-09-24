package release.module.kylinFightModule.model
{
	
	import release.module.kylinFightModule.model.interfaces.IFightViewLayersModel;
	import release.module.kylinFightModule.model.interfaces.IMapRoadModel;
	import release.module.kylinFightModule.model.interfaces.IMonsterWaveModel;
	import release.module.kylinFightModule.model.interfaces.ISceneDataModel;
	import release.module.kylinFightModule.model.marchWave.MonsterWaveModel;
	import release.module.kylinFightModule.model.roads.MapRoadModel;
	import release.module.kylinFightModule.model.scene.SceneDataModel;
	import release.module.kylinFightModule.model.viewLayers.FightViewLayersModel;
	
	import robotlegs.bender.framework.api.IInjector;

	public final class FightModuleModelsStartUp
	{
		public function FightModuleModelsStartUp(injector:IInjector)
		{
			injector.mapSingletonOf(IMonsterWaveModel,MonsterWaveModel);
			injector.mapSingletonOf(IFightViewLayersModel,FightViewLayersModel);
			injector.mapSingletonOf(IMapRoadModel,MapRoadModel);
			injector.mapSingletonOf(ISceneDataModel,SceneDataModel);
		}
	}
}