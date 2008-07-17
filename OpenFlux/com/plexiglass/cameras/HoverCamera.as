package com.plexiglass.cameras
{
	import away3d.cameras.HoverCamera3D;
	import away3d.core.math.Number3D;
	import away3d.primitives.Sphere;
	
	import com.plexiglass.containers.IPlexiContainer;
	
	import flash.events.Event;
	
	public class HoverCamera extends CameraBase implements ICamera
	{
		private var center:Sphere;		
		private var rotCamera:Boolean = false;
		private var lastMouseX:Number = 0;
		private var lastMouseY:Number = 0;
		private var firstClick:Boolean = true;
		
		public function HoverCamera()
		{
			center = new Sphere();
			var hc:HoverCamera3D;
			camera = hc = new HoverCamera3D({zoom:11, focus:200, distance:1000, target:center});
			hc.tiltangle = 40;
			hc.targettiltangle = 40;
			hc.mintiltangle =  20;
			hc.maxtiltangle = 50;
			hc.yfactor = 1;
			hc.steps = 7;
		}
		
		override public function attach(container:IPlexiContainer):void
		{	
			super.attach(container);
			lastMouseX = container.mouseX;
			lastMouseY = container.mouseY;
		}
		
		public function update(w:Number, h:Number):void
		{
			container.view.x = w/2;
			container.view.y = h/2;
			camera.x = w/2;
			//camera.y = -(Math.min(h/2,200));
			//center.x = camera.x;
			//center.y = camera.y;
			camera.lookAt(new Number3D(w/2, 0, 0));
		}
		
		override protected function onEnterFrame(event:Event):void
		{
			if (container.view && container.view.scene)
			{
				var dragX:Number = (container.view.mouseX - lastMouseX);
				var dragY:Number = (container.view.mouseY - lastMouseY);
				
				lastMouseX = container.view.mouseX;
				lastMouseY = container.view.mouseY;
				
				var hc:HoverCamera3D = camera as HoverCamera3D;
				hc.targetpanangle += dragX;
				hc.targettiltangle += dragY
				hc.hover();
			}
		}
	}
}