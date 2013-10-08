package mainModule.service.soundServices
{
	import flash.media.SoundTransform;
	
	import treefortress.sound.SoundInstance;

	public interface ISoundService
	{
		/**
		 * Play audio by id and group. It can not be loaded. 
		 * @param id
		 * @param group
		 * @param loops Number of times to loop audio, pass -1 to loop forever.
		 * @param allowMultiple Allow multiple, overlapping instances of this Sound (useful for SoundFX)
		 * @param allowInterrupt If this sound is currently playing, interrupt it and start at the specified StartTime. Otherwise, just update the Volume.
		 * @param enableSeamlessLoops allow seamless sound loops. Note that this will exhibit a bug when attempting to pause/resume the looping sound.
		 * @param loadCmpCB function(SoundInstance)
		 * @param volume
		 * @param startTime Starting time in milliseconds
		 */
		function play(id:String, group:String, loops:int = 0, allowMultiple:Boolean = false , allowInterrupt:Boolean = true
							 ,enableSeamlessLoops:Boolean = false, loadCmpCB:Function=null,volume:Number = 1, startTime:Number = 0):void;
		/**
		 * Stop all sounds immediately.
		 */
		function stopAll(group:String = ""):void;
		/**
		 * Resume specific sound 
		 */
		function resume(id:String):SoundInstance;
		/**
		 * Resume all paused instances.
		 */
		function resumeAll(group:String = ""):void;
		/** 
		 * Pause a specific sound 
		 **/
		function pause(id:String):SoundInstance;
		/**
		 * Pause all sounds
		 */
		function pauseAll(group:String = ""):void;
		/** 
		 * Fade specific sound starting at the current volume
		 **/
		function fadeTo(type:String, endVolume:Number = 1, duration:Number = 1000, stopAtZero:Boolean = true):SoundInstance;
		/**
		 * Fade all sounds starting from their current Volume
		 * @param group if empty,fade all
		 */
		function fadeAllTo(group:String = "", endVolume:Number = 1, duration:Number = 1000, stopAtZero:Boolean = true):void;
		/** 
		 * Fade specific sound specifying both the StartVolume and EndVolume.
		 **/
		function fadeFrom(type:String, startVolume:Number = 0, endVolume:Number = 1, duration:Number = 1000, stopAtZero:Boolean = true):SoundInstance;
		/**
		 * Fade all sounds specifying both the StartVolume and EndVolume.
		 */
		function fadeAllFrom(group:String = "",startVolume:Number = 0, endVolume:Number = 1, duration:Number = 1000, stopAtZero:Boolean = true):void;
		/** 
		 * Fade master volume starting at the current value
		 **/
		function fadeMasterTo(endVolume:Number = 1, duration:Number = 1000, stopAtZero:Boolean = true):void;
		/** 
		 * Fade master volume specifying both the StartVolume and EndVolume.
		 **/
		function fadeMasterFrom(startVolume:Number = 0, endVolume:Number = 1, duration:Number = 1000, stopAtZero:Boolean = true):void;
		/**
		 * Mute all instances.
		 */
		function getMute(group:String):Boolean;
		function setMute(value:Boolean,group:String=""):void;
		/**
		 * Set volume on all instances
		 */
		function getVolume(group:String=""):Number;
		function setVolume(value:Number,group:String=""):void;
		/**
		 * Set pan on all instances
		 */
		function getPan(group:String=""):Number;
		function setPan(value:Number,group:String=""):void;
		/**
		 * Set master volume, which will me multiplied on top of all existing volume levels.
		 */
		function get masterVolume():Number;
		function set masterVolume(value:Number):void;
		/**
		 * Set soundTransform on all instances. 
		 */
		function setSoundTransform(value:SoundTransform,group:String=""):void;
		/**
		 * Remove a sound from memory.
		 */
		function removeSound(id:String):void;
		/**
		 * Unload all Sound instances.
		 */
		function removeAll():void;
	}
}