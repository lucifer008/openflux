﻿package com.openflux.layout.elements{	import flash.display.DisplayObject;	import com.openflux.layout.elements.Cell;		public class ScatterCell extends Cell	{				private var _rotation:Number;				public function ScatterCell(x:Number=0, y:Number=0, rotation:Number=0, link:DisplayObject=null)		{			super(x, y, link);			_rotation=rotation;		}				public function get rotation():Number		{			return _rotation;		}				public function set rotation(value:Number):void		{			this._rotation=value;		}			}}