/*******************************************************************************
 * Smash Engine
 * Copyright (C) 2009 Smash Labs, LLC
 * For more information see http://www.Smashengine.com
 * 
 * This file is licensed under the terms of the MIT license, which is included
 * in the License.html file at the root directory of this SDK.
 ******************************************************************************/
package io.smash.time
{
    
    import io.smash.core.SmashComponent;
    
    /**
     * Base class for components that need to perform actions every tick. This
     * needs to be subclassed to be useful.
     */
    public class TickedComponent extends SmashComponent implements ITicked
    {
        /**
         * The update priority for this component. Higher numbered priorities have
         * onInterpolateTick and onTick called before lower priorities.
         */
        public var updatePriority:Number = 0.0;
        
        private var _registerForUpdates:Boolean = true;
        private var _isRegisteredForUpdates:Boolean = false;
        
        [SmashInject]
        public var timeManager:TimeManager;
        
        /**
         * Set to register/unregister for tick updates.
         */
        public function set registerForTicks(value:Boolean):void
        {
            _registerForUpdates = value;
            
            if(_registerForUpdates && !_isRegisteredForUpdates)
            {
                // Need to register.
                _isRegisteredForUpdates = true;
                timeManager.addTickedObject(this, updatePriority);                
            }
            else if(!_registerForUpdates && _isRegisteredForUpdates)
            {
                // Need to unregister.
                _isRegisteredForUpdates = false;
                timeManager.removeTickedObject(this);
            }
        }
        
        /**
         * @private
         */
        public function get registerForTicks():Boolean
        {
            return _registerForUpdates;
        }
        
        /**
         * @inheritDoc
         */
        public function onTick(iElapse:int):void
        {
            applyBindings();
        }
        
        override protected function onAdd():void
        {
            super.onAdd();
            
            // This causes the component to be registerd if it isn't already.
            registerForTicks = registerForTicks;
        }
        
        override protected function onRemove():void
        {
            super.onRemove();
            
            // Make sure we are unregistered.
            registerForTicks = false;
        }
    }
}