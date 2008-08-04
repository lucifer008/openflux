package com.plexiglass.animators
{
	import away3d.primitives.Plane;
	
	import caurina.transitions.Tweener;
	
	import com.openflux.animators.AnimationToken;
	import com.openflux.animators.IAnimator;
	import com.openflux.containers.IFluxContainer;
	import com.plexiglass.containers.IPlexiContainer;
	import com.plexiglass.animators.PlexiAnimationToken;
	
	import flash.display.DisplayObject;
	
	import mx.core.UIComponent;
	import mx.utils.ObjectUtil;

	public class PlexiAnimator implements IAnimator
	{
		static public const TRANSITION_LINEAR:String = "linear";
		static public const EASE_OUT_EXPO:String = "easeOutExpo";
		static public const EASE_OUT_BOUNCE:String = "easeOutBounce";
		
		private var container:IFluxContainer;
		
		/**
		 * The duration of time used to animate a component.
		 */
		[StyleBinding] public var time:Number = 1;
		
		/**
		 * The transition path on which to animate a component.
		 */
		[StyleBinding] public var transition:String = EASE_OUT_EXPO;
		
		public function PlexiAnimator()
		{
			super();
		}
		
		public function attach(container:IFluxContainer):void {
			this.container = container;
		}
		
		public function detach(layout:IFluxContainer):void {
			this.container = null;
		}
		
		public function begin():void {} // unused
		public function end():void {} // unused
		
		public function moveItem(item:DisplayObject, token:AnimationToken):void {
			if(container is IPlexiContainer) {
				var pv:IPlexiContainer = container as IPlexiContainer;
				
				if (!(token is PlexiAnimationToken)) {
					token.x = token.x - container.width / 2 + item.width / 2;
					token.y = (token.y - container.height / 2 + item.height / 2) * -1;
				}
				
				var plane:Plane = pv.getChildPlane(item as UIComponent);
				Tweener.addTween(plane, createTweenParameters3d(token, time));
			} else {
				var parameters:Object = createTweenParameters(token, 1);
				Tweener.addTween(item, token);
			}
		}
		
		public function addItem(item:DisplayObject):void {};
		public function removeItem(item:DisplayObject, callback:Function):void {
			callback(item);
		}
		
		public function adjustItem(item:DisplayObject, token:AnimationToken):void {
			if(container is IPlexiContainer && item != container["view"] && item is DisplayObject) {
				var parameters3d:Object = createTweenParameters3d(token, 1/3);
				var pv:IPlexiContainer = container as IPlexiContainer;
				var plane:Plane = pv.getChildPlane(item as UIComponent);
				if (plane) {
						Tweener.addTween(plane, parameters3d);
				}
			} else {
				var parameters:Object = createTweenParameters(token, 1/3);
				Tweener.addTween(item, token);
			}
		}
		
		private function createTweenParameters3d(token:AnimationToken, time:Number):Object {
			var parameters:Object = new Object();
			//parameters.time = token.time;
			parameters.transition = transition;
			parameters.x = token.x;
			parameters.y = token.y;
			parameters.z = token.z;
			parameters.rotationX = token.rotationX;
			parameters.rotationY = token.rotationY;
			parameters.rotationZ = token.rotationZ;
			return parameters;
		}
		
		private function createTweenParameters(token:AnimationToken, time:Number = 1):Object {
			var parameters:Object = new Object();
			parameters.time = time;
			parameters.transition = transition;
			parameters.x = token.x;
			parameters.y = token.y;
			parameters.z = token.z;
			parameters.rotationX = token.rotationX;
			parameters.rotationY = token.rotationY;
			parameters.rotationZ = token.rotationZ ? token.rotationZ : 0;
			parameters.width = token.width;
			parameters.height = token.height;
			return parameters;
		}
		
	}
}