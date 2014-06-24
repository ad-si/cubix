!function() {

	function $(query) {
		query = document.querySelectorAll(query)
		return (query[1]) ? query : query[0]
	}

	var axis = {
			diameter: 0.004,
			surface: function() {
				return this.diameter * this.diameter * Math.PI
			}
		},
		wire = {
			diameter: 0.00004,
			surface: function() {
				return this.diameter * this.diameter * Math.PI
			}
		},
		wiresPerAxis = axis.surface() / wire.surface()


	var	rotationMap = {
			n: 180,
			e: 90,
			s: 0,
			w: 270
		},
		colorMap = {
			n: "rgba(0,0,0,1)",         //black
			e: "rgba(192,192,192,1)",   //silver
			s: "rgba(255,255,255,1)",   //white
			w: "rgba(0,0,255,0.1)"      //transparent
		},
		white = [],
		black = [],
		silver = [],
		transparent = [],
		stripedEven = [],
		stripedOdd = [],
		striped1 = [],
		striped2 = [],
		striped3 = [],
		c = console,
		displayMode = "top"


	for(i = 0; i < 256; i++) {
		white[i] = 's'
		black[i] = 'n'
		silver[i] = 'e'
		transparent[i] = 'w'
		stripedEven[i] = (i % 2 == 0) ? 'n' : 's'
		stripedOdd[i] = ((i + 1) % 2 == 0) ? 'n' : 's'
		striped1[i] = (i % 2 == 0) ? 'n' : 's'
		striped2[i] = (i % 3 == 0) ? 'e' : 'w'
		striped3[i] = (i % 5 == 0) ? 'n' : 's'
	}


	//console.log(axis.surface())
	//console.log(wire.surface())
	//console.log(wiresPerAxis)

	//==========================

	var i,
		a

	function Cube(x, y, nextCubeSide) {

		var edgeLength = 0.04,
			rotationAngle = 0,
			currentCubeSide = "",
			element

		nextCubeSide = nextCubeSide || "s"

		function rotate(degree) {

			var end = rotationAngle + degree

			//c.log(rotationAngle, degree, end)

			if(degree > 0) {

				function turn() {

					if(rotationAngle < end) {

						rotationAngle += 5

						element.setAttribute("style", "-webkit-transform: rotate(" + rotationAngle + "deg)")

						setTimeout(turn, 40)
					}
				}

				turn()

			} else {

				function turn2() {

					if(rotationAngle > end) {

						rotationAngle -= 5

						element.setAttribute("style", "-webkit-transform: rotate(" + rotationAngle + "deg)")

						setTimeout(turn2, 40)
					}
				}

				turn2()
			}
		}


		this.toJSON = function() {
			return {
				x: x,
				y: y,
				side: cubeSide,
				angle: rotationAngle
			}
		}

		this.render = function() {

			element = shaven(['div.cube#cube' + x + '-' + y])[0]

			element.setAttribute("style", "-webkit-transform: rotate(" + rotationMap[nextCubeSide] + "deg)")

			if(displayMode == "front"){
				element.style.backgroundColor = colorMap[nextCubeSide]
				element.style.border = "none"
			}

			$('#cubix').appendChild(element)

			currentCubeSide = nextCubeSide
			rotationAngle = rotationMap[nextCubeSide]

			return this
		}

		this.showSide = function(side) {

			if(currentCubeSide != side) {

				var angle = rotationMap[side] - rotationMap[currentCubeSide]

				if(angle > 180)
					angle = -(angle - 180)

				if(angle < -180)
					angle = -(angle + 180)

				c.log(colorMap[side])



				if(displayMode == "top"){
					rotate(angle)
				}

				if(displayMode == "front"){
					element.style.backgroundColor = colorMap[side]
					element.style.border = "none"
				}

				currentCubeSide = side
			}
		}

	}

	//==============================================

	function Cubix(matrix) {

		var width = 16,
			height = 16,
			currentState = matrix || white,
			currentObjectState = [],
			nextState = []


		this.render = function() {

			$('#cubix').innerHTML = ""

			currentObjectState.forEach(function(cube, index) {

				cube.render()

				if((index + 1) % 16 == 0)
					shaven([$('#cubix'), ['br']])
			})

			return this
		}

		this.update = function(matrix) {

			currentObjectState.forEach(function(cube, index) {

				cube.showSide(matrix[index])
			})

			return this
		}

		this.delay = function(time) {
			setTimeout(function() {

			}, time)
		}

		for(i = 1; i <= height; i++) {
			for(a = 1; a <= width; a++) {

				currentObjectState.push(
					new Cube(a, i, currentState[(i - 1) * height + (a - 1)])
				)

			}
		}
	}

	var cubix = new Cubix()


	cubix.render()

	setTimeout(function() {
		cubix
			//.update(fakesome.matrix(16, 16, ['n', 'e', 's', 'w']))
			.update(stripedEven)

		setTimeout(function() {
			cubix
				//.update(fakesome.matrix(16, 16, ['n', 'e', 's', 'w']))
				.update(stripedOdd)

			setTimeout(function() {
				cubix
					//.update(fakesome.matrix(16, 16, ['n', 'e', 's', 'w']))
					.update(striped3)
				setTimeout(function() {
					cubix
						//.update(fakesome.matrix(16, 16, ['n', 'e', 's', 'w']))
						.update(white)
				}, 3000)
			}, 3000)
		}, 3000)
	}, 1000)


}()
