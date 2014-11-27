Copyist = require '../lib/copyist'

describe 'Copyist', ->
	copyist = null

	beforeEach ->
		copyist = new Copyist()

	it 'converts key=value strings into an object', ->
		data = "#Starting comment.\n
					key=Value.\n
					another.key = And its value."

		test = copyist.parse(data).pojo()

		expect(test).toEqual {
			key:'Value.'
			another:
				key:'And its value.'
		}

	it 'merges its results with a provided object', ->
		data = "#Starting comment.\n
					Continues from prev line.\n
					key=Value.\n
					another.key = And its value."
		result = {
			one: 1
			and:
				two: 2
		}

		test = copyist.parse(data).pojo(result)

		expect(test).toEqual {
			one: 1,
			and:
				two: 2
			key:'Value.'
			another:
				key:'And its value.'
		}

	it 'creates an array with duplicated keys', ->
		data = "item.key=One\n
				item.key=Two"

		test = copyist.parse(data).pojo()

		expect(test).toEqual {
			item:
				key:['One', 'Two']
		}

	it 'merges multiline text in a single value', ->
		data = "#Start comment.\n
				paragraph=Maecenas in vehicula mi, non elementum lectus.\n
				Maecenas mollis lorem neque.\n
				\n
				Maecenas id aliquet lorem. Curabitur luctus ipsum cursus massa luctus vestibulum."

		test = copyist.parse(data).pojo()

		expect(test).toEqual {
			paragraph: 'Maecenas in vehicula mi, non elementum lectus.<br />Maecenas mollis lorem neque.<br /><br />Maecenas id aliquet lorem. Curabitur luctus ipsum cursus massa luctus vestibulum.'
		}

	it 'strips blank lines from the end of a multiline value', ->
		data = "#Start comment.\n
				paragraph=Maecenas in vehicula mi, non elementum lectus.\n
				\n
				\n
				another=Maecenas mollis lorem neque."

		test = copyist.parse(data).pojo()

		expect(test).toEqual {
			paragraph: 'Maecenas in vehicula mi, non elementum lectus.'
			another: 'Maecenas mollis lorem neque.'
		}

	it 'changes line breaks for the provided characters', ->
		data = "#Start comment.\n
				paragraph=Maecenas in vehicula mi, non elementum lectus.\n
				Maecenas mollis lorem neque.\n
				\n
				Maecenas id aliquet lorem. Curabitur luctus ipsum cursus massa luctus vestibulum."

		test = copyist.parse(data).newline('\r').pojo()

		expect(test).toEqual {
			paragraph: 'Maecenas in vehicula mi, non elementum lectus.\rMaecenas mollis lorem neque.\r\rMaecenas id aliquet lorem. Curabitur luctus ipsum cursus massa luctus vestibulum.'
		}

		# Inverted order
		test = copyist.newline('\r').parse(data).pojo()

		expect(test).toEqual {
			paragraph: 'Maecenas in vehicula mi, non elementum lectus.\rMaecenas mollis lorem neque.\r\rMaecenas id aliquet lorem. Curabitur luctus ipsum cursus massa luctus vestibulum.'
		}
