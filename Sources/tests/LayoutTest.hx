package tests;

import jasper.layout.container.Container;
import jasper.Solver;
import jasper.layout.Layout;

import haxe.unit.TestCase;

class LayoutTest extends TestCase
{
    public function testLayout() : Void
    {
        var layout = new Layout(new Solver(), new Data(0, 0, 400, 400), 100, 100);

		var row :Container<Data> = null;		
		var column :Container<Data> = null;		

		layout.root
			.addChild(row = layout.createRow(new Data(100, 200, 200, 200))
				.alter(c -> {
					c.rectangle.height.unit = PERCENT(0.5);
					c.rectangle.width.unit = PERCENT(0.5);
					c.rectangle.x.unit = PERCENT(0.25);
					c.rectangle.y.unit = PERCENT(0.5);
				}));

		row
			.addChild(layout.createColumn(new Data(0, 40, 100, 200))
				.alter(c -> {
					c.rectangle.width.unit = PX(100);
					c.rectangle.y.unit = PERCENT(0.2);
				}))
			.addChild(column = layout.createColumn(new Data(100, 40, 110, 200))
				.alter(c -> {
					c.rectangle.width.unit = CALC(v -> {
						return (v * 0.5) + 10;
					});
					c.rectangle.y.unit = PERCENT(0.2);
				}))
			.addChild(layout.createColumn(new Data(210, 0, 200, 200))
				.alter(c -> {
					c.rectangle.width.unit = PX(200);
				}));

		column
			.addChild(layout.createColumn(new Data(0, 0, 110, 100))
				.alter(c -> {
					c.rectangle.height.unit = PERCENT(0.5);
				}));

		layout.update(400, 400);
		updateData(layout.root);
    }

    private function updateData(root :Container<Data>) : Void
	{
        assertEquals(root.rectangle.x.value.m_value, root.data.targetX);
        assertEquals(root.rectangle.y.value.m_value, root.data.targetY);
        assertEquals(root.rectangle.width.value.m_value, root.data.targetWidth);
        assertEquals(root.rectangle.height.value.m_value, root.data.targetHeight);

		var p = root.firstChild;
		while(p != null) {
			updateData(p);
			p = p.next;
		}
	}
}

class Data
{
    public var targetX :Float;
    public var targetY :Float;
    public var targetWidth :Float;
    public var targetHeight :Float;

	public function new(x :Float, y :Float, width :Float, height :Float) : Void
	{
        targetX = x;
        targetY = y;
        targetWidth = width;
        targetHeight = height;
	}
}