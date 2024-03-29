package com.openflux.layouts
{
	import com.openflux.animators.IAnimator;
	import com.openflux.containers.IFluxContainer;
	import com.openflux.core.IFluxList;
	import com.openflux.core.IFluxView;
	
	import flash.events.EventDispatcher;
	
	import mx.events.ListEvent;
	
	public class LayoutBase extends EventDispatcher
	{
		
		protected var container:IFluxContainer;
		protected var updateOnChange:Boolean = false;
		
		protected function get animator():IAnimator {
			if(container) return container.animator;
			return null;
		}
		
		public function attach(container:IFluxContainer):void {
			this.container = container;
			if (updateOnChange && (container as IFluxView).component is IFluxList)
				(container as IFluxView).component.addEventListener(ListEvent.CHANGE, onChange);
		}
		
		public function detach(container:IFluxContainer):void {
			this.container = null;
			if (updateOnChange && (container as IFluxView).component is IFluxList)
				(container as IFluxView).component.removeEventListener(ListEvent.CHANGE, onChange);
		}
		
		protected function onChange(event:ListEvent):void
		{
			container.invalidateDisplayList();
		}
		
		/*
		public function findIndexAt(children:Array, x:Number, y:Number):int {
			
			var closest:DisplayObject;
			var closestDistance:Number = Number.MAX_VALUE;
			
			// find the closest child
			var length:int = children.length;
			for each(var child:DisplayObject in children) {
				//var child:DisplayObject = children[i];
				var distanceX:Number = x - (child.x+child.width/2);
				var distanceY:Number = y - (child.y+child.height/2);
				var distance:Number = (Math.abs(distanceX) + Math.abs(distanceY))/2;
				//var distance:Point = new Point(Math.abs(child.mouseX)-child.width/2, Math.abs(child.mouseY)-child.height/2);
				if(distance < closestDistance) {
					closest = child;
					closestDistance = distance;
				}
			}
			
			// set the index based on the closest child
			var index:int = children.indexOf(closest);
			var push:Number = ((y - (closest.y+closest.height/2)) + (x - (closest.x+closest.width/2)))/2;
			if(push > 0) {
				index += 1;
			}
			return index;
			
		}
		*/
	}
}