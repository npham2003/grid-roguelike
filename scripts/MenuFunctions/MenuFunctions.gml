function Menu(_x, _y, _options, _description = -1, _width = undefined, _height = undefined){
	with (instance_create_depth(_x, _y, -99999, obj_Menu)) {
		options = _options;
		description = _description;
		var _optionscount = array_length(_options);
		visibleOptionsMax = _optionsCount;
		
		//size
		xmargin = 10;
		ymargin = 8;
		draw_set_font(fnM5x7);
		heightLine = 12;
		
		//auto width
		if (_width == undefined) {
			width = 1;
			
			if (description != -1) {
				width = max(width, string_width(_description));
			}
			
			for (var i = 0; i < _optionsCount; i++) {
				width = max(width, string_width(_options[i][0]));
			}
			widthFull = width + xmargin *2;
		}
		else widthFull = _width;
		
		if (_height == undefined) {
			height = heightLine * (_optionsCount + !(description == -1));
			heightFull = height + ymargin *2;
		}
		else {
			heightFull = _height;
			//scrolling
			if (heightLine * (__optionsCount + !(description = -1)) > +height = (ymargin * 2)) {
				scrolling = true;
				visibleOptionsMax = (_height - ymargin * 2) / heightLine;
			}
		}
	}
}

function subMenu(_options) {
	optionsAbove[subMenuLevel] = optinos;
	subMenuLevel++;
	options = _options;
	hover = 0;
}

function menuGoBack() {
	subMenuLevel--;
	options = optionsAbove[subMenuLevel];
	hovver = 0;
}