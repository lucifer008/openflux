package com.openflux.layouts
{
	import com.openflux.animators.TweenAnimator;
	
	import flash.geom.Point;
	
	import mx.core.UIComponent;

	public class FlowLayout extends LayoutBase implements ILayout, IDragLayout
	{
		
		public var measuredGap:Number;
		public var horizontalAlignment:String = "left";
		public var verticalAlignment:String = "top";
		
		public function FlowLayout():void {
			super();
			//animator = new TweenAnimator();
		}
		
		public function measure():Point {
			var point:Point = new Point();
			for each(var child:UIComponent in container.children) {
				point.x = Math.max(child.width, point.x);
				point.y += child.height + 10;
			}
			return point;
		}
		
		public function update(indices:Array = null):void {
			var containerWidth:Number = container.width;
			var point:Point = measureGrid();
			var cols:Number = Math.floor(containerWidth / point.x);
			var space:Number = (containerWidth - (point.x * cols)) / (cols + 1);
			
			container.animator.begin();
			
			var xPos:Number = space / 2;
			var yPos:Number = space / 2;
			var len:int = container.children.length;
			//var time:Number = container.dragTargetIndex != -1 ? .2 : 2;
			var child:UIComponent;
			var width:Number;
			var height:Number;
			
			for (var i:int = 0; i < len; i++) {
				child = container.children[i];
				width = child.width;
				height = child.height;
				
				if(indices && indices.indexOf(i, 0) >= 0) {
					xPos += width + 10;
					if(xPos > containerWidth - width - space / 2) {
						xPos = space / 2;
						yPos += height + 8;
					}
				}
				
				container.animator.moveItem(child, {x:xPos, y:yPos, width:width, height:height, rotation:0});
				
				xPos += width + 10;
				if(xPos > containerWidth - width - space / 2) {
					xPos = space / 2;
					yPos += height + 8;
				}
			}
			container.animator.end();
		}
		
		override public function findItemAt(px:Number, py:Number, seamAligned:Boolean):int {
			var containerWidth:Number = container.getExplicitOrMeasuredWidth();
			var point:Point = measureGrid();
			var cols:Number = Math.floor(containerWidth / point.x);
			var space:Number = (containerWidth - (point.x * cols)) / (cols + 1);
			var xPos:Number = space / 2;
			var yPos:Number = space / 2;
			var len:int = container.children.length;
			//var time:Number = container.dragTargetIndex != -1 ? .2 : 2;
			var child:UIComponent;
			var width:Number;
			var height:Number;
			
			for (var i:int = 0; i < len; i++) {
				child = container.children[i];
				width = child.getExplicitOrMeasuredWidth();
				height = child.getExplicitOrMeasuredHeight();
				
				if (px >= xPos - 10 && px <= xPos + width && py >= yPos - 8 && py <= yPos + height)
					return i;
				
				xPos += width + 10;
				if(xPos > containerWidth - width - space / 2) {
					xPos = space / 2;
					yPos += height + 8;
				}
			}
			
			return -1;
		}
		
		private function measureGrid():Point {
			
			var point:Point = new Point();
			for each(var child:UIComponent in container.children) {
				var w:Number = child.measuredWidth;
				var h:Number = child.measuredHeight;
				if(w > point.x) {
					point.x = w;
				}
				if(h > point.y) {
					point.y = h;
				}
			}
			var gap:Point = new Point(container.getExplicitOrMeasuredWidth(), container.getExplicitOrMeasuredHeight());
			// do something
			return point;
		}
		
	}
}