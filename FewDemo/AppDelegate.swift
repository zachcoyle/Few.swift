//
//  AppDelegate.swift
//  Few
//
//  Created by Josh Abernathy on 7/22/14.
//  Copyright (c) 2014 Josh Abernathy. All rights reserved.
//

import Cocoa
import Few

func renderBackground(tick: Float) -> Container {
	let low: Float = 200
	let R = (low + sin((tick * 3 + 0) * 1.3) * 128) / 255
	let G = (low + sin((tick * 3 + 1) * 1.3) * 128) / 255
	let B = (low + sin((tick * 3 + 2) * 1.3) * 128) / 255
	let color = NSColor(calibratedRed: CGFloat(R), green: CGFloat(G), blue: CGFloat(B), alpha: 1)
	let button1 = View(type: NSButton.self) { b in b.title = "HELLO YES THIS IS DOG" }
			|> frame(CGRect(x: 0, y: 0, width: 160, height: 23))

	let fn = { (str: String, s: Float) -> Float in
		return s
	}
	let input = Input(initialText: "Hello? Is it me you're looking for?", fn: fn) |> frame(CGRect(x: 50, y: 300, width: 300, height: 23))

	let button2 = Button<Float>(title: "Hello yes this is dog.", fn: { s in
		println("\(input.text)")
		return 0
	})
		|> frame(CGRect(x: 0, y: 200, width: 160, height: 23))

	let fullFrame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
	let background = fillRect(color) |> frame(fullFrame)
	let label = Label(text: "Fun and failure both start out the same way.") |> frame(CGRect(x: 200, y: 200, width: 100, height: 60))
	let errrything = Container([button1, button2, label, input], containerLayout) |> frame(fullFrame)
	return Container([background, errrything], fitInView) |> frame(fullFrame)
}

func fitInView(container: Container, elements: [Element]) {
	let component: Few.Component<Any>? = container.getComponent()
	if let component = component {
		if let view = component.getHostView() {
			for el in elements {
				el.frame = view.bounds
			}
		}
	}
}

func containerLayout(container: Container, elements: [Element]) {
	alignLefts(20)(container: container, elements: elements)
	verticalStack(4)(container: container, elements: elements)
}

func alignLefts(origin: CGFloat)(container: Container, elements: [Element]) {
	for el in elements {
		el.frame.origin.x = origin
	}
}

func verticalStack(padding: CGFloat)(container: Container, elements: [Element]) {
	var y: CGFloat = container.frame.size.height - padding;
	for el in elements {
		y -= el.frame.size.height + padding
		el.frame.origin.y = y
	}
}

// This is to work around Swift's inability to have non-generic subclasses of a
// generic superclass.
typealias BackgroundComponent = BackgroundComponent_<Any>
class BackgroundComponent_<Bullshit>: Few.Component<Float> {
	var timer: NSTimer?
	
	init() {
		super.init(render: renderBackground, initialState: 0)
	}
	
	override func componentDidRealize() {
		timer = every(0.01) { [unowned self] in
			void(self.updateState { s in s + 0.01 })
		}
	}
	
	override func componentWillDerealize() {
		timer?.invalidate()
	}
}

class AppDelegate: NSObject, NSApplicationDelegate {
	@IBOutlet weak var window: NSWindow!

	private let appComponent = BackgroundComponent()
	
	func applicationDidFinishLaunching(notification: NSNotification?) {
		let contentView = window.contentView as NSView
		appComponent.addToView(contentView)
	}
}
