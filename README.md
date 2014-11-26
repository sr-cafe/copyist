copyist
=======

Translates key=value documents (like .properties) to a Javascript object.

It's mostly designed to work with files containing copies, so it supports key duplication (think of multiple paragraphs or list elements, for instance) and multiline values (for linebreaks).

Copyist tries to be as format error tolerant as it can be:
* Whitespace can be applied liberally to both sides of the "=" sign.
* Whitespace can be applied liberally to the beginning of any line.
* Empty lines can be used to separate different blocks.

Example
-------
A document like this (notice the use of non-consistent whitespace):
	meta.title=Title of the site
	 meta.description = Description of the site


	home.title= Title of the homepage
	home.paragraph =Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas non mi dictum, tincidunt diam in, malesuada ligula.
	home.paragraph = Maecenas in vehicula mi, non elementum lectus.
	Maecenas mollis lorem neque.

	Maecenas id aliquet lorem. Curabitur luctus ipsum cursus massa luctus vestibulum.

will translate in an object like this:
```javascript
{
	meta: {
		title: 'Title of the site',
		description: 'Description of the site'
	},
	home:{
		title: 'Title of the homepage',
		paragraph: [
			'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas non mi dictum, tincidunt diam in, malesuada ligula.',
			'Maecenas in vehicula mi, non elementum lectus.<br />Maecenas mollis lorem neque.<br /><br />Maecenas id aliquet lorem. Curabitur luctus ipsum cursus massa luctus vestibulum.'
		]
	}
}
```

There are a couple of things to notice in the resulting home.paragraph:
* The duplicated key has been turned into an array.
* The linebreaks on the second paragraph have been converted into <br /> tags. Copyist is primarily targeted to send text to HTML templates, so its default behaviour is to turn linebreaks into HTML linebreaks. In the future you'll can tell Copyist how to convert those linebreaks.

There is one caveat in the duplicated keys to array conversion. Since the document format is flat (no nested elements), it can lead to some ambiguous situations.
Consider a document like this:
```javascript
	item.name=A
	item.name=B
```

It's not clear to distinguish if we have 1 item with 2 names or 2 items each one having 1 name.
The default behaviour is to turn the last duplicated key into an array, so we will finish with an object like this:
```javascript
	{
		item:{
			name:['A', 'B']
		}
	}
``

For the most part of the documents Copyist is designed for this is the correct behaviour. But in the future, a new "Commands" feature will be introduced that will allow to disambiguate those cases:
```javascript
	!# [] :: item
```

This instruction tells Copyist to turn the "item" key into an array, so the resulting object will be like this:
```javascript
	{
		item: [
			{
				name: 'A'
			},
			{
				name: 'B'
			}
		]
	}
```

Usage
-----
```javascript
Copyist = require('copyist');
var result = new Copyist().parse(document);
```

Documentation
-------------
Documentation can be generated via an npm script:

```bash
$ npm run doc
```

Testing
-------
Linting and testing can be triggered through the usual npm script:
```
$ npm test
```

To do
-----
* Implement line breaks on text.
* Implement line breaks encoding.
* Define Command interface.
* Implement key to array Command.