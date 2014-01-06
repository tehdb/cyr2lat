cyrToLat = require('../cyr2lat').CyrToLat

describe 'cyr2lat testing', ->

	it 'should map cyrillic to latin', (done) ->
		expect( cyrToLat.mapToLatin('файл') ).toEqual 'fajl'
		expect( cyrToLat.mapToLatin('file')).toEqual 'file'
		done()

	it 'should return file extension', (done) ->
		expect( cyrToLat.getExt('file.txt')).toEqual 'txt'
		expect( cyrToLat.getExt('file.1.txt')).toEqual 'txt'
		expect( cyrToLat.getExt('файл.txt')).toEqual 'txt'

		done()

	it 'should increment count for directories', (done) ->
		# cyrToLat = require('../cyr2lat').CyrToLat
		expect( cyrToLat.getIncFilename('dirname', 'dir')).toEqual 'dirname(1)'
		expect( cyrToLat.getIncFilename('dirname/subdir', 'dir')).toEqual 'dirname/subdir(1)'
		expect( cyrToLat.getIncFilename('dirname(2)', 'dir')).toEqual 'dirname(3)'
		expect( cyrToLat.getIncFilename('dirna(me)', 'dir')).toEqual 'dirna(me)(1)'
		expect( cyrToLat.getIncFilename('dir(na)me', 'dir')).toEqual 'dir(na)me(1)'
		expect( cyrToLat.getIncFilename('(dir)name', 'dir')).toEqual '(dir)name(1)'

		done()

	it 'should increment count for files', (done) ->
		expect( cyrToLat.getIncFilename('filename.txt', 'file')).toEqual 'filename(1).txt'
		expect( cyrToLat.getIncFilename('dir/filename.txt', 'file')).toEqual 'dir/filename(1).txt'
		expect( cyrToLat.getIncFilename('filename(1).txt', 'file')).toEqual 'filename(2).txt'
		expect( cyrToLat.getIncFilename('filena(me).txt', 'file')).toEqual 'filena(me)(1).txt'
		expect( cyrToLat.getIncFilename('file(na)me.txt', 'file')).toEqual 'file(na)me(1).txt'
		expect( cyrToLat.getIncFilename('(fi)lename.txt', 'file')).toEqual '(fi)lename(1).txt'
		expect( cyrToLat.getIncFilename('file(1)name.txt', 'file')).toEqual 'file(1)name(1).txt'
		expect( cyrToLat.getIncFilename('(1)filename.txt', 'file')).toEqual '(1)filename(1).txt'

		done()
